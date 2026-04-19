-- MegaKill Announcer - Built-in Pack: Heroes of Newerth Flamboyant
-- Random pack: one sound picked at random from the full pool on every kill.
-- Labels support WoW color escape codes — authors can style them freely.

MegaKill_RegisterPack("Flamboyant_theme", {
	type      = "random",
	label     = "Heroes of Newerth - Flamboyant",
	author    = "S2 Games (sounds used under fair use for personal addon)",
	addonName = "MegaKill_Announcer",
	soundsPath = "assets\\Flamboyant_theme",

	-- Flat pool: one entry picked at random per kill.
	-- Label is shown on-screen. Supports WoW color escape codes.
	files = {
		{ label = "Cherry Poppah!",    sound = "CHERRY_POPPAH.wav"       },
		{ label = "Gotcha!",           sound = "Gotcha.wav"              },
		{ label = "Uuuuuhh...",        sound = "Uuuuuhh.wav"             },
		{ label = "Dead!",             sound = "Dead.wav"                },
		{ label = "It's a Three-Way!", sound = "Its_a_three_wayy.wav"    },
		{ label = "Bitch Slapped!",    sound = "Bitch_Slapped.wav"       },
		{ label = "Hoo Hu Huuu!",      sound = "Hoo_hu_huuu.wav"         },
		{ label = "Uuuuu Scary!",      sound = "Uuuuu_Scary.wav"         },
		{ label = "Fabulous!",         sound = "Fabulous.wav"            },
		{ label = "Home Wrecker!",     sound = "Home_Wracker.wav"        },
		{ label = "Hoooo Noooo!",      sound = "Hoooo_Noooo.wav"         },
		{ label = "Macho!",            sound = "Machooowav.wav"          },
		{ label = "Super Star!",       sound = "Super_Star.wav"          },
		{ label = "Rainbow Warrior!",  sound = "rainbow_warrior.wav"     },
		{ label = "Can't Touch This!", sound = "CANT_TOUCH_THIS.wav"     },
		{ label = "Big Bear!",         sound = "big_bear.wav"            },
		{ label = "Unicorn Stampede!", sound = "Unicorn_Stampeeede.wav"  },
		{ label = "Homicidal!",        sound = "Homecidal.wav"           },
		{ label = "Oh My!",            sound = "Like_Oh_EME_Jay.wav"     },
		{ label = "Domination!",       sound = "Domination.wav"          },
		{ label = "Diva!",             sound = "diva.wav"                },
		{ label = "Yaaaay!",           sound = "YaaaaaYyy.wav"           },
	},
})
