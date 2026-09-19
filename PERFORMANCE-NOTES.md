# Performance and corrective revision

Large evidence files are generated using one BusyBox-compatible awk process per level rather than thousands of shell-loop iterations. The seed, theme, record, target-position, answer, and grader contracts are unchanged.

Levels 5 and 9 explicitly assemble their expected answers as owner|place and owner|value, preventing unset-variable failures under set -u.
