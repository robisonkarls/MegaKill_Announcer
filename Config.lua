-- MegaKill Announcer - Configuration UI

local ADDON_NAME = "MegaKill_Announcer"
local PREFIX = "|cffff7d0aMegaKill|r"
local IS_RETAIL = (WOW_PROJECT_ID == WOW_PROJECT_MAINLINE)

local configPanel = nil
local configCategory = nil

-- ── Open the config panel ─────────────────────────────────────────────────────

function MegaKill_OpenConfig()
	if configCategory then
		Settings.OpenToCategory(configCategory:GetID())
	elseif InterfaceOptionsFrame_OpenToCategory then
		InterfaceOptionsFrame_OpenToCategory(configPanel)
		InterfaceOptionsFrame_OpenToCategory(configPanel)
	end
end

-- ── Simple cycling button (replaces UIDropDownMenu) ──────────────────────────

local function CreateCycleButton(parent, options, getter, setter, yOff)
	local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
	btn:SetPoint("TOPLEFT", 20, yOff)
	btn:SetSize(200, 26)

	local function Refresh()
		btn:SetText(getter() .. "  ▾")
	end

	btn:SetScript("OnClick", function()
		local cur = getter()
		local idx = 1
		for i, v in ipairs(options) do
			if v == cur then idx = i break end
		end
		idx = (idx % #options) + 1
		setter(options[idx])
		Refresh()
	end)

	Refresh()
	btn.Refresh = Refresh
	return btn
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
	subtitle:SetText("|cff888888PvP killstreak announcer — v1.0.4|r")

	local divider = panel:CreateTexture(nil, "ARTWORK")
	divider:SetHeight(1)
	divider:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -10)
	divider:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 0)
	divider:SetColorTexture(0.3, 0.3, 0.3, 1)

	-- ── Helpers ───────────────────────────────────────────────────────────────

	local yOffset = -85
	local checkboxes = {}

	local function SectionHeader(text)
		local lbl = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		lbl:SetPoint("TOPLEFT", 16, yOffset)
		lbl:SetText("|cffffd700" .. text .. "|r")
		yOffset = yOffset - 24
	end

	local function CreateCheckbox(label, tooltip, getter, setter)
		local check = CreateFrame("CheckButton", nil, panel, "UICheckButtonTemplate")
		check:SetPoint("TOPLEFT", 20, yOffset)
		check:SetSize(24, 24)

		local lbl = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
		lbl:SetPoint("LEFT", check, "RIGHT", 4, 0)
		lbl:SetText(label)

		check:SetScript("OnEnter", function(self)
			GameTooltip:SetOwner(self, "ANCHOR_RIGHT")
			GameTooltip:SetText(tooltip, nil, nil, nil, nil, true)
			GameTooltip:Show()
		end)
		check:SetScript("OnLeave", function() GameTooltip:Hide() end)
		check:SetScript("OnClick", function(self) setter(self:GetChecked()) end)
		check.Refresh = function() check:SetChecked(getter()) end
		table.insert(checkboxes, check)

		yOffset = yOffset - 30
		return check
	end

	-- ── General ───────────────────────────────────────────────────────────────

	SectionHeader("General")

	CreateCheckbox("Enable Addon",
		"Turn MegaKill Announcer on or off.",
		function() return db.enabled end,
		function(v) db.enabled = v end)

	CreateCheckbox("PvP Kills Only  (Honorable Kills)",
		"Only track player kills. Disabling counts all kills including mobs.",
		function() return db.onlyPvP end,
		function(v) db.onlyPvP = v end)

	yOffset = yOffset - 8

	-- ── Announcements ─────────────────────────────────────────────────────────

	SectionHeader("Announcements")

	CreateCheckbox("Show On-Screen Text",
		"Display large coloured text in the centre of your screen on each kill.",
		function() return db.screenAnnounce end,
		function(v) db.screenAnnounce = v end)

	CreateCheckbox("Play Sound Effects",
		"Play audio cues for kill milestones.",
		function() return db.sound end,
		function(v) db.sound = v end)

	CreateCheckbox("Sound Only (no on-screen text)",
		"Play sounds on kills but do not show on-screen text announcements.",
		function() return db.soundOnly end,
		function(v) db.soundOnly = v end)

	CreateCheckbox("Announce Killing Sprees",
		"Announce Killing Spree, Rampage, Godlike, etc.",
		function() return db.spreeAnnounce end,
		function(v) db.spreeAnnounce = v end)

	CreateCheckbox("Show Streak Timer Bar",
		"Thin progress bar showing time left to chain the next kill.",
		function() return db.streakBar end,
		function(v)
			db.streakBar = v
			if MegaKill_StreakBar_SetVisible then MegaKill_StreakBar_SetVisible(v) end
		end)

	-- Chat announce — Classic only
	local chatCheck
	if not IS_RETAIL then
		chatCheck = CreateCheckbox("Broadcast to Chat",
			"Send kill announcements to a chat channel.",
			function() return db.chatAnnounce end,
			function(v) db.chatAnnounce = v end)
	end

	yOffset = yOffset - 8

	-- ── Chat Channel (Classic only) ───────────────────────────────────────────

	local channelBtn
	if not IS_RETAIL then
		SectionHeader("Chat Channel")

		local channelNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
		channelNote:SetPoint("TOPLEFT", 20, yOffset)
		channelNote:SetText("Broadcast kills to (click to cycle):")
		yOffset = yOffset - 26

		channelBtn = CreateCycleButton(panel,
			{"PARTY", "RAID", "INSTANCE_CHAT", "BATTLEGROUND"},
			function() return db.chatChannel end,
			function(v) db.chatChannel = v end,
			yOffset)
		yOffset = yOffset - 36
	end

	-- ── Multi-Kill Window ─────────────────────────────────────────────────────

	SectionHeader("Sound Pack")

	local SOUND_PACK_LIST = { "Unreal_Theme", "Flamboyant_theme" }
	local SOUND_PACK_LABELS = { Unreal_Theme = "Unreal Tournament", Flamboyant_theme = "Flamboyant" }

	local packNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	packNote:SetPoint("TOPLEFT", 20, yOffset)
	packNote:SetText("Announcer voice pack:")
	yOffset = yOffset - 26

	-- Prev button
	local prevBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	prevBtn:SetSize(28, 24)
	prevBtn:SetPoint("TOPLEFT", 20, yOffset)
	prevBtn:SetText("<")

	-- Pack name label
	local packLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	packLabel:SetPoint("LEFT", prevBtn, "RIGHT", 8, 0)
	packLabel:SetWidth(200)
	packLabel:SetJustifyH("LEFT")

	-- Next button
	local nextBtn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
	nextBtn:SetSize(28, 24)
	nextBtn:SetPoint("LEFT", packLabel, "RIGHT", 8, 0)
	nextBtn:SetText(">")

	local function UpdatePackLabel()
		packLabel:SetText(SOUND_PACK_LABELS[db.soundPack] or db.soundPack)
	end
	UpdatePackLabel()

	local function GetPackIndex()
		for i, v in ipairs(SOUND_PACK_LIST) do
			if v == db.soundPack then return i end
		end
		return 1
	end

	prevBtn:SetScript("OnClick", function()
		local i = GetPackIndex()
		i = ((i - 2) % #SOUND_PACK_LIST) + 1
		db.soundPack = SOUND_PACK_LIST[i]
		UpdatePackLabel()
	end)

	nextBtn:SetScript("OnClick", function()
		local i = GetPackIndex()
		i = (i % #SOUND_PACK_LIST) + 1
		db.soundPack = SOUND_PACK_LIST[i]
		UpdatePackLabel()
	end)

	yOffset = yOffset - 36

	SectionHeader("Multi-Kill Time Window")

	local windowNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	windowNote:SetPoint("TOPLEFT", 20, yOffset)
	windowNote:SetText("Kills within this window chain together:")
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

	-- ── Preview ───────────────────────────────────────────────────────────────

	SectionHeader("Preview Announcements")

	local previewNote = panel:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	previewNote:SetPoint("TOPLEFT", 20, yOffset)
	previewNote:SetText("Click to preview an announcement:")
	yOffset = yOffset - 30

	-- Preview buttons — use selected pack, slots 1/2/3
	local tests = {
		{ label = "Kill 1", idx = 1, text = "First Blood!",  r = 1.0, g = 1.0, b = 1.0 },
		{ label = "Kill 2", idx = 2, text = "Double Kill!",  r = 1.0, g = 1.0, b = 0.0 },
		{ label = "Kill 3", idx = 3, text = "Triple Kill!",  r = 1.0, g = 0.5, b = 0.0 },
	}

	local xPos = 20
	for _, t in ipairs(tests) do
		local btn = CreateFrame("Button", nil, panel, "UIPanelButtonTemplate")
		btn:SetPoint("TOPLEFT", xPos, yOffset)
		btn:SetSize(110, 26)
		btn:SetText(t.label)
		btn:SetScript("OnClick", function()
			if MegaKill_PlayMilestoneSound then MegaKill_PlayMilestoneSound(t.idx) end
			if MegaKill_ShowAnnounce then
				local soundFile = MegaKill_GetSoundFile and MegaKill_GetSoundFile(t.idx)
				MegaKill_ShowAnnounce(t.text, t.r, t.g, t.b, soundFile)
			end
		end)
		xPos = xPos + 120
	end

	-- ── Refresh on show ───────────────────────────────────────────────────────

	panel:SetScript("OnShow", function()
		for _, cb in ipairs(checkboxes) do cb:Refresh() end
		if channelBtn then channelBtn:Refresh() end
		windowSlider:SetValue(db.killWindow)
	end)

	-- ── Register panel ────────────────────────────────────────────────────────

	if Settings and Settings.RegisterCanvasLayoutCategory then
		local cat = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(cat)
		configCategory = cat
	elseif InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(panel)
	end
end

-- ── Bootstrap ─────────────────────────────────────────────────────────────────

local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
	C_Timer.After(0.1, CreateConfigPanel)
end)
