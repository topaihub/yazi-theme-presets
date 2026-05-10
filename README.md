# Yazi Theme Presets

This project stores the Yazi themes and related terminal color presets created in this workspace.
It also carries the Starship presets plus the loader scripts used by PowerShell and `eza`.

[中文](./README.zh-CN.md) | English

## Documentation

- [English Overview](./docs/en/toolchain-overview.md)
- [English Repo Guide](./docs/en/theme-presets.md)
- [English Yazi Guide](./docs/en/yazi.md)
- [English eza Guide](./docs/en/eza.md)
- [English Starship Guide](./docs/en/starship.md)
- [English PowerShell Profile Guide](./docs/en/powershell-profile.md)
- [Theme Presets Repo](./docs/theme-presets.md)

## Included Themes

Full terminal themes:

- `themes/tokyo-night/theme.toml`
- `themes/catppuccin-powerline/theme.toml`
- `ls-colors/tokyo-night-ls-colors.ps1`
- `ls-colors/catppuccin-powerline-ls-colors.ps1`
- `powershell/tokyo-night-fileinfo.ps1`
- `powershell/catppuccin-powerline-fileinfo.ps1`
- `starship/tokyo-night.toml`
- `starship/catppuccin-powerline.toml`

Yazi-only theme:

- `themes/mac-terminal/theme.toml`

Active state:

- `current\theme.txt`
- `apply-terminal-theme.ps1`

## Apply a Theme

From this directory:

```powershell
pwsh -File .\apply-theme.ps1 tokyo-night
pwsh -File .\apply-theme.ps1 mac-terminal
pwsh -File .\apply-theme.ps1 catppuccin-powerline
```

The script copies the selected preset to:

```text
%AppData%\yazi\config\theme.toml
```

Restart `yazi` after applying a new theme.

## Apply a Starship Preset

From this directory:

```powershell
pwsh -File .\apply-starship.ps1 tokyo-night
pwsh -File .\apply-starship.ps1 catppuccin-powerline
```

The script copies the selected preset to:

```text
YAZI_THEME_PRESETS_PWSH_DIR\starship.toml
or
STARSHIP_CONFIG directory\starship.toml
or
$PROFILE directory\starship.toml
```

Open a new PowerShell session or run `. $PROFILE` after switching.

To force the PowerShell config directory to a custom location:

```powershell
$env:YAZI_THEME_PRESETS_PWSH_DIR = 'D:\Your\PowerShell\Config'
```

Add that to your PowerShell profile if you want it to persist.

The script resolves the target directory in this order:

1. `YAZI_THEME_PRESETS_PWSH_DIR`
2. `STARSHIP_CONFIG` directory
3. `$PROFILE` directory

Repository source assets are resolved relative to the script location. User config targets are resolved from your local environment.

## Apply the Full Terminal Theme

This switches all of the following together:

- Starship
- `eza` through `LS_COLORS`
- PowerShell `dir` / `Get-ChildItem` fallback colors
- `yazi`

From this directory:

```powershell
pwsh -File .\apply-terminal-theme.ps1 tokyo-night
pwsh -File .\apply-terminal-theme.ps1 catppuccin-powerline
```

The active PowerShell and `LS_COLORS` loaders are stored in:

```text
<repo>\current
```

## Current Shell Integration

- `current\ls-colors.ps1` sets `LS_COLORS`, which is consumed by `eza`
- `current\powershell.ps1` sets `$PSStyle.FileInfo.*` for native PowerShell file listings
- your PowerShell profile needs to dot-source both loaders if you want the preset active in new shells

## Theme Coverage

- `tokyo-night`: full terminal theme
- `catppuccin-powerline`: full terminal theme
- `mac-terminal`: Yazi-only preset today; it does not currently include matching Starship, `LS_COLORS`, or PowerShell file-info assets

Open a new PowerShell session or run `. $PROFILE` after switching.
