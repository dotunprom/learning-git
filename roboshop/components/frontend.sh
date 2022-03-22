#!/bin/bash

source components/common.sh

Print "Installing Nginx"
yum install nginx -y &>>$LOG_FILE
MyChoice $?


Print "Downloading Nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
MyChoice $?


Print "Cleaning old Nginx content"
rm -rf /usr/share/nginx/html/* &>>$LOG_FILE
MyChoice $?

cd /usr/share/nginx/html/*

Print "Extracting Archive"
unzip /tmp/frontend.zip &>>$LOG_FILE && mv frontend-main/* . &>>$LOG_FILE && mv static/* . &>>$LOG_FILE
MyChoice $?

# && : move to second line if firs command is good
# || : if first is a failure, move the second command. if first is goo, it will go to second command.

Print "Update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf &>>$LOG_FILE
for component in catalogue user cart shipping; do
  echo -e "Update $component in configuration"
  sed -i -e "/${component}/s/localhost/${component}.roboshop.internal/" /etc/nginx/default.d/roboshop.conf
MyChoice $?
done

Print "Starting Nginx"
systemctl restart nginx &>>{$LOG_FILE} && systemctl enable nginx &>>{$LOG_FILE}
MyChoice $?