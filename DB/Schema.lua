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

function Item:Validate(entry)
	-- The most basic check: Make sure all required fields are set
	-- AssertMandatoryFieldsAreSet
	for key, isRequiredField in pairs(self.expectedFields) do
		if isRequiredField and not entry[key] then
			Rarity:Debug(format("%s is a required field and must be set", key))
			return false
		end
	end

	-- Additional check: Allow only valid fields (result: Alert if something was entered incorrectly while updating the DB...)
	-- AssertNoOptionalFields
	for key, value in pairs(entry) do
		if self.expectedFields[key] == nil then
			Rarity:Debug(format("%s is an invalid field and should'nt be set", key))
			return false
		end
		-- TODO: Type checking, validation etc. here (if ever implemented)
	end

	-- equalOdds and groupSize usually go together since everything is Personal Loot nowadays

	-- AssertPersonalLootSettings
	if entry.groupSize and not entry.equalOdds then
		Rarity:Debug("Found setting for groupSize but equalOdds is not set")
		return false
	end

	if entry.equalOdds and not entry.groupSize then
		Rarity:Debug("Found setting for equalOdds but groupSize is not set")
		return false
	end

	-- AssertHolidayItems
	-- --[[
	--   HOLIDAY VALUES ------------------------------------------------------------------------------------------------------------
	-- ]]
	-- All holiday items should have holidayTexture set to represent which holiday it belongs to.
	if entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY and not entry.holidayTexture then
		Rarity:Debug("Found holiday item without a holidayTexture property")
		return false
	end

	-- There is no reason why items should have holidayTexture unless they are in the Holiday category.
	if entry.holidayTexture and not (entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY) then
		Rarity:Debug("Found item with holidayTexture property, but it's not a holiday item")
		return false
	end

	-- There is no reason why items should have christmasOnly unless they are in the Holiday category.
	if entry.christmasOnly and not (entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY) then
		Rarity:Debug("Found item with christmasOnly property, but it's not a holiday item")
		return false
	end

	return true
end

function Toy:Validate(entry)
	local isValidItem = Item:Validate(entry)
	if not isValidItem then
		return false
	end
	return true -- todo
end

local schema = {
	PET = Pet,
	MOUNT = Mount,
	ITEM = Item,
	-- todo TOY?
	-- Fields that are valid for all types of items
	ANY = {}
}

-- TODO Should probably move this to the Database API, but that's for another time
Rarity.DatabaseSchema = schema
