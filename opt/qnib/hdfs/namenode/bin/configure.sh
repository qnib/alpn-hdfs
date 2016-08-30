#!/usr/local/bin/dumb-init /bin/bash

source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http
sleep 2

export NODE_IP=$(getent hosts $(go-getmyname) |awk '{print $1}')

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hdfs/namenode/hdfs-site.xml.ctmpl:/opt/hadoop/etc/hadoop/hdfs-site.xml"
consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hdfs/core-site.xml.ctmpl:/opt/hadoop/etc/hadoop/core-site.xml"
