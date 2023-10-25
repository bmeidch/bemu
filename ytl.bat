pip install requests

cd scripts/
python ABCNews.py > ../luar/ABCNews.m3u8
sleep 3
python bernama.py > ../luar/bernama.m3u8
sleep 3
python cna.py > ../luar/cna.m3u8
sleep 3
python cna.py > ../luar/aljaen.m3u8
sleep 3
python cna.py > ../luar/aljaar.m3u8
