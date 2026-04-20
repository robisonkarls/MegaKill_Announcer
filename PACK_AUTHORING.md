# MegaKill Announcer — Sound Pack Authoring Guide

Community sound packs are standalone WoW addons that register themselves into MegaKill Announcer's pack registry. No changes to the core addon are needed — players install your pack like any other addon and it appears automatically in the pack selector.

---

## Pack Types

Every pack must declare a `type`:

| Type | Behaviour |
|---|---|
| `"milestone"` | Each kill count maps to a specific sound and label. Sprees fire. Streak bar shows. |
| `"random"` | One sound picked at random from a flat pool every kill. No sprees. No streak bar. |

---

## Folder Structure

```
MegaKill_Pack_YourName/
├── MegaKill_Pack_YourName.toc
├── Pack.lua
└── sound/
    ├── your_sound_1.wav
    ├── your_sound_2.wav
    └── ...
```

Place this folder in `Interface/AddOns/` alongside `MegaKill_Announcer/`.

---

## TOC File

```
## Interface: 120001, 11508
## Title: MegaKill Pack: Your Pack Name
## Notes: Short description of your pack.
## Author: YourName
## Version: 1.0.0
## Dependencies: MegaKill_Announcer

Pack.lua
```

`Dependencies: MegaKill_Announcer` is required — it guarantees the core addon loads first so `MegaKill_RegisterPack` is available when your `Pack.lua` runs.

`120001, 11508` supports both Retail and Classic Era. Remove one if your pack is version-specific.

---

## Pack.lua — Milestone Type

```lua
MegaKill_RegisterPack("MyPack_Milestone", {
    type       = "milestone",
    label      = "My Pack Name",           -- shown in Config UI
    author     = "YourName",               -- optional
    addonName  = "MegaKill_Pack_YourName", -- must match your addon folder name
    soundsPath = "sound",                  -- path to sounds relative to addonName

    -- Kill count slots (1–9)
    -- Each slot is a list — one entry is picked at random from the list
    files = {
        [1] = { { label = "First Blood!",    sound = "first_blood.wav"  } },
        [2] = { { label = "Double Kill!",    sound = "double_kill.wav"  } },
        [3] = { { label = "Triple Kill!",    sound = "triple_kill.wav"  } },
        [4] = { { label = "Quadra Kill!",    sound = "quad_kill.wav"    } },
        [5] = { { label = "Mega Kill!",      sound = "mega_kill.wav"    } },
        [6] = { { label = "Monster Kill!",   sound = "monster_kill.wav" } },
        [7] = { { label = "Ultra Kill!",     sound = "ultra_kill.wav"   } },
        [8] = {
            -- Multiple options: one picked at random
            { label = "Ludicrous Kill!", sound = "ludicrous.wav" },
            { label = "Ownage!",         sound = "ownage.wav"    },
        },
        [9] = {
            { label = "Holy Sh*t!!",  sound = "holy.wav"  },
            { label = "Ownage!",      sound = "ownage.wav" },
        },
    },

    -- Spree slots (keyed by cumulative kill count without dying)
    sprees = {
        [5]  = { label = "Killing Spree!", sounds = { { label = "Killing Spree!", sound = "spree.wav"     } } },
        [10] = { label = "Rampage!",       sounds = { { label = "Rampage!",       sound = "rampage.wav"   } } },
        [15] = { label = "Unstoppable!",   sounds = { { label = "Unstoppable!",   sound = "unstop.wav"    } } },
        [20] = { label = "Dominating!",    sounds = { { label = "Dominating!",    sound = "dominate.wav"  } } },
        [25] = { label = "Godlike!",       sounds = { { label = "Godlike!",       sound = "godlike.wav"   } } },
        [30] = { label = "Wicked Sick!",   sounds = { { label = "Wicked Sick!",   sound = "wicked.wav"    } } },
    },
})
```

---

## Pack.lua — Random Type

```lua
MegaKill_RegisterPack("MyPack_Random", {
    type       = "random",
    label      = "My Random Pack",
    author     = "YourName",
    addonName  = "MegaKill_Pack_YourName",
    soundsPath = "sound",

    -- Flat pool — one entry picked at random per kill
    files = {
        { label = "Nice!",    sound = "nice.wav"    },
        { label = "Rekt!",    sound = "rekt.wav"    },
        { label = "Poggers!", sound = "poggers.wav" },
        { label = "EZ!",      sound = "ez.wav"      },
    },
})
```

No `sprees` table needed — random packs never fire spree announcements.

---

## Label Formatting

Labels support WoW color escape codes. You have full control over how your text looks on screen.

**Solid color:**
```lua
label = "|cffff8000Legendary Kill!|r"   -- orange
label = "|cffa335eeMega Kill!|r"         -- purple (epic)
label = "|cff0070ddDouble Kill!|r"       -- blue (rare)
label = "|cffffffffFirst Blood!|r"       -- white (common)
```

**Per-character rainbow (example for short text):**
```lua
label = "|cffff0000F|r|cffff7f00i|r|cffffff00r|r|cff00ff00e|r|cff0000ff!|r"
```

**Plain text** (no color codes) renders in white by default.

Color format: `|cffRRGGBB` where RR, GG, BB are hex values. Always close with `|r`.

---

## Audio Format

WoW supports `.wav` and `.mp3` files. `.wav` is recommended — it works on all versions including Classic Era without issues. `.mp3` works on Retail but can be unreliable on older clients.

Keep files under 10MB each. Shorter clips (under 3 seconds) work best for kill announcements.

---

## Sound Path Resolution

MegaKill builds the full path as:
```
Interface/AddOns/<addonName>/<soundsPath>/<sound filename>
```

Example with `addonName = "MegaKill_Pack_NBA"` and `soundsPath = "sound"`:
```
Interface/AddOns/MegaKill_Pack_NBA/sound/announcer_1stblood_01.mp3
```

Make sure your folder structure matches exactly.

---

## Testing Locally

1. Copy your pack folder to `Interface/AddOns/`
2. Enable it in the WoW addon list
3. `/reload` in-game
4. Open `/mk config` — your pack should appear in the selector
5. Use the preview buttons (Kill 1, Kill 2, Kill 3) to test sounds
6. Kill mobs to test the full flow

If your pack doesn't appear:
- Check `Dependencies: MegaKill_Announcer` is in your TOC
- Check the `addonName` matches your folder name exactly (case-sensitive on Mac/Linux)
- Check `soundsPath` matches your sounds subfolder

---

## Publishing on CurseForge

1. Create a new project at https://www.curseforge.com/wow/addons
2. Set category to **AddOns** and game to **World of Warcraft**
3. In your TOC add:
   ```
   ## X-Curse-Project-ID: YOUR_PROJECT_ID
   ```
4. Upload your pack folder as a zip

Naming convention: `MegaKill_Pack_YourTheme` keeps packs discoverable alongside the core addon.

---

## Example: Full Minimal Pack

`MegaKill_Pack_Example/MegaKill_Pack_Example.toc`:
```
## Interface: 120001, 11508
## Title: MegaKill Pack: Example
## Notes: Example pack for MegaKill Announcer.
## Author: YourName
## Version: 1.0.0
## Dependencies: MegaKill_Announcer

Pack.lua
```

`MegaKill_Pack_Example/Pack.lua`:
```lua
MegaKill_RegisterPack("Example", {
    type       = "random",
    label      = "Example Pack",
    author     = "YourName",
    addonName  = "MegaKill_Pack_Example",
    soundsPath = "sound",
    files = {
        { label = "Nice!", sound = "nice.wav" },
        { label = "EZ!",   sound = "ez.wav"   },
    },
})
```

`MegaKill_Pack_Example/sound/nice.wav` — your audio file.

That's it. Two files and one function call.
