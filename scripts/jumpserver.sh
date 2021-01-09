#!/bin/bash
runAsRoot() {
  local CMD="$*"

  if [ $EUID -ne 0 ]; then
    CMD="sudo $CMD"
  fi

  $CMD
}

runAsRoot apt-get update && runAsRoot apt-get install -y apt-transport-https gnupg2 curl
curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | runAsRoot apt-key add -
echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | runAsRoot tee -a /etc/apt/sources.list.d/kubernetes.list
runAsRoot apt-get update
runAsRoot apt-get install -y kubectl awscli

runAsRoot mkdir -p /home/ubuntu/.kube

FILE_EXIST=`aws s3 ls s3://${S3_BUCKET}/config`
while [[ -z $FILE_EXIST ]]; do
  sleep 20
  FILE_EXIST=`aws s3 ls s3://${S3_BUCKET}/config`
done
sleep 5
aws s3 cp s3://${S3_BUCKET}/config /home/ubuntu/.kube/config

runAsRoot chown ubuntu:ubuntu -R /home/ubuntu

echo 'source <(kubectl completion bash)' >>  /home/ubuntu/.bashrc