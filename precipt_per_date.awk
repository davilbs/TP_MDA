#!/usr/bin/awk/
function print_group(group_name, precipt, nmeds){
   mean_precipt = nmeds == 0? 0 : precipt/nmeds;
   print group_name, precipt, nmeds, mean_precipt;
}

BEGIN{print "Data", "Precipt Total", "N Medicoes", "Precipt Media"}

($3"/"$2"/"$1 != group_name){
    if (total_precipt != 0)
        print_group(group_name, total_precipt, n_meds)

    total_precipt = 0
    n_meds = 0
    group_name = $3"/"$2"/"$1
}

$5 > 0 {
    total_precipt = total_precipt + $5
    n_meds +=1
}

END {
    # Output last group (only), if there was any data at all.
    if (total_precipt != 0)
        print print_group(group_name, total_precipt, n_meds)
}
