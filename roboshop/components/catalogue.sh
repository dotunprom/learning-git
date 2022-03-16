#!/bin/bash

source components/common.sh

Print "Config YUM repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash -
MyChoice $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>$LOG_FILE
MyChoice $?

Print "Add User"
useradd ${APP_USER} &>>$LOG_FILE
MyChoice $?

Print "Download Application component"
curl -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>$LOG_FILE
MyChoice $?

Print "Clean Old Content"
rm -rf /home/roboshop/catalogue
MyChoice $?


Print "Extract App Content"
cd /home/roboshop &>>$LOG_FILE && unzip -o /tmp/catalogue.zip && mv catalogue-main catalogue &>>$LOG_FILE
MyChoice $?

Print "Install  App Dependencies"
cd /home/roboshop/catalogue &>>$LOG_FILE && npm install &>>$LOG_FILE
MyChoice $?

# mv /home/roboshop/catalogue/systemd.service /etc/systemd/system/catalogue.service
# systemctl daemon-reload
# systemctl start catalogue
# systemctl enable catalogue
