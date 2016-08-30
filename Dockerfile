FROM qnib/alpn-jdk8

ARG HADOOP_VER=2.7.2
ENV HADOOP_DFS_REPLICATION=1 \
    HADOOP_HDFS_NAMENODE=false \
    HADOOP_HDFS_DATANODE=true \
    HADOOP_HDFS_NAMENODE_PORT=8020 \
    HADOOP_HDFS_NAMENODE_URI=localhost \
    HADOOP_YARN_RESOURCEMANAGER=false
RUN apk add --update curl bc jq nmap \
 && curl -fsL http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz | tar xzf - -C /opt && mv /opt/hadoop-${HADOOP_VER} /opt/hadoop \
 && rm -rf /tmp/* /var/cache/apk/*
ADD opt/hadoop/etc/hadoop/hadoop-env.sh \
    opt/hadoop/etc/hadoop/mapred-site.xml \
    /opt/hadoop/etc/hadoop/
RUN adduser -D -s /bin/bash hadoop
ADD etc/supervisord.d/hdfs-datanode.ini \
    etc/supervisord.d/hdfs-namenode.ini \
    /etc/supervisord.d/
ADD etc/consul.d/hdfs-namenode.json \
    etc/consul.d/hdfs-datanode.json \
    /etc/consul.d/
# Namenode/Datanode
ADD etc/consul-templates/hdfs/core-site.xml.ctmpl \
    /etc/consul-templates/hdfs/
ADD opt/qnib/hdfs/bin/check.sh /opt/qnib/hdfs/bin/
# Namenode Setup
ADD etc/consul-templates/hdfs/namenode/hdfs-site.xml.ctmpl /etc/consul-templates/hdfs/namenode/
ADD opt/qnib/hdfs/namenode/bin/start.sh \
    opt/qnib/hdfs/namenode/bin/bootstrap.sh \
    opt/qnib/hdfs/namenode/bin/configure.sh \
    /opt/qnib/hdfs/namenode/bin/
## Datanode Setup
ADD opt/qnib/hdfs/datanode/bin/start.sh \
    opt/qnib/hdfs/datanode/bin/bootstrap.sh \
    opt/qnib/hdfs/datanode/bin/configure.sh \
    /opt/qnib/hdfs/datanode/bin/
ADD etc/consul-templates/hdfs/datanode/hdfs-site.xml.ctmpl /etc/consul-templates/hdfs/datanode/

ADD etc/bashrc.hadoop /etc/
RUN echo "source /etc/bashrc.hadoop" >> /etc/bashrc \
 && echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-${HADOOP_VER}-tests.jar TestDFSIO -write -nrFiles 16 -fileSize 2GB -resFile /tmp/TestDFSIOwrite.txt' hadoop" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.2-tests.jar DistributedFSCheck -resFile /tmp/DistributedFSCheck.txt' hadoop" >> /root/.bash_history \
 && echo "/opt/hadoop/bin/hadoop fs -ls /" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop fs -mkdir /test' hadoop" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop fs -copyFromLocal /etc/hosts /test/' hadoop" >> /root/.bash_history
