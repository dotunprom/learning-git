#!/bin/bash

source components/common.sh

Print "Setup YUM Repos"
curl -s -o /etc/yum.repos.d/mongodb.repo https://raw.githubusercontent.com/roboshop-devops-project/mongodb/main/mongo.repo &>>$LOG_FILE
MyChoice $?

Print "Install mongodb"
yum install -y mongodb-org &>>$LOG_FILE
MyChoice $?

Print "Update mongodb listen Address"
sed -i -e 's/127.0.0.1/0.0.0.0/' /etc/mongod.conf
MyChoice $?

Print "Start mongodb"
systemctl enable mongod &>>$LOG_FILE && systemctl restart mongod &>>$LOG_FILE
MyChoice $?

Print "Download Schema"
curl -f -s -L -o /tmp/mongodb.zip "https://github.com/roboshop-devops-project/mongodb/archive/main.zip" &>>$LOG_FILE
MyChoice $?

Print "Extract Schema"
cd /tmp && unzip mongodb.zip &>>$LOG_FILE
MyChoice $?

Print "Load Schema"
cd mongodb-main && mongo < catalogue.js &>>$LOG_FILE && mongo < users.js &>>$LOG_FILE
MyChoice $?


## Every Database needs the schema to be loaded for the application to work.
# netstat -lntp :  to check listen state