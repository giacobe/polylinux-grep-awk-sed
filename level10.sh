#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
category=$(theme_field category1)
other=$(theme_field category2)
location_name=$(theme_field location)
region="$location_name-$(range_from_byte "$(hex_byte "$(derive_hex target)" 0)" 10 39)"
values_hex=$(derive_hex values)
v1=$(range_from_byte "$(hex_byte "$values_hex" 0)" 15 45)
v2=$(range_from_byte "$(hex_byte "$values_hex" 1)" 15 45)
v3=$(range_from_byte "$(hex_byte "$values_hex" 2)" 15 45)
answer="$category|3|$((v1 + v2 + v3))"
printf 'TARGET_CATEGORY=%s\nTARGET_LOCATION=%s\n' "$category" "$region" > "$CASE_DIR/TASK.txt"
p1=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 513 2100)
p2=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 1)" 3000 5100)
p3=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 2)" 6000 7800)

{
    echo "# LOCATION|CATEGORY|STATUS|AMOUNT"
    i=1
    while [ "$i" -le 8191 ]; do
        case "$i" in
            "$p1") printf '%s|%s|complete|%d_units\n' "$region" "$category" "$v1" ;;
            "$p2") printf '%s|%s|complete|%d_units\n' "$region" "$category" "$v2" ;;
            "$p3") printf '%s|%s|complete|%d_units\n' "$region" "$category" "$v3" ;;
            *)
                case $((i % 4)) in
                    0) printf '%s|%s|void|%d_units\n' "$region" "$category" "$((100 + i % 800))" ;;
                    1) printf '%s|%s|complete|%d_units\n' "$region" "$other" "$((100 + i % 800))" ;;
                    2) printf '%s-99|%s|complete|%d_units\n' "$location_name" "$category" "$((100 + i % 800))" ;;
                    *) printf '%s|%s|invalid|%d_units\n' "$region" "$category" "$((100 + i % 800))" ;;
                esac
                ;;
        esac
        i=$((i + 1))
    done
} > "$CASE_DIR/report.psv"

write_readme "Capstone: read the target category and location in data/TASK.txt. data/report.psv contains 8,192 lines. Keep only records for both targets with status complete. Remove the _units suffix, then count the records and sum their amounts. A grep/sed/awk pipeline is expected. Submit category|count|total, all lowercase with integers containing no leading zeroes."
finish_level
