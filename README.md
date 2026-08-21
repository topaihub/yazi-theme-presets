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

## Included Themes

Full terminal themes:

- `themes/tokyo-night/theme.toml`
- `themes/catppuccin-powerline/theme.toml`
- `themes/mac-terminal/theme.toml`
- `ls-colors/tokyo-night-ls-colors.ps1`
- `ls-colors/catppuccin-powerline-ls-colors.ps1`
- `ls-colors/mac-terminal-ls-colors.ps1`
- `eza/tokyo-night-theme.yml`
- `eza/catppuccin-powerline-theme.yml`
- `eza/mac-terminal-theme.yml`
- `powershell/tokyo-night-fileinfo.ps1`
- `powershell/catppuccin-powerline-fileinfo.ps1`
- `powershell/mac-terminal-fileinfo.ps1`
- `starship/tokyo-night.toml`
- `starship/catppuccin-powerline.toml`
- `starship/mac-terminal.toml`

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
pwsh -File .\apply-starship.ps1 mac-terminal
```

The script copies the selected preset to:

```text
YAZI_THEME_PRESETS_PWSH_DIR\starship.toml
or
STARSHIP_CONFIG directory\starship.toml
or
$PROFILE directory\starship.toml
```

**If the target is a `starship.toml` you hand-tuned, it is backed up first** as
`starship.toml.bak-<timestamp>`. Overwriting it is the only irreversible operation in
this repo. No backup is made when the content matches one of the presets — that is what
a previous apply left behind, and re-backing it up would just pile up identical files in
your config directory.

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
pwsh -File .\apply-terminal-theme.ps1 mac-terminal
```

The active PowerShell and `LS_COLORS` loaders are stored in:

```text
<repo>\current
```

The full apply is **two-phase**: all five assets are written as `.tmp` first, then renamed
once every copy succeeded. A failure partway through (file in use, directory suddenly not
writable) no longer leaves you with "starship and yazi switched, eza still on the old
theme" — a half-applied state that shows up as colors that do not match.

`current/` is not tracked; it is runtime state.

## Current Shell Integration

- `current\ls-colors.ps1` sets `LS_COLORS` (consumed by `eza`) **and `EZA_CONFIG_DIR`**
- `current\eza\theme.yml` styles `eza` metadata such as dates, sizes, headers, and
  permissions — it only takes effect when `EZA_CONFIG_DIR` points at it, which is why the
  loader above sets that variable too
- `current\powershell.ps1` sets `$PSStyle.FileInfo.*` for native PowerShell file listings
- your PowerShell profile needs to dot-source both loaders if you want the preset active in new shells

## Checks

Run this after making changes:

```powershell
pwsh -File .\test.ps1
```

It verifies that every theme carries its five assets, that the theme list has not been
hard-coded back into the scripts, that every loader sets `EZA_CONFIG_DIR`, that `current/`
is untracked, and that theme names mentioned in the docs actually exist. CI runs the same
script (see `.github/workflows/check.yml`).

## Theme Coverage

- `tokyo-night`: full terminal theme
- `catppuccin-powerline`: full terminal theme
- `mac-terminal`: full terminal theme

Open a new PowerShell session or run `. $PROFILE` after switching.
