-- MegaKill Announcer - Retail Events (12.0+)
-- Loaded only by MegaKill_Announcer_Mainline.toc
-- COMBAT_LOG_EVENT_UNFILTERED is restricted on Retail 12.0 (Midnight).
-- UNIT_DIED is the replacement frame event added in 12.0.

local PLAYER_TYPE_FLAG = 0x400

local MK_RetailFrame = CreateFrame("Frame")
MK_RetailFrame:RegisterEvent("PLAYER_LOGIN")
MK_RetailFrame:RegisterEvent("PLAYER_DEAD")
MK_RetailFrame:RegisterEvent("PLAYER_ALIVE")
MK_RetailFrame:RegisterEvent("UNIT_DIED")

MK_RetailFrame:SetScript("OnEvent", function(_, ev, ...)
	if ev == "PLAYER_DEAD" then
		if MegaKill.OnPlayerDead then MegaKill.OnPlayerDead() end

	elseif ev == "PLAYER_ALIVE" then
		if MegaKill.OnPlayerAlive then MegaKill.OnPlayerAlive() end

	elseif ev == "UNIT_DIED" then
		-- unitGUID is a SecretValue on Retail 12.0 when identity is restricted.
		-- We can still ask C_PlayerInfo whether the GUID belongs to a player.
		local db = MegaKill.GetDB and MegaKill.GetDB()
		if not db or not db.enabled then return end
		if UnitIsDeadOrGhost("player") then return end
		local unitGUID = ...
		if not unitGUID then return end
		local isPlayer = (C_PlayerInfo and C_PlayerInfo.IsPlayerFromGUID and
			C_PlayerInfo.IsPlayerFromGUID(unitGUID)) or false
		MegaKill.OnKill(isPlayer)
	end
	-- PLAYER_LOGIN is handled by Core.lua; nothing extra needed here.
end)
