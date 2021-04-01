local _, addonTable = ...

local Validation = {}

-- Upvalues
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

function Validation:ValidateItemDB()
	local ItemDB = Rarity.db.profile.groups.items
	local PetDB = Rarity.db.profile.groups.pets
	local MountDB = Rarity.db.profile.groups.mounts
	local UserDB = Rarity.db.profile.groups.user
	local DB = {
		ItemDB,
		PetDB,
		MountDB
		-- UserDB -- todo
	}

	Rarity:Print(L["Validating item database... this shouldn't take long!"])

	local numErrors = 0
	local numEntriesChecked = 0

	for categoryName, entries in pairs(DB) do
		for itemName, fields in pairs(entries) do
			if type(fields) == "table" then
				numEntriesChecked = numEntriesChecked + 1
				-- Rarity:Debug(format("Validating item: %s ...", itemName))
				local isEntryValid = Rarity.Validation:ValidateEntry(itemName, fields)
				if not isEntryValid then -- Skip pseudo-groups... Another artifact that has to be worked around, I guess
					Rarity:Print(format(L["Validation failed for item: %s"], itemName))
					numErrors = numErrors + 1
				end
			end
		end
	end

	Rarity:Debug(format("Finished validating %d items", numEntriesChecked))

	if numErrors == 0 then
		Rarity:Print(L["We didn't find any errors in your database. Yay!"])
	else
		Rarity:Print(
			format(
				L[
					"We found %d invalid items in your database! If you added them yourself, you should probably fix them to make sure the addon works as expected :)"
				],
				numErrors
			)
		)
	end
end

-- Upvalues
local pairs = pairs
local tostring = tostring
local assert = assert

function Validation:ValidateEntry(itemName, entry)
	-- Rarity:Debug(format("Verifying item %s", itemName))

	-- if L[itemName] ~= entry.name then -- Keys are never localized, but names always are
	-- 	Rarity:Debug(format("Failed to validate item %s (base name must match DB key)", itemName))
	-- 	return false
	-- end

	local itemType = entry.type -- todo use group name to determine the validator instead
	if itemType == nil then -- Also covers entry.name being nil
		Rarity:Debug(format("Failed to validate item %s (undefined item type)", itemName))
		return false
	end

	local schema = Rarity.DatabaseSchema
	if schema[itemType] == nil then
		Rarity:Debug(format("Failed to validate item %s (unknown item type %s)", itemName, itemType))
		return false
	end

	-- Rarity:Debug(format("Validating entry of type %s", itemType))

	local validator = schema[itemType]

	if validator == nil then
		Rarity:Debug(format("Failed to validate item %s (no schema exists for item type %s)", itemName, itemType))
		return false
	end

	local isValidEntry = validator:Validate(entry)
	if not isValidEntry then
		Rarity:Debug(format("Failed to validate item %s of type %s (doesn't match expected schema)", itemName, itemType))
		return false
	end

	return true

	-- return true
end

Rarity.Validation = Validation
return Validation
