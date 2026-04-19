-- MegaKill Announcer - Core (shared logic)
-- Event registration is handled by Events_Retail.lua or Events_Classic.lua.
-- Sound packs register themselves via MegaKill_RegisterPack() after this file loads.

local PREFIX   = "|cffff7d0aMegaKill|r"
local WOW_FONT = "Fonts\\FRIZQT__.TTF"

-- ── Shared namespace ──────────────────────────────────────────────────────────
MegaKill = {}

-- ── Default settings ──────────────────────────────────────────────────────────
local DEFAULTS = {
	enabled        = true,
	screenAnnounce = true,
	soundPack      = "Unreal_Theme",
	killWindow     = 15,
	onlyPvP        = false,
	spreeAnnounce  = true,
	streakBar      = true,
	fontSize       = 32,
}

-- ── State ─────────────────────────────────────────────────────────────────────
local db
local multiKillCount  = 0
local multiKillTimer  = nil
local spreeCount      = 0
local announceFrame, announceText, hideTimer

-- ── Pack registry ─────────────────────────────────────────────────────────────
-- Packs register themselves by calling MegaKill_RegisterPack().
-- Built-in packs live in Packs/. Community packs are separate addons.
local registry = {}

function MegaKill_RegisterPack(key, definition)
	registry[key] = definition
end

local function GetPack()
	return db and registry[db.soundPack]
end

local function PackIsMilestone()
	local pack = GetPack()
	return pack and pack.type == "milestone"
end

-- ── Public API ────────────────────────────────────────────────────────────────
function MegaKill_PackIsMilestone() return PackIsMilestone() end
function MegaKill_GetRegistry()     return registry end

function MegaKill_SetFontSize(size)
	if not announceText then return end
	announceText:SetFont(WOW_FONT, size, "OUTLINE")
	announceFrame:SetHeight(size * 2.5)
end

-- ── Sound selection ───────────────────────────────────────────────────────────
-- Returns soundPath, label for the given key.
-- key is a kill count (number) or a spree name (string).
local function PickSound(pack, slot)
	if not slot or #slot == 0 then return nil, nil end
	local entry = slot[math.random(#slot)]
	local path = "Interface/AddOns/" .. pack.addonName .. "/" .. pack.soundsPath .. "/" .. entry.sound
	return path, entry.label
end

local function GetSound(key)
	local pack = GetPack()
	if not pack then return nil, nil end

	if pack.type == "milestone" then
		return PickSound(pack, pack.files[key])
	elseif pack.type == "random" then
		if type(key) == "string" then return nil, nil end
		return PickSound(pack, pack.files)
	end

	return nil, nil
end

function MegaKill_GetSound(key) return GetSound(key) end

-- ── Announce frame ────────────────────────────────────────────────────────────
local function ShowAnnounce(label)
	if not db or not db.screenAnnounce then return end
	if not announceFrame or not label or label == "" then return end

	announceText:SetText(label)
	announceText:SetTextColor(1, 1, 1)

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

function MegaKill_ShowAnnounce(label) ShowAnnounce(label) end

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

	if MegaKill_StreakBar_Start and db.streakBar and PackIsMilestone() then
		MegaKill_StreakBar_Start(multiKillCount, db.killWindow)
	end

	local soundPath, label = GetSound(multiKillCount)
	if soundPath then PlaySoundFile(soundPath, "Master") end
	ShowAnnounce(label)

	if isPlayer and db.spreeAnnounce and PackIsMilestone() then
		spreeCount = spreeCount + 1
		local pack = GetPack()
		local spreeSlot = pack and pack.sprees and pack.sprees[spreeCount]
		if spreeSlot then
			local spreePath, spreeLabel = PickSound(pack, spreeSlot.sounds)
			C_Timer.After(soundPath and 1.6 or 0, function()
				if spreePath then PlaySoundFile(spreePath, "Master") end
				ShowAnnounce(spreeLabel)
			end)
		end
	end
end

-- ── Namespace: called by Events_Retail / Events_Classic ──────────────────────
function MegaKill.OnKill(isPlayer) OnKill(isPlayer) end
function MegaKill.GetDB()          return db end

function MegaKill.OnPlayerDead()
	if spreeCount >= 5 then
		print(PREFIX .. " Your killing spree of " .. spreeCount .. " has ended!")
	end
	spreeCount = 0
	ResetMultiKill()
end

function MegaKill.OnPlayerAlive()
	ResetMultiKill()
end

-- ── Bootstrap ─────────────────────────────────────────────────────────────────
local function BuildAnnounceFrame()
	announceFrame = CreateFrame("Frame", nil, UIParent)
	announceFrame:SetSize(500, db.fontSize * 2.5)
	announceFrame:SetPoint("CENTER", UIParent, "CENTER", 0, 120)
	announceFrame:SetFrameStrata("HIGH")
	announceFrame:Hide()
	announceText = announceFrame:CreateFontString(nil, "OVERLAY")
	announceText:SetAllPoints()
	announceText:SetJustifyH("CENTER")
	announceText:SetJustifyV("MIDDLE")
	announceText:SetShadowOffset(2, -2)
	announceText:SetShadowColor(0, 0, 0, 1)
	announceText:SetFont(WOW_FONT, db.fontSize, "OUTLINE")
end

local MK_CoreFrame = CreateFrame("Frame")
MK_CoreFrame:RegisterEvent("PLAYER_LOGIN")
MK_CoreFrame:SetScript("OnEvent", function(_, ev)
	if ev == "PLAYER_LOGIN" then
		MegaKill_Config = MegaKill_Config or {}
		for k, v in pairs(DEFAULTS) do
			if MegaKill_Config[k] == nil then MegaKill_Config[k] = v end
		end
		db = MegaKill_Config
		BuildAnnounceFrame()
		print(PREFIX .. " |cffffd700v1.2.0|r loaded — type |cffffd700/mk help|r for commands.")
	end
end)

function MegaKill_OnPlayerLogin() end  -- XML compat, no-op

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
			local soundPath, label = GetSound(idx)
			if soundPath then PlaySoundFile(soundPath, "Master") end
			ShowAnnounce(label)
		else
			print(PREFIX .. ": Use /mk test 2, 3, or 4")
		end

	elseif msg == "config" then
		if MegaKill_OpenConfig then MegaKill_OpenConfig()
		else print(PREFIX .. ": Config UI not loaded yet.") end

	elseif msg == "status" then
		local pack = GetPack()
		print(PREFIX .. " |cffffd700Status:|r")
		print("  Enabled:     " .. (db.enabled and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Screen:      " .. (db.screenAnnounce and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  PvP-only:    " .. (db.onlyPvP and "|cff00ff00Yes|r" or "|cffff0000No|r"))
		print("  Kill window: |cffffd700" .. db.killWindow .. "s|r")
		print("  Sound pack:  |cffffd700" .. (pack and pack.label or db.soundPack) .. "|r")
		print("  Pack type:   |cffffd700" .. (PackIsMilestone() and "milestone" or "random") .. "|r")

	else
		print(PREFIX .. " |cffffd700Commands:|r")
		print("  /mk            — Toggle on/off")
		print("  /mk config     — Open settings UI")
		print("  /mk screen     — Toggle screen text")
		print("  /mk pvp        — Toggle PvP-only mode")
		print("  /mk window X   — Set multi-kill window (5–60s)")
		print("  /mk test 2/3/4 — Preview announcements")
		print("  /mk status     — Show current settings")
	end
end
