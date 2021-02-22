# Volumes with Backup Disabled

This will create 30GB EBS volumes in each availability zone with backup
disabled.

## How to Use

To run the example do the following:
1. copy `terraform.tfvars.example` to a `terraform.tfvars` file and specify the
   region;
1. run `terraform init`;
1. run `terraform apply`;
