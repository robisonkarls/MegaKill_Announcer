-- MegaKill Announcer - Streak Timer Bar
-- Shows a countdown progress bar after a kill so the player can track
-- how much time they have left to chain the next kill.

local BAR_WIDTH   = 220
local BAR_HEIGHT  = 14
local PADDING     = 6

-- ── Frame setup ───────────────────────────────────────────────────────────────

local streakBar = CreateFrame("Frame", "MegaKill_StreakBar", UIParent)
streakBar:SetSize(BAR_WIDTH + PADDING * 2, BAR_HEIGHT + PADDING * 2 + 18)
streakBar:SetPoint("CENTER", UIParent, "CENTER", 0, 72)  -- just below announce text
streakBar:SetFrameStrata("HIGH")
streakBar:SetClampedToScreen(true)
streakBar:EnableMouse(true)
streakBar:SetMovable(true)
streakBar:RegisterForDrag("LeftButton")
streakBar:SetScript("OnDragStart", function(self) self:StartMoving() end)
streakBar:SetScript("OnDragStop",  function(self)
	self:StopMovingOrSizing()
	-- Save position
	local point, _, relPoint, x, y = self:GetPoint()
	if MegaKill_Config then
		MegaKill_Config.barPoint    = point
		MegaKill_Config.barRelPoint = relPoint
		MegaKill_Config.barX        = x
		MegaKill_Config.barY        = y
	end
end)
streakBar:Hide()

-- Background
local bg = streakBar:CreateTexture(nil, "BACKGROUND")
bg:SetAllPoints()
bg:SetColorTexture(0, 0, 0, 0.55)

-- Kill count label (left side: "3 Kills")
local killLabel = streakBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
killLabel:SetPoint("TOPLEFT", PADDING, -PADDING + 1)
killLabel:SetTextColor(1, 1, 1, 0.9)

-- Countdown label (right side: "8s")
local timeLabel = streakBar:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
timeLabel:SetPoint("TOPRIGHT", -PADDING, -PADDING + 1)
timeLabel:SetTextColor(1, 1, 1, 0.9)

-- Bar track (dark background)
local track = streakBar:CreateTexture(nil, "BORDER")
track:SetPoint("TOPLEFT", PADDING, -(PADDING + 16))
track:SetSize(BAR_WIDTH, BAR_HEIGHT)
track:SetColorTexture(0.15, 0.15, 0.15, 0.8)

-- Bar fill
local fill = streakBar:CreateTexture(nil, "ARTWORK")
fill:SetPoint("TOPLEFT", track, "TOPLEFT", 0, 0)
fill:SetHeight(BAR_HEIGHT)
fill:SetWidth(BAR_WIDTH)
fill:SetColorTexture(0.2, 1.0, 0.2, 0.9)  -- starts green

-- Thin border around the track
local border = CreateFrame("Frame", nil, streakBar, "BackdropTemplate")
border:SetPoint("TOPLEFT",     track, "TOPLEFT",     -1,  1)
border:SetPoint("BOTTOMRIGHT", track, "BOTTOMRIGHT",  1, -1)
if border.SetBackdrop then
	border:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 6,
	})
	border:SetBackdropBorderColor(0, 0, 0, 0.6)
end

-- ── State ─────────────────────────────────────────────────────────────────────

local elapsed   = 0
local duration  = 15
local killCount = 0
local running   = false

-- ── Color helper: green → yellow → red ───────────────────────────────────────

local function GetBarColor(fraction)
	if fraction > 0.5 then
		-- green → yellow
		local t = (fraction - 0.5) * 2
		return 1 - t, 1, 0, 0.9
	else
		-- yellow → red
		local t = fraction * 2
		return 1, t, 0, 0.9
	end
end

-- ── OnUpdate ticker ───────────────────────────────────────────────────────────

streakBar:SetScript("OnUpdate", function(self, delta)
	if not running then return end

	elapsed = elapsed + delta
	local remaining = duration - elapsed
	if remaining <= 0 then
		running = false
		UIFrameFadeOut(streakBar, 0.4)
		C_Timer.After(0.4, function() streakBar:Hide() end)
		return
	end

	local fraction = remaining / duration
	local w = math.max(1, BAR_WIDTH * fraction)
	fill:SetWidth(w)

	local r, g, b, a = GetBarColor(fraction)
	fill:SetColorTexture(r, g, b, a)

	timeLabel:SetText(string.format("%.0fs", remaining))
end)

-- ── Public API ────────────────────────────────────────────────────────────────

function MegaKill_StreakBar_Start(count, window)
	killCount = count
	duration  = window
	elapsed   = 0
	running   = true

	killLabel:SetText(count .. (count == 1 and " Kill" or " Kills"))
	timeLabel:SetText(string.format("%.0fs", window))
	fill:SetWidth(BAR_WIDTH)
	fill:SetColorTexture(0.2, 1.0, 0.2, 0.9)

	-- Restore saved position if available
	if MegaKill_Config and MegaKill_Config.barPoint then
		streakBar:ClearAllPoints()
		streakBar:SetPoint(
			MegaKill_Config.barPoint,
			UIParent,
			MegaKill_Config.barRelPoint,
			MegaKill_Config.barX,
			MegaKill_Config.barY
		)
	end

	streakBar:SetAlpha(1)
	streakBar:Show()
end

function MegaKill_StreakBar_Reset()
	running = false
	streakBar:Hide()
end

function MegaKill_StreakBar_SetVisible(visible)
	if not visible then
		MegaKill_StreakBar_Reset()
	end
end
