#!/usr/bin/awk/
# This script assumes that the input file begins with a header line

#After header
NR > 1 {
		while (1) {
			curr_day = $1; curr_station = $(NF-1);
			while ($1 == curr_day && $(NF-1) == curr_station){
				precipitacao_soma += $3;
				if (getline == 0){
					print curr_day, curr_station, precipitacao_soma;
					exit;
				}
			}
			print curr_day, curr_station, precipitacao_soma
			#Resets data
			precipitacao_soma = 0;
 		}
}
