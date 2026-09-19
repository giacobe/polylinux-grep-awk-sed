#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
answer=$(answer_token 12)
item=$(theme_field item)
style=$(range_from_byte "$(hex_byte "$(derive_hex capitalization)" 0)" 0 3)
record_count=4096
target_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)
case "$style" in
    0) marker=PRIORITY ;; 1) marker=Priority ;; 2) marker=priority ;; *) marker=pRiOrItY ;;
esac

awk -v count="$record_count" -v target="$target_position" -v item="$item" -v marker="$marker" -v answer="$answer" 'BEGIN { for(i=1;i<=count;i++) if(i==target) printf "%s-%04d %s CODE=%s\n",item,i,marker,answer; else if(i%7==0) printf "%s-%04d pending routine-review\n",item,i; else printf "%s-%04d routine status=ready\n",item,i }' > "$CASE_DIR/status.txt"

write_readme "data/status.txt contains 4,096 records. The word PRIORITY appears once, but its capitalization varies. Use grep's case-insensitive option to find it. Submit only the value after CODE=. The answer is exactly 12 case-sensitive Base64url characters."
finish_level
