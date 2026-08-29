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

{
    echo "CATEGORY,VALUE"
    i=1
    while [ "$i" -le 4095 ]; do
        case "$i" in
            "$p1") printf '%s,%d\n' "$category" "$v1" ;;
            "$p2") printf '%s,%d\n' "$category" "$v2" ;;
            "$p3") printf '%s,%d\n' "$category" "$v3" ;;
            *) printf '%s,%d\n' "$other" "$((20 + i % 80))" ;;
        esac
        i=$((i + 1))
    done
} > "$CASE_DIR/measurements.csv"

write_readme "Read the target category in data/TASK.txt. data/measurements.csv contains 4,096 lines. Use awk with a comma field separator to add VALUE only for that category. Submit the integer total with no spaces or punctuation."
record_answer "$answer"
finish_level
