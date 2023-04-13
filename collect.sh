#!/bin/bash
echo "Collecting data..."

# Check directory
if [ $1 == "-d" ]; then
	rm -rf dataset
	rm -rf raw
fi
if [ ! -d "raw" ]; then
	mkdir raw
fi
if [ ! -d "dataset" ]; then
	mkdir dataset
fi


# Download each zip file
CURR=$(pwd)
RAWPATH="$CURR/raw"
DATAPATH="$CURR/dataset"
LINK="https://portal.inmet.gov.br/uploads/dadoshistoricos"
for YEAR in {2000..2022}
do
	FILE="$YEAR.zip"
	if [ ! -f "$RAWPATH/$FILE" ]; then
		echo "Downloading ... $FILE"
		wget -P $RAWPATH "$LINK/$FILE"
	fi
done

# Unzip the files
for YEAR in {2000..2022}
do
	FILE="$YEAR.zip"
	echo "Unzipping ... $FILE"
	if [ "$YEAR" -lt "2020" ]; then
		unzip -n -q "$RAWPATH/$FILE" -d "$DATAPATH"
	else
		unzip -n -q "$RAWPATH/$FILE" -d "$DATAPATH/$YEAR"
	fi
	
done

# Trim the header of the files and store into stations csv
STATIONS="$DATAPATH/STATION_DATA.CSV"
echo "CAMINHO PARA STATIONS DATA $STATIONS"
for YEAR in {2000..2022}
do
	if [ ! -f $STATIONS ]; then
		touch $STATIONS
	fi

	for FILE in $DATAPATH/$YEAR/*.CSV
	do
		echo "READING FILE: $FILE"
		LCOUNT=1
		while read LINE;
		do
			if [ "$LCOUNT" -lt "7" ]; 
			then
				VALUE=$(echo "$LINE" | awk -F\; '{print $NF}')
				echo -n "$VALUE;" >> "$STATIONS"
			elif [ "$LCOUNT" -eq "7" ];
			then
				VALUE=$(echo "$LINE" | awk -F\; '{print $NF}')
				echo -n "$VALUE" >> "$STATIONS"
			elif [ "$LCOUNT" -gt "8" ];
			then
				echo "" >> "$STATIONS"
				break
			fi
			sed -i "1d" "$FILE"
			LCOUNT=$(($LCOUNT + 1))
		done < "$FILE"
	done
done
SORTED=$(sort -u $STATIONS)
echo "REGIAO;UF;MUNICIPIO;CODIGO;LATITUDE;LONGITUDE;ALTITUDE" > $STATIONS
echo "$SORTED" >> $STATIONS

# Join all csv into big table
# Create an empty output file with the header row
output_file=$DATAPATH/INMET_DATA.CSV
header_file=$(find $DATAPATH/2000/*.CSV | head -n1)
head -n1 $header_file > $output_file

# Loop over each year from 2000 to 2022
for year in {2000..2022}; do
    # Merge all .csv files in the current year's directory
    csv_files=$(ls $DATAPATH/$year/*.CSV)
    for csv_file in $csv_files; do
        # Remove the header row from the current .csv file
        sed 1d $csv_file >> $output_file
    done
done
