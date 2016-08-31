#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

if [ "${HADOOP_YARN_RESOURCEMANAGER}" != "true" ];then
    echo "> 'HADOOP_YARN_RESOURCEMANAGER!=true' Remove service"
    rm -f /etc/consul.d/yarn-resourcemanager.json
    consul reload
    sleep 2
    exit 0
fi

wait_for_srv hdfs-namenode


/opt/hadoop/bin/yarn resourcemanager
