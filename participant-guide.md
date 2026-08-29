# Text Processing with grep, awk, and sed

This ten-level lab introduces three standard Linux text-processing commands:

- `grep` finds matching lines.
- `awk` selects fields and performs simple calculations.
- `sed` selects or transforms text.

All records use fictional names and values. The installation selects one of 16
themes, but no subject-matter knowledge is required. Each level's `README.txt`
states the task and exact answer format.

## Getting started

At the prompt:

```sh
ls
cat README.txt
ls data
```

Preview evidence with `head` or `tail`, then use the requested command. The
files are quick for command-line tools to process but contain thousands of
records and are intentionally impractical to scan manually.

## Command examples

```sh
grep 'word' file.txt
grep -i 'word' file.txt
grep -n 'pattern$' file.txt
awk '{print $2}' table.txt
awk -F ',' '{print $2}' table.csv
sed 's/old/new/g' file.txt
sed -n '/BEGIN/,/END/p' file.txt
```

Quotes protect spaces and characters such as `$`, `|`, and `*` from the shell.
An `awk` field number begins with `$`: `$1` is the first field and `$2` is the
second.

Move between levels at any time:

```sh
nextlevel
prevlevel
```

Answers are case-sensitive. Preserve separators, punctuation, and spaces exactly
as specified by the current `README.txt`. Submit through the external exercise
grader.
