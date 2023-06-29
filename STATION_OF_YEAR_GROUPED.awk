#!/usr/bin/awk

function retorna_se_presente_ou_v_base(nome_medidor, lista, v_base){
	retorno = nome_medidor in lista ? lista[nome_medidor] : v_base;
	return retorno;
}

#Verão
(($2 == 12 && $3 >= 21) || ($2 == 1 || $2 == 2) || ($2 == 3 && $3 <= 19)) {
	# print "Verão", $2, $3;
	precipt_total_ver[$4] += $5
	pressao_total_ver[$4] += $6
	radiacao_total_ver[$4] += $7
	temp_bulbo_seco_total_ver[$4] += $8
	
	medicoes_ver[$4] += 1
	medidores[$4] = 1
}

#Primavera
(($2 == 9 && $3 >= 22) || ($2 == 10 || $2 == 11) || ($2 == 12 && $3 <= 20)) {
        # print "Primavera", $2, $3;
        precipt_total_prim[$4] += $5
        pressao_total_prim[$4] += $6
	radiacao_total_prim[$4] += $7
	temp_bulbo_seco_total_prim[$4] += $8
        
	medicoes_prim[$4] += 1
        medidores[$4] = 1
}

#Inverno
(($2 == 6 && $3 >= 21) || ($2 == 7 || $2 == 8) || ($2 == 9 && $3 <= 21)) {
        # print "Inverno", $2, $3;
        precipt_total_inv[$4] += $5
	pressao_total_inv[$4] += $6
	radiacao_total_inv[$4] += $7 
	temp_bulbo_seco_total_inv[$4] += $8 
      
        medicoes_inv[$4] += 1
        medidores[$4] = 1
}

#Outono
(($2 == 3 && $3 >= 20) || ($2 == 4 || $2 == 5) || ($2 == 6 && $3 <= 20)) {
        # print "Outono", $2, $3;
        precipt_total_out[$4] += $5
        pressao_total_out[$4] += $6
        radiacao_total_out[$4] += $7
        temp_bulbo_seco_total_out[$4] += $8

        medicoes_out[$4] += 1
        medidores[$4] = 1
}

END{
    print "Medidor", "Precipitacao Media Verao", "Precipitacao Media Primavera", "Precipitacao Media Inverno", "Precipitacao Media Outono", "Pressao Media Verao", "Pressao Media Primavera", "Pressao Media Inverno", "Pressao Media Outono", "Radiacao Media Verao", "Radiacao Media Primavera", "Radiacao Media Inverno", "Radiacao Media Outono", "Temp Bulbo Seco Media Verao", "Temp Bulbo Seco Media Primavera", "Temp Bulbo Seco Media Inverno", "Temp Bulbo Seco Media Outono"
    
    for (medidor in medidores){
    	#Medicoes por estação do ano
    	meds_ver = retorna_se_presente_ou_v_base(medidor, medicoes_ver, 1)
    	meds_prim = retorna_se_presente_ou_v_base(medidor, medicoes_prim, 1)
    	meds_inv = retorna_se_presente_ou_v_base(medidor, medicoes_inv, 1)
    	meds_out = retorna_se_presente_ou_v_base(medidor, medicoes_out, 1)
    	
    	#Verão
    	precp_media_ver = retorna_se_presente_ou_v_base(medidor, precipt_total_ver, 0)/meds_ver
    	pressao_media_ver = retorna_se_presente_ou_v_base(medidor, pressao_total_ver, 0)/meds_ver
    	radiacao_media_ver = retorna_se_presente_ou_v_base(medidor, radiacao_total_ver, 0)/meds_ver
    	temp_bulbo_seco_media_ver = retorna_se_presente_ou_v_base(medidor, temp_bulbo_seco_total_ver, 0)/meds_ver

	#Primavera
	precp_media_prim = retorna_se_presente_ou_v_base(medidor, precipt_total_prim, 0)/meds_prim
    	pressao_media_prim = retorna_se_presente_ou_v_base(medidor, pressao_total_ver, 0)/meds_prim
    	radiacao_media_prim = retorna_se_presente_ou_v_base(medidor, radiacao_total_prim, 0)/meds_prim
    	temp_bulbo_seco_media_prim = retorna_se_presente_ou_v_base(medidor, temp_bulbo_seco_total_prim, 0)/meds_prim
	
	#Inverno
	precp_media_inv = retorna_se_presente_ou_v_base(medidor, precipt_total_inv, 0)/meds_inv	
    	pressao_media_inv = retorna_se_presente_ou_v_base(medidor, pressao_total_inv, 0)/meds_inv
    	radiacao_media_inv = retorna_se_presente_ou_v_base(medidor, radiacao_total_inv, 0)/meds_inv
    	temp_bulbo_seco_media_inv = retorna_se_presente_ou_v_base(medidor, temp_bulbo_seco_total_inv, 0)/meds_inv
    	
	#Outono
	precp_media_out = retorna_se_presente_ou_v_base(medidor, precipt_total_out, 0)/meds_out
    	pressao_media_out = retorna_se_presente_ou_v_base(medidor, pressao_total_out, 0)/meds_out
    	radiacao_media_out = retorna_se_presente_ou_v_base(medidor, radiacao_total_out, 0)/meds_out
    	temp_bulbo_seco_media_out = retorna_se_presente_ou_v_base(medidor, temp_bulbo_seco_total_out, 0)/meds_out
	
    	print medidor, precp_media_ver, precp_media_prim, precp_media_inv, precp_media_out, pressao_media_ver, pressao_media_prim, pressao_media_inv, pressao_media_out, radiacao_media_ver, radiacao_media_prim, radiacao_media_inv, radiacao_media_out, temp_bulbo_seco_media_ver, temp_bulbo_seco_media_prim, temp_bulbo_seco_media_inv, temp_bulbo_seco_media_out;
    }
}
