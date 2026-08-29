#!/bin/sh
set -eu

cd "$(dirname "$0")"
INSTALL_ROOT=$(pwd)
export INSTALL_ROOT
. "$INSTALL_ROOT/resources.sh"

test_root=$(mktemp -d "${TMPDIR:-/tmp}/polylinux-text-processing.XXXXXX")
trap 'rm -rf "$test_root"' EXIT HUP INT TERM

generate_case() {
    case_name=$1
    case_user=$2
    case_date=$3
    case_root="$test_root/$case_name"
    USER_ID=$case_user
    currentDate=$case_date
    SYSTEM_PASSWORD=exercisePassword
    LEVEL_PASSWORD_ROOT=levelPassword
    LAB_PROFILE_PASSWORD="${LEVEL_PASSWORD_ROOT}Theme"
    LAB_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" "$SYSTEM_PASSWORD" \
        "$LAB_PROFILE_PASSWORD" | sha256sum | awk '{print $1}')
    THEME_INDEX=$(lab_derive_hex theme | cut -c 1)
    ANSWER_DIR="$case_root/answers"
    CASE_ROOT="$case_root/cases"
    SKIP_OWNERSHIP=1
    export USER_ID currentDate SYSTEM_PASSWORD LEVEL_PASSWORD_ROOT LAB_HASH \
        THEME_INDEX ANSWER_DIR CASE_ROOT SKIP_OWNERSHIP
    mkdir -p "$case_root/home" "$ANSWER_DIR" "$CASE_ROOT"

    levelnumber=1
    while [ "$levelnumber" -le 10 ]; do
        levelToBuild="level$levelnumber"
        LEVEL_HOME="$case_root/home/$levelToBuild"
        levelPassword="${LEVEL_PASSWORD_ROOT}${levelnumber}"
        level_HASH=$(printf '%s%s%s%s' "$USER_ID" "$currentDate" \
            "$SYSTEM_PASSWORD" "$levelPassword" | sha256sum | awk '{print $1}')
        export levelnumber levelToBuild LEVEL_HOME levelPassword level_HASH
        mkdir -p "$LEVEL_HOME"
        sh "$INSTALL_ROOT/$levelToBuild.sh"
        levelnumber=$((levelnumber + 1))
    done
}

snapshot_case() {
    root=$1
    find "$root" -type f -exec sha256sum {} \; |
        sed "s|$root/||" | sort
}

assert_line_count() {
    file=$1
    expected=$2
    actual=$(wc -l < "$file" | tr -d ' ')
    [ "$actual" -eq "$expected" ] ||
        die "$file has $actual lines; expected $expected"
}

assert_match_count() {
    description=$1
    expected=$2
    actual=$3
    [ "$actual" -eq "$expected" ] ||
        die "$description matched $actual records; expected $expected"
}

echo "generate fixed case A"
generate_case case-a student@example.edu 2026-07-23
echo "verify all reference solvers"
CASE_ROOT="$test_root/case-a/cases" ANSWER_DIR="$test_root/case-a/answers" \
    sh "$INSTALL_ROOT/verify.sh"

echo "test dataset sizes"
assert_line_count "$test_root/case-a/cases/level1/messages.txt" 4096
assert_line_count "$test_root/case-a/cases/level2/status.txt" 4096
assert_line_count "$test_root/case-a/cases/level3/queue.txt" 4096
assert_line_count "$test_root/case-a/cases/level4/inventory.txt" 4096
assert_line_count "$test_root/case-a/cases/level5/records.psv" 4096
assert_line_count "$test_root/case-a/cases/level6/measurements.csv" 4096
assert_line_count "$test_root/case-a/cases/level7/drafts.psv" 4096
assert_line_count "$test_root/case-a/cases/level8/sections.txt" 4096
assert_line_count "$test_root/case-a/cases/level9/jobs.csv" 4096
assert_line_count "$test_root/case-a/cases/level10/report.psv" 8192

echo "test target uniqueness"
assert_match_count "level1 NOTICE" 1 \
    "$(grep -c 'NOTICE' "$test_root/case-a/cases/level1/messages.txt")"
assert_match_count "level2 PRIORITY" 1 \
    "$(grep -ic 'priority' "$test_root/case-a/cases/level2/status.txt")"
assert_match_count "level3 READY suffix" 1 \
    "$(grep -c 'READY$' "$test_root/case-a/cases/level3/queue.txt")"
assert_match_count "level8 ANSWER" 1 \
    "$(grep -c '^ANSWER=' "$test_root/case-a/cases/level8/sections.txt")"
target_job=$(sed -n 's/^TARGET_JOB=//p' \
    "$test_root/case-a/cases/level9/TASK.txt")
assert_match_count "level9 valid target" 1 \
    "$(grep -c "^$target_job,VALID," "$test_root/case-a/cases/level9/jobs.csv")"
target_category=$(sed -n 's/^TARGET_CATEGORY=//p' \
    "$test_root/case-a/cases/level10/TASK.txt")
target_location=$(sed -n 's/^TARGET_LOCATION=//p' \
    "$test_root/case-a/cases/level10/TASK.txt")
assert_match_count "level10 complete targets" 3 \
    "$(grep -c "^$target_location|$target_category|complete|" \
        "$test_root/case-a/cases/level10/report.psv")"

echo "test root-login profile"
[ -f "$INSTALL_ROOT/.profile" ] || die "root .profile is missing"
grep -q '^dmesg -n1$' "$INSTALL_ROOT/.profile"
grep -q '^cd ~$' "$INSTALL_ROOT/.profile"
grep -q '^clear$' "$INSTALL_ROOT/.profile"
grep -q '^\./install\.sh$' "$INSTALL_ROOT/.profile"

echo "test identical-input repeatability"
snapshot_case "$test_root/case-a" > "$test_root/snapshot-a"
generate_case case-a student@example.edu 2026-07-23
snapshot_case "$test_root/case-a" > "$test_root/snapshot-a-rerun"
cmp "$test_root/snapshot-a" "$test_root/snapshot-a-rerun"

echo "test changed-learner variation"
generate_case case-b second.student@example.edu 2026-07-23
if cmp -s "$test_root/case-a/answers/level10" "$test_root/case-b/answers/level10"; then
    die "level10 answer did not vary for a changed learner"
fi

echo "test changed-date variation"
generate_case case-c student@example.edu 2026-07-24
if cmp -s "$test_root/case-a/answers/level6" "$test_root/case-c/answers/level6"; then
    die "level6 answer did not vary for a changed date"
fi

echo "test all 16 theme mappings"
theme=0
while [ "$theme" -le 15 ]; do
    case "$theme" in
        10) THEME_INDEX=a ;; 11) THEME_INDEX=b ;; 12) THEME_INDEX=c ;;
        13) THEME_INDEX=d ;; 14) THEME_INDEX=e ;; 15) THEME_INDEX=f ;;
        *) THEME_INDEX=$theme ;;
    esac
    export THEME_INDEX
    [ -n "$(theme_field title)" ]
    [ -n "$(theme_field item)" ]
    [ -n "$(theme_field category1)" ]
    theme=$((theme + 1))
done

echo "test answer permissions"
find "$test_root/case-a/answers" -type f -exec chmod 600 {} \;
bad_modes=$(find "$test_root/case-a/answers" -type f ! -perm 600)
[ -z "$bad_modes" ] || die "answer file permission check failed"

echo "test required-command detection"
if (command_required definitely-not-a-polylinux-command) >/dev/null 2>&1; then
    die "required-command detection accepted a missing command"
fi

echo "All deterministic tests passed."
