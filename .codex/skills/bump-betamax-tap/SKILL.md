---
name: bump-betamax-tap
description: Update and ship the Betamax formula in Josh's Homebrew tap. Use when Codex is working in `/Users/joshka/local/homebrew-tap` and the user asks to bump Betamax, refresh the Betamax Homebrew formula, validate `joshka/tap/betamax`, or open and merge the tap PR for a new Betamax release.
---

# Bump Betamax Tap

## Workflow

1. Start from a clean `jj` working copy based on `main`.
   If unrelated local work exists, keep it on a separate change and create a
   fresh change from `main` for the formula bump.

2. Determine the latest upstream release with
   `gh release view --repo joshka/betamax`.
   Confirm the tag, version, and four expected release assets before editing
   the formula.

3. Update
   [Formula/betamax.rb](/Users/joshka/local/homebrew-tap/Formula/betamax.rb)
   from the release archives.
   Prefer the repo updater when present:

   ```bash
   python3 .github/scripts/bump_formula.py \
     --package betamax \
     --version <version> \
     --tag betamax-v<version>
   ```

   If the updater is not present on the current `main`, update only the four
   URLs and checksums in the formula.

4. Describe the `jj` change and PR title with the exact version, for example:

   ```bash
   jj --no-pager desc --message "Update Betamax formula to 0.1.12

   Refresh the Homebrew formula for Betamax 0.1.12 so the tap installs the
   current upstream binary archives."
   ```

5. Validate through Homebrew using the tapped formula name, not a raw formula
   path.
   If Homebrew is using a cached tap clone, point the tap clone at this checkout
   or fetch the bump bookmark into
   `/opt/homebrew/Library/Taps/joshka/homebrew-tap`.

   ```bash
   brew audit --strict --online joshka/tap/betamax
   brew livecheck joshka/tap/betamax
   brew install --overwrite joshka/tap/betamax && brew test joshka/tap/betamax
   ```

6. Publish and merge with explicit names.
   Push the `jj` bookmark, create a PR against `main`, and include the version
   in both the commit message and PR title/body.

## Branch Protection Caveat

If GitHub says required checks are expected but no checks are reported, inspect
protection first:

```bash
gh api repos/joshka/homebrew-tap/branches/main/protection
```

This can happen when `main` does not yet contain the workflow files that define
the required contexts. If the user explicitly asks to ship now, save the current
required-status-check config, temporarily clear only the required check
contexts, merge, then restore the exact saved contexts. Do not leave branch
protection weakened.

After merging, fetch with `jj --no-pager git fetch --remote origin` and move
the working copy to a new empty change on top of `main` with
`jj --no-pager new main`.
