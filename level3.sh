#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
answer=$(answer_token 10)
record_count=4096
target_line=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 257 3840)
awk -v n="$record_count" -v p="$target_line" -v a="$answer" 'BEGIN { for (i=1; i<=n; i++) if (i==p) printf "record-%04d TOKEN=%s READY\n",i,a; else if (i%113==0) printf "READY check for record-%04d is pending\n",i; else printf "record-%04d status=WAITING batch=%04d\n",i,i%991 }' > "$CASE_DIR/queue.txt"

write_readme "data/queue.txt contains 4,096 records. Find the one line that ends with READY. Use grep with a line-end anchor and line numbers. Submit line-number|token, for example 731|Ab3_xY9pQ2. The line number has no leading zero and the token is case-sensitive."
finish_level
