/*
 * EBS variables
 */


# general

variable name {
  type = string
  description = "name to use in tags"
}


# ebs

variable availability_zones {
  type = list(string)
  description = "list of availability zones"
  validation {
    condition = length(distinct(var.availability_zones)) == length(var.availability_zones)
    error_message = "Duplicate availablity zones."
  }
}

variable volumes_per_az {
  type = number
  description = "number of volumes per availability zone"
  default = 1
}

variable type {
  type = string
  description = "EBS volume type (standard, gp2, gp3, io1, io2, sc1, st1)"
  default = "gp2"
  validation {
    condition = contains([
      "standard", "gp2", "gp3", "io1", "io2", "sc1", "st1"
    ], var.type)
    error_message = "Invalid volume type."
  }
}

variable size {
  type = number
  description = "volume size (GB)"
}

variable iops {
  type = number
  description = "I/O operations per second (must be set for types io1, io2, gp3)"
  default = 0
}

variable encrypted {
  type = bool
  description = "flag to enable disk encryption (default true)"
  default = true
}

variable kms_key_id {
  type = string
  description = "ARN for the KMS encryption key (if not specified the EBS default key is used)"
  default = ""
}

variable snapshot_ids {
  type = list(string)
  description = "list of snapshot IDs to launch the volumes"
  default = []
}


# dlm

variable enable_backup {
  type = bool
  description = "flag to turn on backups"
  default = true
}

variable dlm_iam_role_arn {
  type = string
  description = "IAM role for DLM service (default is role created by aws dlm create-default-role)"
  default = ""
}

variable dlm_period {
  type = number
  description = "frequency of snapshot in hours (valid values are 1, 2, 3, 4, 6, 8, 12, or 24)"
  default = 24
  validation {
    condition = contains([1, 2, 3, 4, 6, 8, 12, 24], var.dlm_period)
    error_message = "Invalid DLM period."
  }
}

variable dlm_retention {
  type = number
  description = "retention period in days"
  default = 7
}

variable dlm_start_time {
  type = string
  description = "start time in 24 hour format (default is a random time)"
  default = ""
}
