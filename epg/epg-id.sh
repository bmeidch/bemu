#!/bin/bash

cd /home/runner/work/bemu/bemu/iptv-org-epg && npm install

# IDHM EPG

npm run grab -- --channels=../EPG/pt.channels.xml --output=../EPG/epg-pt.xml --days=7 --maxConnections=10

# IDHM EPG

npm run grab -- --site=indihometv.com --output=../EPG/idhm.xml --days=7 --maxConnections=2

# VIS EPG

npm run grab -- --site=visionplus.id --output=../EPG/visionplus.xml --days=7 --maxConnections=10

# VID EPG

npm run grab -- --site=vidio.com --output=../EPG/vidio-com.xml --days=7 --maxConnections=5

# CM EPG

npm run grab -- --site=cubmu.com --output=../EPG/cubmu.xml --days=7 --maxConnections=5

# DS EPG

npm run grab -- --site=dens.tv --output=../EPG/dens.xml --days=7 --maxConnections=5

# Compress EPG xml files

xz -k -f -9 epg*.xml && gzip -k -f -9 epg*.xml

# Remove EPG xml files

rm epg*.xml

exit 0
