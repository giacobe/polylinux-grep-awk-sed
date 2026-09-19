# Performance revision

The ten level data files are generated with one BusyBox-compatible awk process per level instead of thousands of shell-loop iterations. The seed, theme, target-position, record-layout, and grader answer contracts are unchanged.

Level 5 retains its required target_position derivation before invoking awk. No local expected-answer recorder was added; external grading remains authoritative.
