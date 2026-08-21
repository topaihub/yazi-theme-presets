# eza

Role:

- renderer for `ls`, `ll`, and `la`
- shows icons and colors in normal shell listings

Color source:

- `current\ls-colors.ps1` sets `LS_COLORS`, which `eza` reads directly — this drives
  file-type colors
- `current\eza\theme.yml` styles eza metadata such as dates, sizes, headers, and
  permissions

Two channels, and the second one needs a variable:

`eza` only reads `theme.yml` from `$EZA_CONFIG_DIR`. Copying the file into
`current\eza\` is not enough — without the variable those mapped colors never take
effect. `current\ls-colors.ps1` sets it (that loader is already dot-sourced by the
profile, so nothing else has to change), and `test.ps1` asserts every loader does.

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
