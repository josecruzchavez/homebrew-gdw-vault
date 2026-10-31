# homebrew-gdw-vault

Homebrew tap for **GDW Vault** on macOS. This repository is separate from the
`homebrew-gdw` tap for GDW Mirror; its tap name is `josecruzchavez/gdw-vault`.

## Install

```sh
brew install --cask josecruzchavez/gdw-vault/gdw-vault
```

On Homebrew 7, if the first install stops because the cask is untrusted, run
this once and retry the install command:

```sh
brew trust --cask josecruzchavez/gdw-vault/gdw-vault
```

The cask downloads the universal, Developer ID-signed and Apple-notarized
application from the [latest GDW Vault release](https://github.com/josecruzchavez/gdw-vault/releases/latest).
It installs the app in `/Applications`, configures the LaunchAgent for automatic
startup and XPC/MCP access, and links the `gdw-vault` CLI command into Homebrew's
`bin` directory.

Uninstalling the cask removes the app but preserves the local SQLite database
and Keychain credentials. The standalone `.pkg` installer will be added to a
future release.

## Update the cask

For each release, update `version` and `sha256` in
[`Casks/gdw-vault.rb`](./Casks/gdw-vault.rb). Use the digest of the published
ZIP asset, not a local build:

```sh
gh api repos/josecruzchavez/gdw-vault/releases/tags/v1.6.0 \
  --jq '.assets[] | select(.name == "GDW-Vault-1.6.0-universal.zip") | .digest | sub("sha256:"; "")'
```

## Validate

Run these commands on a Mac with Homebrew installed:

```sh
brew tap --custom-remote josecruzchavez/gdw-vault "$PWD"
brew audit --cask --strict josecruzchavez/gdw-vault/gdw-vault
brew style ./Casks/gdw-vault.rb
brew livecheck --cask josecruzchavez/gdw-vault/gdw-vault
```

The GitHub Actions workflow runs the same checks on pushes and pull requests.
