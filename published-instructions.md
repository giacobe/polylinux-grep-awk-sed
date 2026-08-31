---
title: "PolyLinux grep/awk/sed"
short_title: "grep/awk/sed"
panel_title: "Learning Path"
form_url: "https://forms.office.com/Pages/ResponsePage.aspx?id=RY30fNs9iUOpwcEVUm61LvTNagO6dAdDlZnocMnGFFZUQ0laWERDT1laOEtLSzlOWFZXS1pBMVNJTS4u"

---

## START: PolyLinux grep/awk/sed
# Text Processing with `grep`, `awk`, and `sed`

Linux systems store a great deal of useful information as plain text: logs,
inventories, reports, configuration files, exported tables, and command output.
This lab introduces three commands commonly used to investigate that text:

- `grep` finds lines that match a pattern.
- `awk` works with records and fields.
- `sed` selects and transforms text.

You will complete ten levels. The early levels focus on one command at a time.
Later levels combine commands in a pipeline.

## Before you begin

When the virtual machine starts, log in as:

```text
root
```

The exercise installer starts automatically. Enter and confirm your email
address when prompted. The installer uses that address, the installation date,
and protected seed values to generate your version of the lab.

After installation, you will enter the `level1` account automatically.

Each participant may receive different:

- Themes and vocabulary
- Identifiers and tokens
- Numeric values
- Record positions
- Capitalization

Do not copy another participant's answer. Use the evidence generated in your
own virtual machine.

## Working in a level

At the beginning of each level, read its instructions:

```sh
cat README.txt
```

List the available evidence:

```sh
ls
ls data
```

Files in `data` contain thousands of records. Previewing a few records can help
you understand the format:

```sh
head data/example.txt
tail data/example.txt
```

Do not try to read an entire evidence file manually. The point of the lab is to
let the text-processing commands do the searching and calculation for you.

## Moving between levels

You may move forward or backward at any time:

```sh
nextlevel
prevlevel
```

Moving between levels is not proof that the previous answer was correct. Keep
track of the answer you intend to submit for every level.

If the screen becomes cluttered:

```sh
clear
```

To see your current account:

```sh
whoami
```

## Entering answers

The `README.txt` in each level specifies the exact answer shape. Follow it
carefully.

- Answers are case-sensitive unless the instructions say otherwise.
- Do not add quotation marks around an answer.
- Preserve required `|` separators.
- Preserve required spaces.
- Do not insert spaces around separators.
- Do not add labels such as `ANSWER=` unless requested.
- Integers should not contain commas or leading zeroes.

Submit answers through the exercise submission form.

## Shell concepts used in this lab

### Quoting

Quotes prevent the shell from interpreting characters that belong to a pattern
or an argument:

```sh
grep 'some words' file.txt
```

Single quotes are especially useful around:

- Patterns containing spaces
- The `$` end-of-line symbol
- `awk` programs
- `sed` instructions
- The `|` character when it is a field separator

### Pipes

A pipe sends the output of one command into the next command:

```sh
first-command | second-command
```

Read this from left to right:

1. The first command produces some text.
2. The second command receives that text.
3. Only the final command's output appears as the result.

Build long pipelines gradually. Run the first stage and inspect its output
before adding another stage.

### Standard input

Most commands in this lab can read either a named file or the output of the
previous command:

```sh
grep 'example' file.txt
grep 'example' file.txt | awk '{print $2}'
```

The examples in this guide demonstrate syntax only. They are not commands that
produce lab answers.

# Command reference

## `grep`: find matching lines

Basic form:

```sh
grep 'pattern' filename
```

Useful options:

| Option | Purpose |
|---|---|
| `-i` | Ignore uppercase and lowercase differences |
| `-n` | Show the line number with each matching line |
| `-c` | Print the number of matching lines |
| `-v` | Keep lines that do not match |

Examples:

```sh
grep 'ERROR' application.log
grep -i 'warning' application.log
grep -n 'complete$' tasks.txt
```

In a pattern, `$` means “the end of the line.” Therefore, `complete$` matches
lines that end with `complete`. It does not match a line where more text follows
that word.

Start with a simple pattern. If it returns too many lines, make the pattern more
specific. If it returns no lines, check spelling, capitalization, and quoting.

## `awk`: work with fields

By default, `awk` treats runs of spaces or tabs as field separators:

```sh
awk '{print $2}' table.txt
```

Field references begin with `$`:

| Reference | Meaning |
|---|---|
| `$1` | First field |
| `$2` | Second field |
| `$3` | Third field |
| `$NF` | Last field |

For a comma-separated file:

```sh
awk -F ',' '{print $2}' records.csv
```

For a pipe-separated file:

```sh
awk -F '|' '{print $3}' records.psv
```

An `awk` program can contain:

```text
condition { action }
```

It can also update a variable for each selected record and print a result in an
`END` block. Before writing a calculation, identify:

1. Which field determines whether a record should be used.
2. Which field contains the value you need.
3. Whether you need one field, a count, a sum, or a combination.

Use `-v` when you want to pass a shell value into `awk`:

```sh
awk -v wanted="$value" '...' filename
```

## `sed`: select or transform text

A basic substitution has this form:

```sh
sed 's/old/new/' filename
```

Add `g` to replace every occurrence on a line:

```sh
sed 's/old/new/g' filename
```

To suppress normal output and print only selected material, use `-n` with a
print instruction:

```sh
sed -n '/START/,/END/p' notes.txt
```

This example prints an inclusive range beginning with a line that matches
`START` and ending with a line that matches `END`.

Several transformations can be placed in one `sed` program and separated with
semicolons:

```sh
sed 's/first/second/; s/_/ /g' file.txt
```

When a transformation gives an unexpected result, run one substitution at a
time and inspect the intermediate output.

# Level guidance

The hints below point toward the intended concept without giving a complete
answer command. Try the level using its `README.txt` before reading the stronger
hint.

## Level 1: literal searching

Focus: basic `grep`.

First hint: The instructions identify a marker that occurs on exactly one line.
Search for that marker rather than the generated token.

Stronger hint: Once `grep` reduces the file to one line, identify which portion
of that line the `README.txt` asks you to submit.

## Level 2: capitalization

Focus: case-insensitive `grep`.

First hint: A normal search is case-sensitive. The target word may contain an
unexpected mixture of uppercase and lowercase letters.

Stronger hint: Review the `grep` option that ignores case. That option affects
matching only; it does not change the capitalization of the output.

## Level 3: line numbers and anchors

Focus: `grep -n` and the end-of-line anchor.

First hint: Some lines contain the target word in the middle, but only one has
it at the very end.

Stronger hint: Combine the option that displays line numbers with the pattern
symbol meaning “end of line.” The line number printed by `grep` is part of the
answer.

## Level 4: whitespace-separated fields

Focus: selecting a record with `awk`.

First hint: Read `TASK.txt`, then examine the header and a few rows of the
inventory. Count fields from left to right.

Stronger hint: In `awk`, compare the identifier field with the requested
identifier. Print only the field named by the level instructions.

## Level 5: a custom field separator

Focus: pipe-separated data with `awk`.

First hint: The vertical bars divide each record into fields. Spaces are not the
separator in this file.

Stronger hint: Tell `awk` that `|` is the field separator. Use the header to
determine the numbers of the two requested fields, then place a literal `|`
between them in the output.

## Level 6: filtering and arithmetic

Focus: conditions, variables, and totals in `awk`.

First hint: Only records belonging to the category named in `TASK.txt` should
contribute to the total.

Stronger hint: Use one `awk` action to add the numeric field to a running
variable whenever the category field matches. Print the variable after all
records have been processed.

Sanity check: Your command should produce one integer, not thousands of
individual values.

## Level 7: substitutions

Focus: a small pipeline ending in `sed`.

First hint: Locate the record named in `TASK.txt` before transforming it.

Stronger hint: The text before the encoded phrase is not part of the answer.
After removing that prefix, replace every underscore—not only the first
underscore—with a space.

Sanity check: The final result should be a readable lowercase phrase.

## Level 8: selecting a marked section

Focus: address ranges and selective output in `sed`.

First hint: The target section has explicit beginning and ending markers. Avoid
processing unrelated sections.

Stronger hint: First select the inclusive range identified in `TASK.txt`. Then
perform a second selection that keeps the answer record and removes its label.

Build this in two stages. Confirm that the first stage shows only the intended
section before trying to extract the final value.

## Level 9: filtering before field extraction

Focus: a `grep` and `awk` pipeline.

First hint: The requested job appears with more than one status. The status is
therefore part of the selection, not merely descriptive text.

Stronger hint: Make the first pipeline stage return exactly one CSV row. Then
use the header to identify the fields needed for the answer.

Sanity check: If two rows reach `awk`, your search pattern is not specific
enough.

## Level 10: capstone pipeline

Focus: combining `grep`, `sed`, and `awk`.

The report contains several kinds of distractors:

- The correct location and category with a wrong status
- The correct location and status with a different category
- The correct category and status at a different location

All three target properties must agree before a record contributes to the
answer.

Suggested workflow:

1. Read both target values from `TASK.txt`.
2. Preview the report header to identify its fields.
3. Filter by one target property.
4. Add the remaining target properties and confirm that exactly three records
   remain.
5. Normalize the amount field by removing its suffix.
6. Count the remaining records.
7. Add their numeric amounts.
8. Format the three required answer components exactly as instructed.

Do not attempt to write the complete pipeline in one step. Inspect the output
after every stage.

# Troubleshooting

## My command prints too many lines

- Make the search pattern more specific.
- Check whether a status, identifier, location, or category is also required.
- Check whether the match must occur at the end of a line.
- Make sure the header is not being treated as a data record.

## My command prints nothing

- Check the filename with `ls data`.
- Re-read the target value in `TASK.txt`.
- Check capitalization.
- Quote patterns containing `$`, `|`, or spaces.
- Preview the file to confirm its delimiter.

## `awk` prints the wrong field

- Read the header.
- Count fields from one, not zero.
- Confirm that `-F` matches the actual delimiter.
- Remember that `$1` means the first field inside an `awk` program.

## `sed` changes only the first occurrence

Review the flag that makes a substitution global across each input line.

## A pipe-separated pattern behaves strangely

An unquoted `|` is a shell pipe. Quote it when it is data or a field separator.

## My answer looks right but is rejected

- Re-read the exact answer shape in `README.txt`.
- Remove labels that were not requested.
- Check capitalization.
- Check spaces around `|`.
- Check that an integer has no comma or leading zero.
- Make sure the answer came from your own generated lab.

## I want to start over

The virtual machine is disposable. Resetting or reloading the lab reconstructs
it from the published image. You will need to enter your email again, and the
date used by a later installation may produce different data.
