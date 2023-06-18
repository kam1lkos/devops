#w jaki sposób terraform łączy się z kontem? poprzez skonfigurowany AWS CLI? czy poprzez po prostu bycie zalogowanym do konta AWS?

terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"  
    }
  }
  
#skąd brać wersje?
  required_version = ">= 1.2.0" 
}

provider "aws" {
  region = "us-east-1"
}


resource "aws_vpc_security_group_ingress_rule" "aws_sg_ingress" {
  security_group_id = aws_security_group.aws_sg_ingress.id

#czy tutaj nie powinien być udostępniony port 80 (dockerfile)?
  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 8080
  ip_protocol = "tcp"
  to_port     = 8080
}


resource "aws_vpc_security_group_egress_rule" "aws_sg_egress"
  security_group_id = aws_security_group.aws_sg_egress.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 0
  ip_protocol = "-1"
  to_port     = 0
}


data "aws_ami" "app_ami" {
  most_recent = true
  name_regex  = "nginx-app-*"
  owners      = ["self"]
}

resource "aws_instance" "web_app" {
  instance_type          = "t2.micro"
  ami                    = data.aws_ami.app_ami.id
  #dobrze rozdzielone dwa id?
  vpc_security_group_ids = [aws_security_group.aws_sg_ingress.id aws_security_group.aws_sg_egress.id]
}
