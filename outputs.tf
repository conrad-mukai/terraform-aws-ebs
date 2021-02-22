/*
 * EBS outputs
 */

output volume_ids {
  value = local.volume_ids
  description = "list of EBS volume IDs"
}

output volume_id_map {
  value = {
    for i in range(local.num_azs): var.availability_zones[i] => [
      for j in range(var.volumes_per_az): local.volume_ids[i+j*local.num_azs]
    ]
  }
  description = "map of EBS volume IDs per availability zone"
}
