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

Print "Installing Nginx"
yum install nginx -y >>$LOG_FILE
MyChoice $?


Print "Downloading Nginx content"
curl -f -s -L -o /tmp/frontend.zip "https://github.com/roboshop-devops-project/frontend/archive/main.zip" >>$LOG_FILE
MyChoice $?


Print "Cleaning old Nginx content"
rm -rf /usr/share/nginx/html/* >>$LOG_FILE
MyChoice $?

cd /usr/share/nginx/html/

Print "Extracting Archive"
unzip /tmp/frontend.zip >>$LOG_FILE && mv frontend-main/* . >>$LOG_FILE && mv static/* . >>$LOG_FILE
MyChoice $?

# && : move to second line if firs command is good
# || : if first is a failure, move the second command. if first is goo, it will go to second command.

Print "Update roboshop configuration"
mv localhost.conf /etc/nginx/default.d/roboshop.conf >>$LOG_FILE
MyChoice $?

Print "Starting Nginx"
systemctl restart nginx >>$LOG_FILE && systemctl enable nginx >>$LOG_FILE
MyChoice $?