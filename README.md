# Yazi Theme Presets

This project stores the Yazi themes and related terminal color presets created in this workspace.

## Included themes

- `themes/tokyo-night/theme.toml`
- `themes/mac-terminal/theme.toml`
- `themes/catppuccin-powerline/theme.toml`
- `lsd/tokyo-night-ls-colors.ps1`
- `lsd/catppuccin-powerline-ls-colors.ps1`
- `powershell/tokyo-night-fileinfo.ps1`
- `powershell/catppuccin-powerline-fileinfo.ps1`
- `starship/tokyo-night.toml`
- `starship/catppuccin-powerline.toml`
- `current\theme.txt`
- `apply-terminal-theme.ps1`

## Apply a theme

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

## Apply a Starship preset

From this directory:

```powershell
pwsh -File .\apply-starship.ps1 tokyo-night
pwsh -File .\apply-starship.ps1 catppuccin-powerline
```

The script copies the selected preset to:

```text
D:\Users\Documents\PowerShell\starship.toml
```

Open a new PowerShell session or run `. $PROFILE` after switching.

## Apply the full terminal theme

This switches all of the following together:

- Starship
- PowerShell `dir` / built-in `ls` / `Get-ChildItem`
- `lsd`
- `yazi`

From this directory:

```powershell
pwsh -File .\apply-terminal-theme.ps1 tokyo-night
pwsh -File .\apply-terminal-theme.ps1 catppuccin-powerline
```

The active PowerShell and `lsd` loaders are stored in:

```text
E:\scoop\yazi-theme-presets\current
```

Open a new PowerShell session or run `. $PROFILE` after switching.
