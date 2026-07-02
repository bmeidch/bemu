#!/bin/bash

cd iptv-org-epg || exit 1
npm ci

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/files/aioepg.xml --days=2 --maxConnections=20
npm run grab -- --sites=maxstream.tv,visionplus.id,vidio.com,cubmu.com,dens.tv --output=../epg/files/id-{site}.xml --days=2 --maxConnections=20

cd ../epg/files || exit 1
gzip -f9 *.xml
exit 0
