#!/usr/local/bin/dumb-init /bin/bash

if [ ! -d /data/hadoopdata/hdfs ];then
    mkdir -p /data/hadoopdata/hdfs
fi

chown -R hadoop: /data/hadoopdata/hdfs

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
