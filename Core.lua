local PREFIX = "|cffff7d0aMegaKill|r"

-- Default settings
local DEFAULTS = {
	enabled        = true,
	screenAnnounce = true,
	chatAnnounce   = false,
	chatChannel    = "PARTY",
	sound          = true,
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
}

-- State
local db
local playerGUID
local multiKillCount = 0
local multiKillTimer = nil
local spreeCount     = 0
local PLAYER_TYPE_FLAG = 0x400  -- COMBATLOG_OBJECT_TYPE_PLAYER

-- ── Sound ─────────────────────────────────────────────────────────────────────

local function GetSound(key)
	if not db or not db.sound then return nil end
	local pack = SOUND_PACKS[db.soundPack]
	if not pack then return nil end
	local pool = pack[key]
	if not pool or #pool == 0 then return nil end
	local file = pool[math.random(#pool)]
	return "Interface\\AddOns\\MegaKill_Announcer\\assets\\" .. db.soundPack .. "\\" .. file
end

local function PlayMilestoneSound(key)
	local sound = GetSound(key)
	if sound then PlaySoundFile(sound, "Master") end
end

function MegaKill_PlayMilestoneSound(key)
	PlayMilestoneSound(key)
end

-- ── Announce frame (created in PLAYER_LOGIN) ──────────────────────────────────

local announceFrame
local announceText
local hideTimer

local function InitAnnounceFrame()
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
end

local function ShowAnnounce(text, r, g, b)
	if not db or not db.screenAnnounce then return end
	if not announceFrame then return end

	announceText:SetText(text)
	announceText:SetTextColor(r, g, b)

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

function MegaKill_ShowAnnounce(text, r, g, b)
	ShowAnnounce(text, r, g, b)
end

-- ── Chat queue ────────────────────────────────────────────────────────────────

local chatQueue = {}

local function InitChatFrame()
	local chatFrame = CreateFrame("Frame")
	chatFrame:RegisterEvent("PLAYER_REGEN_ENABLED")
	chatFrame:SetScript("OnEvent", function()
		while #chatQueue > 0 do
			local msg = table.remove(chatQueue, 1)
			SendChatMessage(msg.text, msg.channel)
		end
	end)
end

local function GetSafeChannel(requested)
	if requested == "BATTLEGROUND" then
		if not UnitInBattleground("player") then return nil end
	elseif requested == "INSTANCE_CHAT" then
		if not IsInGroup(LE_PARTY_CATEGORY_INSTANCE) then return nil end
	elseif requested == "RAID" then
		if not IsInRaid() then return nil end
	elseif requested == "PARTY" then
		if not IsInGroup() then return nil end
	end
	return requested
end

local function ChatAnnounce(text)
	if not db.chatAnnounce then return end
	local channel = GetSafeChannel(db.chatChannel)
	if not channel then return end
	table.insert(chatQueue, { text = "[MegaKill] " .. text, channel = channel })
end

-- ── Kill logic ────────────────────────────────────────────────────────────────

local function ResetMultiKill()
	multiKillCount = 0
	multiKillTimer = nil
	if MegaKill_StreakBar_Reset then MegaKill_StreakBar_Reset() end
end

local function OnKill(isPlayer)
	if not db.enabled then return end
	if db.onlyPvP and not isPlayer then return end

	if multiKillTimer then multiKillTimer:Cancel() end
	multiKillCount = multiKillCount + 1
	multiKillTimer = C_Timer.NewTimer(db.killWindow, ResetMultiKill)

	if MegaKill_StreakBar_Start and db.streakBar then
		MegaKill_StreakBar_Start(multiKillCount, db.killWindow)
	end

	local mk = MULTI_KILL[multiKillCount]
	if mk then
		ShowAnnounce(mk.text, mk.r, mk.g, mk.b)
		ChatAnnounce(mk.text)
		PlayMilestoneSound(multiKillCount)
	end

	if isPlayer and db.spreeAnnounce then
		spreeCount = spreeCount + 1
		local spree = KILLING_SPREE[spreeCount]
		if spree then
			C_Timer.After(mk and 1.6 or 0, function()
				ShowAnnounce(spree.text, spree.r, spree.g, spree.b)
			end)
			ChatAnnounce(spree.text)
			PlayMilestoneSound(spree.sound)
		end
	end
end

-- ── Main event frame ──────────────────────────────────────────────────────────

-- All frames and RegisterEvent calls are deferred to ADDON_LOADED
-- to avoid taint on Retail 12.0+

local initFrame = CreateFrame("Frame")
initFrame:RegisterEvent("ADDON_LOADED")

initFrame:SetScript("OnEvent", function(self, event, addonName)
	if addonName ~= "MegaKill_Announcer" then return end
	self:UnregisterEvent("ADDON_LOADED")

	-- Init frames now that addon environment is fully loaded
	InitAnnounceFrame()
	InitChatFrame()

	-- Detect correct combat log event for this WoW version
	local combatLogEvent = "COMBAT_LOG_EVENT_UNFILTERED"
	if WOW_PROJECT_ID == WOW_PROJECT_MAINLINE and select(4, GetBuildInfo()) >= 120000 then
		combatLogEvent = "COMBAT_LOG_EVENT"
	end

	local frame = CreateFrame("Frame")
	frame:RegisterEvent("PLAYER_LOGIN")
	frame:RegisterEvent("PLAYER_DEAD")
	frame:RegisterEvent("PLAYER_ALIVE")
	frame:RegisterEvent(combatLogEvent)

	frame:SetScript("OnEvent", function(_, ev)
		if ev == "PLAYER_LOGIN" then
			playerGUID = UnitGUID("player")

			MegaKill_Config = MegaKill_Config or {}
			for k, v in pairs(DEFAULTS) do
				if MegaKill_Config[k] == nil then
					MegaKill_Config[k] = v
				end
			end
			db = MegaKill_Config

			print(PREFIX .. " |cffffd700v1.0.4|r loaded — type |cffffd700/mk help|r for commands.")

		elseif ev == "PLAYER_DEAD" then
			if spreeCount >= 5 then
				local endMsg = "Your killing spree of " .. spreeCount .. " has ended!"
				print(PREFIX .. " " .. endMsg)
				ChatAnnounce(endMsg)
			end
			spreeCount = 0
			ResetMultiKill()

		elseif ev == "PLAYER_ALIVE" then
			ResetMultiKill()

		elseif ev == "COMBAT_LOG_EVENT_UNFILTERED" or ev == "COMBAT_LOG_EVENT" then
			if not playerGUID then return end
			local _, subEvent, _, sourceGUID, _, _, _, _, _, destFlags = CombatLogGetCurrentEventInfo()
			if sourceGUID == playerGUID then
				local isPlayer = bit.band(destFlags, PLAYER_TYPE_FLAG) ~= 0
				if subEvent == "PARTY_KILL" or subEvent == "UNIT_DIED" then
					OnKill(isPlayer)
				end
			end
		end
	end)
end)

-- ── Slash commands ────────────────────────────────────────────────────────────

SLASH_MEGAKILL1 = "/megakill"
SLASH_MEGAKILL2 = "/mk"
SlashCmdList["MEGAKILL"] = function(msg)
	msg = strtrim(msg):lower()

	if msg == "" or msg == "toggle" then
		db.enabled = not db.enabled
		print(PREFIX .. ": " .. (db.enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"))

	elseif msg == "screen" then
		db.screenAnnounce = not db.screenAnnounce
		print(PREFIX .. ": Screen announce " .. (db.screenAnnounce and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

	elseif msg == "chat" then
		db.chatAnnounce = not db.chatAnnounce
		print(PREFIX .. ": Chat announce " .. (db.chatAnnounce and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

	elseif msg == "sound" then
		db.sound = not db.sound
		print(PREFIX .. ": Sound " .. (db.sound and "|cff00ff00ON|r" or "|cffff0000OFF|r"))

	elseif msg == "pvp" then
		db.onlyPvP = not db.onlyPvP
		print(PREFIX .. ": PvP-only " .. (db.onlyPvP and "|cff00ff00ON|r (HKs only)" or "|cffff0000OFF|r (all kills)"))

	elseif msg:match("^channel %a+$") then
		local ch = msg:match("^channel (%a+)$"):upper()
		if ch == "SAY" or ch == "YELL" or ch == "PARTY" or ch == "RAID" or ch == "BATTLEGROUND" then
			db.chatChannel = ch
			print(PREFIX .. ": Chat channel set to |cffffd700" .. ch .. "|r")
		else
			print(PREFIX .. ": Valid channels: SAY, YELL, PARTY, RAID, BATTLEGROUND")
		end

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
			print(PREFIX .. ": Use /mk test 2 (Double Kill), /mk test 3 (Triple Kill), /mk test 4 (Monster Kill)")
		end

	elseif msg == "config" then
		if MegaKill_OpenConfig then
			MegaKill_OpenConfig()
		else
			print(PREFIX .. ": Config UI not loaded yet, try again.")
		end

	elseif msg == "status" then
		print(PREFIX .. " |cffffd700Status:|r")
		print("  Enabled:     " .. (db.enabled and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Screen:      " .. (db.screenAnnounce and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Chat:        " .. (db.chatAnnounce and "|cff00ff00Yes|r" or "|cffff0000No|r") .. " [" .. db.chatChannel .. "]")
		print("  Sound:       " .. (db.sound and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  PvP-only:    " .. (db.onlyPvP and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Kill window: |cffffd700" .. db.killWindow .. "s|r")

	else
		print(PREFIX .. " |cffffd700Commands:|r")
		print("  /mk            — Toggle on/off")
		print("  /mk config     — Open settings UI")
		print("  /mk screen     — Toggle screen text")
		print("  /mk chat       — Toggle chat announcements")
		print("  /mk sound      — Toggle sounds")
		print("  /mk pvp        — Toggle PvP-only mode (HKs only)")
		print("  /mk channel X  — Set chat channel (SAY/YELL/PARTY/RAID/BATTLEGROUND)")
		print("  /mk window X   — Set multi-kill window in seconds (5-60)")
		print("  /mk test 2     — Preview Double Kill")
		print("  /mk test 3     — Preview Triple Kill")
		print("  /mk test 4     — Preview Monster Kill")
		print("  /mk status     — Show current settings")
	end
end
