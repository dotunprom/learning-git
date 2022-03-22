#!/bin/bash

source components/common.sh

Print "Configure YUM Repos"
curl -s https://packagecloud.io/install/repositories/rabbitmq/rabbitmq-server/script.rpm.sh | bash &>>${LOG_FILE}
MyChoice $?

Print "Install ERlang & Rabbitmq"
yum install https://github.com/rabbitmq/erlang-rpm/releases/download/v23.2.6/erlang-23.2.6-1.el7.x86_64.rpm install rabbitmq-server -y &>>${LOG_FILE}
MyChoice $?

Print "RabbitMQ Service"
systemctl enable rabbitmq-server &>>${LOG_FILE} && systemctl start rabbitmq-server &>>${LOG_FILE}
MyChoice $?

#RabbitMQ comes with a default username / password as `guest`/`guest`. But this user cannot be used to connect. Hence we need to create one user for the application.

rabbitmqctl list_users | grep roboshop &>>${LOG_FILE}
if [ $? -ne 0 ]; then
  Print "Create Application User"
  rabbitmqctl add_user roboshop roboshop123 &>>${LOG_FILE}
  MyChoice $?
fi

Print "Configure Application User"
rabbitmqctl set_user_tags roboshop administrator &>>${LOG_FILE} && rabbitmqctl set_permissions -p /roboshop ".*" ".*" ".*" &>>${LOG_FILE}
MyChoice $?