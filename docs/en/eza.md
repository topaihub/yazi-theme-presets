# eza

Role:

- renderer for `ls`, `ll`, and `la`
- shows icons and colors in normal shell listings

Color source:

- `current\ls-colors.ps1`
- this loader sets `LS_COLORS`
- `eza` reads `LS_COLORS` directly

Current shell mappings:

- `ls` -> `eza --icons=auto --group-directories-first`
- `ll` -> `eza --icons=auto --group-directories-first --long --all`
- `la` -> `eza --icons=auto --group-directories-first --all`

Notes:

- this replaces the old `Terminal-Icons` path
- icons now come from `eza`, not from PowerShell formatting
- if colors do not update after switching themes, open a new shell or run `. $PROFILE`

Related docs:

- [PowerShell Profile](./powershell-profile.md)
- [Theme Presets Repo](./theme-presets.md)
