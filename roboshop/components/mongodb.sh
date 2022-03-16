#!/bin/bash

source components/common.sh

print "Setup YUM Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
MyChoice $?

Print "Install mongodb"
yum install -y mongodb-org &>>$LOG_FILE
MyChoice $?

print "Update mongodb listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
MyChoice $?

Print "Start mongodb"
systemctl enable mongod &>>$LOG_FILE && systemctl start mongod &>>$LOG_FILE
MyChoice $?

## Every Database needs the schema to be loaded for the application to work.
# netstat -lntp :  to check listen state