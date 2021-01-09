data "template_file" "init-script-worker" {
  template = file("scripts/init.cfg")
  vars = {
    REGION = var.AWS_REGION
  }
}

data "template_file" "shell-script-worker1" {
  template = file("scripts/kubernetes-setup-all-node.sh")
}

data "template_file" "shell-script-worker2" {
  template = file("scripts/kubernetes-worker-node.sh")
  vars = {
    S3_BUCKET = var.S3_BUCKET
  }
}

data "template_cloudinit_config" "worker-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    filename     = "init.cfg"
    content_type = "text/cloud-config"
    content      = data.template_file.init-script-worker.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-worker1.rendered
  }

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-worker2.rendered
  }

}
