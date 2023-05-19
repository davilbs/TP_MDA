#!/usr/bin/sh

NUM_STATIONS=4
#The tr command is so that numbers like ',2' or '5,2' can be identified as proper numbers (.2 or 5.2) inside awk
tail -n +2 ./dataset/INMET_DATA.CSV | tr ',' '.' | awk -F ';' -v OFS=";" -f group.awk -

