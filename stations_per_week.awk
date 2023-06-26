#!/usr/bin/awk/
function print_group(group_name, stations){
   group = "";
   for (station in stations){
        if (stations[station] > 10){
            if (group == ""){
               group = station;
            }else{
                group = group OFS station;
            }    
        }
   }

   print group_name": "group
}

function alen(a) {
    k = 0
    for(i in a) k++
    return k
}

function clear(a){
    for (i in a) delete a[i]
}

#From https://stackoverflow.com/a/31291337
function dfm(date,   a,year,month,day)
{
        split(date,a,/\//)
        year = a[3]; month = a[2]+0; day = a[1]
        date = ((year - 1970) * 365.25) + D[month] + day - 1
        if ((year % 4) == 0 && month > 2) { date = date + 1}
        return (date * 86400 - (25200))/86400
}

function abs(n)
{
        return n<0 ? -n : n
}

function date_diff(d1,d2)
{
    return  abs(dfm(d1)-dfm(d2))
}

BEGIN {
    group_name = "";
    split("0,31,59,90,120,151,181,212,243,273,304,334",D,/,/);
}

#Change group or not
($1 >= 2008) && ((group_name == "") || (date_diff($3"/"$2"/"$1, group_name) > 7)) && ($5 > 0){
    if (alen(stations_on_week) > 0)
        print_group(group_name, stations_on_week)

    clear(stations_on_week);
    group_name = $3"/"$2"/"$1
}

#Either way, save station rain
($1 >= 2008) && $5 > 0 {
    stations_on_week[$4] += $5 
    #group = (group == "" ? $4 : group OFS $4)
}

END {
    # Output last group (only), if there was any data at all.
    if (alen(stations_on_week) > 0)
        print_group(group_name, stations_on_week)
}