# Recovery provenance

- Lab: 5, Advanced Text Manipulation
- Live initrd: `https://polylab.ist.psu.edu/polylinux/lab5/packaged.rootfs.cpio.gz`
- Initrd SHA-256: `43c76d9019299655a7de5651a01ed41b8ba7d854dd16251ebeca9cf0342e4e3c`
- Recovery date: 2026-08-29
- Recovered boundary: `/root`

Twenty of 21 assessed principal files match the local
`polylinux-text-processing` source exactly. The only difference is
`participant-guide.md`: the initrd contains a shorter guide, while the public
page uses `published-instructions.md` and the local development source contains
a fuller guide. All three states are preserved for reconciliation.

The original `/root` entry manifest is retained at
`provenance/RECOVERY-MANIFEST.json`.
