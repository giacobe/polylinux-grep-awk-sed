# PolyLinux Text Processing

A deterministic ten-level introductory lab for learning `grep`, `awk`, and
`sed` in the PolyLinux Buildroot/v86 environment.

Each installation selects one of 16 globally familiar themes from a lab-wide
SHA-256 hash. Per-level SHA-256 seeds independently vary tokens, identifiers,
values, capitalization, and layouts. The evidence format and learning objective
of every level remain stable.

## Repository interface

```text
.profile
install.sh
resources.sh
level1.sh ... level10.sh
profile
nextlevel
prevlevel
verify.sh
test.sh
LEVELS.md
TOOLSET.md
participant-guide.md
```

When root logs in, `.profile` suppresses kernel console noise, changes to
`/root`, clears the terminal, and launches `install.sh` automatically. The
separate `profile` file becomes `/etc/profile` for the ten learner accounts.

Install in the guest as root:

```sh
sh install.sh
```

For deterministic deployment or validation:

```sh
USER_ID=student@example.edu \
CURRENT_DATE=2026-07-23 \
SYSTEM_PASSWORD=exercisePassword \
LEVEL_PASSWORD_ROOT=levelPassword \
sh install.sh --non-interactive --no-login
```


```text
...
```

Generated learner evidence is stored in `/srv/text-processing/cases`, with a
`data` symlink in each level home.

## Recovered publication material

- `participant-guide.md` is the guide embedded in the recovered initrd.
- `published-instructions.md` preserves the live web-page instructions.
- `provenance/RECOVERY-MANIFEST.json` records the recovered `/root` inventory.

Lab-specific VM images are intentionally excluded and deployed separately.

## License

Licensed under the GNU General Public License v3.0. See `LICENSE`.

## Build the browser VM

Use the `basic` configuration from
[`giacobe/buildroot-builder2`](https://github.com/giacobe/buildroot-builder2),
validated with Buildroot `2025.02.15`:

```sh
git clone https://github.com/giacobe/buildroot-builder2.git
cd buildroot-builder2
BUILDROOT_VERSION=2025.02.15 scripts/01-setup-buildroot.sh
scripts/02-build-baseline.sh --config basic
scripts/03-package-payload.sh \
  --repo https://github.com/giacobe/polylinux-grep-awk-sed.git \
  --ref main \
  --baseline artifacts/basic-<timestamp> \
  --output artifacts/polylinux-grep-awk-sed \
  --output-prefix polylinux-grep-awk-sed
```

Replace `<timestamp>` with the stage-2 artifact directory. Review the manifest
and boot-test the exact generated image pair in v86 before publishing.

## Standard runtime contract

The current release uses the reversible PolyBandit exercise code, the versioned `seed-v1` deterministic seed, ten concurrent level generators, staged `README.txt` readiness, unrestricted `nextlevel`/`prevlevel` navigation, and no client-side answer store or checker. See `lab.json` for the authoritative level count, theme policy, Buildroot configuration, and browser artifact names.

Do not rebuild the assigned Buildroot baseline merely to package this lab. Package the repository payload into the configuration named by `buildroot_configuration`, preserve the baseline kernel, and publish the resulting `packaged.bzImage` and `packaged.rootfs.cpio.gz`.
