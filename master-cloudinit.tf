data "template_file" "init-script" {
  template = file("scripts/init.cfg")
  vars = {
    REGION = var.AWS_REGION
  }
}

data "template_file" "shell-script-all" {
  template = file("scripts/kubernetes-setup-all-node.sh")
}

data "template_file" "shell-script-master" {
  template = file("scripts/kubernetes-master-node.sh")
  vars = {
    S3_BUCKET = var.S3_BUCKET
  }
}

data "template_cloudinit_config" "master-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-all.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-master.rendered
  }
}
