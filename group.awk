#!/usr/bin/awk/
# This script assumes that the input file begins with a header line

function print_daily_result(day, station, precipit_tot, press_tot, radia_tot, temp_ar_b_seco_tot, temp_p_orv_tot, umidade_tot,
			   vento_raj_max_tot, vento_vel_tot, num_medicoes) {
	press_med = press_tot / num_medicoes;
	radia_med = radia_tot / num_medicoes;
	temp_b_seco_med = temp_ar_b_seco_tot / num_medicoes;
	temp_p_orv_med = temp_p_orv_tot / num_medicoes;
	umidade_med = umidade_tot / num_medicoes;
	vento_raj_med = vento_raj_max_tot / num_medicoes;
	vento_vel_med = vento_vel_tot / num_medicoes;
	split(day, array_dia, "-")
	print array_dia[1], array_dia[2], array_dia[3], station, precipit_tot, press_med, radia_med, temp_b_seco_med, temp_p_orv_med, umidade_med, vento_raj_med, vento_vel_med;
}

function return_zero_if_invalid(value){
	if (value == -9999 || value == "null") return 0
	else return value	
}

#If not header
NR > 1 {
		print "Ano", "Mês", "Dia", "Estacao", "Precipitação total", "Pressao media", "Radiacao media", "Temp bulbo seco media",
		      "Temp ponto orvalho media", "Umidade media", "Vento Rajada Media (m/s)", "Vento Velocidade Media (m/s)";
		while (1) {
			curr_day = $1; curr_station = $(NF-1);
			while ($1 == curr_day && $(NF-1) == curr_station){
				precipitacao_soma += return_zero_if_invalid($3);
				num_medicoes_dia++;
				pressao_soma += return_zero_if_invalid($4);
				radiacao_soma += return_zero_if_invalid($7);
				temp_ar_bulb_seco_soma += return_zero_if_invalid($8);
				temp_p_orv_soma += return_zero_if_invalid($9);
				umidade_soma += return_zero_if_invalid($16);
				vento_raj_max_soma += return_zero_if_invalid($18);
				vento_vel_soma += return_zero_if_invalid($19);
				if (getline == 0){
					print_daily_result(curr_day, curr_station, precipitacao_soma, pressao_soma,
							      radiacao_soma, temp_ar_bulb_seco_soma, temp_p_orv_soma,
							      umidade_soma, vento_raj_max_soma, vento_vel_soma, 
							      num_medicoes_dia)
					exit;
				}
			}
			print_daily_result(curr_day, curr_station, precipitacao_soma, pressao_soma, radiacao_soma,
					   temp_ar_bulb_seco, temp_p_orv_soma, umidade_soma, vento_raj_max_soma,
					   vento_vel_soma, num_medicoes_dia)
			#Resets data
			precipitacao_soma = 0;
			pressao_soma = 0;
			radiacao_soma = 0;
			temp_ar_bulb_seco_soma = 0;
			temp_p_orv_soma = 0;
			num_medicoes_dia = 0;
			umidade_soma = 0;
			vento_raj_max_soma = 0;
			vento_vel_soma = 0;
 		}
}
