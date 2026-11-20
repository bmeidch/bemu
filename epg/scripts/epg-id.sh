#!/usr/bin/env bash
set -euo pipefail

repo_root="$(cd "$(dirname "${BASH_SOURCE[0]}")/../.." && pwd)"
epg_dir="$repo_root/epg"
iptv_dir="$repo_root/iptv-org-epg"

cd "$iptv_dir"
npm ci

npm run grab -- --channels="$epg_dir/scripts/aiochannels.xml" --output="$epg_dir/files/aioepg.xml" --days=2 --maxConnections=20
npm run grab -- --sites=maxstream.tv --output="$epg_dir/files/id-mxs.xml" --days=2 --maxConnections=20
npm run grab -- --sites=visionplus.id --output="$epg_dir/files/id-vplus.xml" --days=2 --maxConnections=20
npm run grab -- --sites=vidio.com --output="$epg_dir/files/id-vd.xml" --days=2 --maxConnections=20
npm run grab -- --sites=cubmu.com --output="$epg_dir/files/id-cm.xml" --days=2 --maxConnections=20
npm run grab -- --sites=dens.tv --output="$epg_dir/files/id-ds.xml" --days=2 --maxConnections=20

shopt -s nullglob
xml_files=("$epg_dir"/files/*.xml)
if ((${#xml_files[@]} == 0)); then
  echo "No XML files were generated; refusing to report a successful update." >&2
  exit 1
fi
gzip -f9 "${xml_files[@]}"
