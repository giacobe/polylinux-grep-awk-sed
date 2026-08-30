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

{
    echo "REFERENCE|OWNER|ITEM|LOCATION|STATUS"
    target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)
    i=1
    while [ "$i" -le 4095 ]; do
        if [ "$i" -eq "$target_position" ]; then
            printf '%s|%s|%s|%s|active\n' "$target" "$owner" "$item" "$place"
        else
            if [ $((i % 6)) -eq 0 ]; then
                status=pending
            else
                status=closed
            fi
            printf 'REF-%06d|%s-%02d|%s|%s-%02d|%s\n' "$i" "$group" \
                "$((10 + i % 80))" "$item" "$location" "$((10 + i % 70))" \
                "$status"
        fi
        i=$((i + 1))
    done
} > "$CASE_DIR/records.psv"

write_readme "Read the target reference in data/TASK.txt. data/records.psv contains 4,096 lines. Use awk with | as the field separator to find its row. Submit OWNER|LOCATION exactly as shown."
finish_level
