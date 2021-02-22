# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH NO ENCRYPTION
# This example disables encryption. A 30 GB volume is created in every
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
# A 30GB volume with no encryption is created in every availability zone in the
# target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "no-encryption"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  encrypted = false
}
