#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
answer=$(answer_token 13)
section="$(theme_field category1)-$(hex_fragment section 4)"
answer_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 200 1800)
awk -v s="$section" -v a="$answer" -v p="$answer_position" 'BEGIN{print "BEGIN_GENERAL";for(i=1;i<=1022;i++)printf "NOTE=general-record-%04d\n",i;print "END_GENERAL";print "BEGIN_" s;for(i=1;i<=2046;i++)if(i==p)print "ANSWER=" a;else if(i%211==0)printf "# comment about selected record %04d\n",i;else printf "NOTE=selected-record-%04d\n",i;print "END_" s;print "BEGIN_ARCHIVE";for(i=1;i<=1022;i++)printf "NOTE=archive-record-%04d\n",i;print "END_ARCHIVE"}' > "$CASE_DIR/sections.txt"
printf 'TARGET_SECTION=%s\n' "$section" > "$CASE_DIR/TASK.txt"

write_readme "Read the target section name in data/TASK.txt. data/sections.txt contains 4,096 lines. Use sed to print only the inclusive range from BEGIN_target through END_target, then extract the value on its ANSWER= line. Submit exactly 13 case-sensitive Base64url characters."
finish_level
