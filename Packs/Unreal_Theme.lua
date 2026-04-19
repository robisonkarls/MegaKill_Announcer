-- MegaKill Announcer - Built-in Pack: Unreal Tournament
-- Milestone pack: each kill count and spree maps to a specific sound and label.

MegaKill_RegisterPack("Unreal_Theme", {
	type      = "milestone",
	label     = "Unreal Tournament",
	author    = "Epic Games (sounds used under fair use for personal addon)",
	addonName = "MegaKill_Announcer",
	soundsPath = "assets/Unreal_Theme",

	-- Kill count slots: each entry is a list of { label, sound } options (picked randomly)
	files = {
		[1] = {
			{ label = "First Blood!",    sound = "first_blood.wav" },
		},
		[2] = {
			{ label = "Double Kill!",    sound = "double_kill.wav" },
		},
		[3] = {
			{ label = "Triple Kill!",    sound = "triple_kill.wav" },
		},
		[4] = {
			{ label = "Quadra Kill!",    sound = "mega_kill.wav" },
		},
		[5] = {
			{ label = "Mega Kill!",      sound = "mega_kill.wav" },
		},
		[6] = {
			{ label = "Monster Kill!",   sound = "monster_kill.wav" },
		},
		[7] = {
			{ label = "Ultra Kill!",     sound = "ultra_kill.wav" },
		},
		[8] = {
			{ label = "Ludicrous Kill!", sound = "ludicrous_kill.wav" },
			{ label = "Ownage!",         sound = "ownage.wav" },
		},
		[9] = {
			{ label = "Holy Sh*t!!",     sound = "holy_shit.wav" },
			{ label = "Ownage!",         sound = "ownage.wav" },
		},
	},

	-- Spree slots: keyed by cumulative kill count without dying
	sprees = {
		[5]  = { label = "Killing Spree!", sounds = { { label = "Killing Spree!", sound = "killing_spree.wav" } } },
		[10] = { label = "Rampage!",       sounds = { { label = "Rampage!",       sound = "rampage.wav"       } } },
		[15] = { label = "Unstoppable!",   sounds = { { label = "Unstoppable!",   sound = "unstoppable.wav"   } } },
		[20] = { label = "Dominating!",    sounds = { { label = "Dominating!",    sound = "dominating.wav"    } } },
		[25] = { label = "Godlike!",       sounds = { { label = "Godlike!",       sound = "godlike.wav"       } } },
		[30] = { label = "Wicked Sick!",   sounds = { { label = "Wicked Sick!",   sound = "wicked_sick.wav"   } } },
	},
})
