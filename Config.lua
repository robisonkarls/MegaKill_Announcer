-- MegaKill Announcer - Configuration UI

local ADDON_NAME = "MegaKill_Announcer"
local PREFIX = "|cffff7d0aMegaKill|r"

local configPanel = nil
local configCategory = nil -- Retail 10.0+

-- ── Open the config panel ─────────────────────────────────────────────────────

function MegaKill_OpenConfig()
	if configCategory then
		-- Retail 10.0+ (Settings API)
		Settings.OpenToCategory(configCategory:GetID())
	elseif InterfaceOptionsFrame_OpenToCategory then
		-- Classic / pre-10.0 Retail
		InterfaceOptionsFrame_OpenToCategory(configPanel)
		InterfaceOptionsFrame_OpenToCategory(configPanel) -- Double call fixes scroll bug
	end
end

-- ── Build the panel ───────────────────────────────────────────────────────────

local function CreateConfigPanel()
	local db = MegaKill_Config
	if not db then
		C_Timer.After(0.5, CreateConfigPanel)
		return
	end

	local panel = CreateFrame("Frame", ADDON_NAME .. "_ConfigPanel", UIParent)
	panel.name = "MegaKill Announcer"
	configPanel = panel

	-- ── Header ────────────────────────────────────────────────────────────────

	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("|cffff7d0a⚔ MegaKill Announcer|r")

	local subtitle = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	subtitle:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -4)
	subtitle:SetText("|cff888888PvP killstreak announcer — v1.0|r")

	local divider = panel:CreateTexture(nil, "ARTWORK")
	divider:SetHeight(1)
	divider:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -10)
	divider:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 0)
	divider:SetColorTexture(0.3, 0.3, 0.3, 1)

	-- ── Section header helper ─────────────────────────────────────────────────

	local yOffset = -85
	local function SectionHeader(text)
		local lbl = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		lbl:SetPoint("TOPLEFT", 16, yOffset)
		lbl:SetText("|cffffd700" .. text .. "|r")
		yOffset = yOffset - 24
		return lbl
	end

	-- ── Checkbox helper ───────────────────────────────────────────────────────

	local function CreateCheckbox(label, tooltip, getter, setter)
		local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
		check:SetPoint("TOPLEFT", 20, yOffset)
		check:SetSize(24, 24)

		local lbl = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		lbl:SetPoint("LEFT", check, "RIGHT", 4, 0)
		lbl:SetText(label)

		check.tooltipText = tooltip
		check:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
		check:SetScript("OnLeave", function() GameTooltip:Hide() end)
		check:SetScript("OnClick", function(self)
			setter(self:GetChecked())
		end)

		-- Refresh function
		check.Refresh = function() check:SetChecked(getter()) end

		yOffset = yOffset - 30
		return check
	end

	-- ── General section ───────────────────────────────────────────────────────

	SectionHeader("General")

	local enabledCheck = CreateCheckbox(
		"Enable Addon",
		"Turn MegaKill Announcer on or off.",
		function() return db.enabled end,
		function(val) db.enabled = val end
	)

	local pvpCheck = CreateCheckbox(
		"PvP Kills Only  (Honorable Kills)",
		"Only track player kills. Disabling this counts all kills including mobs.",
		function() return db.onlyPvP end,
		function(val) db.onlyPvP = val end
	)

	yOffset = yOffset - 8

	-- ── Announcements section ─────────────────────────────────────────────────

	SectionHeader("Announcements")

	local screenCheck = CreateCheckbox(
		"Show On-Screen Text",
		"Display large coloured text in the centre of your screen on each kill.",
		function() return db.screenAnnounce end,
		function(val) db.screenAnnounce = val end
	)

	local soundCheck = CreateCheckbox(
		"Play Sound Effects",
		"Play audio cues for Double Kill, Triple Kill, Monster Kill, etc.",
		function() return db.sound end,
		function(val) db.sound = val end
	)

	local spreeCheck = CreateCheckbox(
		"Announce Killing Sprees",
		"Announce milestone kill counts (Killing Spree, Rampage, Godlike…) without dying.",
		function() return db.spreeAnnounce end,
		function(val) db.spreeAnnounce = val end
	)

	local chatCheck = CreateCheckbox(
		"Broadcast to Chat",
		"Send kill announcements to a chat channel.",
		function() return db.chatAnnounce end,
		function(val) db.chatAnnounce = val end
	)

	local streakBarCheck = CreateCheckbox(
		"Show Streak Timer Bar",
		"Display a thin progress bar showing how much time you have left to chain the next kill.",
		function() return db.streakBar end,
		function(val)
			db.streakBar = val
			if MegaKill_StreakBar_SetVisible then
				MegaKill_StreakBar_SetVisible(val)
			end
		end
	)

	yOffset = yOffset - 8

	-- ── Chat channel dropdown ─────────────────────────────────────────────────

	SectionHeader("Chat Channel")

	local channelLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	channelLabel:SetPoint("TOPLEFT", 20, yOffset)
	channelLabel:SetText("Broadcast kills to:")
	yOffset = yOffset - 28

	local channelDropdown = CreateFrame("Frame", ADDON_NAME .. "_ChannelDropdown", panel, "UIDropDownMenuTemplate")
	channelDropdown:SetPoint("TOPLEFT", 4, yOffset + 10)
	UIDropDownMenu_SetWidth(channelDropdown, 160)

	local channels = {"SAY", "YELL", "PARTY", "RAID", "BATTLEGROUND"}

	UIDropDownMenu_Initialize(channelDropdown, function(self, level)
		for _, ch in ipairs(channels) do
			local info = UIDropDownMenu_CreateInfo()
			info.text = ch
			info.checked = (db.chatChannel == ch)
			info.func = function()
				db.chatChannel = ch
				UIDropDownMenu_SetText(channelDropdown, ch)
				CloseDropDownMenus()
			end
			UIDropDownMenu_AddButton(info)
		end
	end)

	yOffset = yOffset - 40

	-- ── Kill window slider ────────────────────────────────────────────────────

	SectionHeader("Multi-Kill Time Window")

	local windowNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	windowNote:SetPoint("TOPLEFT", 20, yOffset)
	windowNote:SetText("Kills within this window chain together (e.g. Double Kill, Triple Kill…)")
	yOffset = yOffset - 28

	local windowSlider = CreateFrame("Slider", ADDON_NAME .. "_WindowSlider", panel, "OptionsSliderTemplate")
	windowSlider:SetPoint("TOPLEFT", 20, yOffset)
	windowSlider:SetWidth(300)
	windowSlider:SetMinMaxValues(5, 60)
	windowSlider:SetValueStep(1)
	windowSlider:SetObeyStepOnDrag(true)
	windowSlider:SetValue(db.killWindow)

	local sn = windowSlider:GetName()
	if _G[sn .. "Low"]  then _G[sn .. "Low"]:SetText("5s")  end
	if _G[sn .. "High"] then _G[sn .. "High"]:SetText("60s") end

	local windowValue = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	windowValue:SetPoint("LEFT", windowSlider, "RIGHT", 12, 0)
	windowValue:SetText(db.killWindow .. " sec")

	windowSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value + 0.5)
		db.killWindow = value
		windowValue:SetText(value .. " sec")
	end)

	yOffset = yOffset - 55

	-- ── Test buttons ──────────────────────────────────────────────────────────

	SectionHeader("Preview Announcements")

	local previewNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	previewNote:SetPoint("TOPLEFT", 20, yOffset)
	previewNote:SetText("Click to preview an announcement on screen:")
	yOffset = yOffset - 30

	local tests = {
		{ label = "Double Kill",  idx = 2, text = "Double Kill!",  r = 1.0, g = 1.0, b = 0.0 },
		{ label = "Triple Kill",  idx = 3, text = "Triple Kill!",  r = 1.0, g = 0.5, b = 0.0 },
		{ label = "Monster Kill", idx = 6, text = "Monster Kill!", r = 0.6, g = 0.0, b = 1.0 },
	}

	local xPos = 20
	for _, t in ipairs(tests) do
		local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		btn:SetPoint("TOPLEFT", xPos, yOffset)
		btn:SetSize(130, 26)
		btn:SetText(t.label)
		btn:SetScript("OnClick", function()
			if MegaKill_ShowAnnounce then
				MegaKill_ShowAnnounce(t.text, t.r, t.g, t.b)
			end
			if MegaKill_PlayMilestoneSound then
				MegaKill_PlayMilestoneSound(t.idx)
			end
		end)
		xPos = xPos + 140
	end

	-- ── Refresh all controls on show ──────────────────────────────────────────

	panel:SetScript("OnShow", function()
		enabledCheck:Refresh()
		pvpCheck:Refresh()
		screenCheck:Refresh()
		soundCheck:Refresh()
		spreeCheck:Refresh()
		chatCheck:Refresh()
		streakBarCheck:Refresh()
		UIDropDownMenu_SetText(channelDropdown, db.chatChannel)
		windowSlider:SetValue(db.killWindow)
	end)

	-- ── Register panel ────────────────────────────────────────────────────────

	if Settings and Settings.RegisterCanvasLayoutCategory then
		-- Retail 10.0+
		local cat = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(cat)
		configCategory = cat
	elseif InterfaceOptions_AddCategory then
		-- Classic / pre-10.0
		InterfaceOptions_AddCategory(panel)
	end
end

-- ── Bootstrap ─────────────────────────────────────────────────────────────────

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
	C_Timer.After(0.1, CreateConfigPanel)
end)
