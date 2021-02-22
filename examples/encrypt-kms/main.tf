# ----------------------------------------------------------------------------
# EBS EXAMPLE WITH USER SUPPLIED ENCRYPTION KEY
# This example creates volumes with a custom encryption key. A 30GB volume is
# created in every availability zone in the target region.
# -----------------------------------------------------------------------------

# -----------------------------------------------------------------------------
# CONFIGURE AWS PROVIDER
# -----------------------------------------------------------------------------
provider aws {
  region = var.region
}

# -----------------------------------------------------------------------------
# KMS KEY
# A KMS encryption key is created to encrypt volmes.
# -----------------------------------------------------------------------------

resource aws_kms_key key {}

# -----------------------------------------------------------------------------
# EBS VOLUMES
# 30GB volumes with a custom encryption key are created in every availability
# zone in the target region.
# -----------------------------------------------------------------------------

data aws_availability_zones current {}

module this {
  source = "../../"
  name = "encrypt-kms"
  availability_zones = data.aws_availability_zones.current.names
  size = 30
  kms_key_id = aws_kms_key.key.arn
}
