terraform {
  required_version = "<= 1.5.7"
  backend "remote" {}
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "4.22.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_vpc" "configu" {
  cidr_block           = var.address_space
  enable_dns_hostnames = true

  tags = var.tags
}

resource "aws_subnet" "configu" {
  vpc_id     = aws_vpc.configu.id
  cidr_block = var.subnet_prefix

  tags = var.tags
}

resource "aws_security_group" "configu" {
  name = "${var.prefix}-security-group"

  vpc_id = aws_vpc.configu.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }


  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
    prefix_list_ids = []
  }

  tags = var.tags
}

resource "aws_internet_gateway" "configu" {
  vpc_id = aws_vpc.configu.id

  tags = var.tags
}

resource "aws_route_table" "configu" {
  vpc_id = aws_vpc.configu.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.configu.id
  }
}

resource "aws_route_table_association" "configu" {
  subnet_id      = aws_subnet.configu.id
  route_table_id = aws_route_table.configu.id
}

data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical
}

resource "aws_eip" "configu" {
  instance = aws_instance.configu.id
  vpc      = true
}

resource "aws_eip_association" "configu" {
  instance_id   = aws_instance.configu.id
  allocation_id = aws_eip.configu.id
}

resource "aws_instance" "configu" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  key_name                    = aws_key_pair.configu.key_name
  associate_public_ip_address = true
  subnet_id                   = aws_subnet.configu.id
  vpc_security_group_ids      = [aws_security_group.configu.id]

  tags = var.tags
}

resource "tls_private_key" "configu" {
  rsa_bits  = 4096
  algorithm = "RSA"
}

resource "aws_key_pair" "configu" {
  key_name   = var.my_aws_key
  public_key = tls_private_key.configu.public_key_openssh
}
