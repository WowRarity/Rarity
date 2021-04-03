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
		announce = false -- This should be used instead
	}
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

function Item:HasZone(entry)
	if entry.coords then
		for _, value in pairs(entry.coords) do
			if type(value) == "table" and value.m ~= nil then
				if tonumber(value.m) then
					return true
				end
			end
		end
	end
	return false
end

Rarity.Item = Item
