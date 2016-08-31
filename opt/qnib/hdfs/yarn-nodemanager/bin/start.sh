#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh
wait_for_srv consul-http

if [ "${HADOOP_YARN_NODEMANAGER}" != "true" ];then
    echo "> 'HADOOP_YARN_NODEMANAGER!=true' Remove service"
    rm -f /etc/consul.d/yarn-nodemanager.json
    consul reload
    sleep 2
    exit 0
fi

wait_for_srv yarn-resourcemanager

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hdfs/yarn/yarn-site.xml.ctmpl:/opt/hadoop/etc/hadoop/yarn-site.xml"
/opt/hadoop/bin/yarn nodemanager
