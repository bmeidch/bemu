#!/usr/bin/env python3

"""
EPG Merger v3.0 - Fixed & Optimized
"""

import os
import re
import sys
import glob
import time
import shutil
import traceback
import requests
import lxml.etree as et
import xml.dom.minidom as dom
import gzip
import tracemalloc
import hashlib
from pathlib import Path
from concurrent.futures import ThreadPoolExecutor, as_completed
from requests.adapters import HTTPAdapter
from urllib3.util.retry import Retry

# --------------------------------------------------------
# Arguments & Global Variables (Dinaikkan agar aman & rapi)
# --------------------------------------------------------
if len(sys.argv) < 6:
    print("Usage: epg_merger.py <RESULT> <SOURCE> <CAPTION_NAME> <CAPTION_URL>")
    sys.exit(1)

_, RESULT, SOURCE, CAPTION_NAME, CAPTION_URL = sys.argv

TMP = Path("../tmp")
MAX_WORKERS = 8
TIMEOUT = 30

START = time.time()

stats = {
    "download": 0,
    "merged": 0,
    "failed": 0,
    "skipped": 0,
}

CHANNELS = 0
PROGRAMMES = 0

# --------------------------------------------------------
# HTTP Session
# --------------------------------------------------------
retry = Retry(
    total=3,
    connect=3,
    read=3,
    backoff_factor=1,
    status_forcelist=[429, 500, 502, 503, 504],
)
adapter = HTTPAdapter(
    max_retries=retry,
    pool_connections=MAX_WORKERS,
    pool_maxsize=MAX_WORKERS,
)
session = requests.Session()
session.mount("http://", adapter)
session.mount("https://", adapter)
session.headers.update({"User-Agent": "EPG-Merger/3.0"})

# --------------------------------------------------------
# Logger
# --------------------------------------------------------
def info(msg): print(msg)
def ok(msg): print(f"[ OK ] {msg}")
def warn(msg): print(f"::warning::{msg}")
def fail(msg): print(f"::error::{msg}")
def group(title): print(f"::group::{title}")
def endgroup(): print("::endgroup::")

# --------------------------------------------------------
# Downloader
# --------------------------------------------------------
def validate_xml(file):
    try:
        et.parse(str(file))
        return True
    except Exception:
        return False

def download(url, filename, index, total):
    outfile = TMP / filename
    if outfile.exists():
        stats["skipped"] += 1
        ok(f"[{index:02}/{total}] Skip {filename}")
        return

    try:
        info(f"[{index:02}/{total}] Download {filename}")
        response = session.get(url, timeout=TIMEOUT, allow_redirects=True)
        response.raise_for_status()

        with open(outfile, "wb") as f:
            f.write(response.content)

        if not validate_xml(outfile):
            raise Exception("Downloaded file is not valid XML.")

        stats["download"] += 1
        ok(filename)
    except Exception:
        stats["failed"] += 1
        fail(filename)
        traceback.print_exc()
        raise

def download_all(files, urls):
    total = len(files)
    group(f"Downloading {total} XML files")
    with ThreadPoolExecutor(max_workers=MAX_WORKERS) as executor:
        futures = []
        for index, (url, filename) in enumerate(zip(urls, files), start=1):
            futures.append(executor.submit(download, url, filename, index, total))
        for future in as_completed(futures):
            future.result()
    endgroup()

# --------------------------------------------------------
# Mapping Loader
# --------------------------------------------------------
def load_mapping(filename):
    mapping = {}
    txt = Path(SOURCE).parent / f"{filename}.txt"
    if not txt.exists():
        return mapping
    with open(txt, encoding="utf-8") as f:
        for line in f:
            line = line.strip()
            if not line or "," not in line:
                continue
            old, new = line.split(",", 1)
            mapping[old] = new
    return mapping

# --------------------------------------------------------
# Streaming Merge Engine v3.0
# --------------------------------------------------------
def stream_merge():
    global CHANNELS, PROGRAMMES
    group("Streaming Merge")

    channels_set = set()
    programmes_set = set()

    with et.xmlfile(RESULT, encoding="UTF-8") as xf:
        xf.write_declaration()
        with xf.element("tv", {"generator-info-name": CAPTION_NAME, "generator-info-url": CAPTION_URL}):
            for xmlfile in sorted(TMP.glob("*.xml")):
                info(f"Processing {xmlfile.name}")
                mapping = load_mapping(xmlfile.name)
                
                context = et.iterparse(str(xmlfile), events=("end",))
                channel_count = 0
                programme_count = 0

                for _, elem in context:
                    if elem.tag == "channel":
                        cid = elem.attrib.get("id")
                        if cid in mapping:
                            elem.attrib["id"] = mapping[cid]
                            cid = mapping[cid]

                        if cid not in channels_set:
                            channels_set.add(cid)
                            xf.write(elem)
                            channel_count += 1
                            CHANNELS += 1 # Update global counter

                    elif elem.tag == "programme":
                        channel = elem.attrib.get("channel")
                        if channel in mapping:
                            elem.attrib["channel"] = mapping[channel]
                            channel = mapping[channel]

                        title = elem.findtext("title", default="")
                        key = (channel, elem.attrib.get("start"), elem.attrib.get("stop"), title)

                        if key not in programmes_set:
                            programmes_set.add(key)
                            xf.write(elem)
                            programme_count += 1
                            PROGRAMMES += 1 # Update global counter

                    elem.clear()
                
                ok(f"{xmlfile.name} C:{channel_count} P:{programme_count}")
    endgroup()

# --------------------------------------------------------
# Validasi, Kompresi & Checksum
# --------------------------------------------------------
def validate_result():
    group("Validate Output")
    try:
        et.parse(RESULT)
        ok("XML OK")
    except Exception:
        fail("Generated XML is invalid")
        raise
    endgroup()

def compress():
    group("Compress")
    gz = RESULT + ".gz"
    with open(RESULT, "rb") as fin:
        with gzip.open(gz, "wb", compresslevel=9) as fout:
            shutil.copyfileobj(fin, fout)
    ok(gz)
    endgroup()

def checksum():
    h = hashlib.sha256()
    with open(RESULT, "rb") as f:
        while True:
            chunk = f.read(1024 * 1024)
            if not chunk:
                break
            h.update(chunk)
    digest = h.hexdigest()
    ok(f"SHA256 : {digest}")
    return digest

def cleanup():
    group("Cleanup")
    if TMP.exists():
        shutil.rmtree(TMP, ignore_errors=True)
        ok("Temporary directory removed")
    endgroup()

def report():
    elapsed = time.time() - START
    xml_size = Path(RESULT).stat().st_size / 1024 / 1024 if Path(RESULT).exists() else 0
    _, peak = tracemalloc.get_traced_memory()

    print()
    print("=" * 45)
    print("           EPG MERGER v3.0")
    print("=" * 45)
    print(f"Downloaded : {stats['download']}")
    print(f"Skipped    : {stats['skipped']}")
    print(f"Failed     : {stats['failed']}")
    print()
    print(f"Channels   : {CHANNELS:,}")
    print(f"Programmes : {PROGRAMMES:,}")
    print()
    print(f"Output     : {RESULT}")
    print(f"XML Size   : {xml_size:.2f} MB")
    print()
    print(f"Elapsed    : {elapsed:.2f} sec")
    print(f"Peak RAM   : {peak / 1024 / 1024:.2f} MB")
    print("=" * 45)
    print(f"::notice::Finished in {elapsed:.2f}s | Channels={CHANNELS} | Programmes={PROGRAMMES}")

# --------------------------------------------------------
# Main Workflow
# --------------------------------------------------------
def main():
    tracemalloc.start()
    TMP.mkdir(exist_ok=True)

    files = []
    urls = []

    with open(SOURCE) as f:
        for line in f:
            line = line.strip()
            if not line:
                continue
            if line.startswith("http"):
                urls.append(line)
            else:
                files.append(line)

    download_all(files, urls)
    stream_merge()
    validate_result()
    compress()
    checksum()
    cleanup()
    report()
    tracemalloc.stop()

if __name__ == "__main__":
    try:
        main()
    except KeyboardInterrupt:
        fail("Cancelled")
        sys.exit(130)
    except Exception:
        traceback.print_exc()
        sys.exit(1)
    finally:
        session.close()
