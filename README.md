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

## Documentation

`brew help`, `man brew` or check [Homebrew's documentation](https://docs.brew.sh).
