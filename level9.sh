#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
group=$(theme_field group)
category=$(theme_field category1)
target="JOB-$(hex_fragment target-id 5)"
owner="${group}-$(range_from_byte "$(hex_byte "$(derive_hex answer)" 0)" 11 77)"
value=$(range_from_byte "$(hex_byte "$(derive_hex answer)" 1)" 120 480)
printf 'TARGET_JOB=%s\n' "$target" > "$CASE_DIR/TASK.txt"
valid_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 1900)
void_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 1)" 2200 3840)

{
    echo "JOB,STATUS,OWNER,CATEGORY,VALUE"
    i=1
    while [ "$i" -le 4095 ]; do
        if [ "$i" -eq "$valid_position" ]; then
            printf '%s,VALID,%s,%s,%d\n' "$target" "$owner" "$category" "$value"
        elif [ "$i" -eq "$void_position" ]; then
            printf '%s,VOID,%s,%s,%d\n' "$target" "$owner" "$category" "$((value + 20))"
        else
            if [ $((i % 9)) -eq 0 ]; then
                status=INVALID
            else
                status=VALID
            fi
            printf 'JOB-%05d,%s,%s-%02d,%s,%d\n' "$i" \
                "$status" "$group" "$((10 + i % 80))" "$category" "$((100 + i % 700))"
        fi
        i=$((i + 1))
    done
} > "$CASE_DIR/jobs.csv"

write_readme "Read the target job in data/TASK.txt. data/jobs.csv contains 4,096 lines. Build a pipeline that uses grep to keep the target's VALID record and awk with a comma separator to print OWNER|VALUE. Submit owner|integer exactly as shown."
finish_level
