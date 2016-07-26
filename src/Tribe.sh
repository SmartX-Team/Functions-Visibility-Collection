#!/bin/bash


#Read node list from template file
NODE=`cat node_list`


#Check Snapd is loaded on all nodes
for i in $NODE
do
    
    STATUS=$(curl -L "http://$i:8181/v1/plugins")


    if [ "$STATUS" == "" ]
    then
           echo
	   echo
           echo "Snapd Load Error: $i Snapd is not loaded"
           exit 1
    else
           echo "$i: Snapd is Loaded!"
    fi

    #echo $TMP
done

#Save First Node 
for i in $NODE
do
    C[1]="$i"
    break
done



#defulat Tribe Port: 8181
PORT=8181



#Install js & jsawk 
sudo apt-get install libmozjs-24-bin
sudo update-alternatives –install /usr/bin/js js /usr/bin/js24 10

curl -L http://github.com/micha/jsawk/raw/master/jsawk > jsawk
chmod 755 jsawk && mv jsawk /usr/local/bin/


#Make New Agreement
curl -X POST http://${C[1]}:$PORT/v1/tribe/agreements -d '{"name":"cluster"}'


Member=$(curl http://localhost:8181/v1/tribe/members | jsawk 'return this.body' | sed -e 's/[{}]/''/g' | sed -e 's/\"/ /g' | sed -e 's/\[//g' | sed -e 's/\]//g' | sed -e 's/\,//g' | sed -e 's/members//g' | sed -e 's/\://g')

for i in $Member
do
	sleep 1
	#Join a member node into an agreement given the agreement name
	curl -X PUT http://${C[1]}:$PORT/v1/tribe/agreements/cluster/join -d '{"member_name": "'$i'"}'
done


