#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh

if [ "${HADOOP_HDFS_NAMENODE}" != "true" ];then
    echo "> 'HADOOP_HDFS_NAMENODE!=true' Remove service"
    rm -f /etc/consul.d/hdfs-namenode.json
    consul reload
    sleep 2
    exit 0
fi

/opt/qnib/hdfs/namenode/bin/configure.sh
/opt/qnib/hdfs/namenode/bin/bootstrap.sh

sleep 3

su -c '/opt/hadoop/bin/hdfs --config /opt/hadoop/etc/hadoop/ namenode' hadoop
