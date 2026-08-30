#!/bin/sh
set -eu
. "$INSTALL_ROOT/resources.sh"

fresh_case
answer=$(answer_token 13)
section="$(theme_field category1)-$(hex_fragment section 4)"
{
    echo "BEGIN_GENERAL"
    i=1
    while [ "$i" -le 1022 ]; do
        printf 'NOTE=general-record-%04d\n' "$i"
        i=$((i + 1))
    done
    echo "END_GENERAL"
    printf 'BEGIN_%s\n' "$section"
    answer_position=$(range_from_byte "$(hex_byte "$(derive_hex layout)" 0)" 200 1800)
    i=1
    while [ "$i" -le 2046 ]; do
        if [ "$i" -eq "$answer_position" ]; then
            printf 'ANSWER=%s\n' "$answer"
        elif [ $((i % 211)) -eq 0 ]; then
            printf '# comment about selected record %04d\n' "$i"
        else
            printf 'NOTE=selected-record-%04d\n' "$i"
        fi
        i=$((i + 1))
    done
    printf 'END_%s\n' "$section"
    echo "BEGIN_ARCHIVE"
    i=1
    while [ "$i" -le 1022 ]; do
        printf 'NOTE=archive-record-%04d\n' "$i"
        i=$((i + 1))
    done
    echo "END_ARCHIVE"
} > "$CASE_DIR/sections.txt"
printf 'TARGET_SECTION=%s\n' "$section" > "$CASE_DIR/TASK.txt"

write_readme "Read the target section name in data/TASK.txt. data/sections.txt contains 4,096 lines. Use sed to print only the inclusive range from BEGIN_target through END_target, then extract the value on its ANSWER= line. Submit exactly 13 case-sensitive Base64url characters."
finish_level
