#!/bin/bash

cd iptv-org-epg || exit 1
npm ci

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/files/aioepg.xml --days=7 --maxConnections=20
npm run grab -- --sites=maxstream.tv --output=../epg/files/id-mxs.xml --days=7 --maxConnections=20
npm run grab -- --sites=visionplus.id --output=../epg/files/id-vplus.xml --days=7 --maxConnections=20
npm run grab -- --sites=vidio.com --output=../epg/files/id-vd.xml --days=7 --maxConnections=20
npm run grab -- --sites=cubmu.com --output=../epg/files/id-cm.xml --days=7 --maxConnections=20
npm run grab -- --sites=dens.tv --output=../epg/files/id-ds.xml --days=7 --maxConnections=20

cd ../epg/files || exit 1
gzip -f9 *.xml
exit 0
