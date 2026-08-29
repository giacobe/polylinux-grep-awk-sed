# Level design

The lab introduces `grep`, `awk`, and `sed` through stable text formats. A
lab-wide hash selects one of 16 themes. Theme selection changes vocabulary, not
the artifact format, task, answer shape, or difficulty.

| Level | Stable artifact | Primary learner task | Exact answer shape |
|---|---|---|---|
| 1 | 4,096 status messages | Find a literal marker with `grep` | 12-character Base64url token |
| 2 | 4,096 mixed-case status messages | Match case-insensitively with `grep -i` | 12-character Base64url token |
| 3 | 4,096 numbered queue records | Use `grep -n` and the `$` line-end anchor | `line-number\|10-character-token` |
| 4 | 4,096-line whitespace table | Select a row and print one field with `awk` | Lowercase location identifier |
| 5 | 4,096-line pipe-separated table | Set `awk`'s field separator and print two fields | `owner\|location` |
| 6 | 4,096-line CSV measurement table | Filter and total a numeric field with `awk` | Integer |
| 7 | 4,096-line draft table | Filter a record and perform two `sed` substitutions | Lowercase phrase with single spaces |
| 8 | 4,096-line marked section file | Select an address range and extract a value with `sed` | 13-character Base64url token |
| 9 | 4,096-line CSV job table | Filter with `grep`, format with `awk` | `owner\|integer` |
| 10 | 8,192-line pipe-separated report | Combine filtering, substitution, counting, and summation | `category\|count\|total` |

## Invariants and collision controls

- Each level has exactly one intended target record or target record set.
- Answers are derived or calculated before distractors are written.
- Distractors use fixed identifiers and statuses that cannot satisfy the complete
  target selector.
- Level 3's only target has `READY` at the end of its line.
- Levels 4 and 5 use unique seeded target identifiers.
- Level 6's non-target category differs from the target category.
- Level 8 has exactly one answer inside the named target section.
- Level 9 has exactly one row matching both the target ID and `VALID`.
- Level 10 has exactly three rows matching location, category, and `complete`;
  invalid, void, other-category, and other-location rows are excluded by
  construction.
- Level 10 is cumulative in skills but requires no prior-level answer.
- Dataset-size tests enforce 4,096 lines for levels 1–9 and 8,192 lines for
  level 10, so manual visual scanning is not the practical solution path.

## Seed contract

For level `N`:

```text
level_password = LEVEL_PASSWORD_ROOT + N
level_seed = SHA256(USER_ID + ISO_date + SYSTEM_PASSWORD + level_password)
derived(label) = SHA256(level_seed + ":" + label)
```

The coherent theme uses a separate lab-scoped password:

```text
lab_profile_password = LEVEL_PASSWORD_ROOT + "Theme"
lab_hash = SHA256(USER_ID + ISO_date + SYSTEM_PASSWORD + lab_profile_password)
theme_digest = SHA256(lab_hash + ":theme")
theme_index = first hexadecimal digit of theme_digest
```

All concatenations hash exact UTF-8 bytes without separators or a trailing
newline.
