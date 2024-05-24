#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# IDHM EPG

npm run grab -- --site=indihometv.com --output=../EPG/epg-idhm.xml --days=7 --maxConnections=2

# VIS EPG

npm run grab -- --site=visionplus.id --output=../EPG/epg-visionplus.xml --days=7 --maxConnections=10

# VID EPG

npm run grab -- --site=vidio.com --output=../EPG/epg-vidio-com.xml --days=7 --maxConnections=5

# CM EPG

npm run grab -- --site=cubmu.com --output=../EPG/epg-cubmu.xml --days=7 --maxConnections=5

# DS EPG

npm run grab -- --site=dens.tv --output=../EPG/epg-dens.xml --days=7 --maxConnections=5

# Compress EPG xml files

xz -k -f -9 epg*.xml && gzip -k -f -9 epg*.xml

# Remove EPG xml files

rm epg*.xml

exit 0
