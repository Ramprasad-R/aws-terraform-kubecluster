data "template_file" "shell-script-jumpserver" {
  template = file("scripts/jumpserver.sh")
  vars = {
    S3_BUCKET = var.S3_BUCKET
  }
}

data "template_cloudinit_config" "jumpserver-cloudinit" {
  gzip          = false
  base64_encode = false

  part {
    content_type = "text/x-shellscript"
    content      = data.template_file.shell-script-jumpserver.rendered
  }

}
