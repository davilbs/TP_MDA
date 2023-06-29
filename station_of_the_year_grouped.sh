#!/usr/bin/sh

tail -n +2 INMET_GROUP_DATA.CSV | awk -F ";" -v OFS=";" -f STATION_OF_YEAR_GROUPED.awk -
