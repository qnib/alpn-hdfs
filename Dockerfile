FROM qnib/alpn-hadoop

ENV HADOOP_DFS_REPLICATION=1 \
    HADOOP_HDFS_NAMENODE=false \
    HADOOP_HDFS_DATANODE=true \
    HADOOP_HDFS_NAMENODE_PORT=8020 \
    HADOOP_HDFS_NAMENODE_URI=localhost \
    HADOOP_YARN_RESOURCEMANAGER=false

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
    opt/qnib/hdfs/namenode/bin/healthcheck.sh \
    /opt/qnib/hdfs/namenode/bin/
## Datanode Setup
ADD opt/qnib/hdfs/datanode/bin/start.sh \
    opt/qnib/hdfs/datanode/bin/bootstrap.sh \
    opt/qnib/hdfs/datanode/bin/configure.sh \
    opt/qnib/hdfs/datanode/bin/healthcheck.sh \
    /opt/qnib/hdfs/datanode/bin/
ADD etc/consul-templates/hdfs/datanode/hdfs-site.xml.ctmpl /etc/consul-templates/hdfs/datanode/
RUN echo "source /etc/bashrc.hadoop" >> /etc/bashrc \
 && echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-${HADOOP_VER}-tests.jar TestDFSIO -write -nrFiles 32 -fileSize 2GB -resFile /tmp/TestDFSIOwrite.txt' hadoop" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop jar /opt/hadoop/share/hadoop/mapreduce/hadoop-mapreduce-client-jobclient-${HADOOP_VER}-tests.jar DistributedFSCheck -resFile /tmp/DistributedFSCheck.txt' hadoop" >> /root/.bash_history \
 && echo "/opt/hadoop/bin/hadoop fs -ls /" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop fs -mkdir /test' hadoop" >> /root/.bash_history \
 && echo "su -c '/opt/hadoop/bin/hadoop fs -copyFromLocal /etc/hosts /test/' hadoop" >> /root/.bash_history
# yarn resourcemanager
ADD opt/qnib/hdfs/yarn-resourcemanager/bin/start.sh /opt/qnib/hdfs/yarn-resourcemanager/bin/
ADD etc/consul-templates/hdfs/yarn/yarn-site.xml.ctmpl /etc/consul-templates/hdfs/yarn/
ADD etc/consul.d/yarn-resourcemanager.json /etc/consul.d/
ADD etc/supervisord.d/yarn-resourcemanager.ini /etc/supervisord.d/

# yarn nodemanager
ADD opt/qnib/hdfs/yarn-nodemanager/bin/start.sh /opt/qnib/hdfs/yarn-nodemanager/bin/
ADD etc/consul.d/yarn-nodemanager.json /etc/consul.d/
ADD etc/supervisord.d/yarn-nodemanager.ini /etc/supervisord.d/
