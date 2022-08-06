# terraform-aws-linux-vm-public

The purpose of this module is to spin up a test server in public subnet quickly.

1. Create Ubuntu Test VM in Public Subnet
2. Allow incoming Web (HTTP)
3. Allow inomcing SSH (From your egress IP)
4. Allow ping from RFC1918 (10.0.0.0/8, 172.16.0.0/12, 192.168.0.0/16)


