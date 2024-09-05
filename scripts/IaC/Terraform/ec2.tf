provider "aws" {
region = "us-east-1"
}
terraform {
  backend "s3" {
    bucket         = "devops630newworldlab"
    key            = "terraform.tfstate"
    region         = "us-east-1"
    encrypt        = true
  }
}


data "aws_ami" "ubuntu" {
most_recent = true

filter {
  name   = "name"
  values = ["ubuntu/images/hvm-ssd/ubuntu-jammy-22.04-amd64-server-*"]
}

filter {
  name   = "virtualization-type"
  values = ["hvm"]
}

owners = ["099720109477"] # Canonical
}

data "aws_vpc" "default" {
  default = true
}

resource "aws_security_group" "allow_ssh_http" {
  name        = "allow_ssh_http"
  description = "Security group for SSH and HTTP access"
  vpc_id      = data.aws_vpc.default.id

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow SSH from anywhere (adjust as necessary)
  }

  ingress {
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"] # Allow HTTP from anywhere (adjust as necessary)
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "allow_ssh_http"
  }
}

resource "aws_key_pair" "ubuntu_ssh_key" {
  key_name = "my_ubuntu_ssh_key"
  public_key = file("./id_rsa.pub")
  
}

resource "aws_instance" "web" {
ami           = data.aws_ami.ubuntu.id
instance_type = "t3.micro"
key_name      = "my_ubuntu_ssh_key"
vpc_security_group_ids = [aws_security_group.allow_ssh_http.id]

tags = {
  Name = "My-ec2-lab-machine"
}
}

output "instance_private_ip" {
 value = aws_instance.web.private_ip
}
output "instance_public_ip" {
 value = aws_instance.web.public_ip

}


output "instance_id" {
 value = aws_instance.web.id

}

output "security_group_id" {
  value = aws_security_group.allow_ssh_http.id
}

output "default_vpc_id" {
  value = data.aws_vpc.default.id
}
