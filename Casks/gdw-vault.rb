cask "gdw-vault" do
  version "1.6.0"
  sha256 "04444a3dd6bafa60a3a6a984978a8ac8a031498968cfe31e0229cb63c0005ece"

  url "https://github.com/josecruzchavez/gdw-vault/releases/download/v#{version}/GDW-Vault-#{version}-universal.zip"
  name "GDW Vault"
  desc "Local-first connection vault with MCP integration"
  homepage "https://vault.gdw.mx/"

  livecheck do
    url :url
    strategy :github_latest
  end

  depends_on macos: :ventura

  app "GDW Vault.app"

  uninstall quit: "mx.gdw.vault"

  caveats <<~EOS
    GDW Vault runs in the menu bar. Connection metadata stays in the local
    SQLite database and credentials remain in the macOS Keychain.

    This Cask installs the app only; it does not create the LaunchAgent or CLI
    wrapper used for automatic startup and MCP/XPC registration. See the
    installation instructions at https://github.com/josecruzchavez/gdw-vault.

    Uninstalling the Cask leaves the local database and Keychain items intact.
  EOS
end
