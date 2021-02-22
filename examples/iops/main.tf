# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH IOPS
# This example creates volues with iops specified. A volume is created in every
# availability zone in the target region.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# 30GB volumes of type io1 are created with iops set to 100.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "iops"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  type = "io1"
  iops = 1000
}
