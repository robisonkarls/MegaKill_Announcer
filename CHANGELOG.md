# Changelog

## [1.0.6] - 2026-04-18
### Added
- Flamboyant announcer sound pack (HoN-inspired) with 22 audio files
- Rainbow text rendering for Flamboyant pack — per-character cycling colors
- Filename-as-display-name for Flamboyant pack (e.g. "Cherry Poppah")
- Sound pack selector in Config UI with prev/next arrows
- 5-slot simple pool system for Flamboyant pack (4–6 random files per slot)

### Fixed
- Retail 12.0 (Midnight): `COMBAT_LOG_EVENT_UNFILTERED` is restricted — switched to `UNIT_DIED`
- Classic: `UNIT_DIED` is unknown — guarded behind Retail version check
- All `RegisterEvent` calls moved to top-level file scope to avoid taint on both versions
- `COMBAT_LOG_EVENT_UNFILTERED` registered at top-level for Classic with `IS_RETAIL` guard
- `triple_kill.mp3` renamed to `.wav` for consistent audio format

All notable changes to MegaKill Announcer will be documented in this file.

The format is based on [Keep a Changelog](https://keepachangelog.com/en/1.0.0/),
and this project adheres to [Semantic Versioning](https://semver.org/spec/v2.0.0.html).

## [1.0.1] - 2026-04-17

### Added
- Streak timer progress bar — shows kill count and countdown timer after each kill
  - Color shifts green → yellow → red as the window expires
  - Fades out on window expiry or player death
  - Draggable, position saved between sessions
- `.gitignore` — excludes build artifacts, OS files, editor junk

### Fixed
- `ADDON_ACTION_BLOCKED` — chat messages now queued and sent after combat ends
- `/mk config` now reliably opens settings panel on Retail 10.0+

### Improved
- Config UI rebuilt with section headers and hover tooltips
- Config panel uses `Settings` API on Retail 10.0+, falls back to `InterfaceOptions` on Classic
- Release workflow now ships only in-game files (no docs/dev files in the zip)

[1.0.1]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.1

---

## [1.0.0] - 2026-04-16

### Added
- Initial release of MegaKill Announcer
- Multi-kill tracking with time-window based streaks
- Killing spree tracking for player kills without dying
- On-screen announcements with large colored text
- Sound effects for Double Kill, Triple Kill, and Monster Kill
- Optional chat announcements to SAY/YELL/PARTY/RAID/BATTLEGROUND
- Configuration UI panel (ESC → Interface → AddOns)
- PvP-only mode to track Honorable Kills exclusively
- Configurable kill window (5-60 seconds)
- Slash commands (`/mk` or `/megakill`)
- Test buttons in UI to preview announcements
- Support for both WoW Classic Era (1.14.3) and Retail (12.0+)
- SavedVariables for persistent settings

### Multi-Kill Milestones
- First Blood (1 kill)
- Double Kill (2 kills)
- Triple Kill (3 kills)
- Quadra Kill (4 kills)
- Mega Kill (5 kills)
- Monster Kill (6 kills)
- Ultra Kill (7 kills)
- Ludicrous Kill (8 kills)
- Holy Sh*t!! (9 kills)

### Killing Spree Milestones
- Killing Spree (5 kills)
- Rampage (10 kills)
- Unstoppable (15 kills)
- Dominating (20 kills)
- Godlike (25 kills)
- Wicked Sick (30 kills)

[1.0.0]: https://github.com/robisonkarls/MegaKill_Announcer/releases/tag/v1.0.0
