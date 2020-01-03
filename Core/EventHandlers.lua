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
local UnitGUID = UnitGUID

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
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "OnSpellcastFailed") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "OnSpellcastFailed") -- Fishing detection
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

-------------------------------------------------------------------------------------
-- ISLAND_COMPLETED handling: Used for detecting Island Expeditions in Battle for Azeroth
-- The collectibles are awarded randomly once the scenario has ended and appear in the "Pose" screen, right after this event is fired (indicated by a subsequent LFG_COMPLETION_REWARD event)
-------------------------------------------------------------------------------------

local islandMapIDs = {
	-- These IDs can be found in DBFilesClient\Map.db2
	[1813] = "Un'gol Ruins",
	[1897] = "Molten Cay",
	[1883] = "Whispering Reef",
	[1882] = "Verdant Wilds",
	[1892] = "Rotting Mire",
	[1893] = "Dread Chain",
	[1898] = "Skittering Hollow",
	[1814] = "Havenswood",
	[1879] = "Jorundall",
	[1907] = "Snowblossom",
	[2124] = "Crestfall"
}

local islandExpeditionCollectibles = {
	-- List of collectibles (so we don't have to search the item DB for them)

	-- Pets
	---- 8.0
	"Scuttle",
	"Captain Nibs",
	"Barnaby",
	"Poro",
	"Octopode Fry",
	"Inky",
	"Sparkleshell Sandcrawler",
	"Kindleweb Spiderling",
	"Mischievous Zephyr",
	"Littlehoof",
	"Snapper",
	"Sunscale Hatchling",
	"Bloodstone Tunneler",
	"Snort",
	"Muskflank Calfling",
	"Juvenile Brineshell",
	"Kunchong Hatchling",
	"Coldlight Surfrunner",
	"Voru'kar Leecher",
	"Tinder Pup",
	"Sandshell Chitterer",
	"Deathsting Scorpid",
	"Thistlebrush Bud",
	"Giggling Flame",
	"Laughing Stonekin",
	"Playful Frostkin",
	"False Knucklebump",
	"Craghoof Kid",
	---- 8.1
	"Baby Stonehide",
	"Leatherwing Screecher",
	"Rotting Ghoul",
	"Thunderscale Whelpling",
	"Scritches",
	"Tonguelasher",
	"Lord Woofington",
	"Firesting Buzzer",
	"Needleback Pup",
	"Shadefeather Hatchling",
	---- 8.2
	"Adventurous Hopling Pack",
	"Ghostly Whelpling",
	-- Toys
	---- 8.0
	"Oomgut Ritual Drum",
	"Whiskerwax Candle",
	"Enchanted Soup Stone",
	"Magic Monkey Banana",
	"Bad Mojo Banana",
	---- Not yet implemented?
	-- "Regenerating Banana Bunch", -- NYI as of 18/01/19
	-- "Yaungol Oil Stove", -- NYI as of 18/01/19
	-- "Jinyu Light Globe", -- NYI as of 18/01/19

	-- Mounts
	---- 8.0
	"Surf Jelly",
	"Squawks",
	"Qinsho's Eternal Hound",
	"Craghorn Chasm-Leaper",
	"Twilight Avenger",
	---- 8.1
	"Risen Mare",
	"Island Thunderscale",
	"Bloodgorged Hunter",
	"Stonehide Elderhorn"
}

function R:OnIslandCompleted(event, mapID, winner)
	R:Debug(
		"Detected completion for Island Expedition: " ..
			(islandMapIDs[mapID] or "Unknown Map") .. " (mapID = " .. tostring(mapID) .. ")"
	)

	if islandMapIDs[mapID] then -- Is a relevant map -> Add attempts for all collectibles
		-- (for now, I'm assuming they just drop from everything at the same rate.
		-- This may have to be revised once more data is available...)
		-- Update: Proper tracking seems night on impossible so this'll have to do for the time being
		-- See https://github.com/SacredDuckwhale/Rarity/issues/61 for more details
		R:Debug("Found this Island Expedition to be relevant -> Adding attempts for all known collectibles...")

		for index, name in pairs(islandExpeditionCollectibles) do -- Add an attempt for each item
			local v =
				self.db.profile.groups.items[name] or self.db.profile.groups.pets[name] or self.db.profile.groups.mounts[name]
			if v and type(v) == "table" and v.enabled ~= false then
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

-------------------------------------------------------------------------------------
-- Criteria in a dungeon completed, currently used for Reins of the Infinite Timereaver detection as a special case
-------------------------------------------------------------------------------------
local timewalkingCriteriaLUT = {
	[24801] = "Ozumat", -- Legacy (seems to no longer work? Perhaps the criterion ID was changed...)
	[34414] = "Ozumat", -- Timewalking difficulty only? (need to test)
	[24803] = "Murozond",
	[24784] = "Trial of the King", -- [126952] = "Trial of the King", -- Object: Legacy of the Clan Leaders
	[19256] = "Gekkan", -- Object: Ancient Mogu Treasure
	[19244] = "Master Snowdrift", -- [123096] = "Master Snowdrift", -- Object: Snowdrift's Possessions
	[34410] = "Taran Zhu" --[123095] = "Taran Zhu", -- Object: Taran Zhu's Personal Stash
}

function R:OnCriteriaComplete(event, id)
	local encounterName = timewalkingCriteriaLUT[id]
	R:Debug("Detected achievement criteria completion: " .. tostring(id))
	if encounterName then -- Is an encounter that can't otherwise be detected
		-- (due to the mount dropping from an object, and not a lootable NPC)
		R:Debug("Completed criteria for relevant encounter: " .. tostring(encounterName))
		local v = self.db.profile.groups.mounts["Reins of the Infinite Timereaver"]
		if v and type(v) == "table" and v.enabled ~= false and R:IsAttemptAllowed(v) then
			if v.attempts == nil then
				v.attempts = 1
			else
				v.attempts = v.attempts + 1
			end
			R:OutputAttempts(v)
		end
	end
end

-------------------------------------------------------------------------------------
-- Mouseover detection, currently used for Mysterious Camel Figurine as a special case
-------------------------------------------------------------------------------------

function R:OnMouseOver(event)
	local guid = UnitGUID("mouseover")
	local npcid = self:GetNPCIDFromGUID(guid)
	Rarity:Debug("Mouse hovered over NPC with id = " .. tostring(npcid))
	if npcid == 50409 or npcid == 50410 then
		if not Rarity.guids[guid] then
			Rarity.guids[guid] = true
			local v = self.db.profile.groups.mounts["Reins of the Grey Riding Camel"]
			if v and type(v) == "table" and v.enabled ~= false then
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

Rarity.EventHandlers = EventHandlers
return EventHandlers
