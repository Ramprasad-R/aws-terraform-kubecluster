#!/bin/bash
terraform init
terraform apply -auto-approve -var S3_BUCKET=$1 -var WORKER_COUNT=$2
echo $2 > worker_node_count.txt