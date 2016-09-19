#!/bin/bash

IP_ADD=$(ip -o -4 address |grep eth0 |egrep -o "\d+\.\d+\.\d+\.\d+")
echo "Check for open|filtered '$1' (port: $2)"
nmap ${IP_ADD} -p $2 
nmap ${IP_ADD} -p $2 |egrep "(open|filtered)"
exit $?
