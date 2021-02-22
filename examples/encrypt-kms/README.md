# Custom KMS Key

This will create a KMS key and use it to encrypt EBS volumes. This will create
a 30GB volume in each availability zone in the target region.

## How to Use

To run the example do the following:
1. copy `terraform.tfvars.example` to a `terraform.tfvars` file and specify the
   region;
1. run `terraform init`;
1. run `terraform apply`;
