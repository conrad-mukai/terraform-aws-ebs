# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH MULTIPLE VOLUMES PER AZ
# This example creates multiple volumes in each availability zone.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# 3 30GB volume are created in every availability zone in the target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "multiple"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  volumes_per_az = 3
}
