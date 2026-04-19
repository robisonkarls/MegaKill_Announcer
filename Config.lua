-- MegaKill Announcer - Configuration UI

local ADDON_NAME = "MegaKill_Announcer"

local configPanel    = nil
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
	subtitle:SetText("|cff888888PvP killstreak announcer — v1.2.0|r")

	local divider = panel:CreateTexture(nil, "ARTWORK")
	divider:SetHeight(1)
	divider:SetPoint("TOPLEFT", subtitle, "BOTTOMLEFT", 0, -8)
	divider:SetPoint("TOPRIGHT", panel, "TOPRIGHT", -16, 0)
	divider:SetColorTexture(0.3, 0.3, 0.3, 1)

	-- ── ScrollFrame ───────────────────────────────────────────────────────────

	local scrollFrame = CreateFrame("ScrollFrame", ADDON_NAME .. "_Scroll", panel, "UIPanelScrollFrameTemplate")
	scrollFrame:SetPoint("TOPLEFT", divider, "BOTTOMLEFT", 0, -8)
	scrollFrame:SetPoint("BOTTOMRIGHT", panel, "BOTTOMRIGHT", -28, 8)

	local content = CreateFrame("Frame", nil, scrollFrame)
	content:SetSize(scrollFrame:GetWidth() or 500, 800)
	scrollFrame:SetScrollChild(content)

	panel:SetScript("OnSizeChanged", function(_, w, _)
		content:SetWidth(w - 44)
	end)

	-- ── Helpers ───────────────────────────────────────────────────────────────

	local yOffset  = -8
	local checkboxes = {}

	local function SectionHeader(text)
		local lbl = content:CreateFontString(nil, "ARTWORK", "GameFontNormal")
		lbl:SetPoint("TOPLEFT", 16, yOffset)
		lbl:SetText("|cffffd700" .. text .. "|r")
		yOffset = yOffset - 24
	end

	local function CreateCheckbox(label, tooltip, getter, setter)
		local check = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
		check:SetPoint("TOPLEFT", 20, yOffset)
		check:SetSize(24, 24)
		local lbl = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
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

	local function CreateCheckboxAt(label, tooltip, getter, setter, x, y)
		local check = CreateFrame("CheckButton", nil, content, "UICheckButtonTemplate")
		check:SetPoint("TOPLEFT", x, y)
		check:SetSize(24, 24)
		local lbl = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
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
		return check
	end

	-- ── General ───────────────────────────────────────────────────────────────

	SectionHeader("General")

	local rowY = yOffset
	CreateCheckboxAt("Enable Addon",
		"Turn MegaKill Announcer on or off.",
		function() return db.enabled end,
		function(v) db.enabled = v end, 20, rowY)

	CreateCheckboxAt("PvP Kills Only",
		"Only track Honorable Kills. Disabling counts all kills including mobs.",
		function() return db.onlyPvP end,
		function(v) db.onlyPvP = v end, 240, rowY)

	yOffset = yOffset - 34

	-- ── Announcements ─────────────────────────────────────────────────────────

	SectionHeader("Announcements")

	CreateCheckbox("Show On-Screen Text",
		"Display large text in the centre of your screen on each kill.",
		function() return db.screenAnnounce end,
		function(v) db.screenAnnounce = v end)

	rowY = yOffset
	local spreeCheck = CreateCheckboxAt("Announce Killing Sprees",
		"Announce Killing Spree, Rampage, Godlike, etc. Milestone packs only.",
		function() return db.spreeAnnounce end,
		function(v) db.spreeAnnounce = v end, 20, rowY)

	local streakCheck = CreateCheckboxAt("Show Streak Timer Bar",
		"Progress bar showing time left to chain the next kill. Milestone packs only.",
		function() return db.streakBar end,
		function(v)
			db.streakBar = v
			if MegaKill_StreakBar_SetVisible then MegaKill_StreakBar_SetVisible(v) end
		end, 240, rowY)

	yOffset = yOffset - 34
	yOffset = yOffset - 4

	-- ── Sound Pack ────────────────────────────────────────────────────────────

	SectionHeader("Sound Pack")

	-- Build sorted pack list dynamically from the registry
	local function GetSortedPackKeys()
		local keys = {}
		local reg = MegaKill_GetRegistry and MegaKill_GetRegistry() or {}
		for k in pairs(reg) do table.insert(keys, k) end
		table.sort(keys)
		return keys
	end

	local packNote = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	packNote:SetPoint("TOPLEFT", 20, yOffset)
	packNote:SetText("Announcer voice pack:")
	yOffset = yOffset - 26

	local prevBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	prevBtn:SetSize(28, 24)
	prevBtn:SetPoint("TOPLEFT", 20, yOffset)
	prevBtn:SetText("<")

	local packLabel = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	packLabel:SetPoint("LEFT", prevBtn, "RIGHT", 8, 0)
	packLabel:SetWidth(200)
	packLabel:SetJustifyH("LEFT")

	local nextBtn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
	nextBtn:SetSize(28, 24)
	nextBtn:SetPoint("LEFT", packLabel, "RIGHT", 8, 0)
	nextBtn:SetText(">")

	local packTypeLabel = content:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	packTypeLabel:SetPoint("TOPLEFT", 20, yOffset - 22)
	packTypeLabel:SetTextColor(0.6, 0.6, 0.6, 1)

	-- Greys out milestone-only controls when a random pack is selected
	local function RefreshMilestoneControls()
		local isMilestone = MegaKill_PackIsMilestone and MegaKill_PackIsMilestone()
		local alpha = isMilestone and 1 or 0.4
		spreeCheck:SetAlpha(alpha)
		if isMilestone then spreeCheck:Enable() else spreeCheck:Disable() end
		streakCheck:SetAlpha(alpha)
		if isMilestone then streakCheck:Enable() else streakCheck:Disable() end
		if not isMilestone and MegaKill_StreakBar_Reset then
			MegaKill_StreakBar_Reset()
		end
		packTypeLabel:SetText(isMilestone
			and "Type: progressive milestone"
			or  "Type: random (no sprees or streak bar)")
	end

	local function UpdatePackLabel()
		local reg = MegaKill_GetRegistry and MegaKill_GetRegistry() or {}
		local pack = reg[db.soundPack]
		packLabel:SetText(pack and pack.label or db.soundPack)
		RefreshMilestoneControls()
	end
	UpdatePackLabel()

	local function GetPackIndex()
		local keys = GetSortedPackKeys()
		for i, k in ipairs(keys) do
			if k == db.soundPack then return i, keys end
		end
		return 1, keys
	end

	prevBtn:SetScript("OnClick", function()
		local i, keys = GetPackIndex()
		i = ((i - 2) % #keys) + 1
		db.soundPack = keys[i]
		UpdatePackLabel()
	end)

	nextBtn:SetScript("OnClick", function()
		local i, keys = GetPackIndex()
		i = (i % #keys) + 1
		db.soundPack = keys[i]
		UpdatePackLabel()
	end)

	yOffset = yOffset - 52

	-- ── Multi-Kill Window ─────────────────────────────────────────────────────

	SectionHeader("Multi-Kill Time Window")

	local windowNote = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	windowNote:SetPoint("TOPLEFT", 20, yOffset)
	windowNote:SetText("Kills within this window chain together:")
	yOffset = yOffset - 28

	local windowSlider = CreateFrame("Slider", ADDON_NAME .. "_WindowSlider", content, "OptionsSliderTemplate")
	windowSlider:SetPoint("TOPLEFT", 20, yOffset)
	windowSlider:SetWidth(300)
	windowSlider:SetMinMaxValues(5, 60)
	windowSlider:SetValueStep(1)
	windowSlider:SetObeyStepOnDrag(true)
	windowSlider:SetValue(db.killWindow)

	local sn = windowSlider:GetName()
	if _G[sn .. "Low"]  then _G[sn .. "Low"]:SetText("5s")  end
	if _G[sn .. "High"] then _G[sn .. "High"]:SetText("60s") end

	local windowValue = content:CreateFontString(nil, "ARTWORK", "GameFontHighlight")
	windowValue:SetPoint("LEFT", windowSlider, "RIGHT", 12, 0)
	windowValue:SetText(db.killWindow .. " sec")

	windowSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value + 0.5)
		db.killWindow = value
		windowValue:SetText(value .. " sec")
	end)

	yOffset = yOffset - 55

	-- ── Preview ───────────────────────────────────────────────────────────────

	SectionHeader("Preview")

	local previewNote = content:CreateFontString(nil, "ARTWORK", "GameFontHighlightSmall")
	previewNote:SetPoint("TOPLEFT", 20, yOffset)
	previewNote:SetText("Click to preview from the selected pack:")
	yOffset = yOffset - 28

	local previewSlots = { 1, 2, 3 }
	local previewLabels = { "Kill 1", "Kill 2", "Kill 3" }

	local xPos = 20
	for i, slot in ipairs(previewSlots) do
		local btn = CreateFrame("Button", nil, content, "UIPanelButtonTemplate")
		btn:SetPoint("TOPLEFT", xPos, yOffset)
		btn:SetSize(100, 26)
		btn:SetText(previewLabels[i])
		btn:SetScript("OnClick", function()
			if MegaKill_GetSound then
				local soundPath, label = MegaKill_GetSound(slot)
				if soundPath then PlaySoundFile(soundPath, "Master") end
				if MegaKill_ShowAnnounce then MegaKill_ShowAnnounce(label) end
			end
		end)
		xPos = xPos + 110
	end

	yOffset = yOffset - 40
	content:SetHeight(math.abs(yOffset) + 20)

	-- ── Refresh on show ───────────────────────────────────────────────────────

	panel:SetScript("OnShow", function()
		for _, cb in ipairs(checkboxes) do cb:Refresh() end
		windowSlider:SetValue(db.killWindow)
		UpdatePackLabel()
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
