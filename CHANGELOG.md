# Changelog

## v0.3.0 — 2026-10-08

First public package of Jack's accepted v0.3 launcher, published as **ChatGPT & Codex Launcher**.

### Public branding update — 2026-10-08

- Renamed the public utility and its default buttons to ChatGPT and Codex.
- Updated the repository, download name, documentation, and interface previews to match.
- Source changes are limited to default labels, display text, and comments. The accepted launcher and EDIT behavior are unchanged.
- Existing v0.3 settings, including custom button names, are reused. Version remains v0.3.0.

### Included

- The accepted `ChatGPT-Codex-Selector-v0.3.ps1` source, preserved without changes to its functionality.
- A Windows launch helper and repeatable portable ZIP build.
- Installation, customization, troubleshooting, and security documentation.
- Rendered previews of the shipped launcher and edit interfaces.
- MIT license and release checksum support.

### Existing behavior retained

- Blue ChatGPT button sends Alt+3; purple Codex button sends Alt+1 to a detected ChatGPT desktop window.
- Editable button names and always-on-top preference.
- Movable, resizable window with minimize and close controls.
- Local v0.3 settings and a highlight for the last requested mode.

The original launcher and edit controls were live-tested by Jack on his Windows PC. This release adds public packaging; it does not redesign the accepted widget.
