# Buildroot command requirements

The existing PolyLinux `basic` baseline contains the required full packages:

```text
BR2_PACKAGE_GREP=y
BR2_PACKAGE_GAWK=y
BR2_PACKAGE_SED=y
```

The root-login bootstrap additionally uses `clear` and `dmesg`. The installer,
generators, tests, and reference verifier require:

```text
adduser awk base64 cat chmod chown cmp cp cut date find grep head id ln
mkdir mktemp passwd printf rm sed sha256sum sort su tail tr uniq wc xxd
```

Learner-facing commands are:

```text
cat grep awk sed
```

`less`, `head`, and `tail` are useful but are not necessary to solve a level.
The lab requires no network access and no compression tools.
