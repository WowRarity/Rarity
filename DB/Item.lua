local _, addonTable = ...

-- Upvalues
local pairs = pairs
local CONSTANTS = addonTable.constants

local Item = {
	expectedFields = {
		isToy = false,
		-- Required ItemDB fields
		name = true,
		cat = false, -- This should be true, but the property doesn't exist for custom items?
		type = true,
		method = true,
		chance = true,
		itemId = true,
		--	arbitraryRequiredTestField = true,

		-- todo if requiresCovenant then requiredCovenantID must be set also

		-- Optional ItemDB fields
		requiredCovenantID = false,
		requiresCovenant = false,
		questId = false,
		groupSize = false,
		equalOdds = false,
		coords = false,
		sourceText = false,
		tooltipNpcs = false,
		tooltipModifier = false,
		statisticId = false,
		lockoutDetails = false,
		instanceDifficulties = false,
		unique = false,
		worldQuestId = false,
		pickpocket = false,
		requiresCompletedQuestId = false,
		-- Populated fields (SavedVariables)
		attempts = false,
		lastAttempts = false,
		realAttempts = false,
		enabled = false,
		dates = false,
		holidayTexture = false,
		known = false,
		finds = false,
		found = false,
		totalFinds = false,
		time = false,
		lastTime = false,
		items = false,
		excludedMaps = false,
		npcs = false,
		christmasOnly = false,
		requiresPool = false,
		creatureId = false,
		zones = false,
		repeatable = false,
		spellId = false,
		lockDungeonId = false,
		lockBossName = false,
		defeatSteps = false,
		bonusSatchel = false,
		wasGuaranteed = false,
		requiresAlliance = false,
		requiresHorde = false,
		worldBossFactionless = false,
		blackMarket = false,
		obtain = false,
		raceId = false,
		defeatAllQuests = false,
		enableCoin = false,
		collectedItemId = false,
		doNotUpdateToHighestStat = false,
		disableForClass = false,
		holidayReminder = false,
		achievementId = false,
		showTooltipCondition = false,
		-- These are only set sometimes, via the Options UI. Super inconsistent?
		import = false,
		export = false,
		obtainedQuestId = false,
		enableAnnouncements = false, -- This is actually wrong, but since the import is bugged it'll exist in all imports (I think)... Doesn't do anything though :/
		announce = false, -- This should be used instead
	},
}

function Item:HasAllRequiredFields(entry)
	-- The most basic check: Make sure all required fields are set
	for key, isRequiredField in pairs(self.expectedFields) do
		if isRequiredField and not entry[key] then
			Rarity:Print(format("%s is a required field and must be set", key))
			return false
		end
	end

	return true
end

function Item:IsPersonalLoot(entry)
	-- equalOdds and groupSize usually go together since everything is Personal Loot nowadays
	if entry.groupSize and not entry.equalOdds then
		Rarity:Print("Found setting for groupSize but equalOdds is not set")
		return false
	end

	if entry.equalOdds and not entry.groupSize then
		Rarity:Print("Found setting for equalOdds but groupSize is not set")
		return false
	end

	-- Solo-able items don't need either setting
	return true
end

function Item:HasOnlyValidFields(entry)
	for key, value in pairs(entry) do
		if self.expectedFields[key] == nil then
			Rarity:Print(format("%s is an invalid field and should'nt be set", key))
			return false
		end

		-- TODO: Type checking, validation etc. here (if ever implemented)
	end

	return true
end

function Item:IsHolidayItem(entry)
	return entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY
end

function Item:IsValidHolidayItem(entry)
	-- All holiday items should have holidayTexture set to represent which holiday it belongs to.
	if not entry.holidayTexture then
		Rarity:Print("Found holiday item without a holidayTexture property")
		return false
	end

	return true
end

function Item:IsUsingHolidayProperties(entry)
	return entry.holidayTexture ~= nil or entry.christmasOnly ~= nil
end

function Item:IsPet(entry)
	return entry.type == CONSTANTS.ITEM_TYPES.PET
end

function Item:IsMount(entry)
	return entry.type == CONSTANTS.ITEM_TYPES.MOUNT
end

function Item:IsCollectionItem(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.COLLECTION
end

function Item:IsValidCollectionItem(entry)
	return entry.collectedItemId ~= nil
end

function Item:IsArchaeologyItem(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.ARCH
end

function Item:IsValidArchaeologyItem(entry)
	if not entry.raceId then
		Rarity:Print("Found archaeology item without raceID property")
		return false
	end

	for _, raceID in pairs(CONSTANTS.ARCHAEOLOGY_RACES) do
		if raceID == entry.raceId then
			return true
		end
	end
	Rarity:Print("Found archaeology item with invalid raceID")
	return false
end

function Item:HasUseMethod(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.USE
end

function Item:IsValidUseMethodItem(entry)
	return entry.items ~= nil
end

function Item:IsCovenantSpecificItem(entry)
	return entry.requiresCovenant == true
end

function Item:IsValidCovenantItem(entry)
	if not entry.requiredCovenantID then
		Rarity:Print("Found covenant item without a covenantID property")
		return false
	end

	for _, covenantID in pairs(CONSTANTS.COVENANT_IDS) do
		if covenantID == entry.requiredCovenantID then
			return true
		end
	end
	Rarity:Print("Found covenant item with invalid covenantID")
	return false
end

function Item:IsZoneItem(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.ZONE
end

function Item:IsValidZoneItem(entry)
	return entry.zones ~= nil
end

function Item:IsFishingItem(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.FISHING
end

function Item:IsValidFishingItem(entry)
	if not Item:IsValidZoneItem(entry) then
		return false
	end

	return entry.requiresPool ~= nil
end

function Item:HasNPCMethod(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.NPC
end

function Item:HasBossMethod(entry)
	return entry.method == CONSTANTS.DETECTION_METHODS.BOSS
end

function Item:IsValidNPCItem(entry)
	return entry.npcs ~= nil
end

function Item:HasWaypointData(entry)
	return entry.coords ~= nil
end

function Item:HasValidWaypoints(entry)
	for _, waypoint in pairs(entry.coords) do
		if not Rarity:IsValidWaypoint(waypoint) then
			return false
		end
	end
	return true
end

function Rarity:IsValidWaypoint(waypointData)
	if type(waypointData) == "table" then
		if not waypointData.m then
			Rarity:Print("Waypoint data is missing a mapID")
			return false
		elseif (waypointData.y and not waypointData.x) or (waypointData.x and not waypointData.y) then
			Rarity:Print("Waypoint data has incomplete map coordinates")
			return false
		end
	end
	return true
end

Rarity.Item = Item
