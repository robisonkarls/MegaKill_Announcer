# MegaKill Announcer

**MegaKill Announcer** brings arena shooter energy to your WoW PvP. Every kill chain gets an on-screen callout and a sound — First Blood, Double Kill, Triple Kill, all the way to Holy Sh*t!! It works on both **Classic Era** and **Retail (12.0+)**.

---

## Sound Packs

MegaKill ships with two built-in announcers and supports **community-made packs** as standalone addons.

**🎮 Unreal Tournament** *(milestone)*
The classic UT callouts. Text color escalates with your streak — white for First Blood, blue for Triple Kill, purple for Mega Kill, and orange legendary for Ultra Kill and beyond. Killing Sprees fire with their own dedicated sounds.

**🌈 Heroes of Newerth — Flamboyant** *(random)*
The iconic HoN Flamboyant announcer. Every kill plays a random sound from the full pool — Cherry Poppah, Fabulous, Unicorn Stampede, and 19 more. Labels render in full per-character rainbow color.

**🔧 Community Packs**
Anyone can publish a sound pack as a separate addon. Install it alongside MegaKill and it appears automatically in the pack selector — no core addon changes needed. Full authoring guide on the [wiki](https://github.com/robisonkarls/MegaKill_Announcer/wiki/Creating-Sound-Packs).

---

## Features

- **Multi-kill tracking** — chain kills within a configurable time window (5–60s)
- **Killing spree tracking** — milestone callouts for kills without dying (5, 10, 15, 20, 25, 30)
- **On-screen text** — large center-screen announcements with adjustable font size (16–128)
- **Sound effects** — full audio cues for every milestone
- **Two pack types** — milestone (progressive, streak bar, sprees) or random (flat pool, chaotic)
- **Streak timer bar** — thin progress bar showing time left to chain your next kill
- **Font size slider** — live preview as you drag
- **PvP-only mode** — optionally restrict to Honorable Kills
- **Community pack API** — `MegaKill_RegisterPack()` for third-party announcers

---

## Kill Milestones

| Kills | Callout | Color |
|---|---|---|
| 1 | First Blood! | White |
| 2 | Double Kill! | White |
| 3 | Triple Kill! | Blue |
| 4 | Mega Kill! | Blue |
| 5 | Mega Kill! | Purple |
| 6 | Monster Kill! | Purple |
| 7 | Ultra Kill! | Orange |
| 8 | Ludicrous Kill! | Orange |
| 9 | Holy Sh*t!! | Orange |

## Killing Sprees

| Kills | Callout |
|---|---|
| 5 | Killing Spree! |
| 10 | Rampage! |
| 15 | Unstoppable! |
| 20 | Dominating! |
| 25 | Godlike! |
| 30 | Wicked Sick! |

---

## Commands

| Command | Description |
|---|---|
| `/mk` | Toggle on/off |
| `/mk config` | Open settings panel |
| `/mk pvp` | Toggle PvP-only mode |
| `/mk window X` | Set kill chain window (5–60s) |
| `/mk test 2/3/4` | Preview announcements |
| `/mk status` | Show current settings |

---

## Installation

1. Download from [CurseForge](https://www.curseforge.com/wow/addons/megakill-announcer) or [Wago Addons](https://addons.wago.io)
2. Copy `MegaKill_Announcer` to your AddOns folder:
   - **Classic Era:** `World of Warcraft/_classic_era_/Interface/AddOns/`
   - **Retail:** `World of Warcraft/_retail_/Interface/AddOns/`
3. Enable in the addon list and `/reload`
4. Open `/mk config` to choose your sound pack and adjust settings

---

## Creating a Sound Pack

Full guide: [wiki/Creating-Sound-Packs](https://github.com/robisonkarls/MegaKill_Announcer/wiki/Creating-Sound-Packs)

Two files and one function call — your pack is live on CurseForge.

```lua
MegaKill_RegisterPack("MyPack", {
    type       = "random",
    label      = "My Pack",
    addonName  = "MegaKill_Pack_MyPack",
    soundsPath = "sound",
    files = {
        { label = "Nice!", sound = "nice.wav" },
        { label = "EZ!",   sound = "ez.wav"   },
    },
})
```

---

## Links

- [GitHub](https://github.com/robisonkarls/MegaKill_Announcer)
- [Wiki](https://github.com/robisonkarls/MegaKill_Announcer/wiki)
- [Creating Sound Packs](https://github.com/robisonkarls/MegaKill_Announcer/wiki/Creating-Sound-Packs)
- [Report a Bug](https://github.com/robisonkarls/MegaKill_Announcer/issues)

---

## License

MIT License — see [LICENSE](LICENSE) for details.
© 2026 Robison Karls Custodio
