# Theme Presets Repo

Role:

- source of truth for terminal theme assets used in this workspace

Directories:

- `themes/`: Yazi themes
- `starship/`: Starship prompt presets
- `ls-colors/`: `LS_COLORS` presets consumed by `eza`
- `powershell/`: `$PSStyle.FileInfo.*` presets for native PowerShell output
- `current/`: active state consumed by the shell profile

Scripts:

- `apply-theme.ps1`: apply only a Yazi theme
- `apply-starship.ps1`: apply only a Starship theme
- `apply-terminal-theme.ps1`: apply the full terminal theme

Current active-state files:

- `current\theme.txt`
- `current\ls-colors.ps1`
- `current\powershell.ps1`

Theme coverage:

- full terminal themes:
  - `tokyo-night`
  - `catppuccin-powerline`
- current Yazi-only theme:
  - `mac-terminal`

Related docs:

- [Toolchain Overview](./toolchain-overview.md)
- [Yazi](../yazi.md)
- [eza](../eza.md)
- [PowerShell Profile](../powershell-profile.md)
