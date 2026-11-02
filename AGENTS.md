# AGENTS.md — minimal hardened container images

Catalog of ~137 shell-less, hardened container images built with **apko** (image
assembly) + **melange** (source builds) against **Wolfi** packages, published to
`ghcr.io/alexander-nemtsov/containers-<name>`. Not a typical code repo: most
"changes" are YAML recipes, bash smoke tests, and registration edits across
multiple files.

## Authoritative docs — read before acting

- `docs/onboarding.md` — **the source of truth** for adding/changing images. Onboard
  from its checklist, never from memory (two real incidents came from skipped steps).
- `CONTRIBUTING.md` — friendly intro; when they disagree, onboarding.md wins.
- `docs/version-management.md` (two-loop update model),
  `docs/dev-variants/CONVENTIONS.md` (`-dev` images).
- `docs/build-pipeline.md` — **how the CI machinery works**: build.yml job
  graph, runners (x86_64 is `self-hosted`!), signing/attestation retry
  invariants, the four update loops, the GitHub-App/auto-merge chain, and the
  "where things silently break" debug map. Read it before touching `.github/**`.

## Prime directive

Any change touching an image's `melange.yaml`, `apko/*.yaml`, `test*.sh`, or its
Makefile targets **must pass locally before push**:

```bash
make keygen            # one-time: melange signing keypair (required for source builds)
make <name>-melange    # source-built images only
make <name>            # apko assemble + docker load
make test-<name>       # smoke test (test-<name>-dev for the dev variant)
```

A red build on `main` blocks the daily scheduled rebuild for **every** image.
Local `make <name>-melange` builds **x86_64 only** — aarch64 runs on CI's native
ARM runners (cross-arch needs QEMU and fails with `bwrap: execvp /bin/sh: Exec
format error`). This is expected, not a bug.

## Dev-environment pins

Tool versions must match CI or builds drift: `apko v1.1.6`, `melange v0.41.1`
(via `go install`), `grype` (brew). `make check-toolchain-pins` verifies.

## Adding an image — the CI-enforced registration points

Every one is mandatory; details and exact snippets in `docs/onboarding.md` §2:

1. `images/<name>/apko/<name>.yaml` (+ `-dev.yaml`) and `test.sh` (+ `test-dev.sh`)
   — **`chmod +x` the tests** or `make test-<name>` dies with Permission denied.
2. `vex/<name>.openvex.json` — every image has one, start with empty `statements`.
3. `Makefile` — version var + `.PHONY` + build/test targets (copy an existing block).
4. `.github/workflows/build.yml` — one JSON line in `MELANGE_IMAGES` or `APKO_IMAGES`.
5. `catalog.json` — entry with a **distinct 140–160 char `description`** (SEO meta;
   boilerplate endings like "built on Wolfi" are rejected by the gate).
6. Auto-update, exactly one live mechanism: source-built → `cron-enabled` row in
   `.github/versions.yaml`; apko-only → classify in `.github/autoupdate-coverage.yaml`.
   Validate with `gh workflow run update-versions.yml -f only=<name>` **before**
   enabling — versions PRs auto-merge.
7. Source-built Go images → three dicts in `patch-go-deps.yml` (`MODROOTS`,
   `MAIN_MODULES`, `BUILD_MARKERS`) **or** `SKIP_IMAGES`; unregistered = silently
   unpatched CVEs forever. Ruby/Rust/Maven → `.github/patch-deps.yaml`.
8. `README.md` image-count badge + prose (enforced by `make check-docs`).

## Rules that bite (verified, each cost someone a debugging session)

- **melange `package.name` = bare upstream name** (`haproxy`, not `haproxy-minimal`):
  a suffix makes grype report **zero** CVEs (breaks both secdb and CPE matching).
  Add `dependencies.provider-priority: 100` whenever Wolfi ships the same name.
  Enforced by `make check-packages`.
- **Never pipe a producer into `grep -q` under `pipefail`** — SIGPIPE race makes
  exit 141 on a perfectly good image. Capture to a variable first. Smoke tests use
  `set -eu` (no pipefail) for this reason.
- Bind-mounted test dirs must be `chmod 0777` (container uid 65532); files the
  container writes are owned 65532/0600 — verify with `[ -s file ]`, not `grep`.
- Prod images: no shell, run as uid 65532, `ca-certificates-bundle` always,
  minimum packages. **Postgres-family exception:** `postgres-slim`/`patroni` ship
  `busybox` only because `initdb` execs `/bin/sh` via `popen()`; tests assert both
  presence of `/bin/sh` and absence of bash/apk-tools.
- Create `/var/*` runtime dirs in apko `paths:`, **not** in the melange pipeline
  (SBOM step can't mkdir into the root-owned destdir).
- `versions.yaml`: use the canonical upstream repo (resolver does **not** follow
  GitHub's rename 301 — symptom: `jq: Cannot index string with string "name"`).

## Local verification gates

`make lint-workflows` is **mandatory** before touching `.github/workflows/**`:
most workflows only run on schedule, so a shell syntax error in a `run:` block
never executes on the PR and detonates on `main` later. Other gates that map to
CI: `make check-autoupdate`, `make check-catalog-descriptions`, `make check-docs`,
`make check-packages` (`-report` lists violations without failing),
`make lint-versions test-versions-config`, `make test-classifier`,
`make check-toolchain-pins`, `make check-curl-retries`, `make check-site-claims`.
VEX tooling: `tools/vex/{validate,reconcile}.sh`.

## Other layout notes

- `site/` — Astro catalog site (catalog.nexaflow.by). `cd site && npm install
  && npm run dev` regenerates `src/data/images.json` from `catalog.json`; CVE/SBOM
  data comes only from CI artifacts (graceful "partial data" locally). `SKIP_TAGS=1`
  skips the GHCR tag fetch. Deploy is decoupled from image builds (`deploy-site.yml`).
- `catalog.json` names must equal the build.yml matrix names **exactly**
  (`validate-catalog` enforces). Valid `category` values are the 8 in onboarding.md §7.
- `.github/scripts/` holds the shared updater implementation used by the
  update/patch workflows; `tests/` contains regression tests for repo tooling
  itself, not image tests.
- Repo lineage: originally forked from `rtvkiz/minimal`, but the fork was
  rebranded — every reference now points to `github.com/alexander-nemtsov/containers`,
  images at `ghcr.io/alexander-nemtsov/containers-*`, site at
  catalog.nexaflow.by. Do not reintroduce `rtvkiz/minimal` or `minimal-*` image
  names. GitHub Actions under `.github/workflows/` is the only CI.
  Signatures on images published BEFORE the rename carry the old
  `rtvkiz/minimal` identity — verify commands in SECURITY.md only match new builds.
