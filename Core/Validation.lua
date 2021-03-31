local _, addonTable = ...

local Validation = {}

-- TODO Clean this up
Validation.itemTypes = {
	-- Specific fields for each item type
	PET = {
		spellId = true,
		creatureId = true
	},
	MOUNT = {
		spellId = true
	},
	ITEM = {
		-- TODO: Internally, the item type TOY doesn't exist...
		isToy = false
	},
	-- Fields that are valid for all types of items
	ANY = {
		-- index = true, -- always defaults to the displayed name, for now

		-- Required ItemDB fields
		name = true,
		cat = true,
		type = true,
		method = true,
		chance = true,
		itemId = true,
		--	arbitraryRequiredTestField = true,

		-- Optional ItemDB fields
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
		-- TODO: These fields seem to be all over the place. They should adhere to the structure defined above for each item type... Sigh.
	}
}

local L = addonTable.L

function Validation:ValidateItemDB()
	local ItemDB = self.db.profile.groups.items
	local PetDB = self.db.profile.groups.pets
	local MountDB = self.db.profile.groups.mounts
	local UserDB = self.db.profile.groups.user
	local DB = {ItemDB, PetDB, MountDB}

	self:Print(L["Verifying item database..."])

	local numErrors = 0

	for category, entry in pairs(DB) do
		for item, fields in pairs(entry) do
			if type(fields) == "table" then
				self:Debug(format(L["Verifying entry: %s ..."], item))
				local isEntryValid = Rarity.Validation:VerifyEntry(fields)
				if not isEntryValid then -- Skip pseudo-groups... Another artifact that has to be worked around, I guess
					self:Print(format(L["Verification failed for entry: %s"], item))
					numErrors = numErrors + 1
				end
			end
		end
	end

	if numErrors == 0 then
		self:Print(L["Verification complete! Everything appears to be in order..."])
	else
		self:Print(format(L["Verfication failed with %d errors!"], numErrors))
	end
end

-- Upvalues
local pairs = pairs
local tostring = tostring
local assert = assert

-- Locals
local CONSTANTS = addonTable.constants

-- Format: fieldName = isRequiredField (optional if set to FALSE)
local DBH = {}

-- TODO Rename
function Validation:VerifyEntry(entry)
	-- print("Verifying entry for item: " .. tostring(entry and entry.name))

	local itemType = entry.type
	if self.itemTypes[itemType] == nil then
		print(tostring(itemType) .. " is not a valid item type")
		return false
	end

	-- The most basic check: Make sure all required fields are set
	for type, fields in pairs(self.itemTypes) do
		for key, isRequiredField in pairs(fields) do -- Check if required fields are actually set
			if isRequiredField and (type == itemType or type == "ANY") then -- This field is required for the given item type
				if not entry[key] then -- ..	. but it isn't set
					print(tostring(key) .. " is a required field and must be set")
					-- dump(entry)
					return false
				end
			end
		end
	end

	-- Additional check: Allow only valid fields (result: Alert if something was entered incorrectly while updating the DB...)
	for key, value in pairs(entry) do
		if (self.itemTypes.ANY[key] == nil) and (self.itemTypes[itemType][key] == nil) then
			print(tostring(key) .. " is an invalid field and cannot be set")
			return false
		end
		-- TODO: Type checking, validation etc. here (if ever implemented)
	end

	-- equalOdds and groupSize usually go together since everything is Personal Loot nowadays
	if entry.groupSize and not entry.equalOdds then
		print("Warning: Found setting for groupSize but equalOdds is not set")
		return false
	end

	if entry.equalOdds and not entry.groupSize then
		print("Warning: Found setting for equalOdds but groupSize is not set")
		return false
	end

	--[[
      HOLIDAY VALUES ------------------------------------------------------------------------------------------------------------
  	]]
	-- All holiday items should have holidayTexture set to represent which holiday it belongs to.
	if entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY and not entry.holidayTexture then
		print("Warning: Found holiday item without a 'holidayTexture'.")
		return false
	end

	-- There is no reason why items should have holidayTexture unless they are in the Holiday category.
	if entry.holidayTexture and not (entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY) then
		print("Warning: Found item with holidayTexture, but it's not a holiday item.")
		return false
	end

	-- There is no reason why items should have christmasOnly unless they are in the Holiday category.
	if entry.christmasOnly and not (entry.cat == CONSTANTS.ITEM_CATEGORIES.HOLIDAY) then
		print("Warning: Found item with christmasOnly, but it's not a holiday item.")
		return false
	end

	return true
end

Rarity.Validation = Validation
return Validation
