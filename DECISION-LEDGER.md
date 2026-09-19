# Audit decision ledger

1. The supplied current implementation is the implementation baseline.
2. The unified grader is authoritative for the seed and answer contract.
3. `LAB_ID` remains `text-processing` because the grader maps the submitted ID `lab05-text-processing` to the seed ID `text-processing`.
4. The `seed-v1` NUL-delimited SHA-256 construction is unchanged.
5. The `themes-v1` catalog and theme ordering are unchanged.
6. All ten answer derivations are unchanged because they match `lab5Answer()` in the supplied grader.
7. Canonical runtime paths remain `/srv/text-processing/cases` and `/var/lib/text-processing/answers`.
8. `checklevel` and `verify.sh` are included without changing externally graded answers.
9. POSIX `/bin/sh` and BusyBox-compatible utilities remain required.
