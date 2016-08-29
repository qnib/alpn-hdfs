#!/bin/bash
set -ex
source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http
sleep 2

if [ "X${HADOOP_HDFS_NAMENODE}" != "Xtrue" ];then
    wait_for_srv hdfs-namenode
fi
export NODE_IP=$(getent hosts $(go-getmyname) |awk '{print $1}')

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/hdfs-site.xml.ctmpl:/opt/hadoop/etc/hadoop/hdfs-site.xml"
consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/core-site.xml.ctmpl:/opt/hadoop/etc/hadoop/core-site.xml"
touch /tmp/hdfs_configure.done
exit 0
