#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

if [ "${HADOOP_HDFS_DATANODE}" != "true" ];then
    echo "> 'HADOOP_HDFS_DATANODE!=true' Remove service"
    rm -f /etc/consul.d/hdfs-datanode.json
    consul reload
    sleep 2
    exit 0
fi

/opt/qnib/hdfs/datanode/bin/configure.sh
/opt/qnib/hdfs/datanode/bin/bootstrap.sh

echo -n ">> Waiting for 'hdfs-namenode'.... "
wait_for_srv hdfs-namenode
sleep 2

su -c "/opt/hadoop/bin/hdfs --config /opt/hadoop/etc/hadoop/ datanode" hadoop
