#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# ID EPG

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/aio.xml --days=7 --maxConnections=10 --gzip

# IDHM EPG

npm run grab -- --site=indihometv.com --output=../epg/id-idhm-id.xml --days=2 --maxConnections=10

# VIS EPG

npm run grab -- --site=visionplus.id --output=../epg/id-vplus-id.xml --days=7 --maxConnections=10

# VID EPG

npm run grab -- --site=vidio.com --output=../epg/id-vd-id.xml --days=7 --maxConnections=10

# CM EPG

npm run grab -- --site=cubmu.com --output=../epg/id-cm-id.xml --days=7 --maxConnections=10

# DS EPG

npm run grab -- --site=dens.tv --output=../epg/id-ds-id.xml --days=7 --maxConnections=10

# Compress EPG xml files
cd ../epg/

gzip -k -f -9 ../epg/id*.xml

# Remove EPG xml files

rm ../epg/id*.xml

exit 0
