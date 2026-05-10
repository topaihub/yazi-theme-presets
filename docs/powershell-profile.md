# PowerShell Profile

Role:

- shell startup entrypoint
- wires together prompt, aliases, and theme loaders

Profile path:

- run `$PROFILE` to inspect the actual path on the current machine

Current responsibilities:

- load `posh-git`
- load `PSReadLine` for interactive shells
- append stable PATH entries
- set `STARSHIP_CONFIG`
- dot-source:
  - `current\ls-colors.ps1`
  - `current\powershell.ps1`
- define aliases and functions for:
  - `y`
  - `ls`
  - `ll`
  - `la`

Theme interaction:

- `current\ls-colors.ps1` feeds `eza`
- `current\powershell.ps1` styles native `Get-ChildItem` output as fallback

Notes:

- changing files in `current\` does nothing for already-open shells
- open a new PowerShell session or run `. $PROFILE`

Related docs:

- [eza](./eza.md)
- [Starship](./starship.md)
- [Theme Presets Repo](./theme-presets.md)
