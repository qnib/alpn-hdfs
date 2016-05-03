#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh

if [ "${HADOOP_HDFS_NAMENODE}" != "true" ];then
    rm -f /etc/consul.d/hdfs-namenode.json
    consul reload
    sleep 2
    exit 0
fi

if [ ! -d /data/hadoopdata/hdfs ];then
    mkdir -p /data/hadoopdata/hdfs
    chown -R hadoop: /data/hadoopdata/hdfs
fi
if [ ! -d /data/hadoopdata/hdfs/namenode ];then
    echo "Formating namenode"
    su -c '/opt/hadoop/bin/hdfs --config /opt/hadoop/etc/hadoop/ namenode -format -force' hadoop
fi
if [ ! -d /data/hadoopdata/logs ];then
    mkdir /data/hadoopdata/logs/
    chown -R hadoop: /data/hadoopdata/logs/
    ln -s /data/hadoopdata/logs /opt/hadoop/
else
    chown -R hadoop: /opt/hadoop/logs
fi

# Wait for sshd to be up'n'running
#wait_for_srv ssh

HADOOP_HDFS_NAMENODE_URI=${HADOOP_HDFS_NAMENODE_URI-0.0.0.0}

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hdfs/namenode/core-site.xml.ctmpl:/opt/hadoop/etc/hadoop/core-site.xml"
su -c '/opt/hadoop/bin/hdfs --config /opt/hadoop/etc/hadoop/ namenode' hadoop
