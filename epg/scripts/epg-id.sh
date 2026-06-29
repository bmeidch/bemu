#!/bin/bash
set -Eeuo pipefail

# Berpindah ke repositori iptv-org-epg
cd "$GITHUB_WORKSPACE/iptv-org-epg"

# Install dependencies
if [[ -f package-lock.json ]]; then
    npm ci --prefer-offline --no-audit --fund=false
else
    npm install --prefer-offline --no-audit --fund=false
fi

# PERBAIKAN JALUR: Disesuaikan dengan folder target epg/files/ di GitHub Actions
OUTPUT="$GITHUB_WORKSPACE/epg/files"
mkdir -p "$OUTPUT"

# Optimasi fungsi kompresi (gzip otomatis menghapus file XML asli)
compress() {
    local file="$1"
    if [[ -f "$file" ]]; then
        gzip -f9 "$file"
    else
        echo "Peringatan: Berkas $file tidak ditemukan untuk dikompresi."
    fi
}

case "${1:-}" in

aio)
    npm run grab -- \
        --channels="$GITHUB_WORKSPACE/epg/scripts/aiochannels.xml" \
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

*)
    echo "Usage:"
    echo "  $0 aio"
    echo "  $0 maxstream"
    echo "  $0 visionplus"
    echo "  $0 vidio"
    echo "  $0 cubmu"
    echo "  $0 dens"   
    exit 1
    ;;
esac
