#!/usr/bin/awk/
function print_group(group_name, precipt){
   print group_name, precipt
}

($3"/"$2"/"$1 != group_name){
    if (group != "")
        print_group(group_name, group)

    group = 0
    group_name = $3"/"$2"/"$1
}

$5 > 0 {
    group = group + $5
}

END {
    # Output last group (only), if there was any data at all.
    if (group != "")
        print print_group(group_name, group)
}
