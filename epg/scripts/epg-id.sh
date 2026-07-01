#!/bin/bash
cd /home/runner/work/M3UPT/M3UPT/iptv-org-epg && npm install

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/files/aioepg.xml --days=2 --maxConnections=10
npm run grab -- --sites=maxstream.tv --output=../epg/files/id-mxs.xml --days=2 --maxConnections=10
npm run grab -- --sites=visionplus.id --output=../epg/files/id-vplus.xml --days=2 --maxConnections=10
npm run grab -- --sites=vidio.com --output=../epg/files/id-vd.xml --days=2 --maxConnections=10
npm run grab -- --sites=cubmu.com --output=../epg/files/id-cm.xml --days=2 --maxConnections=10
npm run grab -- --sites=dens.tv --output=../epg/files/id-ds.xml --days=2 --maxConnections=10

cd ../epg/files

xz -kf9 *.xml && gzip -kf9 *.xml
rm -f *.xml

exit 0
