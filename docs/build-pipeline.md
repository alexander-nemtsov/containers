# Build Pipeline Reference

How images get built, published, kept current, and displayed. Read this before
touching anything under `.github/` or before debugging "why is the build red /
why didn't image X update?". For *adding an image*, see
[`onboarding.md`](onboarding.md); this file explains the machinery it plugs into.

Sources of truth: `.github/workflows/*.yml`, `.github/scripts/*`, `scripts/*`,
`tools/*`. Inline comments in `build.yml` and `patch-go-deps.yml` carry the
incident history behind most conventions — they are load-bearing, keep them.

## 1. Map of the whole system

```
                     ┌────────────────────────────────────────────────────────┐
  push/PR/cron ────▶ │ build.yml            daily 00:17 UTC, full rebuild      │
                     │  detect-changes ─▶ melange-build ─▶ build-melange ─┐   │
                     │                     └▶ build-apko ─────────────────┤   │
                     │  validate-vex / validate-catalog (gates)  summary ◀┘   │
                     │  sign+attest+verify per image; artifacts:              │
                     │    grype-<n>.json, meta-<n>.json, catalog-sbom-<n>     │
                     └───────────────┬───────────────────────┬───────────────┘
                                     │ workflow_run          │ artifacts
                                     ▼                       ▼
              repair-toolchain-pr.yml (failed update-toolchain-* │ deploy-site.yml → gh-pages
              branches only: classify failures, revert real      │  (catalog.nexaflow.by)
              breaks, retry infra blips)          ◀─────────────┘  picks latest COMPLETE build run
  update loops (all open auto-merging PRs via a GitHub App):
   update-versions.yml        daily 07:00  app versions, .github/versions.yaml
   update-wolfi-packages.yml  Mon  07:00  shipped + build-env toolchain majors
   patch-go-deps.yml          daily 19:00  transitive Go CVEs (ONE shared PR)
   patch-deps.yml             daily 19:30  bundler/rust/python/maven/bundled-jars
   update-minio.yml           daily 07:45  bespoke MinIO RELEASE.<date> scheme
  housekeeping:
   auto-update-pr-branches.yml on push + /30min  keeps behind-branch auto-merge PRs alive
   cleanup-packages.yml        Sun  04:00  GHCR retention (DRY-RUN by default)
   refresh-site-data.yml       Mon  04:20  competitor datasets behind site claims
   cve-comparison.yml          1st/15th 03:40  the /compare benchmark
   lint.yml                   on workflow/script changes (actionlint+shellcheck)
```

## 2. `build.yml` — the build & publish pipeline

### Triggers and change detection
- Triggers: push to `main` (paths: `images/*/…`, build.yml itself), PRs, daily
  cron (`17 0 * * *`, full rebuild), `workflow_dispatch` (full rebuild).
- `detect-changes` holds the two image registries as JSON arrays:
  `MELANGE_IMAGES` (source-built) and `APKO_IMAGES` (Wolfi package; extra field
  `grep` = the apk regex that doubles as primary-package locator for the version
  extraction step). Optional per-entry fields: `"apko":"<path>"` (config not at
  the default location), `"variants"` (add `"dev"`), `"arches"` (default
  `x86_64,aarch64`).
- Smart partial rebuild: if the only build.yml diff lines are image entries in
  those arrays, rebuild just those images (avoids a ~128-job fan-out, which
  triggers GH Actions token throttling on ARM runner checkouts); anything else
  in build.yml ⇒ FULL_REBUILD.
- Image names come from the **second** path segment of changed files
  (`images/<name>/…`) — an old bug took the first segment, silently skipped
  every build job, and reported green (#551/#556: PRs stopped building entirely).
- Concurrency: schedule/dispatch get unique groups (never cancelled); push/PR
  cancel in-progress on the same ref.

### Gates (always run, block everything)
- `validate-vex`: `tools/vex/validate.sh` on every event.
- `validate-catalog`: `catalog.json` names == build.yml matrix names (`diff`),
  then the invariant checks: `make check-autoupdate`, `check-site-claims`,
  `check-toolchain-pins`, `check-curl-retries`, `check-catalog-descriptions`,
  `check-docs`, `check-packages`. Same commands exist locally; CI and local
  entrypoints are deliberately identical so they can't drift.

### Runners — special, don't forget
- build.yml jobs run on **`self-hosted`** runners (x86_64) and
  **`ubuntu-24.04-arm`** (aarch64, GitHub-hosted native ARM). The melange matrix
  picks the runner per arch in `detect-changes`. Every *other* workflow uses
  plain `ubuntu-latest`. Fork PRs are handled by the ephemeral-key `keygen`
  path (secrets aren't exposed to them) and never publish or sign.
- Tool pins that must match local dev: `apko v1.1.6`, `melange v0.41.1`,
  `grype v0.109.1` (also pinned in patch-go-deps/patch-deps/cve-comparison).

### Job graph
1. `keygen` (PRs only): ephemeral `melange keygen` pair uploaded as artifact —
   secrets aren't available to fork PRs; the ephemeral key never publishes.
2. `melange-build`: per image × arch. On protected branches the real
   `MELANGE_SIGNING_KEY(_PUB)` secrets are used. Before building, any melange
   env with a **bare `- go`** is rewritten to the newest `go-1.XX` from Wolfi's
   APKINDEX ("Pin latest Go from Wolfi" step) — stale-stdlib CVEs from toolchain
   auto-download otherwise leak in. (Build environments should pin explicitly;
   `check-toolchain-pins` enforces this — the step is the safety net.)
   Packages upload as `packages-<name>-<arch>` artifacts (1-day retention).
3. `build-apko` (apko-only images) and `build-melange` (source-built): assemble
   with apko (`--arch x86_64` locally built + loaded; source-built ones append
   `--repository-append ./packages --keyring-append ./melange.rsa.pub`, and on
   protected branches the keyring is **overwritten with the real public key** —
   the local one is only used for the x86 test build). Then, for prod variants
   only (`scan_for_cves: variant == "prod"` — dev variants are never scanned or
   dashboarded):
   - Grype scan: DB fetch isolated into a retried best-effort `grype db update`
     + date-keyed cache, scan runs with `GRYPE_DB_AUTO_UPDATE=false` so a CDN
     blip can't take down the fleet scan.
   - `meta-<name>.json` sidecar: size/digest/raw+VEX-effective counts, VEX drift
     (`tools/vex/reconcile.sh`) and apk-provenance split
     (`.github/scripts/reconcile-apk-provenance.sh`) — reporting steps are
     non-blocking and degrade to raw counts on failure (over-report, never hide).
   - Version extraction: apko path reads the SBOM via the matrix `grep` pattern;
     melange path reads `version:`+`epoch:` from melange.yaml → tag `<ver>-r<ep>`.
   - Test: `images/<name>/test.sh` / `test-dev.sh` with `$IMAGE` = local `:<sha>` tag.
   - Publish (non-PR): `apko publish` **both arches** from the config, up to 3
     attempts (ghcr BLOB_UNKNOWN), tagging the ladder: `:<ver>`,
     `:<ver>-YYYYMMDD` (dated, immutable history), `:latest`/`:latest-dev`, plus
     rolling major/minor from `.github/scripts/version-ladder.sh` (`:3`, `:3.21`).
     Note the *local* `apko build` is x86_64 only; multi-arch happens at publish.
   - Attest chain (all retried; see §5 for why): `cosign sign` →
     `cosign attest --type spdxjson` per SBOM → `actions/attest-build-provenance`
     (SLSA) → `cosign verify` + `gh attestation verify` as a discoverability
     gate (GHCR propagation races by ~30–60s).
     `COSIGN_REGISTRY_REFERRERS_MODE=legacy` is set workflow-wide — ghcr's OCI
     1.1 referrers are stored unusably by cosign, `:latest`-style `.sig/.att`
     tags are the interoperable mode. Do not "modernize" this away.
   - Artifacts consumed downstream: `vulnerability-report-<name>` (grype json +
     meta json, 90 days) and `catalog-sbom-<name>` — `deploy-site.yml` is the
     customer. SARIF goes to the Security tab.
4. `summary`: re-asserts expected jobs succeeded (the needed `if:` conditions
   make skipped ≠ failed, so someone must turn that back into a verdict).
   **This job is the branch-protection status check** — repairs and re-bases
   target it.
5. `cleanup`: after every non-PR run, deletes untagged GHCR versions, keeping
   the newest 4 per package (separate from `cleanup-packages.yml`, which prunes
   dated tags to the newest 30 and is dry-run by default).

## 3. The update loops (four schedulers, disjoint jobs)

The two-loop mental model (base vs app version) is in
[`version-management.md`](version-management.md). Extending it with the patch
loops:

| Loop | Workflow | Moves | Never moves |
|---|---|---|---|
| Rebuild | build.yml daily | base apks, toolchains inside builds, `patch-go-deps` blocks re-applied | app `version:` |
| App version | update-versions.yml daily | `version:` + checksums + `epoch: 0` in melange.yaml, apko pins for `wolfi-versioned` via update-wolfi-packages.yml | majors past `pin-major` (opens an issue instead) |
| Go transitive | patch-go-deps.yml daily | `go get` pins inside the auto-generated block in melange.yaml | app version |
| Other ecosystems | patch-deps.yml daily | same pattern for ruby gems / rust crates / python pkgs / maven / bundled jars | — |

### `update-versions.yml` (driven by `.github/versions.yaml`, 120 rows, all cron-enabled)
Four stages: `plan` (cron runs only `cron-enabled: true` rows; dispatch ignores
the gate, respects `only=<name>`) → `.github/scripts/check-upstream.sh` (resolve
current vs latest by `source.type`: github-releases-latest / github-tags /
scrape / json / plain-text; `pin-major` guard emits `next_major` instead of
bumping) → `apply-update.sh` (download tarball(s), compute digest, sed
`version:`/checksum-field/`epoch: 0`/`extra-fields`) → `open-pr.sh` (branch
`update-<name>-<ver>`, labels `dependencies`+`<name>`, **auto-merge
`squash`** once required checks pass). PRs come from a GitHub App
(`APP_ID`/`APP_PRIVATE_KEY`) — see §4 why.

### `update-wolfi-packages.yml` (Mondays)
Two kinds of bumps, don't conflate:
- **Shipped toolchains** (per-language steps): rewrites major-version families in
  `images/<lang>/apko/*.yaml` — python/go/node/dotnet/java/postgres. The seds
  rewrite *whole families* (e.g. `postgresql|libpq|ecpg|pgaudit` incl. patroni in
  lockstep, `dotnet-N{,-sdk,-runtime,-targeting-pack}`, `openjdk-N` +
  `java-N-openjdk`) because a single-package sed produces mixed-major images.
  Detection reads postgres-slim; patroni is deliberately in scope.
- **Build-environment toolchain pins** (`bump-toolchain-pins.sh`): bumps the
  `go-1.26`/`nodejs-26`/`rust-1.97` pins inside every `images/*/melange.yaml` to
  the newest Wolfi has. One PR, CI is the probe, repair loop self-heals (§6).
- `dry_run` dispatch input gates **every** PR-creating step — trust its scope.

### `patch-go-deps.yml` (daily 19:00; 82 Go images; ONE shared branch/PR)
Scans each **published** `:latest` image with grype, maps go-module CVEs to fix
versions, and splices an auto-generated `go get` block into each melange.yaml
before the image's `BUILD_MARKERS` line. Three dicts keyed by image name
(`MODROOTS` / `MAIN_MODULES` / `BUILD_MARKERS`) — an image missing from them is
**silently skipped** (that's how alertmanager shipped 24 unpatched CVEs).
Invariants that exist because of regressions — do not "simplify" them away:
- Scan first, strip the old block only when writing a new one (strip-then-scan
  reads the already-patched image, finds "nothing to do", and silently
  de-patches — PR #221).
- Merge new fixes with existing pins (`sort -V` per package) — the replacement
  block must be a superset or old CVEs return (loki/coredns 2026-06-05).
- Sibling harmonization: fetch each candidate's go.mod from proxy.golang.org
  and raise co-bumped siblings that it requires (grype's fix version can be
  lower than a co-bump demands → `go get` aborts). OTel/x-family rules above it.
- `TESTKEEP_IMAGES` (caddy trivy kaniko skopeo opentofu thanos): probe-build
  each candidate against the image's real build command (`TESTKEEP_BUILD`,
  must match tags/GOEXPERIMENT exactly) and keep only pins that compile;
  incompatible ones are logged and wait for upstream. `SKIP_IMAGES` (now empty)
  is for graphs we never auto-patch.
- Self-bump filter: `MAIN_MODULES` prevents `go get <image's own module>@…`.
- One shared PR means one bad image blocks every Go patch — hence test-and-keep
  and the auto-close when a scan yields nothing.
- The giant `run:` block is kept **free of `${{ }}` expressions** on purpose:
  any expression turns the whole scalar into a templated one capped at 21000
  chars — the workflow fails to *parse*. Pass context via `env:` instead
  (same convention in patch-deps.yml's PR step). Also: `$` split from `{{`
  (`D='$'`) so GitHub doesn't parse melange template vars.

### `patch-deps.yml` (daily 19:30, 30 min after the Go loop to avoid PR races)
Generic engine over `.github/patch-deps.yaml` rows: `bundler`, `rust`, `python`,
`maven`, `bundled-jars`. `bundled-jars` (opensearch/keycloak) can't be maven-
patched — jars are baked into upstream artifacts — so `patch-bundled-jars.sh`
does sha-pinned jar swaps, with per-image `policy: auto` vs report-only
(compat-review findings go to the run summary, never auto-patched). Uses syft in
addition to grype (grype reports only matches; syft sees every package, which
lets a whole jar family move together). Skips whitespace-only diffs (the block
regeneration shuffles blanks and was burning full builds — PRs #238–#253).

### `update-minio.yml`
Bespoke: MinIO tags are `RELEASE.YYYYMMDD`, not semver, so it lives outside
`versions.yaml`. When migrating an image off a bespoke workflow, flip
`cron-enabled: true` **in the same commit that deletes the workflow** — never a
window with both, or neither.

## 4. GitHub-App token, auto-merge, branch protection

Every PR-opening workflow mints a token from `APP_ID` + `APP_PRIVATE_KEY` and
opens PRs as the App (bot identity `github-actions[bot]` for commits). Why the
App is load-bearing:
- Pushes/updates made with the default `GITHUB_TOKEN` do **not** re-trigger
  required checks (recursive-run block). Auto-merge on a behind branch would
  stall forever without App-token branch updates — that's
  `auto-update-pr-branches.yml` (on each push to main + every 30 min: find open
  auto-merge PRs that are BEHIND, update their branches with the App token).
- Required checks (see repo branch protection on main): the per-image build
  result flows through `summary`; `lint.yml` gates workflow/script changes.
- Auto-merge mode is always `--auto --squash --delete-branch`, so a bump only
  lands if the new version actually builds and passes its smoke test. A red
  build blocks the merge; it does not revert anything (except toolchain PRs, §6).

Consequence for agents: **a red `main` build freezes every auto-merge bot PR**
(versions bumps included) and `auto-update-pr-branches` will keep re-basing
them onto a broken main — fix red main first, always.

## 5. Flakiness doctrine (why the workflows look over-defensive)

Almost all external services this pipeline touches fail intermittently, and
because the daily cron rebuilds all 137 images, **one unisolated flake = red
main = fleet frozen**. Patterns to preserve in any new workflow step:
- Network fetches: `curl --retry 5 --retry-delay 15 --retry-all-errors -sS`
  (plain `--retry` collapses 5 attempts into a ~30s burst and still loses to
  rate limits — enforced loosely by `make check-curl-retries`).
- `uses:` steps can't be command-wrapped → repeat the step with
  `continue-on-error` + a gated retry step. Jitter retries that fire en masse
  (`sleep $((RANDOM % 300 + 60))`) — 80 jobs retrying at the same second just
  hit the same rate limit.
- Idempotent retries: Sigstore/Rekor `createLogEntryConflict` (409) means the
  entry IS logged for `cosign sign` (treat as success) but **not** for
  `cosign attest` (the attestation may never have been pushed — probe the
  registry with `cosign verify-attestation` before accepting the conflict).
  Attest loops track per-SBOM `.attested-*` markers across attempts.
- Reporting-only steps are `|| true` + degrade to the conservative direction
  (over-report CVEs, never under).
- Download-artifact 403s: `actions/download-artifact` treats them as
  non-retryable — wrap with the repeat-step pattern; the *last* attempt stays
  fatal so genuinely missing artifacts still fail loudly.

## 6. The toolchain self-healing loop

`update-wolfi-packages.yml` (toolchain PR) → `build.yml` rebuilds every affected
image (the probe) → on failure of a branch named `update-toolchain-*`,
`repair-toolchain-pr.yml` runs: `classify-build-failure.sh` decides WHY the job
failed, and **only a genuine compile failure authorises reverting that image's
pin** (`git checkout main -- <recipe>`); anything infra-flavoured (Wolfi
mid-migration index, Sigstore resets, 429s, mutated upstream tarballs — all
observed 2026-08-19/20) returns `transient` → leave red to retry; unrecognised →
`unknown` → human. Rationale: a wrong revert is silent and permanent; a red PR
is visible and self-clearing. Reverted images re-try automatically on the next
weekly bump run. `make test-classifier` regression-tests the classifier.

## 7. Site pipeline (catalog.nexaflow.by)

- `deploy-site.yml`: builds `site/` (Astro) and force-pushes an orphan commit to
  `gh-pages` (deploy-pages action dedupes by commit — data-only refreshes would
  be ignored). Data = scan/SBOM artifacts from the latest **complete** build
  run: completeness is judged relative to that run's own `catalog.json` (never
  HEAD's — mass onboarding raised the bar and froze deploys for 6h), push builds
  skipped as partial by construction, artifact listing paged via API
  (`download-artifact` only sees the first 100 artifacts; a full build emits
  more). On API failure it **degrades**: leaves the current site up, exits
  green with a warning. Site build calls `node scripts/build-data.mjs
  ../reports` + `astro build` directly — NOT `npm run build`, whose `prebuild`
  hook regenerates `images.json` without the reports dir.
- `refresh-site-data.yml` (weekly) and `cve-comparison.yml` (fortnightly):
  regenerate the competitor/comparison datasets that back public claims and open
  a human-reviewed PR. These run ~380 third-party requests / 40–90 min of
  scanning, which is exactly why the *site build itself* stays hermetic and does
  not fetch them. `make check-site-claims` (+ `--online`) asserts the committed
  datasets still match the repo and retracted claims never return.
- `tools/dashboard/build.sh` renders the CVE dashboard from the reports dir
  (grype json + meta sidecars); it is what the site's data is cut from.
- `cleanup-packages.yml`: GHCR hygiene — untagged versions + newest-30 dated-tag
  retention. **Dry-run by default even on dispatch**; run manually with
  `dry_run=false` after reviewing the log.

## 8. Infra prerequisites (required for the automation to work at all)

- Self-hosted x86_64 runner(s) with label `self-hosted`, having: docker, go
  toolchain (`go install chainguard.dev/{apko,melange}@…` cacheable), jq, yq,
  cosign/gh CLIs, and network to ghcr.io + packages.wolfi.dev.
- ARM: GitHub-hosted `ubuntu-24.04-arm`.
- Repo secrets: `MELANGE_SIGNING_KEY` + `MELANGE_SIGNING_KEY_PUB` (the apk
  signing pair every source-built apko config references as its keyring),
  `APP_ID` + `APP_PRIVATE_KEY` for the GitHub App with PR/contents/issues
  permissions and installed on the repo.
- Image signatures are **keyless** (sigstore + GitHub OIDC, verified by
  certificate-identity regexp — see `.github/SECURITY.md`). The root
  `cosign.pub` is unreferenced by any workflow or script; publishing does not
  depend on it.
- Branch protection on `main`: strict "up to date" + `summary` (and lint) as
  required checks; auto-merge enabled.
- CI does **not** gate on CVE counts anywhere — scans are informational
  (matches the README's "On vulnerability counts" section).

## 9. Where things silently break (agent debugging map)

| Symptom | First places to look |
|---|---|
| PR green but image didn't build | `detect-changes` matrix name matching; path regex (must be `images/<name>/`, 2nd segment); `validate-catalog` drift |
| Image frozen at old version | `versions.yaml` row missing/`cron-enabled` absent (check-autoupdate now blocks this); canonical repo 301 (renamed upstream) |
| Go image accruing transitive CVEs | three dicts in `patch-go-deps.yml`; or tangled graph handled manually via VEX |
| Red scheduled build, unrelated PR | grep `::warning`/`::error` for sigstore/ghcr/wolfi flakes (§5); rerun the job — retries are built per-step, a rerun re-executes the same logic |
| Site shows "partial data" | artifact missing from the source run (`vulnerability-report-<name>` per image); deploy run summary "Scan data source" block |
| Auto-merge PRs stalled BEHIND | `auto-update-pr-branches.yml` run log; App token expiry |
| `cosign verify` finds nothing | someone changed `COSIGN_REGISTRY_REFERRERS_MODE` off `legacy` |
| Toolchain bump PR stuck red | repair ran? classifier said `transient`/`unknown`? `make test-classifier`; read `.github/scripts/classify-build-failure.sh` signatures |

## 10. Doc drift to fix when convenient

- `docs/version-management.md` "Known gap as of 2026-07-06 (TODO)" (8 frozen
  images) is **resolved**: all eight (`consul helm kubectl mailpit mimir
  registry telegraf tempo`) have `cron-enabled` rows, and the "CI lint would
  prevent recurrence" TODO became `make check-autoupdate`.
- `CONTRIBUTING.md` §6 lists patch-deps rows as "Ruby/Rust/Maven"; the file now
  also has `python` and `bundled-jars`.
