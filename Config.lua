-- MegaKill Announcer - Configuration UI

local ADDON_NAME = "MegaKill_Announcer"
local PREFIX = "|cffff7d0aMegaKill|r"

-- Wait for addon to load
local function CreateConfigPanel()
	-- Get the saved config reference
	local db = MegaKill_Config
	if not db then
		C_Timer.After(0.5, CreateConfigPanel)
		return
	end

	-- Main panel frame
	local panel = CreateFrame("Frame", ADDON_NAME .. "_ConfigPanel")
	panel.name = "MegaKill Announcer"

	-- Title
	local title = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalLarge")
	title:SetPoint("TOPLEFT", 16, -16)
	title:SetText("|cffff7d0aMegaKill Announcer|r Settings")

	-- Version
	local version = panel:CreateFontString(nil, "ARTWORK", "GameFontNormalSmall")
	version:SetPoint("TOPLEFT", title, "BOTTOMLEFT", 0, -8)
	version:SetText("|cff888888Version 1.0|r")

	-- Divider
	local divider = panel:CreateTexture(nil, "ARTWORK")
	divider:SetHeight(1)
	divider:SetPoint("TOPLEFT", version, "BOTTOMLEFT", 0, -8)
	divider:SetPoint("RIGHT", -16, 0)
	divider:SetColorTexture(0.25, 0.25, 0.25, 1)

	local yOffset = -80

	-- Helper function to create checkboxes
	local function CreateCheckbox(parent, label, tooltip, onClick)
		-- Try retail template first, fallback to classic
		local template = "InterfaceOptionsCheckButtonTemplate"
		if not _G[template] then
			template = "OptionsCheckButtonTemplate" -- Classic fallback
		end
		
		local check = CreateFrame("CheckButton", nil, parent, template)
		check:SetPoint("TOPLEFT", 16, yOffset)
		
		-- Handle both .Text (retail) and .text (classic) properties
		local text = check.Text or check.text
		if text then
			text:SetText(label)
		end
		
		check.tooltipText = tooltip
		check:SetScript("OnClick", onClick)
		yOffset = yOffset - 30
		return check
	end

	-- Enabled checkbox
	local enabledCheck = CreateCheckbox(panel, "Enable Addon", "Turn the addon on/off", function(self)
		db.enabled = self:GetChecked()
		print(PREFIX .. ": " .. (db.enabled and "|cff00ff00Enabled|r" or "|cffff0000Disabled|r"))
	end)

	-- Screen announce checkbox
	local screenCheck = CreateCheckbox(panel, "Show On-Screen Text", "Display large text in the center of your screen", function(self)
		db.screenAnnounce = self:GetChecked()
	end)

	-- Chat announce checkbox
	local chatCheck = CreateCheckbox(panel, "Announce in Chat", "Broadcast announcements to a chat channel", function(self)
		db.chatAnnounce = self:GetChecked()
	end)

	-- Sound checkbox
	local soundCheck = CreateCheckbox(panel, "Play Sounds", "Play audio cues for multi-kills", function(self)
		db.sound = self:GetChecked()
	end)

	-- PvP-only checkbox
	local pvpCheck = CreateCheckbox(panel, "PvP Kills Only", "Only track Honorable Kills (player kills)", function(self)
		db.onlyPvP = self:GetChecked()
	end)

	-- Spree announce checkbox
	local spreeCheck = CreateCheckbox(panel, "Announce Killing Sprees", "Announce milestone kill counts without dying", function(self)
		db.spreeAnnounce = self:GetChecked()
	end)

	yOffset = yOffset - 10

	-- Chat channel dropdown
	local channelLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	channelLabel:SetPoint("TOPLEFT", 16, yOffset)
	channelLabel:SetText("Chat Channel:")
	yOffset = yOffset - 30

	local channelDropdown = CreateFrame("Frame", ADDON_NAME .. "_ChannelDropdown", panel, "UIDropDownMenuTemplate")
	channelDropdown:SetPoint("TOPLEFT", 0, yOffset + 15)

	local channels = {"SAY", "YELL", "PARTY", "RAID", "BATTLEGROUND"}
	
	UIDropDownMenu_SetWidth(channelDropdown, 150)
	UIDropDownMenu_SetText(channelDropdown, db.chatChannel)

	UIDropDownMenu_Initialize(channelDropdown, function(self, level)
		local info = UIDropDownMenu_CreateInfo()
		for _, channel in ipairs(channels) do
			info.text = channel
			info.func = function()
				db.chatChannel = channel
				UIDropDownMenu_SetText(channelDropdown, channel)
				CloseDropDownMenus()
			end
			info.checked = (db.chatChannel == channel)
			UIDropDownMenu_AddButton(info)
		end
	end)

	yOffset = yOffset - 40

	-- Kill window slider
	local windowLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	windowLabel:SetPoint("TOPLEFT", 16, yOffset)
	windowLabel:SetText("Multi-Kill Time Window:")
	yOffset = yOffset - 30

	local windowSlider = CreateFrame("Slider", ADDON_NAME .. "_WindowSlider", panel, "OptionsSliderTemplate")
	windowSlider:SetPoint("TOPLEFT", 16, yOffset)
	windowSlider:SetMinMaxValues(5, 60)
	windowSlider:SetValue(db.killWindow)
	windowSlider:SetValueStep(1)
	windowSlider:SetObeyStepOnDrag(true)
	windowSlider:SetWidth(300)
	
	-- Compatible with both Classic and Retail
	local sliderName = windowSlider:GetName()
	local lowText = _G[sliderName .. "Low"] or getglobal(sliderName .. "Low")
	local highText = _G[sliderName .. "High"] or getglobal(sliderName .. "High")
	local valueText = _G[sliderName .. "Text"] or getglobal(sliderName .. "Text")
	
	if lowText then lowText:SetText("5s") end
	if highText then highText:SetText("60s") end
	if valueText then valueText:SetText(db.killWindow .. " seconds") end

	windowSlider:SetScript("OnValueChanged", function(self, value)
		value = math.floor(value + 0.5)
		db.killWindow = value
		local txt = _G[self:GetName() .. "Text"] or getglobal(self:GetName() .. "Text")
		if txt then txt:SetText(value .. " seconds") end
	end)

	yOffset = yOffset - 60

	-- Test buttons section
	local testLabel = panel:CreateFontString(nil, "ARTWORK", "GameFontNormal")
	testLabel:SetPoint("TOPLEFT", 16, yOffset)
	testLabel:SetText("Test Announcements:")
	yOffset = yOffset - 35

	local function CreateTestButton(parent, text, testIndex, xPos)
		local btn = CreateFrame("Button", nil, parent, "UIPanelButtonTemplate")
		btn:SetPoint("TOPLEFT", xPos, yOffset)
		btn:SetSize(120, 25)
		btn:SetText(text)
		btn:SetScript("OnClick", function()
			-- Call the test function from Core.lua
			local MULTI_KILL = {
				[2] = { text = "Double Kill!",  r = 1.0, g = 1.0, b = 0.0 },
				[3] = { text = "Triple Kill!",  r = 1.0, g = 0.5, b = 0.0 },
				[6] = { text = "Monster Kill!", r = 0.6, g = 0.0, b = 1.0 },
			}
			local mk = MULTI_KILL[testIndex]
			if mk and MegaKill_ShowAnnounce then
				MegaKill_ShowAnnounce(mk.text, mk.r, mk.g, mk.b)
				if MegaKill_PlayMilestoneSound then
					MegaKill_PlayMilestoneSound(testIndex)
				end
			end
		end)
		return btn
	end

	CreateTestButton(panel, "Double Kill", 2, 16)
	CreateTestButton(panel, "Triple Kill", 3, 150)
	CreateTestButton(panel, "Monster Kill", 6, 284)

	-- OnShow: refresh checkboxes from current config
	panel:SetScript("OnShow", function()
		enabledCheck:SetChecked(db.enabled)
		screenCheck:SetChecked(db.screenAnnounce)
		chatCheck:SetChecked(db.chatAnnounce)
		soundCheck:SetChecked(db.sound)
		pvpCheck:SetChecked(db.onlyPvP)
		spreeCheck:SetChecked(db.spreeAnnounce)
		UIDropDownMenu_SetText(channelDropdown, db.chatChannel)
		windowSlider:SetValue(db.killWindow)
	end)

	-- Register with Interface Options
	if InterfaceOptions_AddCategory then
		InterfaceOptions_AddCategory(panel)
	elseif Settings and Settings.RegisterCanvasLayoutCategory then
		-- Retail 10.0+ API
		local category = Settings.RegisterCanvasLayoutCategory(panel, panel.name)
		Settings.RegisterAddOnCategory(category)
	end

	print(PREFIX .. " configuration UI loaded. Type |cffffd700/mk config|r or check Interface Options.")
end

-- Hook into PLAYER_LOGIN
local loader = CreateFrame("Frame")
loader:RegisterEvent("PLAYER_LOGIN")
loader:SetScript("OnEvent", function()
	C_Timer.After(0.1, CreateConfigPanel)
end)
