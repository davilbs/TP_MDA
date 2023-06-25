#!/usr/bin/sh

cut -f1-5 -d ";" dataset/INMET_GROUP_DATA.CSV | tail -n +2 | sort -k 1,1 -k 2,2 -k 3,3 -t ";" | awk -F ';' -v OFS="," -f stations_per_week.awk -