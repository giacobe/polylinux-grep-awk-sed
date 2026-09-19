#!/bin/sh
set -eu
base=$(CDPATH= cd -- "$(dirname "$0")" && pwd)
for f in "$base"/.profile "$base"/install.sh "$base"/resources.sh "$base"/polylinux-common.sh "$base"/polylinux-parallel-runtime.sh "$base"/profile "$base"/nextlevel "$base"/prevlevel "$base"/checklevel "$base"/level1.sh "$base"/level2.sh "$base"/level3.sh "$base"/level4.sh "$base"/level5.sh "$base"/level6.sh "$base"/level7.sh "$base"/level8.sh "$base"/level9.sh "$base"/level10.sh; do
    [ -f "$f" ] || { echo "missing: $f" >&2; exit 1; }
    sh -n "$f"
done
for bad in 'shuf' '<(' '<<<' 'RANDOM'; do
    if grep -n "$bad" "$base"/install.sh "$base"/resources.sh "$base"/polylinux-common.sh "$base"/polylinux-parallel-runtime.sh "$base"/level*.sh 2>/dev/null; then
        echo "disallowed construct found: $bad" >&2
        exit 1
    fi
done
echo 'Static POSIX/package verification passed.'
grep -q "^LAB_ID='text-processing'$" "$base/install.sh"
grep -q "SEED_CONTRACT_VERSION=seed-v1" "$base/polylinux-common.sh"
grep -q "THEME_CATALOG_VERSION=themes-v1" "$base/polylinux-common.sh"
grep -q "CASE_ROOT:-/srv/text-processing/cases" "$base/resources.sh"
echo 'Grader-sensitive identity and path verification passed.'
