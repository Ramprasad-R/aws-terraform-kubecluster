resource "aws_security_group" "kubernetes-security-group" {
  name   = "kubernete-security-group"
  vpc_id = aws_vpc.kubernetes.id
  dynamic "ingress" {
    for_each = var.KUBE_INTERNAL_PORTS
    content {
      from_port = ingress.value
      to_port   = ingress.value
      protocol  = "tcp"
      self      = true
    }
  }

  dynamic "ingress" {
    for_each = var.EXTERNAL_PORTS
    content {
      from_port   = ingress.value
      to_port     = ingress.value
      protocol    = "tcp"
      cidr_blocks = ["0.0.0.0/0"]
    }
  }

  ingress {
    from_port   = var.KUBE_API_PORT
    to_port     = var.KUBE_API_PORT
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = var.NODE_PORT["FROM"]
    to_port     = var.NODE_PORT["TO"]
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

}