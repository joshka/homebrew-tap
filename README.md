# Joshka Tap

## How do I install these formulae?

Install a formula directly from the tap:

```sh
brew trust --formula joshka/tap/jk
brew install joshka/tap/jk
```

Or tap the repository first:

```sh
brew tap joshka/tap
brew trust --formula joshka/tap/jk
brew install jk
```

Or, in a `brew bundle` `Brewfile`:

```ruby
tap "joshka/tap"
brew "<formula>"
```

## Formulae

- [`betamax`](https://www.joshka.net/betamax/) - Rust-first terminal capture CLI
  for generating screenshots, GIFs, videos, and terminal test artifacts from tape
  files.
- [`jk`](https://github.com/joshka/jk) - Log-first terminal UI for Jujutsu.

## Maintainer automation

The `Bump package formula` workflow opens or updates a checked PR for supported
formula updates.

Trigger a Betamax formula update from a release workflow:

```sh
gh workflow run bump-package.yml \
  --repo joshka/homebrew-tap \
  --field package=betamax \
  --field version=0.1.13 \
  --field tag=betamax-v0.1.13
```

Trigger a jk formula update from a release workflow:

```sh
gh workflow run bump-package.yml \
  --repo joshka/homebrew-tap \
  --field package=jk \
  --field version=0.2.3
```

The workflow requires `HOMEBREW_TAP_TOKEN` so the generated PR branch can run the
normal required checks. By default it enables auto-merge on the PR after CI
passes.

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
