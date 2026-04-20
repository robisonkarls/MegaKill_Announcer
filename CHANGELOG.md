# Changelog

All notable changes to MegaKill Announcer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.2.0] - 2026-04-19

### Added
- **Community sound pack registry** — third-party packs can now register via `MegaKill_RegisterPack()` as standalone addons; see `PACK_AUTHORING.md`
- Built-in packs split into `Packs/Unreal_Theme.lua` and `Packs/Flamboyant_theme.lua` — same API as community packs
- **Milestone vs Random pack types** — milestone packs map sounds to kill counts; random packs pick from a flat pool every kill
- Streak bar and spree announcements automatically disabled for random packs; controls grey out in Config UI
- **WoW item quality colors** on Unreal Tournament pack — white (common) → blue (rare) → purple (epic) → orange (legendary) as streak builds
- **Rainbow labels** baked into Flamboyant pack entries via WoW color escape codes
- **Font size slider** in Config UI (range 16–128) with live on-screen preview while dragging
- Pack type shown as subtitle under pack selector in Config UI

### Changed
- `ShowAnnounce()` now takes a single label string — packs own all text formatting including colors
- Config UI pack selector reads dynamically from registry — community packs appear automatically

### Fixed
- `local db` declared before `GetPack()` — scoping bug caused `GetPack()` to always return nil
- `local announceFrame` declared before `MegaKill_SetFontSize()` — same scoping bug
- TOC file paths use forward slashes — backslashes broke pack loading on Mac
- `SetEnabled()` replaced with `Enable()`/`Disable()` — `SetEnabled` does not exist on WoW CheckButton frames
- Font path uses hardcoded `Fonts\FRIZQT__.TTF` — `GameFontNormalHuge:GetFont()` can return nil before UI loads

[1.2.0]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.2.0

## [1.1.0] - 2026-04-19

### Added
- **Events split by version** — `Events_Retail.lua` loaded by Mainline TOC, `Events_Classic.lua` loaded by Classic TOC
- `MegaKill = {}` shared namespace — `OnKill`, `OnPlayerDead`, `OnPlayerAlive`, `GetDB` exposed for event files

### Changed
- `Core.lua` no longer registers any events — all event registration moved to version-specific files
- Removed `IS_RETAIL_PRECHECK` version check hack from Core

### Fixed
- Version bleed impossible — Classic cannot accidentally register `UNIT_DIED`; Retail cannot register `COMBAT_LOG_EVENT_UNFILTERED`

[1.1.0]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.1.0

## [1.0.8] - 2026-04-18

### Removed
- Chat broadcasting feature removed entirely — sounds and screen text only

### Fixed
- Classic: syntax errors from orphaned code after chat removal
- Classic: `WOW_PROJECT_MAINLINE` constant unreliable — switched to `WOW_PROJECT_ID == 1`
- Classic: `UNIT_DIED` no longer attempted on Classic (Retail-only event)
- Wago Addons: release now uploads as Stable (was Alpha due to untagged commit)

[1.0.8]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.8

## [1.0.7] - 2026-04-18

### Added
- Heroes of Newerth Flamboyant announcer sound pack (22 audio files)
- Rainbow text rendering for HoN Flamboyant pack — per-character cycling colors
- Sound pack selector in Config UI (prev/next arrows)
- Config UI uses ScrollFrame — nothing cut off on small panels
- Two-column checkbox layout in Config
- Preview buttons use selected pack sounds and matching text

### Fixed
- Retail 12.0: COMBAT_LOG_EVENT_UNFILTERED now only registered on Classic
- UNIT_DIED now only registered on Retail 12.0+
- Preview sound and text now always match (single random roll)
- Config overlapping checkboxes resolved
- Sounds always play — removed redundant sound toggle

[1.0.7]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.7

## [1.0.6] - 2026-04-18

### Added
- Flamboyant announcer sound pack (HoN-inspired) with 22 audio files
- Sound pack selector in Config UI with prev/next arrows

### Fixed
- Retail 12.0 (Midnight): `COMBAT_LOG_EVENT_UNFILTERED` is restricted — switched to `UNIT_DIED`

[1.0.6]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.6

## [1.0.1] - 2026-04-17

### Added
- Streak timer progress bar — shows kill count and countdown timer after each kill
- `.gitignore` — excludes build artifacts, OS files, editor junk

### Fixed
- `ADDON_ACTION_BLOCKED` — chat messages now queued and sent after combat ends
- `/mk config` now reliably opens settings panel on Retail 10.0+

[1.0.1]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.1

## [1.0.0] - 2026-04-16

### Added
- Initial release of MegaKill Announcer
- Multi-kill tracking with time-window based streaks
- Killing spree tracking for player kills without dying
- On-screen announcements with large colored text
- Sound effects for multi-kills and killing sprees
- Configuration UI panel (ESC → Interface → AddOns)
- PvP-only mode to track Honorable Kills exclusively
- Configurable kill window (5–60 seconds)
- Slash commands (`/mk` or `/megakill`)
- Support for WoW Classic Era (1.15.x) and Retail (12.0+)

[1.0.0]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.0
