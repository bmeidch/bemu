#!/bin/bash
set -e

cd "$GITHUB_WORKSPACE/iptv-org-epg"

npm ci

npm run grab -- --channels=../epg/scripts/aiochannels.xml --output=../epg/aioepg.xml --days=2 --maxConnections=10
npm run grab -- --sites=maxstream.tv --output=../epg/id-mxs.xml --days=2 --maxConnections=10
npm run grab -- --sites=visionplus.id --output=../epg/id-vplus.xml --days=2 --maxConnections=10
npm run grab -- --sites=vidio.com --output=../epg/id-vd.xml --days=2 --maxConnections=10
npm run grab -- --sites=cubmu.com --output=../epg/id-cm.xml --days=2 --maxConnections=10
npm run grab -- --sites=dens.tv --output=../epg/id-ds.xml --days=2 --maxConnections=10
npm run grab -- --channels=../epg/scripts/mvs.xml --output=../epg/id-mvsepg.xml --days=2 --maxConnections=10

cd ../epg

gzip -kf9 *.xml
rm -f *.xml

exit 0
