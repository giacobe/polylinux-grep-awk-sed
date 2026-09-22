#!/bin/sh
set -eu
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
for f in "$base"/.profile "$base"/install.sh "$base"/resources.sh "$base"/polylinux-common.sh "$base"/polylinux-parallel-runtime.sh "$base"/profile "$base"/nextlevel "$base"/prevlevel "$base"/level1.sh "$base"/level2.sh "$base"/level3.sh "$base"/level4.sh "$base"/level5.sh "$base"/level6.sh "$base"/level7.sh "$base"/level8.sh "$base"/level9.sh "$base"/level10.sh; do
    [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
    sh -n "$f"
done
grep -q "^LAB_ID='text-processing'$" "$base/install.sh"
grep -q '^target_position=' "$base/level5.sh"
[ ! -e "$base/checklevel" ] || { echo 'local checklevel helper must not ship' >&2; exit 1; }
! grep -R -n 'record_expected_answer' "$base"
echo 'Static verification passed.'
