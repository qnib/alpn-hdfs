#!/usr/local/bin/dumb-init /bin/bash

source /etc/bashrc.hadoop
source /opt/qnib/consul/etc/bash_functions.sh

if [ ! -d /data/hadoopdata/logs ];then
    mkdir /data/hadoopdata/logs/
    chown -R hadoop: /data/hadoopdata/logs/
    ln -s /data/hadoopdata/logs /opt/hadoop/
else
    chown -R hadoop: /opt/hadoop/logs
fi

if [ ! -d /data/hadoopdata/hdfs/datanode ];then
    mkdir -p /data/hadoopdata/hdfs/datanode
    chown -R hadoop: /data/hadoopdata/hdfs/datanode
else
    chown -R hadoop: /data/hadoopdata/hdfs/datanode
fi
# Wait for sshd to be up'n'running
#echo -n ">> Waiting for 'ssh'.... "
#wait_for_srv ssh

echo -n ">> Waiting for 'hdfs-namenode'.... "
wait_for_srv hdfs-namenode
sleep 2

echo ">> Is the namenode localhost?..."
supervisorctl status|egrep "hdfs-namenode.*RUNNING"
if [ $? -eq 0 ];then
    HADOOP_HDFS_NAMENODE_URI=localhost
else
    HADOOP_HDFS_NAMENODE_URI=hdfs-namenode.service.consul
fi
echo ">> NAMENODE=${HADOOP_HDFS_NAMENODE_URI}"

su -c "/opt/hadoop/bin/hdfs --config /opt/hadoop/etc/hadoop/ datanode -fs hdfs://${HADOOP_HDFS_NAMENODE_URI}/" hadoop

