# homebrew-gdw-vault

Homebrew tap for **GDW Vault** on macOS. This repository is separate from the
`homebrew-gdw` tap for GDW Mirror; its tap name is `josecruzchavez/gdw-vault`.

## Install

```sh
brew install --cask josecruzchavez/gdw-vault/gdw-vault
```

The cask downloads the universal, Developer ID-signed and Apple-notarized
application from the [latest GDW Vault release](https://github.com/josecruzchavez/gdw-vault/releases/latest).
It installs the app in `/Applications`. It does not configure the LaunchAgent
or CLI wrapper; see the [GDW Vault installation guide](https://github.com/josecruzchavez/gdw-vault#instalación-actualización-y-desinstalación)
for the source installation that registers those components.

Uninstalling the cask removes the app but preserves the local SQLite database
and Keychain credentials.

## Update the cask

For each release, update `version` and `sha256` in
[`Casks/gdw-vault.rb`](./Casks/gdw-vault.rb). Use the digest of the published
ZIP asset, not a local build:

```sh
gh api repos/josecruzchavez/gdw-vault/releases/tags/v1.6.0 \
  --jq '.assets[] | select(.name == "GDW-Vault-1.6.0-universal.zip") | .digest'
```

## Validate

Run these commands on a Mac with Homebrew installed:

```sh
brew audit --cask --strict ./Casks/gdw-vault.rb
brew style ./Casks/gdw-vault.rb
brew livecheck --cask ./Casks/gdw-vault.rb
```

The GitHub Actions workflow runs the same checks on pushes and pull requests.
