#!/bin/sh
set -eu

ANSWER_DIR=${ANSWER_DIR:-/var/lib/text-processing/answers}
CASE_ROOT=${CASE_ROOT:-/srv/text-processing/cases}
failures=0

check() {
    level=$1
    actual=$2
    expected=$(sed -n '1p' "$ANSWER_DIR/level$level")
    if [ "$actual" = "$expected" ]; then
        echo "level$level: PASS"
    else
        echo "level$level: FAIL" >&2
        echo "  expected: $expected" >&2
        echo "  solver:   $actual" >&2
        failures=$((failures + 1))
    fi
}

# Level 1: literal matching.
actual=$(grep 'NOTICE' "$CASE_ROOT/level1/messages.txt" | sed 's/.*FLAG=//')
check 1 "$actual"

# Level 2: case-insensitive matching.
actual=$(grep -i 'priority' "$CASE_ROOT/level2/status.txt" | sed 's/.*CODE=//')
check 2 "$actual"

# Level 3: an end anchor plus grep line numbers.
actual=$(grep -n 'READY$' "$CASE_ROOT/level3/queue.txt" |
    sed 's/^\([0-9]*\):.*TOKEN=\([^ ]*\) READY$/\1|\2/')
check 3 "$actual"

# Level 4: select and print a whitespace-separated field.
target=$(sed -n 's/^TARGET_ID=//p' "$CASE_ROOT/level4/TASK.txt")
actual=$(awk -v target="$target" '$1 == target {print $3}' \
    "$CASE_ROOT/level4/inventory.txt")
check 4 "$actual"

# Level 5: use a custom field separator.
target=$(sed -n 's/^TARGET_REF=//p' "$CASE_ROOT/level5/TASK.txt")
actual=$(awk -F '|' -v target="$target" \
    '$1 == target {print $2 "|" $4}' "$CASE_ROOT/level5/records.psv")
check 5 "$actual"

# Level 6: condition and arithmetic.
category=$(sed -n 's/^TARGET_CATEGORY=//p' "$CASE_ROOT/level6/TASK.txt")
actual=$(awk -F ',' -v category="$category" \
    '$1 == category {sum += $2} END {print sum+0}' \
    "$CASE_ROOT/level6/measurements.csv")
check 6 "$actual"

# Level 7: substitutions.
target=$(sed -n 's/^TARGET_REF=//p' "$CASE_ROOT/level7/TASK.txt")
actual=$(grep "^$target|" "$CASE_ROOT/level7/drafts.psv" |
    sed 's/^[^|]*|draft-//; s/_/ /g')
check 7 "$actual"

# Level 8: range selection and extraction.
section=$(sed -n 's/^TARGET_SECTION=//p' "$CASE_ROOT/level8/TASK.txt")
actual=$(sed -n "/^BEGIN_$section\$/,/^END_$section\$/p" \
    "$CASE_ROOT/level8/sections.txt" | sed -n 's/^ANSWER=//p')
check 8 "$actual"

# Level 9: filter a record, then print fields.
target=$(sed -n 's/^TARGET_JOB=//p' "$CASE_ROOT/level9/TASK.txt")
actual=$(grep "^$target,VALID," "$CASE_ROOT/level9/jobs.csv" |
    awk -F ',' '{print $3 "|" $5}')
check 9 "$actual"

# Level 10: compose filtering, normalization, counting, and arithmetic.
category=$(sed -n 's/^TARGET_CATEGORY=//p' "$CASE_ROOT/level10/TASK.txt")
location=$(sed -n 's/^TARGET_LOCATION=//p' "$CASE_ROOT/level10/TASK.txt")
actual=$(grep "^$location|$category|complete|" "$CASE_ROOT/level10/report.psv" |
    sed 's/_units$//' |
    awk -F '|' -v category="$category" \
        '{count++; total += $4} END {print category "|" count "|" total}')
check 10 "$actual"

if [ "$failures" -ne 0 ]; then
    echo "$failures level(s) failed validation." >&2
    exit 1
fi
echo "All levels passed."
