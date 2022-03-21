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

#echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('RoboShop@1');" >/tmp/rootpass.sql
#DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')
#mysql -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql

echo 'show databases' | mysql -uroot -pRoboShop@1 &>>$LOG_FILE
if [ $? -ne 0 ]; then
Print "Change Default Root Password"
echo "SET PASSWORD FOR 'root'@'localhost' = PASSWORD('Roboshop@1');" >/tmp/rootpass.sql &>>$LOG_FILE
DEFAULT_ROOT_PASSWORD=$(grep 'temporary password' /var/log/mysqld.log | awk '{print $NF}')

mysql --connect-expired-password -uroot -p"${DEFAULT_ROOT_PASSWORD}" </tmp/rootpass.sql &>>$LOG_FILE
MyChoice $?
fi



## mysql_secure_installation
#```
#
#1. You can check the new password working or not using the following command in MySQL
#
#First lets connect to MySQL
#
#```bash
## mysql -uroot -pRoboShop@1
#```
#
#Once after login to MySQL prompt then run this SQL Command.
#
#```sql
#> uninstall plugin validate_password;
#```
#
### **Setup Needed for Application.**
#
#As per the architecture diagram, MySQL is needed by
#
#- Shipping Service
#
#So we need to load that schema into the database, So those applications will detect them and run accordingly.
#
#To download schema, Use the following command
#
#```bash
## curl -s -L -o /tmp/mysql.zip "https://github.com/roboshop-devops-project/mysql/archive/main.zip"
#```
#
#Load the schema for Services.