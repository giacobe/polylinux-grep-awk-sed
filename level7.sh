#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
item=$(theme_field item)
group=$(theme_field group)
number=$(range_from_byte "$(hex_byte "$(derive_hex answer)" 0)" 20 89)
answer="$item ready for $group $number"
encoded=$(printf 'draft-%s_ready_for_%s_%d' "$item" "$group" "$number")
target="REF-$(hex_fragment target-id 6)"
target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)
printf 'TARGET_REF=%s\n' "$target" > "$CASE_DIR/TASK.txt"
{
    echo "REFERENCE|DRAFT"
    i=1
    while [ "$i" -le 4095 ]; do
        if [ "$i" -eq "$target_position" ]; then
            printf '%s|%s\n' "$target" "$encoded"
        else
            printf 'REF-%06d|review-%s_waiting_for_%s_%d\n' \
                "$i" "$item" "$group" "$((10 + i % 80))"
        fi
        i=$((i + 1))
    done
} > "$CASE_DIR/drafts.psv"

write_readme "Read the target reference in data/TASK.txt. data/drafts.psv contains 4,096 lines. Use grep to select that record, then sed to remove everything through |draft- and replace every underscore with one space. Submit the resulting lowercase phrase with single spaces and no leading or trailing space."
record_answer "$answer"
finish_level
