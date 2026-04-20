-- MegaKill Announcer - Built-in Pack: Unreal Tournament
-- Milestone pack: each kill count and spree maps to a specific sound and label.
-- Labels use WoW item quality colors: common → rare → epic → legendary.

-- Item quality colors
local C = {
	common    = "|cffffffff",  -- white
	rare      = "|cff0070dd",  -- blue
	epic      = "|cffa335ee",  -- purple
	legendary = "|cffff8000",  -- orange
	reset     = "|r",
}

local function color(quality, text)
	return C[quality] .. text .. C.reset
end

MegaKill_RegisterPack("Unreal_Theme", {
	type      = "milestone",
	label     = "Unreal Tournament",
	author    = "Epic Games (sounds used under fair use for personal addon)",
	addonName = "MegaKill_Announcer",
	soundsPath = "assets/Unreal_Theme",

	-- Kill count slots — color escalates with streak
	-- [1-2] common, [3-4] rare, [5-6] epic, [7+] legendary
	files = {
		[1] = {
			{ label = color("common",    "First Blood!"),    sound = "first_blood.wav"    },
		},
		[2] = {
			{ label = color("common",    "Double Kill!"),    sound = "double_kill.wav"    },
		},
		[3] = {
			{ label = color("rare",      "Triple Kill!"),    sound = "triple_kill.wav"    },
		},
		[4] = {
			{ label = color("rare",      "Mega Kill!"),    sound = "mega_kill.wav"      },
		},
		[5] = {
			{ label = color("epic",      "Mega Kill!"),      sound = "mega_kill.wav"      },
		},
		[6] = {
			{ label = color("epic",      "Monster Kill!"),   sound = "monster_kill.wav"   },
		},
		[7] = {
			{ label = color("legendary", "Ultra Kill!"),     sound = "ultra_kill.wav"     },
		},
		[8] = {
			{ label = color("legendary", "Ludicrous Kill!"), sound = "ludicrous_kill.wav" },
			{ label = color("legendary", "Ownage!"),         sound = "ownage.wav"         },
		},
		[9] = {
			{ label = color("legendary", "Holy Sh*t!!"),     sound = "holy_shit.wav"      },
			{ label = color("legendary", "Ownage!"),         sound = "ownage.wav"         },
		},
	},

	-- Spree slots — all legendary, they're earned
	sprees = {
		[5]  = { label = color("legendary", "Killing Spree!"), sounds = { { label = color("legendary", "Killing Spree!"), sound = "killing_spree.wav" } } },
		[10] = { label = color("legendary", "Rampage!"),       sounds = { { label = color("legendary", "Rampage!"),       sound = "rampage.wav"       } } },
		[15] = { label = color("legendary", "Unstoppable!"),   sounds = { { label = color("legendary", "Unstoppable!"),   sound = "unstoppable.wav"   } } },
		[20] = { label = color("legendary", "Dominating!"),    sounds = { { label = color("legendary", "Dominating!"),    sound = "dominating.wav"    } } },
		[25] = { label = color("legendary", "Godlike!"),       sounds = { { label = color("legendary", "Godlike!"),       sound = "godlike.wav"       } } },
		[30] = { label = color("legendary", "Wicked Sick!"),   sounds = { { label = color("legendary", "Wicked Sick!"),   sound = "wicked_sick.wav"   } } },
	},
})
