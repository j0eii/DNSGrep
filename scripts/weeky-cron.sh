#!/bin/bash
while true; do
	bash /home/dev/apps/DNSGrep/scripts/fdns_a.sh
	bash /home/dev/apps/DNSGrep/scripts/rdns.sh
	bash /home/dev/apps/DNSGrep/scripts/scan.sh
	echo "Done - $(date +%Y/%m/%d-%T)"
	sleep 864000
done
