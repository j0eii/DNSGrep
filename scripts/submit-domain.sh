#!/bin/bash

curPath="/home/dev/apps/DNSGrep/scripts"
target=$1

echo "INIT - cleaning"

cd "$curPath"
rm -rf temp
rm -rf outputs_*
sleep 5


echo "Querying $1"
go run ../dnsgrep.go -f fdns_a.sort.txt -i ".$target" >> temp
go run ../dnsgrep.go -f rdns.sort.txt -i ".$target" >> temp

echo "Sorting $1"
res=`cat temp | cut -f 2 -d "," | sort -u`
echo -e "$res" > temp
echo "$target" >> temp

echo "Splitting $1"
split -l 500 --numeric-suffixes temp outputs_
sleep 5

allFiles=`ls $curPath/outputs_*`

while read -r file; do
	# you can upload your domains to any server you want
	echo "Submitting - $1 - $file"
	curl -s -L -H "Content-Type: multipart/form-data" \
		--connect-timeout 999 \
		-H "Authorization:Bearer iamkey" \
		-X POST \
		-F domains=@$file\
		-o /dev/null \
		http://192.168.200.163:2000/private/domains
	sleep 2
	echo "Submited - $1 - $file"
done <<< "$allFiles"
rm -rf temp
rm -rf outputs_*
sleep 2

echo "Done Query $1"
