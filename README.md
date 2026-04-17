# MegaKill Announcer

A World of Warcraft addon that announces multi-kills and killing sprees with on-screen text, sounds, and optional chat messages — inspired by classic arena shooter callouts.

Compatible with **Classic Era** and **Retail**.

---

## Features

- **Multi-kill tracking** — announces streaks of kills made within a configurable time window
- **Killing spree tracking** — announces milestone kill counts without dying (PvP kills only)
- **On-screen text** — large colored text displayed in the center of your screen
- **Sound effects** — custom audio cues for Double Kill, Triple Kill, and Monster Kill+
- **Chat announcements** — optional broadcast to SAY, YELL, PARTY, RAID, or BATTLEGROUND
- **PvP-only mode** — optionally restrict tracking to Honorable Kills only
- **Fully configurable** — all options toggleable via slash commands, saved between sessions

---

## Multi-Kill Milestones

Kills made within the time window (default: 15 seconds) chain together:

| Kills | Announcement    |
|-------|-----------------|
| 1     | First Blood!    |
| 2     | Double Kill!    |
| 3     | Triple Kill!    |
| 4     | Quadra Kill!    |
| 5     | Mega Kill!      |
| 6     | Monster Kill!   |
| 7     | Ultra Kill!     |
| 8     | Ludicrous Kill! |
| 9     | Holy Sh*t!!     |

---

## Killing Spree Milestones

Player kills accumulated without dying:

| Kills | Announcement   |
|-------|----------------|
| 5     | Killing Spree! |
| 10    | Rampage!       |
| 15    | Unstoppable!   |
| 20    | Dominating!    |
| 25    | Godlike!       |
| 30    | Wicked Sick!   |

---

## Installation

1. Download or clone this repository
2. Copy the `MegaKill_Announcer` folder into your WoW AddOns directory:
   - **Classic Era:** `World of Warcraft/_classic_era_/Interface/AddOns/`
   - **Retail:** `World of Warcraft/_retail_/Interface/AddOns/`
3. Launch WoW and enable the addon in the AddOns menu

---

## Commands

| Command | Description |
|---------|-------------|
| `/mk` | Toggle addon on/off |
| `/mk screen` | Toggle on-screen text |
| `/mk chat` | Toggle chat announcements |
| `/mk sound` | Toggle sounds |
| `/mk pvp` | Toggle PvP-only mode (Honorable Kills only) |
| `/mk channel X` | Set chat channel (`SAY`, `YELL`, `PARTY`, `RAID`, `BATTLEGROUND`) |
| `/mk window X` | Set multi-kill time window in seconds (5–60) |
| `/mk test 2` | Preview Double Kill announcement |
| `/mk test 3` | Preview Triple Kill announcement |
| `/mk test 4` | Preview Monster Kill announcement |
| `/mk status` | Show current settings |

---

## License

MIT License — see [LICENSE](LICENSE) for details.  
© 2026 Robison Karls Custodio
