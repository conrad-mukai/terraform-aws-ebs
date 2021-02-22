# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH VOLUMES CREATED FROM SNAPSHOTS
# This example creates volumes created with snapshots.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# 30GB volumes with a custom encryption key are created in every availability
# zone in the target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module starters {
  source = "../../"
  name = "starter"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  enable_backup = false
}

resource aws_ebs_snapshot snapshots {
  count = length(module.starters.volume_ids)
  volume_id = module.starters.volume_ids[count.index]
}

module this {
  source = "../../"
  name = "snapshot"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  snapshot_ids = aws_ebs_snapshot.snapshots[*].id
}
