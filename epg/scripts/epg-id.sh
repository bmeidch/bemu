#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install --legacy-peer-deps

# ID EPG

# npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/aioepg.xml --days=2 --maxConnections=10

# IDHM EPG

npm run grab -- --site=indihometv.com --output=../epg/id-idhm-id.xml --days=2 --maxConnections=10

# VIS EPG

npm run grab -- --site=visionplus.id --output=../epg/id-vplus-id.xml --days=2 --maxConnections=10

# VID EPG

npm run grab -- --site=vidio.com --output=../epg/id-vd-id.xml --days=2 --maxConnections=10

# CM EPG

npm run grab -- --site=cubmu.com --output=../epg/id-cm-id.xml --days=2 --maxConnections=10

# DS EPG

npm run grab -- --site=dens.tv --output=../epg/id-ds-id.xml --days=2 --maxConnections=10

# MNCVISION EPG

npm run grab -- --site=mncvision.id --output=../epg/id-mncvision-id.xml --days=2 --maxConnections=10

# Compress EPG xml files
cd ../epg/

gzip -k -f -9 ../epg/aioepg.xml
gzip -k -f -9 ../epg/id*.xml

# Remove EPG xml files

rm ../epg/id*.xml
rm ../epg/aioepg.xml

exit 0
