local EventHandlers = {}


-- Upvalues
local R = Rarity

function EventHandlers:Register()
	self = Rarity

	self:UnregisterAllEvents()
	self:RegisterBucketEvent("BAG_UPDATE", 0.5, "OnBagUpdate")
	self:RegisterEvent("LOOT_READY", "OnEvent")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "OnCurrencyUpdate")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombat") -- Used to detect boss kills that we didn't solo
	self:RegisterEvent("BANKFRAME_OPENED", "OnEvent")
	self:RegisterEvent("BANKFRAME_CLOSED", "OnEvent")
	self:RegisterEvent("GUILDBANKFRAME_OPENED", "OnEvent")
	self:RegisterEvent("GUILDBANKFRAME_CLOSED", "OnEvent")
	self:RegisterEvent("MAIL_CLOSED", "OnEvent")
	self:RegisterEvent("MAIL_SHOW", "OnEvent")
	self:RegisterEvent("CURSOR_UPDATE", "CursorChange") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_SENT", "SpellStarted") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_STOP", "SpellStopped") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "SpellFailed") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "SpellFailed") -- Fishing detection
	self:RegisterEvent("LOOT_CLOSED", "GatherCompleted") -- Fishing detection
	self:RegisterEvent("RESEARCH_ARTIFACT_HISTORY_READY", "ScanAllArch")
	self:RegisterEvent("PLAYER_LOGOUT", "OnEvent")
	self:RegisterEvent("AUCTION_HOUSE_CLOSED", "OnEvent")
	self:RegisterEvent("AUCTION_HOUSE_SHOW", "OnEvent")
	self:RegisterEvent("TRADE_CLOSED", "OnEvent")
	self:RegisterEvent("TRADE_SHOW", "OnEvent")
	self:RegisterEvent("TRADE_SKILL_SHOW", "OnEvent")
	self:RegisterEvent("TRADE_SKILL_CLOSE", "OnEvent")
	self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "OnMouseOver")
	self:RegisterEvent("CRITERIA_COMPLETE", "OnCriteriaComplete")
	self:RegisterEvent("ENCOUNTER_END", "OnEncounterEnd")
	self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCombatEnded")
	self:RegisterEvent("PET_BATTLE_OPENING_START", "OnPetBattleStart")
	self:RegisterEvent("PET_BATTLE_CLOSE", "OnPetBattleEnd")
	self:RegisterEvent("ISLAND_COMPLETED", "OnIslandCompleted")
	self:RegisterBucketEvent("UPDATE_INSTANCE_INFO", 1, "OnEvent")
	self:RegisterBucketEvent("LFG_UPDATE_RANDOM_INFO", 1, "OnEvent")
	self:RegisterBucketEvent("CALENDAR_UPDATE_EVENT_LIST", 1, "OnEvent")
	self:RegisterBucketEvent("TOYS_UPDATED", 1, "OnEvent")
	self:RegisterBucketEvent("COMPANION_UPDATE", 1, "OnEvent")
end

-------------------------------------------------------------------------------------
-- Pet battles: we want to hide the progress bar(s) during them
-------------------------------------------------------------------------------------

local wasBarVisibleBeforePetBattle = false

function R:OnPetBattleStart(event)
	R:Debug("Pet battle started")
	wasBarVisibleBeforePetBattle = R.db.profile.bar.visible
	R.db.profile.bar.visible = false
	Rarity.GUI:UpdateBar()
	Rarity.GUI:UpdateText()
end

function R:OnPetBattleEnd(event)
	R:Debug("Pet battle ended")
	R.db.profile.bar.visible = wasBarVisibleBeforePetBattle
	Rarity.GUI:UpdateBar()
	Rarity.GUI:UpdateText()
end

Rarity.EventHandlers = EventHandlers
return EventHandlers
