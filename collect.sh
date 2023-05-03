#!/bin/bash
echo "Collecting data..."

# Check directory
delete=0
reprocess=0
while [[ "$#" -gt 0 ]]; do
    case $1 in
	-d=*|--delete=*) delete=1; range="${1#*=}" ;;
        -d|--delete) delete=1; range=0 ;;
        -p|--reprocess) reprocess=1 ;;
        *) echo "Unknown parameter passed: $1"; exit 1 ;;
    esac
    shift
done

if [ "$delete" -eq "1" ]; then
	if [ "$range" -ne "0" ]; then
		echo "Deleting range $range"
		beginning=$(sed -e 's/\(.*\)-.*$/\1/')
		final=$(sed -e 's/.*-\(.*\)$/\1/')
		for i in $(seq $beggining $final)
		do
			rm -rf dataset/$i
		done
	else	
		echo "Deleting all"
		rm -rf dataset
	fi
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
OUTPUTFILE="$DATAPATH/INMET_DATA.CSV"
echo "CAMINHO PARA STATIONS DATA $STATIONS"
echo "PATH TO CONCATENATED DATA $OUTPUTFILE"
HDSET=0
if [ $reprocess == 1 ] || [ ! -f "$OUTPUTFILE" ]; then
	echo "Processing  data"
	for YEAR in {2000..2022}
	do
		if [ ! -f $STATIONS ]; then
			touch $STATIONS
		fi

		FILECOUNT=$(ls $DATAPATH/$YEAR/*.CSV | wc -l)
		POS=0
		LOD="|"
		for FILE in $DATAPATH/$YEAR/*.CSV
		do
			STATION=$(echo $FILE | awk -F/ '{print $NF}' | awk -F_ '{printf $4}')
			LCOUNT=1
			echo -ne "LOADING $YEAR [$POS/$FILECOUNT] $LOD \r"
			if [ "$LOD" == "|" ]; then LOD="/" 
			elif [ "$LOD" == "/" ]; then LOD="-"
			elif [ "$LOD" == "-" ]; then LOD="\\"
			elif [ "$LOD" == "\\" ]; then LOD="|"
			fi
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
			if [ $HDSET -eq 0 ];
			then
				header_file=$(find $DATAPATH/2000/*.CSV | head -n1)
				header=$(head -n1 $header_file)
				echo "${header}ESTACAO;" > $OUTPUTFILE
				HDSET=1
			fi
			sed "1d" "$FILE" | sed -e "s/$/${STATION};/" >> $OUTPUTFILE
			POS=$(($POS+1))
		done
		echo "LOADING $YEAR [$POS/$FILECOUNT] ok!"
	done
	SORTED=$(sort -u -t';' -k 1,1 -k 2,2 -k 3,3  $STATIONS)
	echo "REGIAO;UF;MUNICIPIO;CODIGO;LATITUDE;LONGITUDE;ALTITUDE" > $STATIONS
	echo "$SORTED" >> $STATIONS
fi
# Remove invalid rows
echo "Cleaning output data..."
sed -i -e "/\(-9999;\)\1\{1,\}/d" "$OUTPUTFILE"
echo "Done!"
