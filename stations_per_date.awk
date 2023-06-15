#!/usr/bin/awk/
function print_group(group_name, stations){
   print group_name": "stations
}

($3"/"$2"/"$1 != group_name) && ($5 > 0){
    if (group != "")
        print_group(group_name, group)

    group = ""
    group_name = $3"/"$2"/"$1
}

$5 > 0 {
    group = (group == "" ? $4 : group OFS $4)
}

END {
    # Output last group (only), if there was any data at all.
    if (group != "")
        print print_group(group_name, group)
}
