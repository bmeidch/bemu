#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# ID EPG

npm run grab --- --channels=../epg/scripts/aiochannels.xml --output=../epg/aioepg.xml --days=2 --maxConnections=10

# IDHM EPG

npm run grab --- --sites=maxstream.tv --output=../epg/id-mxs-id.xml --days=2 --maxConnections=10

# VIS EPG

npm run grab --- --sites=visionplus.id --output=../epg/id-vplus-id.xml --days=2 --maxConnections=10

# VID EPG

npm run grab --- --sites=vidio.com --output=../epg/id-vd-id.xml --days=2 --maxConnections=10

# CM EPG

npm run grab --- --sites=cubmu.com --output=../epg/id-cm-id.xml --days=2 --maxConnections=10

# DS EPG

npm run grab --- --sites=dens.tv --output=../epg/id-ds-id.xml --days=2 --maxConnections=10

# MNCVISION EPG

npm run grab -- --sites=mncvision.id --output=../epg/id-mncvision-id.xml --days=1 --maxConnections=10

# Compress EPG xml files
cd ../epg/

# Compress EPG xml files

xz -k -f -9 id*.xml && gzip -k -f -9 aioepg.xml

# gzip -k -f -9 ../epg/aioepg.xml
# gzip -k -f -9 ../epg/id*.xml
# Remove EPG xml files

rm ../epg/id*.xml
rm ../epg/aioepg.xml

exit 0
