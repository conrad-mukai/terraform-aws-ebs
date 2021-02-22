# ----------------------------------------------------------------------------
# EBS VOLUMES WITH SCHEDULED BACKUPS
# This module creates multiple EBS volumes with DLM scheduled backups. The
# caller submits a list of availability zones and number of volumes per AZ.
# All volumes will be created with the prescribed settings.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# REQUIRE A SPECIFIC TERRAFORM VERSION OR HIGHER
# -----------------------------------------------------------------------------
terraform {
  required_version = ">= 0.13.0"
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# Create EBS volumes. Certain EBS resource argument combinations are
# incompatible so all of the various combinations are presented and the
# appropriate one has a non-zero count. All others have a zero count.
# -----------------------------------------------------------------------------

data aws_availability_zone this {
  count = local.num_azs
  name = var.availability_zones[count.index]
}

locals {
  io1_types = ["io1", "io2", "gp3"]
  num_azs = length(var.availability_zones)
  num_volumes = local.num_azs * var.volumes_per_az
  volume_names = [for i in range(local.num_volumes): "${var.name}-${element(data.aws_availability_zone.this[*].zone_id, i)}-${format("%02d", floor(i/local.num_azs)+1)}"]
  snapshot_ids = length(var.snapshot_ids) == 0 ? [""] : var.snapshot_ids
}

resource aws_ebs_volume volumes {
  count = !contains(local.io1_types, var.type) ? local.num_volumes : 0
  availability_zone = element(var.availability_zones, count.index)
  type = var.type
  size = var.size
  encrypted = var.encrypted
  kms_key_id = var.kms_key_id
  snapshot_id = element(local.snapshot_ids, count.index)
  tags = {
    Name = local.volume_names[count.index]
    DLM = var.name
  }
}

resource aws_ebs_volume iops-volumes {
  count = contains(local.io1_types, var.type) ? local.num_volumes : 0
  availability_zone = element(var.availability_zones, count.index)
  type = var.type
  size = var.size
  iops = var.iops
  encrypted = var.encrypted
  kms_key_id = var.kms_key_id
  snapshot_id = element(local.snapshot_ids, count.index)
  tags = {
    Name = local.volume_names[count.index]
    DLM = var.name
  }
}

# -----------------------------------------------------------------------------
# BACKUP
# Create a DLM (data lifecycle manager) policy to backup the EBS volumes.
# -----------------------------------------------------------------------------

locals {
  custom_dlm_role = var.enable_backup && length(var.dlm_iam_role_arn) > 0
}

data aws_caller_identity current {
  count = !local.custom_dlm_role ? 1 : 0
}

locals {
  volume_ids = concat(aws_ebs_volume.volumes[*].id, aws_ebs_volume.iops-volumes[*].id)
  volume_id_list = join(",", local.volume_ids)
  random_start = var.enable_backup && length(var.dlm_start_time) == 0
}

resource random_integer hour {
  count = local.random_start ? 1 : 0
  max = 23
  min = 0
  keepers = {
    ebs_volume_ids = local.volume_id_list
  }
}

resource random_integer minute {
  count = local.random_start ? 1 : 0
  max = 59
  min = 0
  keepers = {
    ebs_volume_ids = local.volume_id_list
  }
}

locals {
  dlm_iam_role = local.custom_dlm_role ? var.dlm_iam_role_arn : "arn:aws:iam::${data.aws_caller_identity.current[0].account_id}:role/AWSDataLifecycleManagerDefaultRole"
  backup_start = !local.random_start ? var.dlm_start_time : format("%02d:%02d", random_integer.hour[0].result, random_integer.minute[0].result)
  retention_count = var.dlm_retention * (24 / var.dlm_period)
}

resource aws_dlm_lifecycle_policy backup {
  count = var.enable_backup ? 1 : 0
  description = "${var.name} snapshots"
  execution_role_arn = local.dlm_iam_role
  policy_details {
    resource_types = ["VOLUME"]
    target_tags = {
      DLM = var.name
    }
    schedule {
      name = var.name
      create_rule {
        interval = var.dlm_period
        times = [local.backup_start]
      }
      retain_rule {
        count = local.retention_count
      }
    }
  }
}
