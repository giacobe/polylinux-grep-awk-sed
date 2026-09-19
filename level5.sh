#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
item=$(theme_field item)
group=$(theme_field group)
location=$(theme_field location)
target="REF-$(hex_fragment target-id 6)"
owner="${group}-$(range_from_byte "$(hex_byte "$(derive_hex answer)" 0)" 12 88)"
place="${location}-$(range_from_byte "$(hex_byte "$(derive_hex answer)" 1)" 10 79)"
printf 'TARGET_REF=%s\n' "$target" > "$CASE_DIR/TASK.txt"
target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)

awk -v t="$target" -v p="$target_position" -v o="$owner" -v item="$item" -v pl="$place" -v g="$group" -v loc="$location" 'BEGIN { print "REFERENCE|OWNER|ITEM|LOCATION|STATUS"; for (i=1; i<=4095; i++) if (i==p) printf "%s|%s|%s|%s|active\n",t,o,item,pl; else printf "REF-%06d|%s-%02d|%s|%s-%02d|%s\n",i,g,10+i%80,item,loc,10+i%70,(i%6==0?"pending":"closed") }' > "$CASE_DIR/records.psv"

write_readme "Read the target reference in data/TASK.txt. data/records.psv contains 4,096 lines. Use awk with | as the field separator to find its row. Submit OWNER|LOCATION exactly as shown."
finish_level
