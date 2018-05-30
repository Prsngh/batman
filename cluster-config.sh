#!/bin/bash

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
  diff   $i.config $i.new  | grep -v "^---" | grep -v "^[0-9c0-9]" >Tmp_diff.txt
for j in ` awk -F"\"" '{print $2}' Tmp_diff.txt | sort | uniq `
do 
a=`grep $j Tmp_diff.txt| grep "<" | sed 's/</-->/g'`
b=`grep $j Tmp_diff.txt| grep ">"|sed 's/>/-->/g'` 
echo "Value for $j yesterday  $a " >> Diff.txt
echo "" >> Diff.txt
echo "Value for $j today is $b" >> Diff.txt
  echo "-----------------------------------------------------------------------------------------------------" >> Diff.txt
done
fi
mv $i.new $i.config
done
