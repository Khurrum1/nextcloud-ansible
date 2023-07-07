packer {
  required_plugins {
    amazon = {
      version = ">= 1.2.6"
      source  = "github.com/hashicorp/amazon"
    }
  }
}

locals {
  timestamp = regex_replace(timestamp(), "[- TZ:]", "")
}

source "amazon-ebs" "code-club-kb" {
  ami_name      = "${var.ami_prefix}-${local.timestamp}"
  source_ami    = data.amazon-ami.code-club-kb.id
  instance_type = var.instance_type
  region        = var.region
  ssh_username  = "ubuntu"
  tags = {
    Name = "${var.ami_prefix}-KB-${local.timestamp}"
    Env  = var.environment
  }
}


build {
  name = "baked-ami-kb"
  sources = [
    "source.amazon-ebs.code-club-kb"
  ]

  provisioner "ansible" {
    playbook_file = "../ansible/ubuntu-debian.yml"
  }

  provisioner "shell" {
    inline = [
      "ansible-galaxy collection install -r requirements.yml"
    ]
  }


  # provisioner "breakpoint" {
  #   disable = false
  #   note    = "this is breakpoint 1"
  # }

  # post-processor "checksum" {
  #   checksum_types      = ["sha1", "sha256"]
  #   output              = "packer_{{.BuildName}}_{{.ChecksumType}}.checksum"
  #   keep_input_artifact = true
  # }

  # provisioner "breakpoint" {
  #   disable = false
  #   note    = "this is a breakpoint 2"
  # }

  post-processor "manifest" {}

}



