#!/bin/bash
set -ex
source /opt/qnib/consul/etc/bash_functions.sh

sleep 10

if [ "X${HADOOP_HDFS_NAMENODE}" != "Xtrue" ];then
    wait_for_srv hdfs-namenode
fi

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/hdfs-site.xml.ctmpl:/opt/hadoop/etc/hadoop/hdfs-site.xml"
consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/core-site.xml.ctmpl:/opt/hadoop/etc/hadoop/core-site.xml"
touch /tmp/hdfs_configure.done
exit 0
