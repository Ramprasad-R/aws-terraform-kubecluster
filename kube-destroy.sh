#!/bin/bash
S3_BUCKET=`cat s3_bucket_name.txt`
aws s3 rm s3://${S3_BUCKET} --recursive
terraform destroy -var S3_BUCKET=$S3_BUCKET