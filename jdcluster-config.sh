#!/bin/bash
IFS=$'\n'
servicefile=/root/ray/servicefile 
host=c143-node1.phwblr.com
user=admin
passwd=prsingh
cluster=c143
port=8080
> Diff.txt
curl -k -s -u $user:$passwd "http://$host:$port/api/v1/clusters/$cluster?fields=Clusters/desired_configs" > $servicefile

for i in `cat  $servicefile | grep -i tag -B1 | grep "{" | awk  '{print $1}' | sed -e 's/^"//'  -e 's/"$//'`
do 
/var/lib/ambari-server/resources/scripts/configs.py -u $user -p $passwd -l $host -n $cluster -a get -c $i | grep -v INFO > $i.new
diff -q $i.config $i.new > /dev/null 2>&1
returncode=`echo $?`
if [ $returncode == 1 ];then
  echo "Changes made in $i are" >> Diff.txt
  echo "====================================================================================================" >>Diff.txt
  echo "" >> Diff.txt
  /root/ray/jd -set $i.config $i.new  >Tmp_diff.txt
  awk '/^@/{x="F"++i;next}{print > x;}' Tmp_diff.txt 
  echo "Property changes are below" >>Diff.txt
  count=1
        for j in ` grep ^@ Tmp_diff.txt `
        do 
        echo "$j" >> Diff.txt
        echo "Changes made below" >> Diff.txt
        cat F$count >>Diff.txt 
        rm F$count
        count=$((count+1))
        echo "-----------------------------------------------------------------------------------------------------" >> Diff.txt
        done
fi
mv $i.new $i.config
done
