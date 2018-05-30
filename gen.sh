#!/bin/bash

servicefile=/root/ray/servicefile
host=c143-node1.phwblr.com
user=admin
passwd=prsingh
cluster=c143
port=8080
touch Diff.txt
curl -k -s -u admin:prsingh "http://172.25.34.6:8080/api/v1/clusters/c143?fields=Clusters/desired_configs" > $servicefile

for i in `cat  $servicefile | grep -i tag -B1 | grep "{" | awk  '{print $1}' | sed -e 's/^"//'  -e 's/"$//'`
do
/var/lib/ambari-server/resources/scripts/configs.py -u $user -p $passwd -l $host -n $cluster -a get -c $i | grep -v INFO > $i.config
echo $i
done
