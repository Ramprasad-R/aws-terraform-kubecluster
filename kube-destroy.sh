#!/bin/bash
S3_BUCKET=`cat s3_bucket_name.txt`
WORKER_COUNT=`cat worker_node_count.txt`
aws s3 rm s3://${S3_BUCKET} --recursive
terraform destroy -auto-approve -var S3_BUCKET=$S3_BUCKET -var WORKER_COUNT=$WORKER_COUNT