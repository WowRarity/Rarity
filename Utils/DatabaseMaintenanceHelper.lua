local addonName, addon = ...
if not addon then
	return
end

-- TODO: Migrate the functionality to Core/Database.lua and then delete this

-- Upvalues
local pairs = pairs
local tostring = tostring
local assert = assert

-- Locals
-- Format: fieldName = isRequiredField (optional if set to FALSE)
local DBH = {
	itemTypes = {
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
}

function DBH:VerifyEntry(entry)
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

	return true
end

function DBH:GetExportString(entry)
	local isValidEntry = self:VerifyEntry(entry)
	assert(isValidEntry, "Cannot export an invalid entry")

	local exportString = '["' .. entry.name .. '"] = {/n'

	for key, value in pairs(entry) do -- Assemble the string
		exportString = exportString .. key .. " = " .. value .. ","
	end

	exportString = exportString .. "},\n"

	return exportString
end

Rarity.Utils.DatabaseMaintenanceHelper = DBH
