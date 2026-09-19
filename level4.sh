#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
item=$(theme_field item)
location=$(theme_field location)
target="ID-$(hex_fragment target-id 5)"
answer="${location}-$(range_from_byte "$(hex_byte "$(derive_hex answer)" 0)" 11 49)"
printf 'TARGET_ID=%s\n' "$target" > "$CASE_DIR/TASK.txt"

awk -v t="$target" -v p="$target_position" -v item="$item" -v a="$answer" -v loc="$location" 'BEGIN{print "ID ITEM LOCATION STATUS";for(i=1;i<=4095;i++)if(i==p)printf "%s %s %s active\n",t,item,a;else printf "ID-%05d %s %s-%02d %s\n",i,item,loc,10+i%80,(i%5==0?"pending":"ready")}' > "$CASE_DIR/inventory.txt"

write_readme "Read the target ID in data/TASK.txt. data/inventory.txt contains 4,096 lines. In this whitespace-separated table, use awk to select that ID and print its LOCATION field. Submit only the location, in lowercase exactly as shown."
finish_level
