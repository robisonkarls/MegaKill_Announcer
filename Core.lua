local PREFIX = "|cffff7d0aMegaKill|r"

-- ── Top-level event frame (created before any function runs) ─────────────────
-- Must be at file scope so RegisterEvent runs in a clean execution context,
-- not inside a callback. This is how DBM and other major addons do it.
local MK_Frame = CreateFrame("Frame")
MK_Frame:RegisterEvent("PLAYER_LOGIN")
MK_Frame:RegisterEvent("PLAYER_DEAD")
MK_Frame:RegisterEvent("PLAYER_ALIVE")
-- Version check at file scope (before any callback)
local IS_RETAIL_PRECHECK = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
if IS_RETAIL_PRECHECK then
	MK_Frame:RegisterEvent("UNIT_DIED")                   -- Retail 12.0+: replaces CLEU
else
	MK_Frame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED") -- Classic only
end

-- Default settings
local DEFAULTS = {
	enabled        = true,
	screenAnnounce = true,
	soundPack      = "Unreal_Theme",
	killWindow     = 15,
	onlyPvP        = false,
	spreeAnnounce  = true,
	streakBar      = true,
}

-- Multi-kill milestones
local MULTI_KILL = {
	[1] = { text = "First Blood!",    r = 1.0, g = 1.0, b = 1.0 },
	[2] = { text = "Double Kill!",    r = 1.0, g = 1.0, b = 0.0 },
	[3] = { text = "Triple Kill!",    r = 1.0, g = 0.5, b = 0.0 },
	[4] = { text = "Quadra Kill!",    r = 1.0, g = 0.2, b = 0.0 },
	[5] = { text = "Mega Kill!",      r = 1.0, g = 0.0, b = 0.0 },
	[6] = { text = "Monster Kill!",   r = 0.6, g = 0.0, b = 1.0 },
	[7] = { text = "Ultra Kill!",     r = 0.0, g = 0.8, b = 1.0 },
	[8] = { text = "Ludicrous Kill!", r = 0.0, g = 1.0, b = 0.0 },
	[9] = { text = "Holy Sh*t!!",     r = 1.0, g = 0.0, b = 1.0 },
}

-- Killing spree milestones
local KILLING_SPREE = {
	[5]  = { text = "Killing Spree!", r = 1.0, g = 1.0, b = 0.0, sound = "Killing_Spree" },
	[10] = { text = "Rampage!",       r = 1.0, g = 0.5, b = 0.0, sound = "Rampage"       },
	[15] = { text = "Unstoppable!",   r = 1.0, g = 0.2, b = 0.0, sound = "Unstoppable"   },
	[20] = { text = "Dominating!",    r = 0.6, g = 0.0, b = 1.0, sound = "Dominating"    },
	[25] = { text = "Godlike!",       r = 0.0, g = 0.8, b = 1.0, sound = "Godlike"       },
	[30] = { text = "Wicked Sick!",   r = 0.0, g = 1.0, b = 0.0, sound = "Wicked_Sick"   },
}

-- Sound packs
local SOUND_PACKS = {
	Unreal_Theme = {
		[1]  = { "first_blood.wav" },
		[2]  = { "double_kill.wav" },
		[3]  = { "triple_kill.wav" },
		[4]  = { "mega_kill.wav" },
		[5]  = { "mega_kill.wav" },
		[6]  = { "monster_kill.wav" },
		[7]  = { "ultra_kill.wav" },
		[8]  = { "ludicrous_kill.wav", "ownage.wav" },
		[9]  = { "holy_shit.wav", "ownage.wav" },
		Killing_Spree = { "killing_spree.wav" },
		Rampage       = { "rampage.wav" },
		Unstoppable   = { "unstoppable.wav" },
		Dominating    = { "dominating.wav" },
		Godlike       = { "godlike.wav" },
		Wicked_Sick   = { "wicked_sick.wav" },
	},
	Flamboyant_theme = {
		-- Use filename as announce text, render in rainbow colors
		displayName = true,
		rainbow     = true,
		-- Simple 5-slot mode: kill count capped at 5, no spree tracking
		simpleSlots = true,
		[1] = { "CHERRY_POPPAH.wav", "Gotcha.wav", "Uuuuuhh.wav", "Dead.wav" },
		[2] = { "Its_a_three_wayy.wav", "Bitch_Slapped.wav", "Hoo_hu_huuu.wav", "Uuuuu_Scary.wav" },
		[3] = { "Fabulous.wav", "Home_Wracker.wav", "Hoooo_Noooo.wav", "Machooowav.wav" },
		[4] = { "Super_Star.wav", "rainbow_warrior.wav", "CANT_TOUCH_THIS.wav", "big_bear.wav" },
		[5] = { "Unicorn_Stampeeede.wav", "Homecidal.wav", "Like_Oh_EME_Jay.wav", "Domination.wav", "diva.wav", "YaaaaaYyy.wav" },
	},
}

-- State
local db
local playerGUID
local multiKillCount = 0
local multiKillTimer = nil
local spreeCount     = 0
local IS_RETAIL      = false
local PLAYER_TYPE_FLAG = 0x400

-- Text helpers

-- "CHERRY_POPPAH.wav" -> "Cherry Poppah"
local function FileToDisplayName(filename)
	local name = filename:match("^(.+)%..+$") or filename
	name = name:gsub("_", " ")
	name = name:gsub("(%a)([%w_']*)", function(first, rest)
		return first:upper() .. rest:lower()
	end)
	return name
end

-- Wrap each character in a cycling rainbow color
local RAINBOW = {
	"|cffff0000", "|cffff7f00", "|cffffff00",
	"|cff00ff00", "|cff0000ff", "|cff8b00ff",
}
local function RainbowText(text)
	local out = ""
	local ci = 1
	for char in text:gmatch(".") do
		if char == " " then
			out = out .. " "
		else
			out = out .. RAINBOW[ci] .. char .. "|r"
			ci = ci % #RAINBOW + 1
		end
	end
	return out
end

-- ── Sound ─────────────────────────────────────────────────────────────────────

local function GetSound(key)
	if not db then return nil, nil end
	local pack = SOUND_PACKS[db.soundPack]
	if not pack then return nil, nil end
	-- simpleSlots: cap numeric keys at 5, ignore spree string keys
	if pack.simpleSlots and type(key) == "number" then
		key = math.min(key, 5)
	elseif pack.simpleSlots and type(key) == "string" then
		return nil, nil  -- no spree slots in simple mode
	end
	local pool = pack[key]
	if not pool or #pool == 0 then return nil, nil end
	local file = pool[math.random(#pool)]
	return "Interface\\AddOns\\MegaKill_Announcer\\assets\\" .. db.soundPack .. "\\" .. file, file
end

local function PlayMilestoneSound(key)
	local sound = GetSound(key)
	if sound then PlaySoundFile(sound, "Master") end
end

function MegaKill_PlayMilestoneSound(key)
	PlayMilestoneSound(key)
end

-- Returns both the sound path and filename for a given key (single roll)
function MegaKill_GetSound(key)
	return GetSound(key)
end

-- Returns the selected file for a given key (for Config preview)
function MegaKill_GetSoundFile(key)
	local _, file = GetSound(key)
	return file
end

-- ── Announce frame ────────────────────────────────────────────────────────────

local announceFrame, announceText, hideTimer

-- packFlags: optional table with displayName/rainbow overrides from the sound pack
local function ShowAnnounce(text, r, g, b, soundFile)
	if not db or not db.screenAnnounce then return end
	if not announceFrame then return end
	local pack = SOUND_PACKS[db.soundPack]
	local displayText = text
	if pack and pack.displayName and soundFile then
		displayText = FileToDisplayName(soundFile)
	end
	if pack and pack.rainbow then
		announceText:SetText(RainbowText(displayText))
		announceText:SetTextColor(1, 1, 1)
	else
		announceText:SetText(displayText)
		announceText:SetTextColor(r, g, b)
	end
	if hideTimer then hideTimer:Cancel() hideTimer = nil end
	announceFrame:SetAlpha(1)
	announceFrame:Show()
	UIFrameFadeIn(announceFrame, 0.2)
	hideTimer = C_Timer.NewTimer(2.5, function()
		UIFrameFadeOut(announceFrame, 0.5)
		hideTimer = C_Timer.NewTimer(0.5, function()
			announceFrame:Hide()
			hideTimer = nil
		end)
	end)
end

function MegaKill_ShowAnnounce(text, r, g, b, soundFile)
	ShowAnnounce(text, r, g, b, soundFile)
end

-- ── Chat queue (Classic only) ─────────────────────────────────────────────────

	if not IsChannelAvailable(ch) then return end
end

-- ── Kill logic ────────────────────────────────────────────────────────────────

local function ResetMultiKill()
	multiKillCount = 0
	multiKillTimer = nil
	if MegaKill_StreakBar_Reset then MegaKill_StreakBar_Reset() end
end

local function OnKill(isPlayer)
	if not db or not db.enabled then return end
	if db.onlyPvP and not isPlayer then return end

	if multiKillTimer then multiKillTimer:Cancel() end
	multiKillCount = multiKillCount + 1
	multiKillTimer = C_Timer.NewTimer(db.killWindow, ResetMultiKill)

	if MegaKill_StreakBar_Start and db.streakBar then
		MegaKill_StreakBar_Start(multiKillCount, db.killWindow)
	end

	local mk = MULTI_KILL[multiKillCount]
	if mk then
		local sound, file = GetSound(multiKillCount)
		if sound then PlaySoundFile(sound, "Master") end
		ShowAnnounce(mk.text, mk.r, mk.g, mk.b, file)
	end

	if isPlayer and db.spreeAnnounce then
		spreeCount = spreeCount + 1
		local spree = KILLING_SPREE[spreeCount]
		if spree then
			local spreeSound, spreeFile = GetSound(spree.sound)
			C_Timer.After(mk and 1.6 or 0, function()
				if spreeSound then PlaySoundFile(spreeSound, "Master") end
				ShowAnnounce(spree.text, spree.r, spree.g, spree.b, spreeFile)
			end)
		end
	end
end

-- ── Bootstrap ───────────────────────────────────────────────────────────────

MK_Frame:SetScript("OnEvent", function(_, ev, ...)
	if ev == "PLAYER_LOGIN" then
		IS_RETAIL = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)
		playerGUID = UnitGUID("player")
		MegaKill_Config = MegaKill_Config or {}
		for k, v in pairs(DEFAULTS) do
			if MegaKill_Config[k] == nil then MegaKill_Config[k] = v end
		end
		db = MegaKill_Config

		-- Build announce frame
		announceFrame = CreateFrame("Frame", nil, UIParent)
		announceFrame:SetSize(500, 80)
		announceFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
		announceFrame:SetFrameStrata("HIGH")
		announceFrame:Hide()
		announceText = announceFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalHuge")
		announceText:SetAllPoints()
		announceText:SetJustifyH("CENTER")
		announceText:SetJustifyV("MIDDLE")
		announceText:SetShadowOffset(2, -2)
		announceText:SetShadowColor(0, 0, 0, 1)

		print(PREFIX .. " |cffffd700v1.0.7|r loaded — type |cffffd700/mk help|r for commands.")

	elseif ev == "PLAYER_DEAD" then
		if spreeCount >= 5 then
			local endMsg = "Your killing spree of " .. spreeCount .. " has ended!"
			print(PREFIX .. " " .. endMsg)
		end
		spreeCount = 0
		ResetMultiKill()

	elseif ev == "PLAYER_ALIVE" then
		ResetMultiKill()

			end
		end

	elseif ev == "UNIT_DIED" then
		-- Retail 12.0+: UNIT_DIED fires when a unit dies near the player.
		-- unitGUID is a SecretValue when unit identity is restricted, but
		-- UnitIsEnemy/UnitIsPlayer work on the unit token which is not secret.
		if not db or not db.enabled then return end
		local unitGUID = ...
		if not unitGUID then return end
		-- We can check if the player was the responsible killer via the kill credit
		-- unitGUID is the dead unit; check hostility via UnitReaction if token available
		-- Since destGUID is a secret value we use a simpler heuristic:
		-- fire OnKill for any nearby enemy death while we're not dead
		if UnitIsDeadOrGhost("player") then return end
		local isPlayer = (C_PlayerInfo and C_PlayerInfo.IsPlayerFromGUID and C_PlayerInfo.IsPlayerFromGUID(unitGUID)) or false
		OnKill(isPlayer)

	elseif ev == "COMBAT_LOG_EVENT_UNFILTERED" then
		-- Classic only — ignored on Retail (CLEU is restricted there)
		if IS_RETAIL or not db then return end
		local _, subEvent, _, sourceGUID, _, _, _, _, _, destFlags = CombatLogGetCurrentEventInfo()
		if subEvent == "PARTY_KILL" and sourceGUID == playerGUID then
			local isPlayer = bit.band(destFlags, PLAYER_TYPE_FLAG) ~= 0
			OnKill(isPlayer)
		end
	end
end)

-- Bootstrap.xml is only used for the BootFrame name (no events registered there)
function MegaKill_OnPlayerLogin() end  -- kept for XML compat, no-op now

-- ── Slash commands ────────────────────────────────────────────────────────────

SLASH_MEGAKILL1 = "/megakill"
SLASH_MEGAKILL2 = "/mk"
SlashCmdList["MEGAKILL"] = function(msg)
	if not db then print(PREFIX .. ": Still loading...") return end
	msg = strtrim(msg):lower()

	if msg == "" or msg == "toggle" then
		db.enabled = not db.enabled
		print(PREFIX .. ": " .. (db.enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"))

	elseif msg == "screen" then
		db.screenAnnounce = not db.screenAnnounce
		print(PREFIX .. ": Screen announce " .. (db.screenAnnounce and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

	elseif msg == "sound" then
		db.sound = not db.sound
		print(PREFIX .. ": Sound " .. (db.sound and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

	elseif msg == "pvp" then
		db.onlyPvP = not db.onlyPvP
		print(PREFIX .. ": PvP-only " .. (db.onlyPvP and "|cff00ff00ON|r (HKs only)" or "|cffff0000OFF|r (all kills)"))

	elseif msg:match("^window %d+$") then
		local secs = tonumber(msg:match("^window (%d+)$"))
		if secs and secs >= 5 and secs <= 60 then
			db.killWindow = secs
			print(PREFIX .. ": Multi-kill window set to |cffffd700" .. secs .. "s|r")
		else
			print(PREFIX .. ": Window must be 5–60 seconds.")
		end

	elseif msg:match("^test %d+$") then
		local n = tonumber(msg:match("^test (%d+)$"))
		local testMap = { [2] = 2, [3] = 3, [4] = 6 }
		local idx = testMap[n]
		if idx then
			local mk = MULTI_KILL[idx]
			ShowAnnounce(mk.text, mk.r, mk.g, mk.b)
			PlayMilestoneSound(idx)
		else
			print(PREFIX .. ": Use /mk test 2, 3, or 4")
		end

	elseif msg == "config" then
		if MegaKill_OpenConfig then MegaKill_OpenConfig()
		else print(PREFIX .. ": Config UI not loaded yet.") end

	elseif msg == "status" then
		print(PREFIX .. " |cffffd700Status:|r")
		print("  Enabled:     " .. (db.enabled and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Screen:      " .. (db.screenAnnounce and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Sound:       " .. (db.sound and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  PvP-only:    " .. (db.onlyPvP and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Kill window: |cffffd700" .. db.killWindow .. "s|r")

	else
		print(PREFIX .. " |cffffd700Commands:|r")
		print("  /mk            — Toggle on/off")
		print("  /mk config     — Open settings UI")
		print("  /mk screen     — Toggle screen text")
		print("  /mk sound      — Toggle sounds")
		print("  /mk pvp        — Toggle PvP-only mode")
		print("  /mk window X   — Set multi-kill window (5-60s)")
		print("  /mk test 2/3/4 — Preview announcements")
		print("  /mk status     — Show current settings")
	end
end
