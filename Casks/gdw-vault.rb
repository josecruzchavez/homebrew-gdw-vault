cask "gdw-vault" do
  version "1.6.1"
  sha256 "caf541feee73b03f813434a65cc6c829f58902196f23c8a6c438fd27f419562b"

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
  binary "#{appdir}/GDW Vault.app/Contents/MacOS/GDW Vault", target: "gdw-vault"

  postflight_steps do
    run "/bin/bash", args: [
      "-c",
      <<~BASH,
        set -euo pipefail
        user_id="$(/usr/bin/id -u)"
        gui_domain="gui/$user_id"
        service_target="$gui_domain/mx.gdw.vault"
        launch_agent="$HOME/Library/LaunchAgents/mx.gdw.vault.plist"
        app_executable="$1"

        if /bin/launchctl print "$service_target" >/dev/null 2>&1; then
          /bin/launchctl bootout "$service_target"
        fi

        /bin/mkdir -p "$(dirname "$launch_agent")"
        cat > "$launch_agent" <<PLIST
        <?xml version="1.0" encoding="UTF-8"?>
        <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
        <plist version="1.0">
        <dict>
            <key>Label</key>
            <string>mx.gdw.vault</string>
            <key>ProgramArguments</key>
            <array>
                <string>$app_executable</string>
            </array>
            <key>RunAtLoad</key>
            <true/>
            <key>KeepAlive</key>
            <dict>
                <key>SuccessfulExit</key>
                <false/>
            </dict>
            <key>MachServices</key>
            <dict>
                <key>mx.gdw.vault.db.$user_id</key>
                <true/>
            </dict>
        </dict>
        </plist>
        PLIST
        /bin/chmod 644 "$launch_agent"
        /bin/launchctl bootstrap "$gui_domain" "$launch_agent"
      BASH
      "--",
      "{{appdir}}/GDW Vault.app/Contents/MacOS/GDW Vault",
    ]
  end

  uninstall_preflight_steps do
    run "/bin/bash", args: [
      "-c",
      <<~BASH,
        set -euo pipefail
        service_target="gui$(/usr/bin/id -u)/mx.gdw.vault"
        if /bin/launchctl print "$service_target" >/dev/null 2>&1; then
          /bin/launchctl bootout "$service_target"
        fi
        /bin/rm -f "$HOME/Library/LaunchAgents/mx.gdw.vault.plist"
      BASH
    ]
  end

  uninstall quit: "mx.gdw.vault"

  caveats <<~EOS
    GDW Vault runs in the menu bar. Connection metadata stays in the local
    SQLite database and credentials remain in the macOS Keychain.

    The Cask registers the LaunchAgent for automatic startup and XPC/MCP access,
    and links the gdw-vault CLI command into Homebrew's bin directory.

    Uninstalling the Cask leaves the local database and Keychain items intact.
  EOS
end
