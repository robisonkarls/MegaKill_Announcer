-- MegaKill Pack: NBA Announcer
-- Milestone pack using NBA Jam announcer sounds.
-- Install alongside MegaKill_Announcer in your AddOns folder.

MegaKill_RegisterPack("NBA_Announcer", {
	type      = "milestone",
	label     = "|cffee6730NBA Announcer|r",
	author    = "Robison Karls Custodio",
	addonName = "MegaKill_Pack_NBA",
	soundsPath = "sound",

	files = {
		[1] = {
			{ label = "|cffee6730First Blood!|r",      sound = "announcer_1stblood_01.mp3"    },
		},
		[2] = {
			{ label = "|cffee6730Heating Up!|r",       sound = "announcer_kill_double_01.mp3" },
		},
		[3] = {
			{ label = "|cffee6730He's on Fire!|r",     sound = "announcer_kill_triple_01.mp3" },
		},
		[4] = {
			{ label = "|cffee6730Monsterjam!|r",       sound = "announcer_kill_mega_01.mp3"   },
		},
		[5] = {
			{ label = "|cffee6730Monsterjam!|r",       sound = "announcer_kill_mega_01.mp3"   },
			{ label = "|cffee6730Too Big!|r",          sound = "announcer_ownage_01.mp3"       },
		},
		[6] = {
			{ label = "|cffee6730Spectacular Dunk!|r", sound = "announcer_kill_dominate_01.mp3" },
		},
		[7] = {
			{ label = "|cffee6730Knock Knock!|r",      sound = "announcer_kill_ultra_01.mp3"  },
		},
		[8] = {
			{ label = "|cffee6730Boom-shaka-laka!|r",  sound = "announcer_kill_holy_01.mp3"   },
			{ label = "|cffee6730Too Big!|r",          sound = "announcer_ownage_01.mp3"       },
		},
		[9] = {
			{ label = "|cffee6730Boom-shaka-laka!|r",  sound = "announcer_kill_holy_01.mp3"   },
			{ label = "|cffee6730Too Big!|r",          sound = "announcer_ownage_01.mp3"       },
		},
	},

	sprees = {
		[5]  = { label = "|cffee6730Jams it In!|r",          sounds = { { label = "|cffee6730Jams it In!|r",          sound = "announcer_kill_spree_01.mp3"   } } },
		[10] = { label = "|cffee6730Retirement!|r",          sounds = { { label = "|cffee6730Retirement!|r",          sound = "announcer_kill_rampage_01.mp3" } } },
		[15] = { label = "|cffee6730From Downtown!|r",       sounds = { { label = "|cffee6730From Downtown!|r",       sound = "announcer_kill_unstop_01.mp3"  } } },
		[25] = { label = "|cffee6730Is it the Shoes?|r",     sounds = { { label = "|cffee6730Is it the Shoes?|r",     sound = "announcer_kill_godlike_01.mp3" } } },
		[30] = { label = "|cffee6730Serves up the Facial!|r",sounds = { { label = "|cffee6730Serves up the Facial!|r",sound = "announcer_kill_wicked_01.mp3"  } } },
	},
})
