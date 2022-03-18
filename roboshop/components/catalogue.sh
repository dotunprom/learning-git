#!/bin/bash

source components/common.sh

Print "Config YUM repo"
curl -fsSL https://rpm.nodesource.com/setup_lts.x | bash - &>>${LOG_FILE}
MyChoice $?

Print "Install NodeJS"
yum install nodejs gcc-c++ -y &>>${LOG_FILE}
MyChoice $?

Print "Add Application User"
      id ${APP_USER} &>>${LOG_FILE}
      if [ $? -ne 0 ]; then
         Print "Add Application User"
         useradd ${APP_USER} &>>${LOG_FILE}
         MyChoice $?
       fi

Print "Download Application component"
curl -f -s -L -o /tmp/catalogue.zip "https://github.com/roboshop-devops-project/catalogue/archive/main.zip" &>>${LOG_FILE}
MyChoice $?

Print "Clean Old Content"
rm -rf /home/${APP_USER}/catalogue &>>${LOG_FILE}
MyChoice $?


Print "Extract App Content"
cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/catalogue.zip &>>${LOG_FILE} && mv catalogue-main catalogue &>>${LOG_FILE}
MyChoice $?

Print "Install  App Dependencies"
cd /home/${APP_USER}/catalogue &>>${LOG_FILE} && npm install &>>${LOG_FILE}
MyChoice $?

Print "Fix App_User Permissions"
chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
MyChoice $?

Print "Setup SystemD File"
sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/'
/home/roboshop/catalogue/systemd.service &>>${LOG_FILE} && mv /home/roboshop/catalogue/systemd.service
/etc/systemd/system/catalogue.service &>>${LOG_FILE}
MyChoice $?



Print "Restart Catalogue Service"
systemctl daemon-reload &>>${LOG_FILE} && systemctl restart catalogue &>>${LOG_FILE} && systemctl enable catalogue &>>${LOG_FILE}
MyChoice $?