#!/bin/bash

echo $(dirname $0)

python3 -m pip install requests

cd $(dirname $0)/scripts/

python3 tvone.py > ../lokal/tvone.m3u8
sleep 3
python3 r21.py > ../lokal/r21.m3u8
sleep 3
python3 nettv.py > ../lokal/nettv.m3u8
sleep 3
python3 metrotv.py > ../lokal/metrotv.m3u8
sleep 3
python3 kompastv.py > ../lokal/kompastv.m3u8
sleep 3
python3 kompastvlr.py > ../lokal/kompastvlr.m3u8
sleep 3
python3 hope.py > ../lokal/hope.m3u8

echo m3u grabbed
