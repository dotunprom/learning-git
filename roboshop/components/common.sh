MyChoice()

{

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


APP_USER=roboshop

NODEJS(){
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
         curl -f -s -L -o /tmp/${COMPONENT}.zip "https://github.com/roboshop-devops-project/user/archive/main.zip" &>>${LOG_FILE}
         MyChoice $?

         Print "Clean Old Content"
         rm -rf /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}
         MyChoice $?


         Print "Extract App Content"
         cd /home/${APP_USER} &>>${LOG_FILE} && unzip -o /tmp/${COMPONENT}.zip &>>${LOG_FILE} && mv ${COMPONENT}-main ${COMPONENT} &>>${LOG_FILE}
         MyChoice $?

         Print "Install  App Dependencies"
         cd /home/${APP_USER}/${COMPONENT} &>>${LOG_FILE}&& npm install &>>${LOG_FILE}
         MyChoice $?

         Print "Fix App_User Permissions"
         chown -R ${APP_USER}:${APP_USER} /home/${APP_USER}
         MyChoice $?

         Print "Setup SystemD File"
          sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' -e 's/REDIS_HOST/redis.roboshop.internal/' -e 's/MONGO_ENDPOINT/mongodb.roboshop.internal/'
            /home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG_FILE}
         MyChoice $?

          #Print "Setup SystemD File"
           #sed -i  -e 's/MONGO_DNSNAME/mongodb.roboshop.internal/' \
                   #/home/roboshop/${COMPONENT}/systemd.service &>>${LOG_FILE} && mv /home/roboshop/${COMPONENT}/systemd.service /etc/systemd/system/${COMPONENT}.service  &>>${LOG_FILE}
           #MyChoice $?


         Print "Restart Catalogue Service"
         systemctl daemon-reload &>>${LOG_FILE} && systemctl restart ${COMPONENT} &>>${LOG_FILE} && systemctl enable ${COMPONENT} &>>${LOG_FILE}
         MyChoice $?

         }