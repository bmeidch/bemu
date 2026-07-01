#!/bin/bash

cd iptv-org-epg || exit 1
npm install

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/files/aioepg.xml --days=2 --maxConnections=10
npm run grab -- --sites=maxstream.tv --output=../epg/files/id-mxs.xml --days=2 --maxConnections=10
npm run grab -- --sites=visionplus.id --output=../epg/files/id-vplus.xml --days=2 --maxConnections=10
npm run grab -- --sites=vidio.com --output=../epg/files/id-vd.xml --days=2 --maxConnections=10
npm run grab -- --sites=cubmu.com --output=../epg/files/id-cm.xml --days=2 --maxConnections=10
npm run grab -- --sites=dens.tv --output=../epg/files/id-ds.xml --days=2 --maxConnections=10

cd ../epg/files || exit 1

# Kompresi file menjadi .xz dan .gz, lalu hapus file .xml mentah
xz -kf9 *.xml && gzip -kf9 *.xml
rm -f *.xml

exit 0
