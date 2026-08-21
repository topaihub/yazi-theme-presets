# Toolchain Overview

This workspace uses a split terminal theme toolchain instead of a single monolithic shell setup.

Components:

- [Yazi](./yazi.md): interactive file manager
- [eza](./eza.md): `ls` / `ll` / `la` renderer with icons
- [Starship](./starship.md): prompt renderer
- [PowerShell Profile](./powershell-profile.md): shell startup, aliases, and loader wiring
- [Theme Presets Repo](./theme-presets.md): theme assets and apply scripts

Theme flow:

1. `apply-theme.ps1` updates only the Yazi theme
2. `apply-starship.ps1` updates only the Starship prompt theme
3. `apply-terminal-theme.ps1` updates the full terminal theme set for:
   - Yazi
   - Starship
   - `LS_COLORS` consumed by `eza`
   - PowerShell file-info fallback colors
4. `Microsoft.PowerShell_profile.ps1` dot-sources the active loaders from `current\`

Current command conventions:

- `y` -> `yazi`
- `ls` -> `eza --icons=auto --group-directories-first`
- `ll` -> `eza --icons=auto --group-directories-first --long --all`
- `la` -> `eza --icons=auto --group-directories-first --all`

Current full terminal themes (all three carry the five assets; `test.ps1` checks this):

- `tokyo-night`
- `catppuccin-powerline`
- `mac-terminal`
