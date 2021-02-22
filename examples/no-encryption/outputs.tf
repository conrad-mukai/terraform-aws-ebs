/*
 * EBS example outputs
 */

output volume_ids {
  value = module.this.volume_ids
  description = "list of all volumes"
}

output volume_id_map {
  value = module.this.volume_id_map
  description = "map of all volumes per availability zone"
}
