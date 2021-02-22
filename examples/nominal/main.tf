# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH NOMINAL SETTINGS
# This example uses defaults to create 30GB volumes. A volume is created in
# every availability zone in the target region.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# A 30GB volume is created in every availability zone in the target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "nominal"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
}
