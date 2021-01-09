locals {
  PRIVATE_SUBNET_ID = [aws_subnet.kubernetes-private-1.id, aws_subnet.kubernetes-private-2.id, aws_subnet.kubernetes-private-3.id]
}


resource "aws_instance" "kube-worker" {
  ami           = var.AMIS[var.AWS_REGION]
  instance_type = var.WORKER_INSTANCE_TYPE

  tags = {
    Name                               = "kube-worker-${count.index + 1}"
    "kubernetes.io/cluster/kubernetes" = "owned"
  }

  count = var.WORKER_COUNT

  subnet_id = element(local.PRIVATE_SUBNET_ID, count.index)


  vpc_security_group_ids = [aws_security_group.kubernetes-security-group.id]

  key_name = aws_key_pair.kubernete-key.key_name

  user_data = data.template_cloudinit_config.worker-cloudinit.rendered

  iam_instance_profile = aws_iam_instance_profile.k8s-cluster-iam-worker-role-instanceprofile.name
}

