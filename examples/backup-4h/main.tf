# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH CUSTOM BACKUP PERIOD
# This example creates a backup policy with a custom period.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# 30GB volumes with a 4 hour backup period are created in every availability
# zone in the target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "nominal"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  dlm_period = 4
}
