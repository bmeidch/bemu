#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# IDHM EPG

npm run grab -- --site=indihometv.com --output=../epg/id/id-idhm-id.xml --days=2 --maxConnections=10

# VIS EPG

npm run grab -- --site=visionplus.id --output=../epg/id/id-vplus-id.xml --days=7 --maxConnections=10

# VID EPG

npm run grab -- --site=vidio.com --output=../epg/id/id-vd-id.xml --days=7 --maxConnections=10

# CM EPG

npm run grab -- --site=cubmu.com --output=../epg/id/id-cm-id.xml --days=7 --maxConnections=10

# DS EPG

npm run grab -- --site=dens.tv --output=../epg/id/id-ds-id.xml --days=7 --maxConnections=10

# Compress EPG xml files
cd epg/id

xz -k -f -9 id*.xml && gzip -k -f -9 id*.xml

# Remove EPG xml files

rm id*.xml

exit 0