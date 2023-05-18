#!/usr/bin/sh

#echo 'Getting num of stations:'
#NUM_STATIONS=$(cut -d ';' -f 20 './dataset/INMET_DATA.CSV' | sort -u - | wc -l)
#echo $NUM_STATIONS

NUM_STATIONS=4
#The tr command is so that numbers like ',2' or '5,2' can be identified as proper numbers (.2 or 5.2) inside awk
tail -n +2 ./dataset/INMET_DATA.CSV | tr ',' '.' | head -1900 | awk -F ';' -v NUM_STATIONS=$NUM_STATIONS -f group.awk -

