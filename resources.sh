#!/bin/sh

die() {
    echo "ERROR: $*" >&2
    exit 1
}

command_required() {
    command -v "$1" >/dev/null 2>&1 || die "required command not found: $1"
}

derive_hex() {
    label=$1
    printf '%s:%s' "$level_HASH" "$label" | sha256sum | awk '{print $1}'
}

lab_derive_hex() {
    label=$1
    printf '%s:%s' "$LAB_HASH" "$label" | sha256sum | awk '{print $1}'
}

hex_byte() {
    hex=$1
    index=$2
    start=$((index * 2 + 1))
    pair=$(printf '%s' "$hex" | cut -c "$start-$((start + 1))")
    printf '%d\n' "$((0x$pair))"
}

range_from_byte() {
    byte=$1
    minimum=$2
    maximum=$3
    printf '%d\n' "$((minimum + byte % (maximum - minimum + 1)))"
}

hex_fragment() {
    label=$1
    length=$2
    derive_hex "$label" | cut -c "1-$length"
}

base64url_digest() {
    printf '%s' "$1" | xxd -r -p | base64 | tr -d '\r\n=' | tr '+/' '-_'
}

answer_token() {
    length=$1
    base64url_digest "$(derive_hex answer)" | cut -c "1-$length"
}

theme_field() {
    field=$1
    case "$THEME_INDEX:$field" in
        0:title) printf 'Music streaming service' ;;
        0:item) printf track ;; 0:group) printf artist ;; 0:location) printf playlist ;;
        0:category1) printf ambient ;; 0:category2) printf electronic ;;
        1:title) printf 'Film festival' ;;
        1:item) printf film ;; 1:group) printf director ;; 1:location) printf theater ;;
        1:category1) printf documentary ;; 1:category2) printf animation ;;
        2:title) printf 'Online store' ;;
        2:item) printf product ;; 2:group) printf seller ;; 2:location) printf warehouse ;;
        2:category1) printf electronics ;; 2:category2) printf household ;;
        3:title) printf 'Food delivery service' ;;
        3:item) printf order ;; 3:group) printf restaurant ;; 3:location) printf zone ;;
        3:category1) printf prepared-food ;; 3:category2) printf groceries ;;
        4:title) printf 'Public transportation network' ;;
        4:item) printf vehicle ;; 4:group) printf operator ;; 4:location) printf stop ;;
        4:category1) printf local-route ;; 4:category2) printf express-route ;;
        5:title) printf 'Airline and airport operations' ;;
        5:item) printf flight ;; 5:group) printf carrier ;; 5:location) printf gate ;;
        5:category1) printf domestic-route ;; 5:category2) printf international-route ;;
        6:title) printf 'Hotel reservation system' ;;
        6:item) printf booking ;; 6:group) printf property ;; 6:location) printf floor ;;
        6:category1) printf standard-room ;; 6:category2) printf suite ;;
        7:title) printf 'Package delivery network' ;;
        7:item) printf parcel ;; 7:group) printf courier ;; 7:location) printf depot ;;
        7:category1) printf standard-delivery ;; 7:category2) printf priority-delivery ;;
        8:title) printf 'Weather observation network' ;;
        8:item) printf reading ;; 8:group) printf station ;; 8:location) printf region ;;
        8:category1) printf temperature ;; 8:category2) printf precipitation ;;
        9:title) printf 'Wildlife conservation project' ;;
        9:item) printf observation ;; 9:group) printf survey-team ;; 9:location) printf habitat ;;
        9:category1) printf bird-survey ;; 9:category2) printf mammal-survey ;;
        a:title) printf 'Space mission operations' ;;
        a:item) printf telemetry ;; a:group) printf mission-team ;; a:location) printf module ;;
        a:category1) printf navigation ;; a:category2) printf life-support ;;
        b:title) printf 'Renewable energy network' ;;
        b:item) printf generator ;; b:group) printf maintenance-team ;; b:location) printf site ;;
        b:category1) printf solar-output ;; b:category2) printf wind-output ;;
        c:title) printf 'Mobile application service' ;;
        c:item) printf session ;; c:group) printf service-team ;; c:location) printf region ;;
        c:category1) printf android-client ;; c:category2) printf ios-client ;;
        d:title) printf 'Video game service' ;;
        d:item) printf match ;; d:group) printf player ;; d:location) printf server ;;
        d:category1) printf cooperative ;; d:category2) printf competitive ;;
        e:title) printf 'International news service' ;;
        e:item) printf article ;; e:group) printf editorial-desk ;; e:location) printf bureau ;;
        e:category1) printf science-news ;; e:category2) printf culture-news ;;
        f:title) printf 'Museum collection and exhibitions' ;;
        f:item) printf object ;; f:group) printf curator ;; f:location) printf gallery ;;
        f:category1) printf permanent-collection ;; f:category2) printf visiting-exhibit ;;
        *) die "unknown theme field: $THEME_INDEX:$field" ;;
    esac
}

write_readme() {
    instructions=$1
    {
        echo "Theme: $(theme_field title)"
        echo "Learner: $USER_ID"
        echo "Collection date: $currentDate"
        echo "************************************************************************"
        printf '%s\n' "$instructions"
    } > "$LEVEL_HOME/README.txt"
}

fresh_case() {
    case "$levelToBuild" in
        level[1-9]|level10) ;;
        *) die "refusing unexpected level name: $levelToBuild" ;;
    esac
    CASE_DIR="${CASE_ROOT:-/srv/text-processing/cases}/$levelToBuild"
    case "$CASE_DIR" in
        */level[1-9]|*/level10) ;;
        *) die "refusing unexpected case path: $CASE_DIR" ;;
    esac
    rm -rf "$CASE_DIR"
    mkdir -p "$CASE_DIR"
    ln -s "$CASE_DIR" "$LEVEL_HOME/data"
    export CASE_DIR
}

finish_level() {
    if [ "${SKIP_OWNERSHIP:-0}" -eq 1 ]; then
        return
    fi
    chown -R "$levelToBuild:$levelToBuild" "$LEVEL_HOME" "$CASE_DIR"
    find "$CASE_DIR" -type d -exec chmod 750 {} \;
    find "$CASE_DIR" -type f -exec chmod 640 {} \;
    chmod 700 "$LEVEL_HOME"
}
