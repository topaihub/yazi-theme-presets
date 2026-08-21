# Theme Presets Repo

Role:

- source of truth for terminal theme assets used in this workspace

Directories:

- `themes/`: Yazi themes
- `starship/`: Starship prompt presets
- `ls-colors/`: `LS_COLORS` presets consumed by `eza`
- `eza/`: `eza` metadata themes for dates, sizes, headers, and permissions
- `powershell/`: `$PSStyle.FileInfo.*` presets for native PowerShell output
- `current/`: active state consumed by the shell profile
- `lib/`: path resolution and backup logic shared by the three apply scripts

Scripts:

- `apply-theme.ps1`: apply only a Yazi theme
- `apply-starship.ps1`: apply only a Starship theme
- `apply-terminal-theme.ps1`: apply the full terminal theme
- `test.ps1`: repo invariant checks — run it after making changes

Adding a theme means adding a directory, not editing scripts:

The theme list comes from `Get-AvailableThemes` in `lib/paths.ps1`, which reads
`themes/`. Each of the three scripts used to carry its own `ValidateSet`, so adding a
theme meant editing three places — and whichever script you missed would reject the new
theme as an invalid value. `test.ps1` asserts no `ValidateSet` remains.

`current/` is not tracked:

It is runtime state that the apply scripts overwrite every run. Tracking it means
applying a theme dirties your working tree, and the next `git pull` hits a meaningless
conflict between the theme you picked and the theme that was committed.

Current active-state files:

- `current\theme.txt`
- `current\ls-colors.ps1`
- `current\eza\theme.yml`
- `current\powershell.ps1`

Theme coverage:

- full terminal themes:
  - `tokyo-night`
  - `catppuccin-powerline`
  - `mac-terminal`

A full theme should include:

- `themes/<theme>/theme.toml`
- `starship/<theme>.toml`
- `ls-colors/<theme>-ls-colors.ps1`
- `eza/<theme>-theme.yml`
- `powershell/<theme>-fileinfo.ps1`

If any of these assets is missing, the theme should be treated as partial rather than a full terminal theme.

Color-mapping rules for `eza` themes:

`eza` metadata themes should not be guessed from scratch. They should be mapped from the existing theme assets.

Recommended mapping:

- `date`
  - prefer the foreground color used by the `starship` time module
  - otherwise fall back to a muted text or secondary text color from the theme
- `header`
  - use the main accent color of the theme
  - for themes like `tokyo-night`, this is typically the directory or title accent
- `size`
  - numeric values should use a positive or emphasized file-information color
  - units should use a muted helper color
- `perms.read`
  - map from Yazi `perm_read`
- `perms.write`
  - map from Yazi `perm_write`
- `perms.execute`
  - map from Yazi `perm_exec`
- `inode` / `blocks` / `links`
  - prefer muted helper colors so metadata does not overpower filenames

Recommended source priority:

1. `starship/<theme>.toml`
2. `themes/<theme>/theme.toml`
3. `ls-colors/<theme>-ls-colors.ps1`

Notes:

- `starship` is best for time color, accent color, and overall mood
- `yazi` is best for permissions, directory color, and text hierarchy
- `ls-colors` is useful for file-type colors, but should not be the only source for `eza` date and metadata colors

Practical rule:

- do not blindly copy one file's palette into another tool
- do not invent an entirely new palette by intuition
- always read the existing `starship` / `yazi` / `ls-colors` assets first, then map fields intentionally

Related docs:

- [Toolchain Overview](./toolchain-overview.md)
- [Yazi](./yazi.md)
- [eza](./eza.md)
- [PowerShell Profile](./powershell-profile.md)
