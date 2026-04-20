-- MegaKill Announcer - Built-in Pack: Heroes of Newerth Flamboyant
-- Random pack: one sound picked at random from the full pool on every kill.
-- Labels use WoW color escape codes for per-character rainbow text.

MegaKill_RegisterPack("Flamboyant_theme", {
	type      = "random",
	label     = "Heroes of Newerth - Flamboyant",
	author    = "S2 Games (sounds used under fair use for personal addon)",
	addonName = "MegaKill_Announcer",
	soundsPath = "assets/Flamboyant_theme",

	-- Flat pool: one entry picked at random per kill.
	-- Labels are pre-rendered rainbow text via WoW color escape codes.
	files = {
		{ label = "|cffff0000C|r|cffff7f00h|r|cffffff00e|r|cff00ff00r|r|cff0000ffr|r|cff8b00ffy|r |cffff0000P|r|cffff7f00o|r|cffffff00p|r|cff00ff00p|r|cff0000ffa|r|cff8b00ffh|r|cffff0000!|r", sound = "CHERRY_POPPAH.wav" },
		{ label = "|cffff0000G|r|cffff7f00o|r|cffffff00t|r|cff00ff00c|r|cff0000ffh|r|cff8b00ffa|r|cffff0000!|r", sound = "Gotcha.wav" },
		{ label = "|cffff0000U|r|cffff7f00u|r|cffffff00u|r|cff00ff00u|r|cff0000ffu|r|cff8b00ffh|r|cffff0000h|r|cffff7f00.|r|cffffff00.|r|cff00ff00.|r", sound = "Uuuuuhh.wav" },
		{ label = "|cffff0000D|r|cffff7f00e|r|cffffff00a|r|cff00ff00d|r|cff0000ff!|r", sound = "Dead.wav" },
		{ label = "|cffff0000I|r|cffff7f00t|r|cffffff00'|r|cff00ff00s|r |cff0000ffa|r |cff8b00ffT|r|cffff0000h|r|cffff7f00r|r|cffffff00e|r|cff00ff00e|r|cff0000ff-|r|cff8b00ffW|r|cffff0000a|r|cffff7f00y|r|cffffff00!|r", sound = "Its_a_three_wayy.wav" },
		{ label = "|cffff0000B|r|cffff7f00i|r|cffffff00t|r|cff00ff00c|r|cff0000ffh|r |cff8b00ffS|r|cffff0000l|r|cffff7f00a|r|cffffff00p|r|cff00ff00p|r|cff0000ffe|r|cff8b00ffd|r|cffff0000!|r", sound = "Bitch_Slapped.wav" },
		{ label = "|cffff0000H|r|cffff7f00o|r|cffffff00o|r |cff00ff00H|r|cff0000ffu|r |cff8b00ffH|r|cffff0000u|r|cffff7f00u|r|cffffff00u|r|cff00ff00!|r", sound = "Hoo_hu_huuu.wav" },
		{ label = "|cffff0000U|r|cffff7f00u|r|cffffff00u|r|cff00ff00u|r|cff0000ffu|r |cff8b00ffS|r|cffff0000c|r|cffff7f00a|r|cffffff00r|r|cff00ff00y|r|cff0000ff!|r", sound = "Uuuuu_Scary.wav" },
		{ label = "|cffff0000F|r|cffff7f00a|r|cffffff00b|r|cff00ff00u|r|cff0000ffl|r|cff8b00ffo|r|cffff0000u|r|cffff7f00s|r|cffffff00!|r", sound = "Fabulous.wav" },
		{ label = "|cffff0000H|r|cffff7f00o|r|cffffff00m|r|cff00ff00e|r |cff0000ffW|r|cff8b00ffr|r|cffff0000e|r|cffff7f00c|r|cffffff00k|r|cff00ff00e|r|cff0000ffr|r|cff8b00ff!|r", sound = "Home_Wracker.wav" },
		{ label = "|cffff0000H|r|cffff7f00o|r|cffffff00o|r|cff00ff00o|r|cff0000ffo|r |cff8b00ffN|r|cffff0000o|r|cffff7f00o|r|cffffff00o|r|cff00ff00o|r|cff0000ff!|r", sound = "Hoooo_Noooo.wav" },
		{ label = "|cffff0000M|r|cffff7f00a|r|cffffff00c|r|cff00ff00h|r|cff0000ffo|r|cff8b00ff!|r", sound = "Machooowav.wav" },
		{ label = "|cffff0000S|r|cffff7f00u|r|cffffff00p|r|cff00ff00e|r|cff0000ffr|r |cff8b00ffS|r|cffff0000t|r|cffff7f00a|r|cffffff00r|r|cff00ff00!|r", sound = "Super_Star.wav" },
		{ label = "|cffff0000R|r|cffff7f00a|r|cffffff00i|r|cff00ff00n|r|cff0000ffb|r|cff8b00ffo|r|cffff0000w|r |cffff7f00W|r|cffffff00a|r|cff00ff00r|r|cff0000ffr|r|cff8b00ffi|r|cffff0000o|r|cffff7f00r|r|cffffff00!|r", sound = "rainbow_warrior.wav" },
		{ label = "|cffff0000C|r|cffff7f00a|r|cffffff00n|r|cff00ff00'|r|cff0000fft|r |cff8b00ffT|r|cffff0000o|r|cffff7f00u|r|cffffff00c|r|cff00ff00h|r |cff0000ffT|r|cff8b00ffh|r|cffff0000i|r|cffff7f00s|r|cffffff00!|r", sound = "CANT_TOUCH_THIS.wav" },
		{ label = "|cffff0000B|r|cffff7f00i|r|cffffff00g|r |cff00ff00B|r|cff0000ffe|r|cff8b00ffa|r|cffff0000r|r|cffff7f00!|r", sound = "big_bear.wav" },
		{ label = "|cffff0000U|r|cffff7f00n|r|cffffff00i|r|cff00ff00c|r|cff0000ffo|r|cff8b00ffr|r|cffff0000n|r |cffff7f00S|r|cffffff00t|r|cff00ff00a|r|cff0000ffm|r|cff8b00ffp|r|cffff0000e|r|cffff7f00d|r|cffffff00e|r|cff00ff00!|r", sound = "Unicorn_Stampeeede.wav" },
		{ label = "|cffff0000H|r|cffff7f00o|r|cffffff00m|r|cff00ff00i|r|cff0000ffc|r|cff8b00ffi|r|cffff0000d|r|cffff7f00a|r|cffffff00l|r|cff00ff00!|r", sound = "Homecidal.wav" },
		{ label = "|cffff0000O|r|cffff7f00h|r |cffffff00M|r|cff00ff00y|r|cff0000ff!|r", sound = "Like_Oh_EME_Jay.wav" },
		{ label = "|cffff0000D|r|cffff7f00o|r|cffffff00m|r|cff00ff00i|r|cff0000ffn|r|cff8b00ffa|r|cffff0000t|r|cffff7f00i|r|cffffff00o|r|cff00ff00n|r|cff0000ff!|r", sound = "Domination.wav" },
		{ label = "|cffff0000D|r|cffff7f00i|r|cffffff00v|r|cff00ff00a|r|cff0000ff!|r", sound = "diva.wav" },
		{ label = "|cffff0000Y|r|cffff7f00a|r|cffffff00a|r|cff00ff00a|r|cff0000ffa|r|cff8b00ffy|r|cffff0000!|r", sound = "YaaaaaYyy.wav" },
	},
})
