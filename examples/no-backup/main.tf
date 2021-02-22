# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH NO BACKUP
# This example create 30GB volumes with the backup disabled. A volume is
# created in every availability zone in the target region.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# A 30GB volume with no backup is created in every availability zone in the
# target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "no-backup"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  enable_backup = false
}
