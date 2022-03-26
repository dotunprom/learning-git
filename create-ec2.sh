#!/bin/bash

if [ -z "$1" ]; then
  echo -e "\e[31mInput Machine Name is needed\e[0m"
  exit
fi

COMPONENT=$1
ZONE_ID="Z0162740WGIXNEZAQ2EF"

AMI_ID=$(aws ec2 describe-images --filters "Name=name,Values=Centos-7-DevOps-Practice" | jq '.Images[].ImageId' | sed -e 's/"//g')

echo $AMI_ID
PRIVATE_IP=$(aws ec2 run-instances \
  --image-id ${AMI_ID} \
  --instance-type t2.micro \
  --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=${COMPONENT}}]" \
  --instance-market-options "MarketType=spot,SpotOptions={SpotInstanceType=persistent,InstanceInterruptionBehavior=stop}"\
  --security-group-ids ${SGID} \
  | jq '.Instances[].PrivateIpAddress' | sed -e 's/"//g')

  sed -e "s/IPADDRESS/${PRIVATE_IP}/" -e "s/COMPONENT/${COMPONENT}/" route53.json >/tmp/record.json
  aws route53 change-resource-record-sets --hosted-zone-id ${ZONE_ID} --change-batch file:///tmp/record.json | jq