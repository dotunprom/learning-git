#!/bin/bash

source components/common.sh


Print "configure YUM Repo"
curl -f -s -L -o /etc/yum.repos.d/mysql.repo https://raw.githubusercontent.com/roboshop-devops-project/mysql/main/mysql.repo &>>$LOG_FILE
MyChoice $?

Print "Install MySQL"
yum install mysql-community-server -y &>>$LOG_FILE
MyChoice $?

Print "Start MySQL Service"
systemctl enable mysqld &>>$LOG_FILE && systemctl start mysqld &>>$LOG_FILE
MyChoice $?


echo 'show databases' | mysql -uroot -pRoboShop@1 &>>${LOG_FILE}
if [ $? -ne 0 ]; then
Print "Change Default Root Password"
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');" >/tmp/rootpass.sql &>>${LOG_FILE} DEFAULT_ROOT_PASSWORD="$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')"  ! mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD} " </tmp/rootpass.sql &>>${LOG_FILE}
MyChoice $?
fi

echo show plugins | mysql -uroot -pRoboShop@1 2>>${LOG_FILE} | grep validate_password &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "Uninstall Password validate plugin"
  echo 'uninstall password validate_password;' >/tmp/rootpass.sql &>>${LOG_FILE}
 MyChoice $?
fi

Print "Download Schema"
curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip" &>>${LOG_FILE}
MyChoice $?

Print "Extract Schema"
cd /tmp && unzip -o mysql.zip &>>${LOG_FILE}
MyChoice $?

Print "Load Schema"
cd mysql-main && mysql -u root -pRoboShop@1 <shipping.sql &>>${LOG_FILE}
ALTER USER 'root'@'localhost' IDENTIFIED WITH mysql_native_password BY 'Current-Root-Password';
FLUSH PRIVILEGES;
MyChoice $?