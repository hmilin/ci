#!/bin/sh

# 启动WWeb主流程

echo
echo "* Web starting..."
echo

# 初始化Web
# 判断是否需要执行初始化操作，非容器环境不进行初始化
if [ "${CONTAINERIZED}" = true ] && [ ! -f provisioned ]; then
  echo "* Web provisioning..."
  echo

  echo "Replacing SUBDOMAIN with: \"${domain_suffix}\""
  sed -i "s/__SUBDOMAIN__/${domain_suffix}/g" $(grep __SUBDOMAIN__ -rl html/)
  echo

  # create a mark file tells that provision has been done
  touch provisioned
  echo "* Web provisioned."
  echo
fi

nginx -p $PWD -c conf/nginx.conf -g "daemon off;"
echo
