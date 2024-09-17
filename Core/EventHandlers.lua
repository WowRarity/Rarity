local _, addonTable = ...

local EventHandlers = {}

-- Upvalues
local R = Rarity
local CONSTANTS = addonTable.constants

-- Locals
local coinamounts = {}

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()

-- Lua APIs
local bit_band = _G.bit.band
local strlower = _G.strlower
local format = _G.format

-- WOW APIs
local GetCurrencyInfo = _G.C_CurrencyInfo.GetCurrencyInfo
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local UnitGUID = UnitGUID
local LoadAddOn = _G.C_AddOns.LoadAddOn
local GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local GetMapInfo = _G.C_Map.GetMapInfo
local IsQuestFlaggedCompleted = C_QuestLog.IsQuestFlaggedCompleted
local UnitCanAttack = _G.UnitCanAttack
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsDead = _G.UnitIsDead
local GetNumLootItems = _G.GetNumLootItems
local GetLootSlotInfo = _G.GetLootSlotInfo
local GetLootSlotLink = _G.GetLootSlotLink
local GetItemInfo_Blizzard = _G.C_Item.GetItemInfo
local GetItemInfo = function(id)
	return R:GetItemInfo(id)
end
local GetRealZoneText = _G.GetRealZoneText
local GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local GetContainerItemID = _G.C_Container.GetContainerItemID
local GetContainerItemInfo = _G.C_Container.GetContainerItemInfo
local GetNumArchaeologyRaces = _G.GetNumArchaeologyRaces
local GetArchaeologyRaceInfo = _G.GetArchaeologyRaceInfo
local GetStatistic = _G.GetStatistic
local GetLootSourceInfo = _G.GetLootSourceInfo
local C_Timer = _G.C_Timer
local IsSpellKnown = _G.IsSpellKnown
local GetCurrentRenownLevel = C_MajorFactions.GetCurrentRenownLevel

-- Addon APIs
local DebugCache = Rarity.Utils.DebugCache

function EventHandlers:Register()
	self = Rarity
	local WOW_INTERFACE_VER = select(4, GetBuildInfo())

	self:UnregisterAllEvents()
	self:RegisterBucketEvent("BAG_UPDATE", 0.5, "OnBagUpdate")
	self:RegisterEvent("LOOT_READY", "OnLootReady")
	self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "OnCurrencyUpdate")
	self:RegisterEvent("RESEARCH_ARTIFACT_COMPLETE", "OnResearchArtifactComplete")
	self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombat") -- Used to detect boss kills that we didn't solo
	self:RegisterEvent("BANKFRAME_OPENED", "OnEvent")
	self:RegisterEvent("BANKFRAME_CLOSED", "OnEvent")
	self:RegisterEvent("GUILDBANKFRAME_OPENED", "OnEvent")
	self:RegisterEvent("GUILDBANKFRAME_CLOSED", "OnEvent")
	self:RegisterEvent("MAIL_CLOSED", "OnEvent")
	self:RegisterEvent("MAIL_SHOW", "OnEvent")
	self:RegisterEvent("CURSOR_CHANGED", "OnCursorChanged") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_SENT", "OnSpellcastSent") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_STOP", "OnSpellcastStopped") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_FAILED", "OnSpellcastFailed") -- Fishing detection
	self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "OnSpellcastFailed") -- Fishing detection
	self:RegisterEvent("LOOT_CLOSED", "OnLootFrameClosed") -- Fishing detection
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
	self:RegisterEvent("UNIT_SPELLCAST_SUCCEEDED", "OnSpellcastSucceeded")
	self:RegisterEvent("QUEST_TURNED_IN", "OnQuestTurnedIn")
	self:RegisterEvent("SHOW_LOOT_TOAST", "OnShowLootToast")
	self:RegisterBucketEvent("UPDATE_INSTANCE_INFO", 1, "OnEvent")
	self:RegisterBucketEvent("LFG_UPDATE_RANDOM_INFO", 1, "OnEvent")
	self:RegisterBucketEvent("CALENDAR_UPDATE_EVENT_LIST", 1, "OnEvent")
	self:RegisterBucketEvent("TOYS_UPDATED", 1, "OnEvent")
	self:RegisterBucketEvent("COMPANION_UPDATE", 1, "OnEvent")

	if WOW_INTERFACE_VER >= 100000 then
		-- minimum for PLAYER_INTERACTION_MANAGER_FRAME_SHOW/HIDE events
		self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_SHOW", "OnEvent")
		self:RegisterEvent("PLAYER_INTERACTION_MANAGER_FRAME_HIDE", "OnEvent")
	end
end

-- TODO: Move elsewhere/refactor
local function addAttemptForItem(itemName, categoryName)
	if not itemName or not categoryName then
		return
	end

	local Rarity = Rarity

	local group = Rarity.db.profile.groups[categoryName]
	if not group then
		return
	end

	local item = group[itemName]
	if not item then
		return
	end

	if item and type(item) == "table" and item.enabled ~= false and Rarity:IsAttemptAllowed(item) then -- Add one attempt for this item
		if item.attempts == nil then
			item.attempts = 1
		else
			item.attempts = item.attempts + 1
		end
		Rarity:OutputAttempts(item)
	end
end

local function table_contains(haystack, needle)
	if type(haystack) ~= "table" then
		return
	end

	for _, value in pairs(haystack) do
		if value == needle then
			return true
		end
	end
end

local function IsPlayerInHorrificVision()
	return (GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_STORMWIND)
		or (GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_ORGRIMMAR)
end

function R:OnSpellcastSucceeded(event, unitID, castGUID, spellID)
	if unitID ~= "player" then
		return
	end

	if not Rarity.relevantSpells[spellID] then
		return
	end

	R:Debug("OnSpellcastSucceeded triggered with relevant spell " .. spellID)

	if IsPlayerInHorrificVision() and spellID == 312881 then
		self:Debug("Finished searching mailbox in a Horrific Vision")
		addAttemptForItem("Mail Muncher", "mounts")
	end

	if spellID == 430315 then
		addAttemptForItem("Writhing Transmutagen", "pets")
	end

	-- Detects opening on Dirty Glinting Object which may contain Lucy's Lost Collar
	if spellID == 345071 and Rarity.lastNode and Rarity.lastNode == L["Dirty Glinting Object"] then
		Rarity:Debug("Detected Opening on " .. L["Dirty Glinting Object"] .. " (method = SPECIAL)")
		addAttemptForItem("Lucy's Lost Collar", "pets")
	end
end

-- TBD: Move to shared constants?
local TYPE_IDENTIFIER_ITEM = "item" -- What others do they have? currency? gold? No idea.

-- Upvalues
--- WOW API
local GetItemInfoInstant = _G.C_Item.GetItemInfoInstant

function R:OnShowLootToast(
	event,
	typeIdentifier,
	itemLink,
	quantity,
	specID,
	sex,
	personalLootToast,
	toastMethod,
	lessAwesome,
	upgraded,
	corrupted
)
	if typeIdentifier ~= TYPE_IDENTIFIER_ITEM then
		return R:Debug(format("Ignoring loot toast of type %s (not an item)", typeIdentifier))
	end

	-- From wowhead: "\124cff0070dd\124Hitem:187278::::::::60:::::\124h[Talon-Pierced Mawsworn Lockbox]\124h\124r"
	local itemID = GetItemInfoInstant(itemLink)

	-- TBD: Should we generalize this to a LOOT_TOAST detection method? Not sure if there are many other items people would care about
	-- Seems a bit too specialized, since we're detecting the loot toast for one item and then add attempts for another (hacky)
	local TALONPIERCED_MAWSWORN_LOCKBOX = 187278 -- TBD: Move to shared enum for ITEM_IDS? If we ever get to that point, that is...
	local lootToastItems = { [TALONPIERCED_MAWSWORN_LOCKBOX] = "Wilderling Saddle" }

	local linkedItemName = lootToastItems[itemID]
	if not linkedItemName then
		return R:Debug(format("Ignoring loot toast item %s (not relevant)", itemID))
	end

	-- There's only one item, so hardcoding the mounts group isn't an issue (but if we do want to generalize this later, it'll be easy)
	addAttemptForItem(linkedItemName, "items") -- Should take care of the covenant restriction by itself (and not add them if it doesn't match)
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

	-- Check if any coins were used
	for k, v in pairs(self.coins) do
		local currency = GetCurrencyInfo(k)
		local name, currencyAmount = currency.name, currency.quantity
		local diff = currencyAmount - (coinamounts[k] or 0)
		coinamounts[k] = currencyAmount
		if diff < 0 then
			self:Debug("Used coin: " .. name)
			R:CheckForCoinItem()
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 2)
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 5)
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 10)
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 15)
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 20)
			self:ScheduleTimer(function()
				R:CheckForCoinItem()
			end, 25)
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
	[1140] = { "Stormforged Rune" }, -- The Assembly of Iron
	[1133] = { "Blessed Seed" }, -- Freya
	[1135] = { "Ominous Pile of Snow" }, -- Hodir
	[1138] = { "Overcomplicated Controller" }, -- Mimiron
	[1143] = { "Wriggling Darkness" }, -- Yogg-Saron (mount uses the BOSS method and is tracked separately)
	[1500] = { "Celestial Gift" }, -- Elegon
	[1505] = { "Azure Cloud Serpent Egg" }, -- Tsulong
	[1506] = { "Spirit of the Spring" }, -- Lei Shi
	-- 8.3: Horrific Visions
	[2332] = { "Swirling Black Bottle", "Void-Link Frostwolf Collar" }, -- Thrall the Corrupted
	[2338] = { "Swirling Black Bottle", "Voidwoven Cat Collar" }, -- Alleria Windrunner
	[2370] = { "C'Thuffer" }, -- Rexxar
	[2377] = { "Void-Scarred Hare" }, -- Magister Umbric
	[2372] = { "Void-Touched Souvenir Totem", "Box With Faintly Glowing 'Air' Holes" }, -- Oblivion Elemental (Final objective for Zekhan's area)
	[2374] = { 'Box Labeled "Danger: Void Rat Inside"' }, -- Therum Deepforge (Final objective for Kelsey's area)
}

function R:OnEncounterEnd(event, encounterID, encounterName, difficultyID, raidSize, endStatus)
	R:Debug(
		"ENCOUNTER_END with encounterID = "
			.. tonumber(encounterID or "0")
			.. ", name = "
			.. tostring(encounterName)
			.. ", endStatus = "
			.. tostring(endStatus)
	)

	local items = encounterLUT[encounterID]
	if type(items) ~= "table" then
		-- Not a relevant encounter
		return
	end
	for _, item in ipairs(items) do
		if item and type(item) == "string" then -- This encounter has an entry in the LUT and needs special handling
			R:Debug("Found item of interest for this encounter: " .. tostring(item))
			local v = self.db.profile.groups.pets[item]
				or self.db.profile.groups.items[item]
				or self.db.profile.groups.mounts[item]
			-- v = value = number of attempts for this item

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
		-- if R:InTooltip() then Rarity:ShowTooltip() end

		self:CancelTimer(timer1, true)
		self:CancelTimer(timer2, true)
		self:CancelTimer(timer3, true)
		self:CancelTimer(timer4, true)
		self:CancelTimer(timer5, true)
		self:CancelTimer(timer6, true)

		self:ScanStatistics(event)

		timer1 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 1")
		end, 2)
		timer2 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 2")
		end, 5)
		timer3 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 3")
		end, 8)
		timer4 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 4")
		end, 10)
		timer5 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 5")
		end, 15)
		timer6 = self:ScheduleTimer(function()
			Rarity:ScanStatistics(event .. " 6")
		end, 20)
	end
end

-------------------------------------------------------------------------------------
-- Handle boss kills. You may not ever open a loot window on a boss, so we need to watch the combat log for its death.
-- This event also handles some special cases.
-------------------------------------------------------------------------------------
function R:OnCombat()
	-- Extract event payload (it's no longer being passed by the event iself as of 8.0.1)
	local timestamp, eventType, hideCaster, srcGuid, srcName, srcFlags, srcRaidFlags, dstGuid, dstName, dstFlags, dstRaidFlags, spellId, spellName, spellSchool, auraType =
		CombatLogGetCurrentEventInfo()

	if eventType == "UNIT_DIED" then -- A unit died near you
		local npcid = self:GetNPCIDFromGUID(dstGuid)
		if Rarity.bosses[npcid] then -- It's a boss we're interested in
			R:Debug("Detected UNIT_DIED for relevant NPC with ID = " .. tostring(npcid))
			if
				bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE)
				or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY)
				or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID)
			then -- You, a party member, or a raid member killed it
				if not Rarity.guids[dstGuid] then
					if not UnitAffectingCombat("player") and not UnitIsDead("player") then
						Rarity:Debug("Ignoring this UNIT_DIED event because the player is alive, but not in combat")
						return
					end

					-- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
					if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
						for k, v in pairs(Rarity.npcs_to_items[npcid]) do
							local isBossDrop = (v.method == CONSTANTS.DETECTION_METHODS.BOSS)
							local hasKillStatistics = type(v.statisticId) ~= "nil"
							if v.enabled ~= false and isBossDrop and not hasKillStatistics then
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

local worldEventQuests = {
	[52196] = "Slightly Damp Pile of Fur", -- Dunegorger Kraulok
	[70867] = "Everlasting Horn of Lavaswimming", -- Scalebane Keep (scenario completion)
}

function R:OnQuestTurnedIn(event, questID, experience, money)
	self:Debug(
		"OnQuestTurnedIn triggered with ID = " .. questID .. ", experience = " .. experience .. ", money = " .. money
	)

	local relevantItem = worldEventQuests[questID]
	if not relevantItem then
		return
	end
	self:Debug(format("Relevant quest turnin detected for item %s (questID = %d)", questID, relevantItem))

	local v = self.db.profile.groups.items[relevantItem]
		or self.db.profile.groups.pets[relevantItem]
		or self.db.profile.groups.mounts[relevantItem]
	if v and type(v) == "table" and v.enabled ~= false then
		if v.attempts == nil then
			v.attempts = 1
		else
			v.attempts = v.attempts + 1
		end
		self:OutputAttempts(v)
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
	[2124] = "Crestfall",
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
	"Stonehide Elderhorn",
}

function R:OnIslandCompleted(event, mapID, winner)
	R:Debug(
		"Detected completion for Island Expedition: "
			.. (islandMapIDs[mapID] or "Unknown Map")
			.. " (mapID = "
			.. tostring(mapID)
			.. ")"
	)

	if islandMapIDs[mapID] then -- Is a relevant map -> Add attempts for all collectibles
		-- (for now, I'm assuming they just drop from everything at the same rate.
		-- This may have to be revised once more data is available...)
		-- Update: Proper tracking seems night on impossible so this'll have to do for the time being
		-- See https://github.com/SacredDuckwhale/Rarity/issues/61 for more details
		R:Debug("Found this Island Expedition to be relevant -> Adding attempts for all known collectibles...")

		for index, name in pairs(islandExpeditionCollectibles) do -- Add an attempt for each item
			local v = self.db.profile.groups.items[name]
				or self.db.profile.groups.pets[name]
				or self.db.profile.groups.mounts[name]
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

local timewalkingCriteriaLUT = {
	[24801] = "Ozumat", -- Legacy (seems to no longer work? Perhaps the criterion ID was changed...)
	[34414] = "Ozumat", -- Timewalking difficulty only? (need to test)
	[24784] = "Trial of the King", -- [126952] = "Trial of the King", -- Object: Legacy of the Clan Leaders
	[19244] = "Master Snowdrift", -- [123096] = "Master Snowdrift", -- Object: Snowdrift's Possessions
	[34410] = "Taran Zhu", -- [123095] = "Taran Zhu", -- Object: Taran Zhu's Personal Stash
}

local timeRiftCriteriaLUT = {
	[60685] = "Gill'dan (Azmerloth)",
	[60688] = "Freya (Ulderoth)",
	[60689] = "The Lich King (Azmourne)",
	[60690] = "Illidan Stormrage (Azewrath)",
	[60691] = "Fury of N'zoth (Azq'roth)",
	[60692] = "Varian Wrynn (The Warlands)",
	[60693] = "Overlord Mechagon (A.Z.E.R.O.T.H.)",
}

local timeRiftMounts = {
	"Felstorm Dragon",
	"Gold-Toed Albatross",
	"Perfected Juggernaut",
	"Reins of the Scourgebound Vanquisher",
	"Sulfur Hound's Leash",
}

local timeRiftPets = {
	"Briarhorn Hatchling",
	"Doomrubble",
	"Gill'dan",
	"Jeepers",
	"Killbot 9000",
	"N'Ruby",
	"Obsidian Warwhelp",
}

function R:OnCriteriaComplete(event, id)
	local timewalkingEncounterName = timewalkingCriteriaLUT[id]
	local timeRiftEncounterName = timeRiftCriteriaLUT[id]
	R:Debug("Detected achievement criteria completion: " .. tostring(id))
	if timewalkingEncounterName then
		R:Debug("Completed criteria for Timewalking encounter: " .. tostring(timewalkingEncounterName))
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

	if timeRiftEncounterName then
		R:Debug("Completed criteria for Time Rift encounter: " .. timeRiftEncounterName)
		self:OnTimeRiftCompleted()
	end
end

function R:OnTimeRiftCompleted()
	if self.Caching:IsAlliance() then
		local itemName = "Reins of the Ravenous Black Gryphon"
		addAttemptForItem(itemName, "mounts")
	else
		local itemName = "Horn of the White War Wolf"
		addAttemptForItem(itemName, "mounts")
	end

	for _, itemName in ipairs(timeRiftMounts) do
		addAttemptForItem(itemName, "mounts")
	end

	for _, itemName in ipairs(timeRiftPets) do
		addAttemptForItem(itemName, "pets")
	end
end

-------------------------------------------------------------------------------------
-- Mouseover detection, currently used for Mysterious Camel Figurine as a special case
-------------------------------------------------------------------------------------

function R:OnMouseOver(event)
	local guid = UnitGUID("mouseover")
	local npcid = self:GetNPCIDFromGUID(guid)

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

function R:OnProfileChanged(event, database, newProfileKey)
	self:Debug("Profile changed. Reinitializing.")
	Rarity.Session:Cancel()

	local sessionTimer = Rarity.Session:GetTimer()
	if sessionTimer then
		self:CancelTimer(sessionTimer, true)
	end
	Rarity.Session:SetTimer(nil)
	self.db:RegisterDefaults(self.defaults)
	self:UpdateInterestingThings()
	self:OnCurrencyUpdate(event)
	self:ScanAllArch(event)
	Rarity.Collections:ScanExistingItems(event)
	self:ScanBags()
	Rarity.Tracking:FindTrackedItem()
	Rarity.GUI:UpdateText()
	self.db.profile.lastRevision = R.MINOR_VERSION
end

function R:OnChatCommand(input)
	if strlower(input) == "debug" then
		if self.db.profile.debugMode then
			self.db.profile.debugMode = false
			self:Print(L["Debug mode OFF"])
		else
			self.db.profile.debugMode = true
			self:Print(L["Debug mode ON"])
		end
	elseif strlower(input) == "dump" then
		self.ScrollingDebugMessageFrame:Toggle()
	elseif strlower(input) == "validate" then -- Verify the ItemDB
		self.Validation:ValidateItemDB()
	elseif strlower(input) == "mapinfo" then
		local mapID = C_Map.GetBestMapForUnit("player")
		local mapInfo = C_Map.GetMapInfo(mapID)
		local mapName = mapInfo and mapInfo.name or "Unknown"
		self:Print("Current map: " .. mapID .. " ~ " .. mapName)
	elseif strlower(input) == "purge" then -- TODO: This should be done automatically, no?
		self.Database:PurgeObsoleteEntries()
	elseif strlower(input) == "progress" then
		self.GUI:ToggleProgressBar()
	elseif strlower(input) == "test" then
		self.Testing:RunIntegrationTests()
	elseif strlower(input) == "profiling" then
		if self.db.profile.enableProfiling then
			self.db.profile.enableProfiling = false
			self:Print(L["Profiling OFF"])
		else
			self.db.profile.enableProfiling = true
			self:Print(L["Profiling ON"])
		end
	elseif strlower(input) == "tinspect" then --  TODO Document it?
		Rarity.Profiling:InspectAccumulatedTimes()
	else
		LoadAddOn("Rarity_Options")
		if R.optionsFrame then
			Settings.OpenToCategory("Rarity")
		else
			self:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		end
	end
end

function R:OnItemFound(itemId, item)
	if item.found and not item.repeatable then
		return
	end

	local playerClass = select(2, UnitClass("player"))
	if item.disableForClass and item.disableForClass[playerClass] then
		Rarity:Debug(format("Ignoring OnItemFound trigger for item %s (disabled for class %s)", item.name, playerClass))
		return
	end

	self:Debug("FOUND ITEM %d!", itemId)
	if item.attempts == nil then
		item.attempts = 1
	end
	if item.lastAttempts == nil then
		item.lastAttempts = 0
	end

	-- Hacky: If the item is unique and has 0 attempts, don't do this (if you really find a unique item on your first attempt, sorry)
	if item.unique and item.attempts - item.lastAttempts <= 1 then
		return
	end

	self:ShowFoundAlert(itemId, item.attempts - item.lastAttempts, item, item)
	if Rarity.Session:IsActive() then
		Rarity.Session:End()
	end
	item.realAttempts = item.attempts - item.lastAttempts
	item.lastAttempts = item.attempts
	item.enabled = false
	item.found = true
	item.totalFinds = (item.totalFinds or 0) + 1
	if not item.finds then
		item.finds = {}
	end
	local count = 0
	for k, v in pairs(item.finds) do
		count = count + 1
	end
	table.insert(item.finds, {
		num = count + 1,
		totalAttempts = item.attempts,
		totalTime = item.time,
		attempts = item.realAttempts,
		time = (item.time or 0) - (item.lastTime or 0),
	})
	item.lastTime = item.time
	Rarity.Tracking:Update(item)
	self:UpdateInterestingThings()
	if item.repeatable then
		self:ScheduleTimer(function()
			-- If this is a repeatable item, turn it back on in a few seconds.
			-- OnItemFound() gets called repeatedly when we get an item, so we need to lock it out for a few seconds.
			item.enabled = nil
			item.found = nil
			self:UpdateInterestingThings()
			Rarity.GUI:UpdateText()
		end, 5)
	end
end

local FISHING_DELAY = 22

function R:OnSpellcastSent(event, unit, target, castGUID, spellID)
	if unit ~= "player" then
		return
	end
	Rarity.foundTarget = false
	-- ga = "No" -- WTF is this?

	if Rarity.relevantSpells[spellID] then -- An entry exists for this spell in the LUT -> It's one that needs to be tracked
		Rarity:Debug(
			"Detected relevant spell: " .. tostring(spellID) .. " ~ " .. tostring(Rarity.relevantSpells[spellID])
		)
		Rarity.currentSpell = spellID
		Rarity.previousSpell = spellID
		if Rarity.relevantSpells[spellID] == "Fishing" or Rarity.relevantSpells[spellID] == "Opening" then
			self:Debug("Fishing or opening something")
			if Rarity.relevantSpells[spellID] == "Opening" then
				self:Debug("Opening detected")
				Rarity.isOpening = true
			else
				Rarity.isOpening = false
			end
			Rarity.isFishing = true
			if Rarity.fishingTimer then
				self:CancelTimer(Rarity.fishingTimer, true)
			end
			Rarity.fishingTimer = self:ScheduleTimer(Rarity.OnFishingEnded, FISHING_DELAY)
			self:GetWorldTarget()
		end
	else
		Rarity.previousSpell, Rarity.currentSpell = nil, nil
	end
end

function R:OnFishingEnded()
	R:Debug("You didn't loot anything from that fishing. Giving up.")
	Rarity.fishingTimer = nil
	Rarity.isFishing = false
	Rarity.isPool = false
	Rarity.isOpening = false
end

function R:OnLootFrameClosed(event)
	Rarity.previousSpell, Rarity.currentSpell = nil, nil
	Rarity.foundTarget = false
	self:ScheduleTimer(function()
		Rarity.lastNode = nil
	end, 1)
end

local tooltipLeftText1 = _G["GameTooltipTextLeft1"]

local function stripColorCode(input)
	local output = input or ""
	output = gsub(output, "|c%x%x%x%x%x%x%x%x", "")
	output = gsub(output, "|r", "")
	return output
end

function R:OnCursorChanged(event)
	if Rarity.foundTarget then
		return
	end
	if MinimapCluster:IsMouseOver() then
		return
	end
	local t = stripColorCode(tooltipLeftText1:GetText())
	if self.miningnodes[t] or self.fishnodes[t] or self.opennodes[t] then
		Rarity.lastNode = t
		Rarity:Debug("OnCursorChanged found lastNode = " .. tostring(t))
	end
	if Rarity.relevantSpells[Rarity.previousSpell] then
		self:GetWorldTarget()
	end
end

-- Doesn't really belong here, but no idea where to put it right now. Later...
function R:GetWorldTarget()
	if Rarity.foundTarget or not Rarity.relevantSpells[Rarity.currentSpell] then
		return
	end
	if MinimapCluster:IsMouseOver() then
		return
	end
	local t = tooltipLeftText1:GetText()
	Rarity:Debug("Getting world target " .. tostring(t))
	if t and Rarity.previousSpell and t ~= Rarity.previousSpell and R.fishnodes[t] then
		self:Debug("------YOU HAVE STARTED FISHING A NODE ------")
		Rarity.isFishing = true
		Rarity.isPool = true
		if Rarity.fishingTimer then
			self:CancelTimer(Rarity.fishingTimer, true)
		end
		Rarity.fishingTimer = self:ScheduleTimer(Rarity.OnFishingEnded, FISHING_DELAY)
		Rarity.foundTarget = true
	end
end

function R:OnSpellcastStopped(event, unit)
	if unit ~= "player" then
		return
	end
	if Rarity.relevantSpells[Rarity.previousSpell] then
		self:GetWorldTarget()
	end
	Rarity.previousSpell, Rarity.currentSpell = Rarity.currentSpell, Rarity.currentSpell
end

function R:OnSpellcastFailed(event, unit)
	if unit ~= "player" then
		return
	end
	Rarity.previousSpell, Rarity.currentSpell = nil, nil
end

-------------------------------------------------------------------------------------
-- Something in your bags changed.
--
-- This is used for a couple things. First, for boss drops that require a group, you may not have obtained the item even if it dropped from the boss.
-- Therefore, we only say you obtained it when it appears in your inventory. Secondly, this is useful as a second line of defense in case
-- you somehow obtain an item without us noticing it. This event fires a lot, so we need to be fast.
--
-- We also store how many of every item you have on you at the moment. If we notice an item decreasing in quantity, and it's something we care
-- about, you just used an item or opened a container.
--
-- This event is bucketed because it tends to fire tons of times in a row rapidly, leading to innaccurate results.
-------------------------------------------------------------------------------------
local table_wipe = table.wipe -- Nonstandard, but always exists in WOW's Lua environment

function R:BackUpInventoryItemAmounts()
	table_wipe(Rarity.tempbagitems)
	for itemID, inventoryAmount in pairs(Rarity.bagitems) do
		Rarity.tempbagitems[itemID] = inventoryAmount
	end
end

function R:ProcessContainerItems()
	for k, v in pairs(Rarity.tempbagitems) do
		if (Rarity.bagitems[k] or 0) < (Rarity.tempbagitems[k] or 0) then -- An inventory item went down in count or disappeared
			if Rarity.used[k] then -- It's an item we care about
				-- Scan through the whole item database now to find all items that could want this
				for _k, _v in pairs(self.db.profile.groups) do
					if type(_v) == "table" then
						for kk, vv in pairs(_v) do
							if type(vv) == "table" then
								if vv.enabled ~= false then
									if
										vv.method == CONSTANTS.DETECTION_METHODS.USE
										and vv.items ~= nil
										and type(vv.items) == "table"
									then
										local isHordePlayer = R.Caching:IsHorde()
										local canPlayerObtainFactionSpecificItem = not (
												vv.requiresHorde and not isHordePlayer
											) or (vv.requiresAlliance and isHordePlayer)
										if canPlayerObtainFactionSpecificItem then
											for kkk, vvv in pairs(vv.items) do
												if vvv == k then
													local i = vv
													if i.attempts == nil then
														i.attempts = 1
													else
														i.attempts = i.attempts + 1
													end
													self:OutputAttempts(i)
												end
											end
										end
									end
								end
							end
						end
					end
				end
				-- End scan through all items
			end
		end
	end
end

function R:ProcessInventoryItems()
	for itemID, _ in pairs(Rarity.bagitems) do
		self:ProcessCollectionItem(itemID)
		self:ProcessOtherItem(itemID)
	end
end

function R:ProcessCollectionItem(itemID)
	if not itemID then
		return
	end

	local item = Rarity.items[itemID]
	if not item then
		return
	end

	-- Handle collection items
	if not self:IsCollectionItem(item) then
		return
	end

	local inventoryItemCount = R:GetInventoryItemCount(itemID)

	-- Our items hashtable only saves one item for this collected item, so we have to scan to find them all now.
	-- Earlier, we pre-built a list of just the items that are COLLECTION items to save some time here.
	for collectionItemID, collectionItem in pairs(Rarity.collection_items) do
		-- This item is a collection of several items; add them all up and check for attempts
		if self:HasMultipleCollectionItems(collectionItem) then
			self:ProcessCollectionItemAggregate(collectionItem)
		else
			self:ProcessCollectionItemSingle(collectionItem, itemID)
		end
	end
end

function R:HasMultipleCollectionItems(item)
	return type(item.collectedItemId) == "table"
end

-- TODO: DRY
function R:IsCollectionItem(item)
	return item.method == CONSTANTS.DETECTION_METHODS.COLLECTION
end

function R:ProcessOtherItem(itemID)
	if not itemID then
		return
	end

	local item = Rarity.items[itemID]
	if not item then
		return
	end

	local amountIncreasedSinceLastScan = (Rarity.bagitems[itemID] or 0) > (Rarity.tempbagitems[itemID] or 0)
	if amountIncreasedSinceLastScan then -- An inventory item went up in count
		if item and item.enabled ~= false and not self:IsCollectionItem(item) then
			self:OnItemFound(itemID, item)
		end
	end
end

function R:GetInventoryItemCount(itemID)
	local inventoryItemCount = (Rarity.bagitems[itemID] or 0)
	return inventoryItemCount
end

-- Still incomprehensible, but I'll leave it for now
function R:ProcessCollectionItemSingle(collectionItem, itemID)
	local inventoryItemCount = self:GetInventoryItemCount(itemID)
	local item = Rarity.items[itemID]

	if
		collectionItem.enabled
		and (
			collectionItem.collectedItemId == item.collectedItemId
			or table_contains(item.collectedItemId, collectionItem.collectedItemId)
		)
	then
		local originalCount = (collectionItem.attempts or 0)
		local goal = (collectionItem.chance or 100)
		collectionItem.lastAttempts = 0
		if collectionItem.attempts ~= inventoryItemCount then
			collectionItem.attempts = inventoryItemCount
		end
		if originalCount < inventoryItemCount and originalCount < goal and inventoryItemCount >= goal then
			self:OnItemFound(collectionItem.itemId, collectionItem)
		elseif originalCount < inventoryItemCount then
			self:OutputAttempts(collectionItem)
		end
	end
end

-- Still incomprehensible, but I'll leave it for now
function R:ProcessCollectionItemAggregate(collectionItem)
	if collectionItem.enabled ~= false then
		local total = 0
		local originalCount = (collectionItem.attempts or 0)
		local goal = (collectionItem.chance or 100)
		for kkk, vvv in pairs(collectionItem.collectedItemId) do
			vvv = tonumber(vvv) -- It's stored as string, but we expect numbers...
			if (Rarity.bagitems[vvv] or 0) > 0 then
				total = total + Rarity.bagitems[vvv]
			end
		end
		if total > originalCount then
			self:Debug("Total is > original count, overriding current attempts")
			collectionItem.attempts = total
			if originalCount < goal and total >= goal then
				self:Debug("Triggering OnItemFound since we just reached the goal")
				self:OnItemFound(collectionItem.itemId, collectionItem)
			elseif total > originalCount then
				self:Debug("Triggering OutputAttempts since we gained one item, but didn't reach the goal")
				self:OutputAttempts(collectionItem)
			end
		end
	end
end

-- It's an abomination, but without tests I'm not refactoring this any further
function R:OnBagUpdate()
	-- Save a copy of your bags before this event
	R:BackUpInventoryItemAmounts()

	-- Get a list of the items you have now, alerting if we find anything we're looking for
	self:ScanBags()

	-- I assume that if there's even the feintest possibility of items being removed, we don't want to risk it?
	local shouldSkipBagUpdate = (
		Rarity.isBankOpen
		or Rarity.isGuildBankOpen
		or Rarity.isAuctionHouseOpen
		or Rarity.isTradeWindowOpen
		or Rarity.isTradeskillOpen
		or Rarity.isMailboxOpen
	)

	if shouldSkipBagUpdate then
		return
	end

	-- Check for a decrease in quantity of any items we're watching for
	R:ProcessContainerItems()

	-- Check for an increase in quantity of any items we're watching for
	R:ProcessInventoryItems()
end

function R:OnResearchArtifactComplete(event, _)
	self:ScanArchFragments(event)
end

-- 10.x added events PLAYER_INTERACTION_MANAGER_FRAME_HIDE and PLAYER_INTERACTION_MANAGER_FRAME_SHOW
-- which currently fire either in addition to, or instead of, older events like MAIL_SHOW or MAIL_CLOSED.
-- This maps new events onto old ones, so there's just one (old-style) event to check against.
-- (Note many PlayerInteractionTypes are defined but not all are necessarily used; we add the ones most
-- likely to be relevant here, whether currently being triggered or not.)

local EventRemapping = {
	["PLAYER_INTERACTION_MANAGER_FRAME_HIDE"] = {
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.Banker or ""] = "BANKFRAME_CLOSED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.GuildBanker or ""] = "GUILDBANKFRAME_CLOSED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.Auctioneer or ""] = "AUCTION_HOUSE_CLOSED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.TradePartner or ""] = "TRADE_CLOSED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.MailInfo or ""] = "MAIL_CLOSED",
	},
	["PLAYER_INTERACTION_MANAGER_FRAME_SHOW"] = {
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.Banker or ""] = "BANKFRAME_OPENED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.GuildBanker or ""] = "GUILDBANKFRAME_OPENED",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.Auctioneer or ""] = "AUCTION_HOUSE_SHOW",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.TradePartner or ""] = "TRADE_SHOW",
		[Enum and Enum.PlayerInteractionType and Enum.PlayerInteractionType.MailInfo or ""] = "MAIL_SHOW",
	},
}

function R:OnEvent(event, ...)
	-- do EventRemapping if appropriate
	local param1 = select(1, ...)
	if EventRemapping[event] and EventRemapping[event][param1] then
		event = EventRemapping[event][param1]
	end

	if event == "BANKFRAME_OPENED" then
		Rarity.isBankOpen = true
	elseif event == "GUILDBANKFRAME_OPENED" then
		Rarity.isGuildBankOpen = true
	elseif event == "AUCTION_HOUSE_SHOW" then
		Rarity.isAuctionHouseOpen = true
	elseif event == "TRADE_SHOW" then
		Rarity.isTradeWindowOpen = true
	elseif event == "TRADE_SKILL_SHOW" then
		Rarity.isTradeskillOpen = true
	elseif event == "MAIL_SHOW" then
		Rarity.isMailboxOpen = true
	elseif event == "BANKFRAME_CLOSED" then
		Rarity.isBankOpen = false
	elseif event == "GUILDBANKFRAME_CLOSED" then
		Rarity.isGuildBankOpen = false
	elseif event == "AUCTION_HOUSE_CLOSED" then
		Rarity.isAuctionHouseOpen = false
	elseif event == "TRADE_CLOSED" then
		Rarity.isTradeWindowOpen = false
	elseif event == "TRADE_SKILL_CLOSE" then
		Rarity.isTradeskillOpen = false
	elseif event == "MAIL_CLOSED" then
		Rarity.isMailboxOpen = false
	elseif event == "UPDATE_INSTANCE_INFO" then
		-- Instance lock info updated
		self:ScanInstanceLocks(event)
	elseif event == "LFG_UPDATE_RANDOM_INFO" then
		self:ScanInstanceLocks(event)
	elseif event == "CALENDAR_UPDATE_EVENT_LIST" then
		-- Calendar updated
		self:ScanCalendar(event)
	elseif event == "TOYS_UPDATED" then
		-- Toy box updated
		Rarity.Collections:ScanExistingItems(event)
	elseif event == "COMPANION_UPDATE" then
		-- Pets updated
		Rarity.Collections:ScanExistingItems(event)
	elseif event == "PLAYER_LOGOUT" then
		-- Logging out; end any open session
		if Rarity.Session:IsActive() then
			Rarity.Session:End()
		end
	end
end

-------------------------------------------------------------------------------------
-- You opened a loot window on a corpse or fishing node
-------------------------------------------------------------------------------------
function R:OnLootReady(event, ...)
	do
		self:Debug("LOOT_READY with target: " .. (UnitGUID("target") or "NO TARGET"))

		-- Two LOOT_READY events may trigger when the loot window opens, in which case this prevents double counting
		if self.Session:IsLocked() then
			self:Debug("Session is locked; ignoring this LOOT_READY event")
			return
		end

		self.Session:Lock()

		if Rarity.isBankOpen then
			Rarity:Debug("Ignoring this LOOT_READY event (bank is open)")
			return
		end

		if Rarity.isGuildBankOpen then
			Rarity:Debug("Ignoring this LOOT_READY event (guild bank is open)")
			return
		end

		if Rarity.isMailboxOpen then
			Rarity:Debug("Ignoring this LOOT_READY event (mailbox is open)")
			return
		end

		if Rarity.isAuctionHouseOpen then
			Rarity:Debug("Ignoring this LOOT_READY event (auction house is open)")
			return
		end

		if Rarity.isTradeWindowOpen then
			Rarity:Debug("Ignoring this LOOT_READY event (trade window is open)")
			return
		end

		local zone = GetRealZoneText()
		local subzone = GetSubZoneText()
		local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
		local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]

		if Rarity.isFishing and Rarity.isOpening then
			self:Debug("Opened something")
		end

		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode then
			self:Debug("Opened a node: " .. Rarity.lastNode)
		end

		-- Handle opening Crane Nest
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Crane Nest"]) then
			Rarity:Debug("Detected Opening on " .. L["Crane Nest"] .. " (method = SPECIAL)")
			local v = self.db.profile.groups.pets["Azure Crane Chick"]
			if v and type(v) == "table" and v.enabled ~= false then
				if v.attempts == nil then
					v.attempts = 1
				else
					v.attempts = v.attempts + 1
				end
				self:OutputAttempts(v)
			end
		end

		-- Handle opening Timeless Chest
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Timeless Chest"]) then
			Rarity:Debug("Detected Opening on " .. L["Timeless Chest"] .. " (method = SPECIAL)")
			local v = self.db.profile.groups.pets["Bonkers"]
			if v and type(v) == "table" and v.enabled ~= false then
				if v.attempts == nil then
					v.attempts = 1
				else
					v.attempts = v.attempts + 1
				end
				self:OutputAttempts(v)
			end
		end

		-- Handle opening Snow Mound
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Snow Mound"])
			and GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.FROSTFIRE_RIDGE
		then -- Make sure we're in Frostfire Ridge (there are Snow Mounds in other zones, particularly Ulduar in the Hodir room)
			Rarity:Debug("Detected Opening on " .. L["Snow Mound"] .. " (method = SPECIAL)")
			local v = self.db.profile.groups.pets["Grumpling"]
			if v and type(v) == "table" and v.enabled ~= false then
				if v.attempts == nil then
					v.attempts = 1
				else
					v.attempts = v.attempts + 1
				end
				self:OutputAttempts(v)
			end
		end

		-- Handle opening Curious Wyrmtongue Cache
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Curious Wyrmtongue Cache"])
		then
			local names = { "Scraps", "Pilfered Sweeper" }
			Rarity:Debug("Detected Opening on " .. L["Curious Wyrmtongue Cache"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Glimmering Chest
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Glimmering Chest"]) then
			local names = { "Sandclaw Nestseeker" }
			Rarity:Debug("Detected Opening on " .. L["Glimmering Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Penitence of Purity (Shadowlands Kyrian only chest)
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Penitence of Purity"])
		then
			local names = { "Phalynx of Humility" }
			Rarity:Debug("Detected Opening on " .. L["Penitence of Purity"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.mounts[name]
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

		-- Handle opening Silver Strongbox & Gilded Chest (Bastion, Shadowlands nodes for Acrobatic Steward (toy) and Gilded Wader (pet))
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Silver Strongbox"] or Rarity.lastNode == L["Gilded Chest"])
		then
			local names = { "Acrobatic Steward", "Gilded Wader" }
			Rarity:Debug("Detected Opening on " .. Rarity.lastNode .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Broken Bell & Skyward Bell (Shadowlands, Bastion nodes for Soothing Vesper (toy) & Gilded Wader (pet))
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Broken Bell"] or Rarity.lastNode == L["Skyward Bell"])
		then
			local names = { "Soothing Vesper", "Gilded Wader" }
			Rarity:Debug("Detected Opening on " .. Rarity.lastNode .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Cache of the Ascended (Shadowlands, Bastion mount cache)
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Cache of the Ascended"])
		then
			local names = { "Ascended Skymane" }
			Rarity:Debug("Detected Opening on " .. L["Cache of the Ascended"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.mounts[name]
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

		-- Handle opening Slime-Coated Crate (Shadowlands, Maldraxxus crate for Kevin's Party Supplies (toy) & Bubbling Pustule (pet))
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Slime-Coated Crate"])
		then
			local names = { "Kevin's Party Supplies", "Bubbling Pustule" }
			Rarity:Debug("Detected Opening on " .. L["Slime-Coated Crate"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Sprouting Growth (Shadowlands, Maldraxxus crate for Skittering Venomspitter pet)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Sprouting Growth"]) then
			local names = { "Skittering Venomspitter" }
			Rarity:Debug("Detected Opening on " .. L["Sprouting Growth"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Stewart's Stewpendous Stew (Shadowlands, Bastion crate for Silvershell Snapper pet)
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Stewart's Stewpendous Stew"])
		then
			local names = { "Silvershell Snapper" }
			Rarity:Debug("Detected Opening on " .. L["Stewart's Stewpendous Stew"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Bleakwood Chest (Shadowlands, Revendreth chest for Trapped Stonefiend pet)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Bleakwood Chest"]) then
			local names = { "Trapped Stonefiend" }
			Rarity:Debug("Detected Opening on " .. L["Bleakwood Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Blackhound Cache (Shadowlands, Maldraxxus cache for Battlecry of Krexus - Necrolord toy)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Blackhound Cache"]) then
			local names = { "Battlecry of Krexus" }
			Rarity:Debug("Detected Opening on " .. L["Blackhound Cache"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Secret Treasure (Shadowlands, Revendreth chest for Soullocked Sinstone pet)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Secret Treasure"]) then
			local names = { "Soullocked Sinstone" }
			Rarity:Debug("Detected Opening on " .. L["Secret Treasure"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Forgotten Chest (Shadowlands, Revendreth chest for Stony's Infused Ruby pet and Silessa's Battle Harness mount)
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Forgotten Chest"])
			and GetBestMapForUnit("player") ~= CONSTANTS.UIMAPIDS.STORMSONG_VALLEY -- Chest with the same name in Stormsong Valley
		then
			local names = { "Stony's Infused Ruby", "Silessa's Battle Harness" }
			Rarity:Debug("Detected Opening on " .. L["Forgotten Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.pets[name] or self.db.profile.groups.mounts[name]
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

		-- Handle opening Cache of Eyes (Shadowlands, Maldraxxus chest for Luminous Webspinner pet)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Cache of Eyes"]) then
			local names = { "Luminous Webspinner" }
			Rarity:Debug("Detected Opening on " .. L["Cache of Eyes"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening lots of various chests for Gilded Wader (pet).
		local nodesGildedWader = {
			[L["Gift of Thenios"]] = true,
			[L["Hidden Hoard"]] = true,
			[L["Memorial Offerings"]] = true,
			[L["Treasure of Courage"]] = true,
		}
		local isRelevantNode = false
		if Rarity.lastNode then
			isRelevantNode = nodesGildedWader[Rarity.lastNode]
		end
		if Rarity.isFishing and Rarity.isOpening and isRelevantNode then
			local names = { "Gilded Wader" }
			Rarity:Debug("Detected Opening on " .. Rarity.lastNode .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.pets[name]
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

		-- Handle opening Zovaal's Vault (The Maw, Shadowlands treasure for Personal Ball and Chain & Jailer's Cage
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Zovaal's Vault"]) then
			local names = { "Personal Ball and Chain", "Jailer's Cage" }
			Rarity:Debug("Detected Opening on " .. L["Zovaal's Vault"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name]
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

		-- Handle opening Pile of Coins
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Pile of Coins"]) then
			local names = { "Armored Vaultbot" }
			Rarity:Debug("Detected Opening on " .. L["Pile of Coins"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.pets[name]
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

		-- Handle opening Glimmering Treasure Chest
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Glimmering Treasure Chest"])
			and select(8, GetInstanceInfo()) == 1626
		then -- Player is in Withered Army scenario and looted the reward chest
			local bigChest = false
			for _, slot in pairs(GetLootInfo()) do
				if slot.item == L["Ancient Mana"] and slot.quantity == 100 then
					bigChest = true
				end
			end

			if bigChest == true then
				self:Debug("Detected " .. Rarity.lastNode .. ": Adding toy drop attempts")
				local names = {
					"Arcano-Shower",
					"Displacer Meditation Stone",
					"Kaldorei Light Globe",
					"Unstable Powder Box",
					"Wisp in a Bottle",
					"Ley Spider Eggs",
				}
				for _, name in pairs(names) do
					local v = self.db.profile.groups.items[name]
					if v and type(v) == "table" and v.enabled ~= false then
						if v.attempts == nil then
							v.attempts = 1
						else
							v.attempts = v.attempts + 1
						end
						self:OutputAttempts(v)
					end
				end

				local v = self.db.profile.groups.mounts["Torn Invitation"]
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

		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Mawsworn Supply Chest"])
		then
			local names = { "Spectral Mawrat's Tail" }
			Rarity:Debug("Detected Opening on " .. L["Mawsworn Supply Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name] or self.db.profile.groups.mounts[name]
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

		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Sandworn Chest"]) then
			local names = { "Makaris's Satchel of Mines" }
			Rarity:Debug("Detected Opening on " .. L["Sandworn Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name]
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

		-- Handle opening Expedition Scout's Pack (Verdant Skitterfly mount in Dragonflight)
		if
			Rarity.isFishing
			and Rarity.isOpening
			and Rarity.lastNode
			and (Rarity.lastNode == L["Expedition Scout's Pack"])
		then
			local names = { "Verdant Skitterfly" }
			Rarity:Debug("Detected Opening on " .. L["Expedition Scout's Pack"] .. " (method = SPECIAL)")
			-- This mount has a prerequisite to drop. Renown 25 with Dragonscale Expedition
			if GetCurrentRenownLevel(CONSTANTS.FACTION_IDS.DRAGONSCALE_EXPEDITION) >= 25 then
				for _, name in pairs(names) do
					local v = self.db.profile.groups.mounts[name]
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

		if Rarity.isOpening and Rarity.lastNode and Rarity.lastNode == L["Awakened Cache"] then
			Rarity:Debug("Detected Opening on " .. Rarity.lastNode .. " (method = SPECIAL)")
			addAttemptForItem("Machine Defense Unit 1-11", "mounts")
		end

		-- Handle opening Opera Chest (Holoviewers)
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and (Rarity.lastNode == L["Opera Chest"]) then
			local names = { "Holoviewer: The Timeless One", "Holoviewer: The Lady of Dreams" }
			Rarity:Debug("Detected Opening on " .. L["Opera Chest"] .. " (method = SPECIAL)")
			for _, name in pairs(names) do
				local v = self.db.profile.groups.items[name]
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

		-- Handle opening various chests in Zskera Vaults
		local vaultPets = {
			"Bunbo",
			"Berylmane",
			"Brightfeather",
		}
		local vaultToys = {
			"Obsidian Battle Horn",
		}
		local vaultChests = {
			[L["Chain-Bound Strongbox"]] = true,
			[L["Crystal Basket"]] = true,
			[L["Hardened Chest"]] = true,
			[L["Mindless Slime"]] = true,
			[L["Searing Chest"]] = true,
			[L["Hardened Strongbox"]] = true,
			[L["Cart of Crushed Stone"]] = true,
			[L["Hardshell Chest"]] = true,
			[L["Titan Coffer"]] = true,
			[L["Void-Bound Strongbox"]] = true,
			[L["Inert Goo"]] = true,
			[L["Mysterious Chest"]] = true,
			[L["Supply Trunk"]] = true,
			[L["Shattered Crystals"]] = true,
			[L["Chest of Ice"]] = true,
			[L["Forgotten Lockbox"]] = true,
			[L["Slimy Goo"]] = true,
			[L["Wind-Bound Strongbox"]] = true,
			[L["Spun Webs"]] = true,
			[L["Obsidian Grand Cache"]] = true,
			[L["Frozen Coffer"]] = true,
		}
		if Rarity.isFishing and Rarity.isOpening and Rarity.lastNode and vaultChests[Rarity.lastNode] then
			Rarity:Debug("Detected Opening on " .. Rarity.lastNode .. " (method = SPECIAL)")
			for _, itemName in ipairs(vaultToys) do
				addAttemptForItem(itemName, "items")
			end
			for _, itemName in ipairs(vaultPets) do
				addAttemptForItem(itemName, "pets")
			end
		end

		-- HANDLE FISHING
		if Rarity.isFishing and Rarity.isOpening == false then
			if Rarity.isPool then
				self:Debug("Successfully fished from a pool")
			else
				self:Debug("Successfully fished")
			end
			if
				Rarity.fishzones[tostring(GetBestMapForUnit("player"))]
				or Rarity.fishzones[zone]
				or Rarity.fishzones[subzone]
				or Rarity.fishzones[zone_t]
				or Rarity.fishzones[subzone_t]
			then
				-- We're interested in fishing in this zone; let's find the item(s) involved
				Rarity:Debug("We're interested in fishing in this zone; let's find the item(s) involved")
				for k, v in pairs(self.db.profile.groups) do
					if type(v) == "table" then
						for kk, vv in pairs(v) do
							if type(vv) == "table" then
								if vv.enabled ~= false then
									local found = false
									if
										vv.method == CONSTANTS.DETECTION_METHODS.FISHING
										and vv.zones ~= nil
										and type(vv.zones) == "table"
									then
										for kkk, vvv in pairs(vv.zones) do
											if
												vvv == tostring(GetBestMapForUnit("player"))
												or vvv == zone
												or vvv == lbz[zone]
												or vvv == subzone
												or vvv == lbsz[subzone]
												or vvv == zone_t
												or vvv == subzone_t
												or vvv == lbz[zone_t]
												or vvv == subzone
												or vvv == lbsz[subzone_t]
											then
												if (vv.requiresPool and Rarity.isPool) or not vv.requiresPool then
													Rarity:Debug(
														"Found interesting item for this zone: " .. tostring(vv.name)
													)
													found = true
												end
											end
										end
									end

									if
										vv.excludedMaps
										and type(vv.excludedMaps) == "table"
										and vv.excludedMaps[GetBestMapForUnit("player")]
									then
										Rarity:Debug(
											"The current map is excluded for item: "
												.. tostring(vv.name)
												.. ". Attempts will not be counted"
										)
										found = false
									end

									if found then
										if self:IsAttemptAllowed(vv) then
											if vv.attempts == nil then
												vv.attempts = 1
											else
												vv.attempts = vv.attempts + 1
											end
											self:OutputAttempts(vv)
										end
									end
								end
							end
						end
					end
				end
			end
		end
		if Rarity.fishingTimer then
			self:CancelTimer(Rarity.fishingTimer, true)
		end
		Rarity.fishingTimer = nil
		Rarity.isFishing = false
		Rarity.isPool = false

		-- Handle Disgusting Vat Fishing
		if -- There's no UNIT_SPELLCAST_SENT, so this will have to do
			Rarity.lastNode == L["Disgusting Vat"]
		then
			Rarity:OnDisgustingVatFished()
		end

		if Rarity.isOpening and Rarity.lastNode == L["Chest of Massive Gains"] then
			Rarity:OnChestOfMassiveGainsOpened()
		end

		-- Handle mining Elementium
		if
			Rarity.relevantSpells[Rarity.previousSpell] == "Mining"
			and (Rarity.lastNode == L["Elementium Vein"] or Rarity.lastNode == L["Rich Elementium Vein"])
		then
			Rarity:Debug("Detected Mining on " .. Rarity.lastNode .. " (method = SPECIAL)")
			local v = self.db.profile.groups.pets["Elementium Geode"]
			if v and type(v) == "table" and v.enabled ~= false then
				if v.attempts == nil then
					v.attempts = 1
				else
					v.attempts = v.attempts + 1
				end
				self:OutputAttempts(v)
			end
		end

		-- Handle skinning on Argus (Fossorial Bile Larva)
		if
			(
				Rarity.relevantSpells[Rarity.previousSpell] == "Skinning"
				or Rarity.relevantSpells[Rarity.previousSpell] == "Mother's Skinning Knife"
			) -- Skinned something
			and (
				GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.KROKUUN
				or GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.MACAREE
				or GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.ANTORAN_WASTES
			)
		then -- Player is on Argus -> Can obtain the pet from skinning creatures
			Rarity:Debug(
				"Detected skinning on Argus - Can obtain " .. L["Fossorial Bile Larva"] .. " (method = SPECIAL)"
			)
			local v = self.db.profile.groups.pets["Fossorial Bile Larva"]
			if v and type(v) == "table" and v.enabled ~= false then -- Add an attempt
				v.attempts = v.attempts ~= nil and v.attempts + 1 or 1 -- Defaults to 1 if this is the first attempt
				self:OutputAttempts(v)
			end
		end

		if Rarity.isOpening and Rarity.lastNode == L["Dreamseed Cache"] then
			Rarity:OnDreamseedCacheOpened()
		end

		-- Handle herb gathering on Argus (Fel Lasher)
		if
			Rarity.relevantSpells[Rarity.previousSpell] == "Herb Gathering" -- Gathered a herbalism node
			and (
				GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.KROKUUN
				or GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.MACAREE
				or GetBestMapForUnit("player") == CONSTANTS.UIMAPIDS.ANTORAN_WASTES
			)
		then -- Player is on Argus -> Can obtain the pet from gathering herbalism nodes
			Rarity:Debug("Detected herb gathering on Argus - Can obtain " .. L["Fel Lasher"] .. " (method = SPECIAL)")
			local v = self.db.profile.groups.pets["Fel Lasher"]
			if v and type(v) == "table" and v.enabled ~= false then -- Add an attempt
				v.attempts = v.attempts ~= nil and v.attempts + 1 or 1 -- Defaults to 1 if this is the first attempt
				self:OutputAttempts(v)
			end
		end

		-- HANDLE NORMAL NPC LOOTING
		local numItems = GetNumLootItems()

		-- Legacy support for pre-5.0 single-target looting
		local guid = UnitGUID("target")
		local name = UnitName("target")
		if not name or not guid then
			return
		end -- No target when looting
		if not UnitCanAttack("player", "target") then
			return
		end -- You targeted something you can't attack
		if UnitIsPlayer("target") then
			return
		end -- You targetted a player

		-- You're looting something that's alive -- this is only done for pickpocketing
		local requiresPickpocket = false
		if not UnitIsDead("target") then
			requiresPickpocket = true
		end

		-- Disallow "minus" NPCs; nothing good drops from them
		if UnitClassification(guid) == "minus" then
			return
		end -- (This doesn't actually work currently; UnitClassification needs a unit, not a GUID)

		local numChecked = 0
		self:Debug(numItems .. " slot(s) to loot")
		for slotID = 1, numItems, 1 do -- Loop through all loot slots (for AoE looting)
			local guidlist
			if GetLootSourceInfo then
				guidlist = { GetLootSourceInfo(slotID) }
			else
				guidlist = { guid }
			end
			local guidIndex
			for k, v in pairs(guidlist) do -- Loop through all NPC Rarity.guids being looted (will be 1 for single-target looting pre-5.0)
				guid = v
				if guid and type(guid) == "string" then
					self:Debug("Checking NPC guid (" .. (numChecked + 1) .. "): " .. guid)
					self:CheckNpcInterest(
						guid,
						zone,
						subzone,
						zone_t,
						subzone_t,
						Rarity.currentSpell,
						requiresPickpocket
					) -- Decide if we should increment an attempt count for this NPC
					numChecked = numChecked + 1
					-- else
					-- 	--self:Debug("Didn't check guid: "..guid or "nil")
				end -- Loop through all NPC GUIDs being looted (will be 1 for single-target looting pre-5.0)
			end -- Haven't seen this corpse yet
		end -- Loop through all loot slots (for AoE looting)

		-- If we failed to scan anything, scan the current target
		if numChecked <= 0 then
			self:CheckNpcInterest(UnitGUID("target"), zone, subzone, zone_t, subzone_t, Rarity.currentSpell)
		end

		-- Scan the loot to see if we found something we're looking for
		for slotID = 1, numItems, 1 do
			local _, _, qty = GetLootSlotInfo(slotID)
			if (qty or 0) > 0 then -- Coins have quantity of 0, so skip those
				local itemLink = GetLootSlotLink(slotID)
				if itemLink then
					local _, itemId = strsplit(":", itemLink)
					itemId = tonumber(itemId)
					if
						Rarity.items[itemId] ~= nil
						and Rarity.items[itemId].method ~= CONSTANTS.DETECTION_METHODS.COLLECTION
					then
						self:OnItemFound(itemId, Rarity.items[itemId])
					end
				end
			end
		end

		if requiresPickpocket then
			-- Pick Pocket triggers the same loot events, but it shouldn't prevent kills from counting afterwards
			Rarity.guids[guid] = false
		end
	end
end

function Rarity:OnChestOfMassiveGainsOpened()
	Rarity:Debug("Detected Opening on Chest of Massive Gains")

	local hasOpenedChestToday = IsQuestFlaggedCompleted(75325)
	if hasOpenedChestToday then
		Rarity:Debug("Skipping this attempt (loot lockout for Chest of Massive Gains is active)")
		return
	end

	local wasRequiredAuraFoundOnPlayer = false
	AuraUtil.ForEachAura("player", "HELPFUL", nil, function(_, _, _, _, _, _, _, _, _, spellID)
		if spellID == CONSTANTS.AURAS.ROCKS_ON_THE_ROCKS then
			wasRequiredAuraFoundOnPlayer = true
		end
	end)

	if not wasRequiredAuraFoundOnPlayer then
		Rarity:Debug(format("Required aura %s NOT found on player", L["Rocks on the Rocks"]))
		return
	end

	addAttemptForItem("Brul", "pets")
end

function Rarity:OnDisgustingVatFished()
	local hasFishedEmmahThisWeek = IsQuestFlaggedCompleted(75488)
	if hasFishedEmmahThisWeek then
		self:Debug("Skipping this fishing attempt (loot lockout for Emmah is active)")
		return
	end

	self:Debug("Detected fishing on Disgusting Vat (method = SPECIAL)")
	addAttemptForItem("Emmah", "pets")
end

local dreamseedMounts = {
	"Reins of the Winter Night Dreamsaber",
	"Reins of the Snowfluff Dreamtalon",
	"Reins of the Evening Sun Dreamsaber",
	"Reins of the Blossoming Dreamstag",
	"Reins of the Springtide Dreamtalon",
	"Reins of the Morning Flourish Dreamsaber",
	"Reins of the Rekindled Dreamstag",
}

function Rarity:OnDreamseedCacheOpened()
	Rarity:Debug("Detected Opening on Dreamseed Cache")
	for _, mount in ipairs(dreamseedMounts) do
		addAttemptForItem(mount, "mounts")
	end
end

Rarity.EventHandlers = EventHandlers
return EventHandlers
