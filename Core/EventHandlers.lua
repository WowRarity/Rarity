local _, addonTable = ...

local EventHandlers = {}

-- Upvalues
local R = Rarity
local CONSTANTS = addonTable.constants

-- Locals
local coinamounts = {}

-- Lua APIs
local bit_band = _G.bit.band

-- WOW APIs
local GetCurrencyInfo = GetCurrencyInfo
local CombatLogGetCurrentEventInfo = CombatLogGetCurrentEventInfo

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

-------------------------------------------------------------------------------------
-- Currency updates. Used for coin roll and archaeology solve detection.
-------------------------------------------------------------------------------------

function R:OnCurrencyUpdate(event)
	self:Debug("Currency updated (" .. event .. ")")

	-- Check if any archaeology projects were solved
	self:ScanArchFragments(event)

	-- Check if any coins were used
	for k, v in pairs(self.coins) do
		local name, currencyAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(k)
		local diff = currencyAmount - (coinamounts[k] or 0)
		coinamounts[k] = currencyAmount
		if diff < 0 then
			self:Debug("Used coin: " .. name)
			R:CheckForCoinItem()
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				2
			)
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				5
			)
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				10
			)
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				15
			)
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				20
			)
			self:ScheduleTimer(
				function()
					R:CheckForCoinItem()
				end,
				25
			)
		end
	end
end

function R:CheckForCoinItem()
	if self.lastCoinItem and self.lastCoinItem.enableCoin then
		self:Debug("COIN USE DETECTED FOR AN ITEM")
		if self.lastCoinItem.attempts == nil then
			self.lastCoinItem.attempts = 1
		else
			self.lastCoinItem.attempts = self.lastCoinItem.attempts + 1
		end
		self:OutputAttempts(self.lastCoinItem)
		self.lastCoinItem = nil
	end
end

-------------------------------------------------------------------------------------
-- Raid encounter ended:
-- Used for detecting raid bosses that don't actually die when the encounter ends and
-- have no statistic tied to them (e.g., the Keepers of Ulduar)
-- While it might work to change their method from NPC to BOSS,
-- at this time I'm not sure if that wouldn't cause problems elsewhere... so I won't touch it
-------------------------------------------------------------------------------------
local encounterLUT = {
	[1140] = "Stormforged Rune", -- The Assembly of Iron
	[1133] = "Blessed Seed", -- Freya
	[1135] = "Ominous Pile of Snow", -- Hodir
	[1138] = "Overcomplicated Controller", -- Mimiron
	[1143] = "Wriggling Darkness", -- Yogg-Saron (mount uses the BOSS method and is tracked separately)
	[1500] = "Celestial Gift", -- Elegon
	[1505] = "Azure Cloud Serpent Egg", -- Tsulong
	[1506] = "Spirit of the Spring" -- Lei Shi
}

function R:OnEncounterEnd(event, encounterID, encounterName, difficultyID, raidSize, endStatus)
	R:Debug(
		"ENCOUNTER_END with encounterID = " ..
			tonumber(encounterID or "0") .. ", name = " .. tostring(encounterName) .. ", endStatus = " .. tostring(endStatus)
	)

	local item = encounterLUT[encounterID]
	if item and type(item) == "string" then -- This encounter has an entry in the LUT and needs special handling
		R:Debug("Found item of interest for this encounter: " .. tostring(item))
		local v = self.db.profile.groups.pets[item] -- v = value = number of attempts for this item

		if endStatus == 1 then -- Encounter succeeded -> Check if number of attempts should be increased
			if v and type(v) == "table" and v.enabled ~= false and R:IsAttemptAllowed(v) then -- Add one attempt for this item
				if v.attempts == nil then
					v.attempts = 1
				else
					v.attempts = v.attempts + 1
				end
				R:OutputAttempts(v)
			end
		end
	end
end

-------------------------------------------------------------------------------------
-- When combat ends, we scan your statistics a few times.
-- This helps catch some items that can't be tracked by normal means (i.e. Ragnaros),
-- as well as acting as another backup to detect attempts if we missed one.
-- WoW can take a few seconds to update statistics, thus the repeated scans.
-- This is also where we detect if an achievement criteria has been met.
-------------------------------------------------------------------------------------
do
	local timer1, timer2, timer3, timer4, timer5, timer6
	function R:OnCombatEnded(event)
		--if R:InTooltip() then Rarity:ShowTooltip() end

		self:CancelTimer(timer1, true)
		self:CancelTimer(timer2, true)
		self:CancelTimer(timer3, true)
		self:CancelTimer(timer4, true)
		self:CancelTimer(timer5, true)
		self:CancelTimer(timer6, true)

		self:ScanStatistics(event)

		timer1 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 1")
			end,
			2
		)
		timer2 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 2")
			end,
			5
		)
		timer3 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 3")
			end,
			8
		)
		timer4 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 4")
			end,
			10
		)
		timer5 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 5")
			end,
			15
		)
		timer6 =
			self:ScheduleTimer(
			function()
				Rarity:ScanStatistics(event .. " 6")
			end,
			20
		)
	end
end

-------------------------------------------------------------------------------------
-- Handle boss kills. You may not ever open a loot window on a boss, so we need to watch the combat log for its death.
-- This event also handles some special cases.
-------------------------------------------------------------------------------------
function R:OnCombat()
	-- Extract event payload (it's no longer being passed by the event iself as of 8.0.1)
	local timestamp,
		eventType,
		hideCaster,
		srcGuid,
		srcName,
		srcFlags,
		srcRaidFlags,
		dstGuid,
		dstName,
		dstFlags,
		dstRaidFlags,
		spellId,
		spellName,
		spellSchool,
		auraType = CombatLogGetCurrentEventInfo()

	if eventType == "UNIT_DIED" then -- A unit died near you
		local npcid = self:GetNPCIDFromGUID(dstGuid)
		if Rarity.bosses[npcid] then -- It's a boss we're interested in
			R:Debug("Detected UNIT_DIED for relevant NPC with ID = " .. tostring(npcid))
			if
				bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) or
					bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID)
			 then -- You, a party member, or a raid member killed it
				if not Rarity.guids[dstGuid] then
					-- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
					if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
						for k, v in pairs(Rarity.npcs_to_items[npcid]) do
							if v.enabled ~= false and v.method == CONSTANTS.DETECTION_METHODS.BOSS then
								if self:IsAttemptAllowed(v) then
									Rarity.guids[dstGuid] = true
									if v.attempts == nil then
										v.attempts = 1
									else
										v.attempts = v.attempts + 1
									end
									self:OutputAttempts(v)
								end
							end
						end
					end
				end
			end
		end
	end
end

Rarity.EventHandlers = EventHandlers
return EventHandlers
