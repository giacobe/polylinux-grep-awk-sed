#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
answer=$(answer_token 12)
item=$(theme_field item)
target_id="$(printf '%s' "$item" | tr 'a-z' 'A-Z')-$(hex_fragment target-id 4)"
record_count=4096
target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)

i=1
while [ "$i" -le "$record_count" ]; do
    if [ "$i" -eq "$target_position" ]; then
        printf 'NOTICE %s FLAG=%s\n' "$target_id" "$answer"
    else
        printf 'INFO %s-%04d status=normal batch=%04d\n' \
            "$item" "$i" "$((i % 997))"
    fi
    i=$((i + 1))
done > "$CASE_DIR/messages.txt"

write_readme "data/messages.txt contains 4,096 records. Use grep to find the single line containing NOTICE. Submit only the value after FLAG=. The answer is exactly 12 case-sensitive Base64url characters."
finish_level
