-- MegaKill Announcer - Classic Events
-- Loaded only by MegaKill_Announcer_Classic.toc
-- COMBAT_LOG_EVENT_UNFILTERED is available and unrestricted on Classic.

local PLAYER_TYPE_FLAG = 0x400
local playerGUID

local MK_ClassicFrame = CreateFrame("Frame")
MK_ClassicFrame:RegisterEvent("PLAYER_LOGIN")
MK_ClassicFrame:RegisterEvent("PLAYER_DEAD")
MK_ClassicFrame:RegisterEvent("PLAYER_ALIVE")
MK_ClassicFrame:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED")

MK_ClassicFrame:SetScript("OnEvent", function(_, ev, ...)
	if ev == "PLAYER_LOGIN" then
		-- Capture GUID after login so CLEU comparisons are valid
		playerGUID = UnitGUID("player")

	elseif ev == "PLAYER_DEAD" then
		if MegaKill.OnPlayerDead then MegaKill.OnPlayerDead() end

	elseif ev == "PLAYER_ALIVE" then
		if MegaKill.OnPlayerAlive then MegaKill.OnPlayerAlive() end

	elseif ev == "COMBAT_LOG_EVENT_UNFILTERED" then
		local db = MegaKill.GetDB and MegaKill.GetDB()
		if not db or not db.enabled then return end
		local _, subEvent, _, sourceGUID, _, _, _, _, _, destFlags = CombatLogGetCurrentEventInfo()
		if subEvent == "PARTY_KILL" and sourceGUID == playerGUID then
			local isPlayer = bit.band(destFlags, PLAYER_TYPE_FLAG) ~= 0
			MegaKill.OnKill(isPlayer)
		end
	end
end)
