local _, addonTable = ...

-- Upvalues
local pairs = pairs
local CONSTANTS = addonTable.constants

local Pet = {
	spellId = true,
	creatureId = true
}

local Mount = {
	spellId = true
}

local Toy = {
	isToy = true
}

local Item = {
	expectedFields = {
		isToy = false,
		-- Required ItemDB fields
		name = true,
		cat = true,
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
		announce = false,
		enableCoin = false,
		collectedItemId = false,
		doNotUpdateToHighestStat = false,
		disableForClass = false,
		holidayReminder = false,
		achievementId = false,
		showTooltipCondition = false
	}
}

function Pet:Validate(entry)
	local isValidItem = Item:Validate(entry)
	if not isValidItem then
		return false
	end

	-- but is it a valid pet?

	return true -- todo
end

function Mount:Validate(entry)
	local isValidItem = Item:Validate(entry)
	if not isValidItem then
		return false
	end
	return true -- todo
end

function Toy:Validate(entry)
	local isValidItem = Item:Validate(entry)
	if not isValidItem then
		return false
	end
	return true -- todo
end

function Item:IsHolidayItem(entry)
	return entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY
end

local DatabaseSchema = {
	PET = Pet,
	MOUNT = Mount,
	ITEM = Item,
	-- todo TOY?
	-- Fields that are valid for all types of items
	ANY = {}
}

function Item:IsValidHolidayItem(entry)
	-- All holiday items should have holidayTexture set to represent which holiday it belongs to.
	if not entry.holidayTexture then
		Rarity:Debug("Found holiday item without a holidayTexture property")
		return false
	end

	return true
end

function Item:HasOnlyValidFields(entry)
	for key, value in pairs(entry) do
		if self.expectedFields[key] == nil then
			Rarity:Debug(format("%s is an invalid field and should'nt be set", key))
			return false
		end

		-- TODO: Type checking, validation etc. here (if ever implemented)
	end

	return true
end

function Item:IsPersonalLoot(entry)
	-- equalOdds and groupSize usually go together since everything is Personal Loot nowadays
	if entry.groupSize and not entry.equalOdds then
		Rarity:Debug("Found setting for groupSize but equalOdds is not set")
		return false
	end

	if entry.equalOdds and not entry.groupSize then
		Rarity:Debug("Found setting for equalOdds but groupSize is not set")
		return false
	end

	-- Solo-able items don't need either setting
	return true
end

function Item:HasAllRequiredFields(entry)
	-- The most basic check: Make sure all required fields are set
	for key, isRequiredField in pairs(self.expectedFields) do
		if isRequiredField and not entry[key] then
			Rarity:Debug(format("%s is a required field and must be set", key))
			return false
		end
	end

	return true
end

function Item:IsUsingHolidayProperties(entry)
	return entry.holidayTexture ~= nil or entry.christmasOnly ~= nil
end

function DatabaseSchema:IsValidItem(entry)
	if not Item:HasAllRequiredFields(entry) then
		Rarity:Debug("Required fields are missing")
		return false
	end

	if not Item:IsPersonalLoot(entry) then
		Rarity:Debug("Personal loot settings are inconsistent")
		return false
	end

	if not Item:HasOnlyValidFields(entry) then
		Rarity:Debug("Unsupported fields are set")
		return false
	end

	if Item:IsHolidayItem(entry) and not Item:IsValidHolidayItem(entry) then
		Rarity:Debug("Holiday event settings are inconsistent")
		return false
	end

	if not Item:IsHolidayItem(entry) and Item:IsUsingHolidayProperties(entry) then
		Rarity:Debug("Found item using holiday properties, but it's not a holiday item")
		return false
	end

	return true
end

function DatabaseSchema:IsValidPet(entry)
	if not Item:IsPet(entry) then
		Rarity:Debug("Item is not of type PET")
		return false
	end

	if not entry.spellId then
		Rarity:Debug("Expected field spellId is missing")
		return false
	end

	if not entry.creatureId then
		Rarity:Debug("Expected field creatureId is missing")
		return false
	end

	return true
end

function Item:IsPet(entry)
	return entry.type == CONSTANTS.ITEM_TYPES.PET
end

function DatabaseSchema:IsValidMount(entry)
	if not Item:IsMount(entry) then
		Rarity:Debug("Item is not of type MOUNT")
		return false
	end

	if not entry.spellId then
		Rarity:Debug("Expected field spellId is missing")
		return false
	end

	return true
end

function Item:IsMount(entry)
	return entry.type == CONSTANTS.ITEM_TYPES.MOUNT
end

-- TODO Should probably move this to the Database API, but that's for another time
Rarity.DatabaseSchema = DatabaseSchema
