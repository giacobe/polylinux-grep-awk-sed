#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
item=$(theme_field item)
location=$(theme_field location)
target="ID-$(hex_fragment target-id 5)"
answer="${location}-$(range_from_byte "$(hex_byte "$(derive_hex answer)" 0)" 11 49)"
printf 'TARGET_ID=%s\n' "$target" > "$CASE_DIR/TASK.txt"

{
    echo "ID ITEM LOCATION STATUS"
    target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)
    i=1
    while [ "$i" -le 4095 ]; do
        if [ "$i" -eq "$target_position" ]; then
            printf '%s %s %s active\n' "$target" "$item" "$answer"
        else
            if [ $((i % 5)) -eq 0 ]; then
                status=pending
            else
                status=ready
            fi
            printf 'ID-%05d %s %s-%02d %s\n' "$i" "$item" "$location" \
                "$((10 + i % 80))" "$status"
        fi
        i=$((i + 1))
    done
} > "$CASE_DIR/inventory.txt"

write_readme "Read the target ID in data/TASK.txt. data/inventory.txt contains 4,096 lines. In this whitespace-separated table, use awk to select that ID and print its LOCATION field. Submit only the location, in lowercase exactly as shown."
finish_level
