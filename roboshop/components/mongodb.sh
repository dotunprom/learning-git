#!/bin/bash

MyChoice(){

  if [ $1 -eq 0 ]; then
  echo -e "\e[32mSUCCESS\e[0m"
else
  echo -e "\e[31mFAILURE\e[0m"
  exit 2
fi
}

Print() {
  echo -e "\n.................$1.................." &>>$LOG_FILE
  echo -e "\e[36m $1 \e[0m"
}

USER_ID=$(id -u)
if [ "$USER_ID" -ne 0 ]; then
  echo you should run your script as sudo or root user
  exit 1
fi
LOG_FILE=/tmp/roboshop.log
rm -f $LOG_FILE

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