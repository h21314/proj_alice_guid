#!/bin/sh
BUILD_ID=DONTKILLME
SERVER_NAME=APP_NAME
TEM_SERVER_ZIP_FILE=$1
BACKUP=false
DATE_NAME=$(date +%Y%m%d-%H%M%S)

user=app
group=app

#create group if not exists
egrep "^$group" /etc/group >& /dev/null
if [ $? -ne 0 ]
then
    groupadd $group
fi

#create user if not exists
egrep "^$user" /etc/passwd >& /dev/null
if [ $? -ne 0 ]
then
    useradd -g $group $user
fi

if [ ! -n "$TEM_SERVER_ZIP_FILE" ];then
  TEM_SERVER_ZIP_FILE="/tmp/${SERVER_NAME}/target/${SERVER_NAME}.zip"
  BACKUP=true
fi
if [ ! -f "$TEM_SERVER_ZIP_FILE" ];then
  echo "jenkines deploy path ${TEM_SERVER_ZIP_FILE} 不存在，无法发布服务，请检查jenkines配置"
  echo "或者选择 /data/${SERVER_NAME}/backup目录下的历史版本进行发布服务"
  exit 1
fi
if [ ! -d "/data/${SERVER_NAME}/lib" ];then
  echo "项目路径不存在，开始初始化"
  mkdir -p "/data/${SERVER_NAME}/backup"
  mkdir -p "/data/logs/${SERVER_NAME}"
  ln -s "/data/logs/${SERVER_NAME}" "/data/${SERVER_NAME}/logs"
fi
echo "开始解压zip, $TEM_SERVER_ZIP_FILE"

unzip  -q -o "$TEM_SERVER_ZIP_FILE" -d /data/${SERVER_NAME}
chown app:app /data/${SERVER_NAME}/${SERVER_NAME} -R

if [ -d "/data/${SERVER_NAME}/lib" ];then
  rm -rf "/data/${SERVER_NAME}/lib"
  rm -rf "/data/${SERVER_NAME}/bin"
  rm -rf "/data/${SERVER_NAME}/conf"
fi

mv -f "/data/${SERVER_NAME}/${SERVER_NAME}/"* "/data/${SERVER_NAME}/"
rm -rf "/data/${SERVER_NAME}/${SERVER_NAME}"

if [ "$BACKUP" = true ];then
  echo "备份为 /data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
  mv "$TEM_SERVER_ZIP_FILE" "/data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
  chmod 777 "/data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
  chown app:app "/data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
fi

# 修改已存在目录为app用户
path="/data/${SERVER_NAME}"
q=$(ls -l ${path}|sed -n '2p' |awk -F " " '{print $3}')
if [ "$q"x = "app"x ]; then
	echo '${path} user ok'
else
	chmod 777 ${path} -R
	chown app:app ${path} -R
	echo ${path}' user is not app'
fi
logpath="/data/logs/${SERVER_NAME}"
q=$(ls -l ${logpath}|sed -n '2p' |awk -F " " '{print $3}')
if [ "$q"x = "app"x ]; then
	echo ${logpath}' user ok'
else
	chmod 777 ${logpath} -R
	chown app:app ${logpath} -R
	echo ${logpath}' user is not app'
fi
tpath="/data/tmp"
q=$(ls -l ${tpath}|sed -n '2p' |awk -F " " '{print $3}')
if [ "$q"x = "app"x ]; then
	echo ${tpath}' user ok'
else
	chmod 777 ${tpath} -R
	chown app:app ${tpath} -R
	echo ${tpath}' user is not app'
fi

# 避免之前为root启动，先stop
/data/${SERVER_NAME}/bin/stop.sh

# 以app启动服务
su - app -c "/data/${SERVER_NAME}/bin/start.sh"