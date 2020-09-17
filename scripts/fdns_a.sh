# fetch the fdns_a file
#wget -O fdns_a.gz https://opendata.rapid7.com/sonar.fdns_v2/2019-01-25-1548417890-fdns_a.json.gz
cd /home/dev/apps/DNSGrep/scripts
RES=`curl -k -s https://opendata.rapid7.com/sonar.fdns_v2/`
NEWURL=`echo $RES | grep -Eo "/sonar.fdns_v2/[0-9]{4}-[0-9]{2}-[0-9]{2}-[0-9]{10}-fdns_a.json.gz"`
URL="https://opendata.rapid7.com$NEWURL"

wget -O fdns_a.gz "$URL"

# extract and format our data
gunzip -c fdns_a.gz | jq -r '.value + ","+ .name' | tr '[:upper:]' '[:lower:]' | rev > fdns_a.rev.lowercase.txt

# split the data into chunks ot sort
split -l2000000 fdns_a.rev.lowercase.txt fileChunk

# remove the old files
rm fdns_a.gz
rm fdns_a.rev.lowercase.txt

## Sort each of the pieces and delete the unsorted one
for f in fileChunk*; do LC_COLLATE=C sort "$f" > "$f".sorted && rm "$f"; done

## merge the sorted files with local tmp directory
mkdir -p sorttmp
LC_COLLATE=C sort -T sorttmp/ -muo fdns_a.sort.txt fileChunk*.sorted

# clean up
rm fileChunk*
