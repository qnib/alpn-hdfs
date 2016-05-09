FROM qnib/alpn-jdk8

ENV HADOOP_VER=2.7.2 \
    HADOOP_DFS_REPLICATION=1 \
    HADOOP_HDFS_NAMENODE=false \
    HADOOP_HDFS_DATANODE=true \
    HADOOP_HDFS_NAMENODE_PORT=8020 \
    HADOOP_HDFS_NAMENODE_URI=localhost \
    HADOOP_YARN_RESOURCEMANAGER=false
RUN apk add --update curl bc jq nmap \
 && curl -fsL http://apache.claz.org/hadoop/common/hadoop-${HADOOP_VER}/hadoop-${HADOOP_VER}.tar.gz | tar xzf - -C /opt && mv /opt/hadoop-${HADOOP_VER} /opt/hadoop \
 && apk del curl \
 && rm -rf /tmp/* /var/cache/apk/*
ADD opt/hadoop/etc/hadoop/hadoop-env.sh \
    opt/hadoop/etc/hadoop/mapred-site.xml \
    /opt/hadoop/etc/hadoop/
RUN adduser -D -s /bin/bash hadoop
RUN echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-${HADOOP_VER}-tests.jar TestDFSIO -write -nrFiles 64 -fileSize 16GB -resFile /tmp/TestDFSIOwrite.txt' hadoop" >> /root/.bash_history && \
    echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-2.7.2-tests.jar DistributedFSCheck -resFile /tmp/DistributedFSCheck.txt' hadoop" >> /root/.bash_history && \
    echo "hadoop fs -ls /" >> /root/.bash_history && \
    echo "su -c '/opt/hadoop/bin/hadoop fs -mkdir /test' hadoop" >> /root/.bash_history && \
    echo "su -c '/opt/hadoop/bin/hadoop fs -copyFromLocal /etc/hosts /test/' hadoop" >> /root/.bash_history
ADD etc/supervisord.d/hdfs-datanode.ini \
    etc/supervisord.d/hdfs-namenode.ini \
    /etc/supervisord.d/
ADD etc/consul.d/hdfs-namenode.json \
    etc/consul.d/hdfs-datanode.json \
    /etc/consul.d/
## Namenode Setup
#ADD etc/consul-templates/hdfs/namenode/core-site.xml.ctmpl \
#    etc/consul-templates/hdfs/namenode/hdfs-site.xml.ctmpl \
#    /etc/consul-templates/hdfs/namenode/
ADD opt/qnib/hdfs/namenode/bin/start.sh /opt/qnib/hdfs/namenode/bin/

## Datanode Setup
ADD opt/qnib/hdfs/datanode/bin/start.sh /opt/qnib/hdfs/datanode/bin/
ADD opt/qnib/hdfs/namenode/etc/hadoop-env.sh \
    opt/qnib/hdfs/namenode/etc/hdfs-site.xml \
    /opt/qnib/hdfs/namenode/etc/
ADD opt/qnib/hdfs/datanode/etc/hadoop-env.sh \
    opt/qnib/hdfs/datanode/etc/hdfs-site.xml \
    /opt/qnib/hdfs/datanode/etc/
ADD etc/consul-templates/hadoop/core-site.xml.ctmpl \
    etc/consul-templates/hadoop/hdfs-site.xml.ctmpl \
    /etc/consul-templates/hadoop/
ADD opt/qnib/hdfs/bin/configure.sh \
    opt/qnib/hdfs/bin/check.sh \
    /opt/qnib/hdfs/bin/
ADD etc/supervisord.d/hdfs-configure.ini /etc/supervisord.d/
ADD etc/bashrc.hadoop /etc/
#RUN echo "source /etc/bashrc.hadoop" >> /etc/bashrc
