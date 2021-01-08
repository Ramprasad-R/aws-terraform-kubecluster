# aws-terraform-kubecluster

## Run following command to setup custom kubernetes cluster in AWS.

Create a file terraform.tfvars and update the vaule for variable AWS_ACCESS_KEY, AWS_SECRET_KEY, AWS_REGION 

```bash
ssh-keygen -f awskey

chmod +x kube-setup.sh
./kube-setup.sh <unique-bucket-name> <worker-node-count>
```
