# Audit decision ledger

1. The supplied current implementation is the implementation baseline.
2. The unified grader is authoritative for the seed and answer contract.
3. `LAB_ID` remains `text-processing` because the grader maps the submitted ID `lab05-text-processing` to the seed ID `text-processing`.
4. The `seed-v1` NUL-delimited SHA-256 construction is unchanged.
5. The `themes-v1` catalog and theme ordering are unchanged.
6. All ten answer derivations are unchanged because they match `lab5Answer()` in the supplied grader.
7. Learner evidence remains under `/srv/text-processing/cases`; expected-answer comparison stays outside the distributed VM.
8. The external exercise grading form and unified grader are the sole correctness authority. `verify.sh` remains a developer-side static check and is not a local answer checker.
9. POSIX `/bin/sh` and BusyBox-compatible utilities remain required.
