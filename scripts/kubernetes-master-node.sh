#!/bin/bash

sudo cat <<EOF | sudo tee /etc/kubernetes/aws.yaml
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: ClusterConfiguration
networking:
  serviceSubnet: "10.100.0.0/16"
  podSubnet: "10.244.0.0/16"
apiServer:
  extraArgs:
    cloud-provider: "aws"
controllerManager:
  extraArgs:
    cloud-provider: "aws"
EOF

sudo kubeadm init --config /etc/kubernetes/aws.yaml

sudo mkdir -p /home/ubuntu/.kube
sudo cp -i /etc/kubernetes/admin.conf /home/ubuntu/.kube/config
sudo chown ubuntu:ubuntu -R /home/ubuntu
sleep 60
export KUBECONFIG=/etc/kubernetes/admin.conf && kubectl apply -f https://raw.githubusercontent.com/coreos/flannel/master/Documentation/kube-flannel.yml

echo 'source <(kubectl completion bash)' >>  /home/ubuntu/.bashrc

cat <<EOF | sudo tee join-config.yaml
---
apiVersion: kubeadm.k8s.io/v1beta2
kind: JoinConfiguration
discovery:
  bootstrapToken:
    token: API_TOKEN
    apiServerEndpoint: API_ENDPOINT
    caCertHashes:
      - CERT_HASH
  timeout: 2m0s
  tlsBootstrapToken: API_TOKEN
nodeRegistration:
  name: HOSTNAME
  kubeletExtraArgs:
    cloud-provider: aws
EOF

export API_TOKEN=`cat /var/log/cloud-init-setup.log  | grep "kubeadm join" -A 1 | tr '\n' ' ' | cut -d ' ' -f5`
export API_ENDPOINT=`cat /var/log/cloud-init-setup.log  | grep "kubeadm join" -A 1 | tr '\n' ' ' | cut -d ' ' -f3`
export CERT_HASH=`cat /var/log/cloud-init-setup.log  | grep "kubeadm join" -A 1 | tr '\n' ' ' | cut -d ' ' -f12`

sed -i "s/API_TOKEN/$API_TOKEN/g" join-config.yaml
sed -i "s/API_ENDPOINT/$API_ENDPOINT/g" join-config.yaml
sed -i "s/CERT_HASH/$CERT_HASH/g" join-config.yaml

aws s3 cp join-config.yaml s3://${S3_BUCKET}/join-config.yaml
aws s3 cp /home/ubuntu/.kube/config s3://${S3_BUCKET}/config