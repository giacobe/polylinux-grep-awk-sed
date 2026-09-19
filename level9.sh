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

awk -v t="$target" -v vp="$valid_position" -v xp="$void_position" -v o="$owner" -v c="$category" -v v="$value" -v g="$group" 'BEGIN { print "JOB,STATUS,OWNER,CATEGORY,VALUE"; for (i=1; i<=4095; i++) if (i==vp) printf "%s,VALID,%s,%s,%d\n",t,o,c,v; else if (i==xp) printf "%s,VOID,%s,%s,%d\n",t,o,c,v+20; else printf "JOB-%05d,%s,%s-%02d,%s,%d\n",i,(i%9==0?"INVALID":"VALID"),g,10+i%80,c,100+i%700 }' > "$CASE_DIR/jobs.csv"

write_readme "Read the target job in data/TASK.txt. data/jobs.csv contains 4,096 lines. Build a pipeline that uses grep to keep the target's VALID record and awk with a comma separator to print OWNER|VALUE. Submit owner|integer exactly as shown."
finish_level
