#!/bin/bash

echo $(dirname $0)

python3 -m pip install requests

cd $(dirname $0)/scripts/
python3 ABCNews.py > ../luar/ABCNews.m3u8
sleep 3
python3 bernama.py > ../luar/bernama.m3u8
sleep 3
python3 cna.py > ../luar/cna.m3u8
sleep 3
python3 aljaen.py > ../luar/aljaen.m3u8
sleep 3
python3 aljaar.py > ../luar/aljaar.m3u8

echo m3u grabbed
