#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
category=$(theme_field category1)
other=$(theme_field category2)
value_hex=$(derive_hex values)
v1=$(range_from_byte "$(hex_byte "$value_hex" 0)" 10 35)
v2=$(range_from_byte "$(hex_byte "$value_hex" 1)" 10 35)
v3=$(range_from_byte "$(hex_byte "$value_hex" 2)" 10 35)
answer=$((v1 + v2 + v3))
printf 'TARGET_CATEGORY=%s\n' "$category" > "$CASE_DIR/TASK.txt"
p1=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 1100)
p2=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 1)" 1500 2500)
p3=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 2)" 2900 3900)

awk -v c="$category" -v o="$other" -v p1="$p1" -v p2="$p2" -v p3="$p3" -v v1="$v1" -v v2="$v2" -v v3="$v3" 'BEGIN { print "CATEGORY,VALUE"; for (i=1; i<=4095; i++) if (i==p1) print c "," v1; else if (i==p2) print c "," v2; else if (i==p3) print c "," v3; else print o "," 20+i%80 }' > "$CASE_DIR/measurements.csv"

write_readme "Read the target category in data/TASK.txt. data/measurements.csv contains 4,096 lines. Use awk with a comma field separator to add VALUE only for that category. Submit the integer total with no spaces or punctuation."
finish_level
