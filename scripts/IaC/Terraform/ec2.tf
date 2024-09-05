provider "aws" {
region = "us-east-1"
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

resource "aws_instance" "web" {
ami           = data.aws_ami.ubuntu.id
instance_type = "t3.micro"

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
