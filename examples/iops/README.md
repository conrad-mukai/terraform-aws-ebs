# Volumes with Custom IOPs

This will create EBS volumes of type io1 so the iops can be specified. This
will create a 30GB volume with 1000 IOPs in each availability zone in the
target region.

## How to Use

To run the example do the following:
1. copy `terraform.tfvars.example` to a `terraform.tfvars` file and specify the
   region;
1. run `terraform init`;
1. run `terraform apply`;
