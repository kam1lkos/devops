#w jaki sposób packer łączy się z kontem AWS? poprzez AWS CLI?

packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.5"
      source = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "app" {
  ami_name = "app-pipeline-${local.timestamp}"

  source_ami_filter {
    filters = {
      name                 = "amzn2-ami-hvm-2.*.1-x86_64-gp2"    #do sprawdzenia
      root-device-type     = "ebs"
      virtualization-type  = "hvm"
    }
    most_recent = true
    owners      = ["amazon"]
  }

  instance_type = "t2.micro"
  region = "us-east-1"
  ssh_username = "ec2-user-cicd"                                 #do sprawdzenia
}

build {
  sources = [
    "source.amazon-ebs.app"
  ]

  provisioner "ansible" {
    playbook_file = "./ec2_packer_playbook.yml"
  }
}
