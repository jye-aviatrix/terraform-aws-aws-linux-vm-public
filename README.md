# terraform-aws-aws-linux-vm-public

The purpose of this module is to spin up a test server in public subnet quickly.

1. Create Ubuntu Test VM in Public Subnet
2. Allow incoming Web (HTTP)
3. Allow inomcing SSH (From your egress IP)
4. Allow ping from RFC1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)

## Example without EIP

```terraform
module "aws-linux-vm-public" {
  source    = "jye-aviatrix/aws-linux-vm-public/aws"
  version   = "1.0.3"
  key_name  = "key-pair"
  region    = "us-east-1"
  vm_name   = "public1"
  vpc_id    = "vpc-04fc1"
  subnet_id = "subnet-08ff"
}

output "public1" {
  value = module.aws-linux-vm-public
}
```

## Example with EIP

```terraform
module "aws-linux-vm-public" {
  source    = "jye-aviatrix/aws-linux-vm-public/aws"
  version   = "1.0.3"
  key_name  = "key-pair"
  region    = "us-east-1"
  vm_name   = "public1"
  vpc_id    = "vpc-04fc1"
  subnet_id = "subnet-08ff"
  use_eip   = true
}

output "public1" {
  value = module.aws-linux-vm-public
}
```


