#!/bin/bash

set -ex

sleep 2

consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/hdfs-site.xml.ctmpl:/opt/hadoop/etc/hadoop/hdfs-site.xml"
consul-template -consul localhost:8500 -once -template "/etc/consul-templates/hadoop/core-site.xml.ctmpl:/opt/hadoop/etc/hadoop/core-site.xml"

exit 0
