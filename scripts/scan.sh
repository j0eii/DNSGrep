#!/bin/bash

curPath="/home/dev/apps/DNSGrep/scripts"

cd "$curPath"

targets=`curl -s http://192.168.200.163/targets.txt| grep -e "\."|sort -u| shuf`

while read -r target; do
	./submit-domain.sh $target
done <<< "$targets"
