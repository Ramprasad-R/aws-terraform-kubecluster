#!/bin/bash
file_exist=`aws s3 ls s3://${S3_BUCKET}/join-config.yaml`
while [[ -z $file_exist ]]; do
  sleep 30
  file_exist=`aws s3 ls s3://${S3_BUCKET}/join-config.yaml`
done
aws s3 cp s3://${S3_BUCKET}/join-config.yaml join-config.yaml

HOSTNAME=`hostname`

sed -i "s/HOSTNAME/$HOSTNAME/g" join-config.yaml

sudo cp join-config.yaml /etc/kubernetes/node.yaml

sleep 60

sudo kubeadm join --config /etc/kubernetes/node.yaml

mkdir -p /home/ubuntu/.kube
aws s3 cp s3://${S3_BUCKET}/config /home/ubuntu/.kube/config
