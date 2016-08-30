#!/usr/local/bin/dumb-init /bin/bash

echo ">> Bootstrap datanode"
if [ ! -d /data/hadoopdata/logs ];then
    mkdir -p /data/hadoopdata/logs/
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
