#!/bin/bash

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-Devops-Practice" | jq '.images[].ImageID' | sed -e 's/"//g')

echo $AMI_ID
aws ec2 run-instances --image-id ${AMI_ID} --instance-type t2.micro