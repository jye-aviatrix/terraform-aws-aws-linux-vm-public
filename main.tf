data "aws_ami" "ubuntu_20_04_lts" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }
  owners = ["099720109477"]
}

data "http" "ip" {
  url = "https://ifconfig.me"
}

resource "aws_security_group" "this" {
  name        = "${var.vm_name} allow inbound HTTP(*) SSH(EgressIP), PING(RFC1918)"
  description = "${var.vm_name} allow inbound HTTP from anywhere, SSH from your egress public IP, and ping from RFC 1918"
  vpc_id      = var.vpc_id

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["${data.http.ip.body}/32"]
  }

  ingress {
    description = "ICMP10"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["10.0.0.0/8"]
  }

  ingress {
    description = "ICMP172"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["172.16.0.0/12"]
  }

  ingress {
    description = "ICMP192"
    from_port   = -1
    to_port     = -1
    protocol    = "icmp"
    cidr_blocks = ["192.168.0.0/16"]
  }



  ingress {
    description      = "TCP80"
    from_port        = 80
    to_port          = 80
    protocol         = "tcp"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  egress {
    description      = "Allow_All_Out_Bound"
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
    ipv6_cidr_blocks = ["::/0"]
  }

  tags = local.tags
}

resource "aws_network_interface" "this" {
  subnet_id       = var.subnet_id
  security_groups = [aws_security_group.this.id]

  tags = local.tags
}

resource "aws_instance" "this" {
  ami           = data.aws_ami.ubuntu_20_04_lts.id
  instance_type = "t2.micro"

  network_interface {
    network_interface_id = aws_network_interface.this.id
    device_index         = 0
  }

  key_name = var.key_name
  tags     = local.tags

  user_data = <<EOF
#!/bin/bash
sudo apt update -y
sudo apt install apache2 -y
echo "<h1>${var.vm_name}</h1>" | sudo tee /var/www/html/index.html
EOF

}


resource "aws_eip" "this" {
  count = var.use_eip ? 1 : 0
  vpc   = true

  instance = aws_instance.this.id
  tags     = local.tags
}

locals {
  public_ip = var.use_eip ? aws_eip.this[0].public_ip : aws_instance.this.public_ip
}