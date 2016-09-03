#!/usr/local/bin/dumb-init /bin/bash

/opt/qnib/hdfs/bin/check.sh dfs.datanode.address 50010
/opt/qnib/hdfs/bin/check.sh dfs.datanode.ipc.address 50020
/opt/qnib/hdfs/bin/check.sh dfs.datanode.http.address 50075
