#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# ID EPG

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/aioepg.xml --days=2 --maxConnections=10

# IDHM EPG

npm run grab -- --sites=maxstream.tv --output=../epg/id-mxs.xml --days=2 --maxConnections=10

# VIS EPG

npm run grab -- --sites=visionplus.id --output=../epg/id-vplus.xml --days=2 --maxConnections=10

# VID EPG

npm run grab -- --sites=vidio.com --output=../epg/id-vd.xml --days=2 --maxConnections=10

# CM EPG

npm run grab -- --sites=cubmu.com --output=../epg/id-cm.xml --days=2 --maxConnections=10

# DS EPG

npm run grab -- --sites=dens.tv --output=../epg/id-ds.xml --days=2 --maxConnections=10

# MNCVISION EPG

npm run grab -- --channels=../epg/scripts/mvs.xml --output=../epg/id-mvsepg.xml --days=2 --maxConnections=10

# Compress EPG xml files
cd ../epg/

# Compress EPG xml files

#xz -k -f -9 id*.xml && gzip -k -f -9 aioepg.xml
#gzip -k -f -9 ../epg/aioepg.xml
#gzip -k -f -9 ../epg/id*.xml

shopt -s nullglob

for f in ../epg/*.xml; do
    gzip -kf9 "$f"
done

# Remove EPG xml files

rm -f ../epg/*.xml

exit 0
