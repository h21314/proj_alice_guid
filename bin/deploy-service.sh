#!/bin/sh
BUILD_ID=DONTKILLME
TEM_SERVER_ZIP_FILE=$1
BACKUP=false
SERVER_NAME=APP_NAME

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

if [ -d "/data/${SERVER_NAME}/lib" ];then
  rm -rf "/data/${SERVER_NAME}/lib"
  rm -rf "/data/${SERVER_NAME}/bin"
  rm -rf "/data/${SERVER_NAME}/conf"
fi

mv -f "/data/${SERVER_NAME}/${SERVER_NAME}/"* "/data/${SERVER_NAME}/"
rm -rf "/data/${SERVER_NAME}/${SERVER_NAME}"

if [ "$BACKUP" = true ];then
  mv "$TEM_SERVER_ZIP_FILE" "/data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
  echo "备份为 /data/${SERVER_NAME}/backup/${SERVER_NAME}-${DATE_NAME}.zip"
fi

cd "/data/${SERVER_NAME}"
sh "bin/restart.sh"
