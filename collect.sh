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
LINK="https://portal.inmet.gov.br/uploads/dadoshistoricos"
for YEAR in {2000..2022}
do
	FILE="$YEAR.zip"
	if [ ! -f "$CURR/raw/$FILE" ]; then
		echo "Downloading ... $FILE"
		wget -P "$CURR/raw" "$LINK/$FILE"
	fi
done

# Unzip the files
for YEAR in {2000..2022}
do
	FILE="$YEAR.zip"
	echo "Unzipping ... $FILE"
	if [ "$YEAR" -lt "2020" ]; then
		unzip -n -q "$CURR/raw/$FILE" -d "$CURR/dataset/"
	else
		unzip -n -q "$CURR/raw/$FILE" -d "$CURR/dataset/$YEAR"
	fi
	
done

# Trim the header of the files and store into stations csv
STATIONS="$CURR/dataset/STATION_DATA.CSV"
echo "CAMINHO PARA STATIONS DATA $STATIONS"
for YEAR in {2000..2022}
do
	if [ ! -f $STATIONS ]; then
		touch $STATIONS
	fi

	for FILE in $CURR/dataset/$YEAR/*.CSV
	do
		echo "READING FILE: $FILE"
		LCOUNT=1
		while read LINE;
		do
			if [ "$LCOUNT" -gt "0" -a "$LCOUNT" -lt "7" ]; 
			then
				VALUE=$(echo "$LINE" | awk -F\; '{print $NF}')
				echo -n "$VALUE;" >> "$STATIONS"
				sed -i "1d" "$FILE"
			elif [ "$LCOUNT" -eq "7" ];
			then
				VALUE=$(echo "$LINE" | awk -F\; '{print $NF}')
				echo -n "$VALUE" >> "$STATIONS"
			elif [ "$LCOUNT" -eq "8" ]; 
			then
				sed -i "1d" "$FILE"
			else
				echo "" >> "$STATIONS"
				break
			fi
			LCOUNT=$(($LCOUNT + 1))
		done < "$FILE"
	done
done
SORTED=$(sort -u $STATIONS)
echo "REGIAO;UF;MUNICIPIO;CODIGO;LATITUDE;LONGITUDE;ALTITUDE" > $STATIONS
echo "$SORTED" >> $STATIONS

# Join all csv into big table
