# Starship

Role:

- renders the shell prompt
- controls separators, prompt symbols, and prompt colors

Theme source:

- `starship/<theme>.toml`

Apply commands:

```powershell
pwsh -File .\apply-starship.ps1 tokyo-night
pwsh -File .\apply-starship.ps1 catppuccin-powerline
```

Target resolution order:

1. `YAZI_THEME_PRESETS_PWSH_DIR\starship.toml`
2. `STARSHIP_CONFIG` directory
3. `$PROFILE` directory

Notes:

- this affects the prompt only
- it does not control `ls` colors or Yazi theme colors
- source preset files are resolved relative to this repository
- target config files are resolved from the user's local PowerShell environment

Related docs:

- [Toolchain Overview](./toolchain-overview.md)
- [PowerShell Profile](./powershell-profile.md)
