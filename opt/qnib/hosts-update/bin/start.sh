#!/usr/local/bin/dumb-init /bin/bash

export LOCAL_HOSTS=$(grep $(hostname) /etc/hosts |awk '{print $1"="$2}' |xargs |sed -e 's/ /,/g)
consul-template -consul localhost:8500 -wait 5s -template "/etc/consul-templates/hosts.ctmpl:/etc/hosts.new:cat /etc/hosts.new > /etc/hosts"

