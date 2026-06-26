#!/bin/bash
set -Eeuo pipefail

cd "$GITHUB_WORKSPACE/iptv-org-epg"

# Install dependencies
if [[ -f package-lock.json ]]; then
    npm ci --prefer-offline --no-audit --fund=false
else
    npm install --prefer-offline --no-audit --fund=false
fi

OUTPUT="../epg"

mkdir -p "$OUTPUT"

compress() {
    local file="$1"

    gzip -kf9 "$file"
    rm -f "$file"
}

case "${1:-}" in

aio)
    npm run grab -- \
        --channels="$OUTPUT/scripts/aiochannels.xml" \
        --output="$OUTPUT/aioepg.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/aioepg.xml"
    ;;

maxstream)
    npm run grab -- \
        --sites=maxstream.tv \
        --output="$OUTPUT/id-mxs.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-mxs.xml"
    ;;

visionplus)
    npm run grab -- \
        --sites=visionplus.id \
        --output="$OUTPUT/id-vplus.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-vplus.xml"
    ;;

vidio)
    npm run grab -- \
        --sites=vidio.com \
        --output="$OUTPUT/id-vd.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-vd.xml"
    ;;

cubmu)
    npm run grab -- \
        --sites=cubmu.com \
        --output="$OUTPUT/id-cm.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-cm.xml"
    ;;

dens)
    npm run grab -- \
        --sites=dens.tv \
        --output="$OUTPUT/id-ds.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-ds.xml"
    ;;

mncvision)
    npm run grab -- \
        --channels="$OUTPUT/scripts/mvs.xml" \
        --output="$OUTPUT/id-mvsepg.xml" \
        --days=2 \
        --maxConnections=10

    compress "$OUTPUT/id-mvsepg.xml"
    ;;

*)
    echo "Usage:"
    echo "  $0 aio"
    echo "  $0 maxstream"
    echo "  $0 visionplus"
    echo "  $0 vidio"
    echo "  $0 cubmu"
    echo "  $0 dens"
    echo "  $0 mncvision"
    exit 1
    ;;
esac
