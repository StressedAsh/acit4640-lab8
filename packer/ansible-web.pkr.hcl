packer {
  required_plugins {
    amazon = {
      source = "github.com/hashicorp/amazon"
      version = "> 1.0.0"
    }
    ansible = {
      version = ">= 1.1.2"
      source  = "github.com/hashicorp/ansible"
    }

}

source "amazon-ebs" "ubuntu" {
  ami_name = "packer-ansible-nginx"
  instance_type = "t2.micro"
  region = "us-west-2"
  source_ami_filter {
    filters = {
      name = "ubuntu/images/hvm-ssd/ubuntu-noble-24.04-amd64-server-*"
      root-device-type = "ebs"
      virtualization-type = "hvm"
    }
    most_recent = true
    owners = ["self"]
  }
  ssh_username = var.ssh_username
}

build {
  sources = ["source.amazon-ebs.ubuntu"]
  provisioner "ansible" {
    playbook_file = "ansible/playbook.yml"
    ansible_env_vars = ["ANSIBLE_HOST_KEY_CHECKING=False", "ANSIBLE_NOCOWS=1"]
    extra_arguments = ["--extra-vars", "-vvv"]
  }
}
