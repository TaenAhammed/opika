# Configure terraform version and provider
terraform {
  required_version = "1.6.6"

  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

# Configure the AWS provider region
provider "aws" {
  region = "ap-southeast-1"
}

# Create a VPC
resource "aws_vpc" "taen_vpc" {
  cidr_block = "10.0.0.0/16"

  tags = {
    Name = "taen_vpc"
  }
}

# Create an Internet Gateway
resource "aws_internet_gateway" "taen_igw" {
  vpc_id = aws_vpc.taen_vpc.id

  tags = {
    Name = "taen_igw"
  }
}

# Create a public subnet
resource "aws_subnet" "taen_public_subnet" {
  vpc_id = aws_vpc.taen_vpc.id
  cidr_block = "10.0.0.0/24"
  availability_zone = "ap-southeast-1a"

  tags = {
    Name = "taen_public_subnet"
  }
}

# Create a route table
resource "aws_route_table" "taen_route_table" {
  vpc_id = aws_vpc.taen_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.taen_igw.id
  }

  route {
    ipv6_cidr_block        = "::/0"
    gateway_id             = aws_internet_gateway.taen_igw.id
  }

  tags = {
    Name = "taen_route_table"
  }
}

# Associate the public subnet with the route table
resource "aws_route_table_association" "taen_route_table_association" {
  subnet_id = aws_subnet.taen_public_subnet.id
  route_table_id = aws_route_table.taen_route_table.id
}

# Create a security group to allow port 22, 80, 443, 3000 access
resource "aws_security_group" "taen_security_group" {
  name = "taen_security_group"
  description = "Allow port 22, 80, 443, 3000 access"
  vpc_id = aws_vpc.taen_vpc.id

  ingress {
    description = "Allow port 22 access"
    from_port = 22
    to_port = 22
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 80 access"
    from_port = 80
    to_port = 80
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 443 access"
    from_port = 443
    to_port = 443
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Allow port 3000 access"
    from_port = 3000
    to_port = 3000
    protocol = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "taen_security_group"
  }
}

# Create a network interface with an IP in the public subnet
resource "aws_network_interface" "taen_network_interface" {
  subnet_id = aws_subnet.taen_public_subnet.id
  private_ips = ["10.0.0.50"]
  security_groups = [aws_security_group.taen_security_group.id]
}

# Create an Elastic IP for the network interface
resource "aws_eip" "taen_eip" {
  network_interface = aws_network_interface.taen_network_interface.id
  depends_on = [ aws_instance.taen_web_server ]
}

# Output the Elastic IP
output "taen_eip" {
  value = aws_eip.taen_eip.public_ip
}

# Create a key pair
resource "aws_key_pair" "taen_key" {
  key_name = "taen_key"
  public_key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINZ3wQnF7we7/FsnKk7hAt2zZUFF8hR2H0GeNZVzGzqp opswithtaen@gmail.com"
}

# Create an web server
resource "aws_instance" "taen_web_server" {
  ami = "ami-0fa377108253bf620" #Canonical, Ubuntu, 22.04 LTS, amd64 jammy image build on 2023-12-07
  instance_type = "t2.micro"
  key_name = "taen_key"
  network_interface {
    device_index = 0
    network_interface_id = aws_network_interface.taen_network_interface.id
  }

  user_data = <<-EOF
              #!/bin/bash
              curl -sL https://deb.nodesource.com/setup_20.x | sudo -E bash -
              sudo apt-get install -y nodejs
              EOF
  tags = {
    Name = "taen_web_server"
  }
}
