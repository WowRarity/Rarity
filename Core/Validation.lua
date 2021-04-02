local _, addonTable = ...

local Validation = {}

-- Upvalues
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants
local pairs = pairs

function Validation:ValidateItemDB()
	Rarity:Print(L["Validating item database... this shouldn't take long!"]) -- It better be true :P

	local numErrors = 0

	local numInvalidItemsAndToys = self:ValidateItemsAndToys() -- Yeah, they aren't separated... I guess toys didn't exist originally and were just regular items
	local numInvalidPets = self:ValidatePets()
	local numInvalidMounts = self:ValidateMounts()
	local numInvalidCustomItems = self:ValidateCustomItems()

	numErrors = numErrors + numInvalidItemsAndToys + numInvalidPets + numInvalidMounts + numInvalidCustomItems

	if numErrors == 0 then
		Rarity:Print(L["We didn't find any errors in your database. Yay!"])
	else
		Rarity:Print(format(L["We found %d invalid items in your database!"], numErrors))
		Rarity:Debug(format("Items/Toys: %d errors", numInvalidItemsAndToys))
		Rarity:Debug(format("Pets: %d errors", numInvalidPets))
		Rarity:Debug(format("Mounts: %d errors", numInvalidMounts))
		Rarity:Debug(format("Custom: %d errors", numInvalidCustomItems))
	end
end

function Validation:ValidateItemsAndToys()
	Rarity:Debug("Validating items and toys")
	return self:ValidateGroup(Rarity.db.profile.groups.items)
end

function Validation:ValidatePets()
	Rarity:Debug("Validating pets")
	return self:ValidateGroup(Rarity.db.profile.groups.pets)
end

function Validation:ValidateMounts()
	Rarity:Debug("Validating mounts")
	return self:ValidateGroup(Rarity.db.profile.groups.mounts)
end

function Validation:ValidateCustomItems()
	Rarity:Debug("Validating custom items")
	return self:ValidateGroup(Rarity.db.profile.groups.user)
end

function Validation:ValidateGroup(group)
	local numErrors = 0

	for key, entry in pairs(group) do
		if not self:IsMetaKey(key) then
			local isValid = self:IsValidItem(entry)
			if not isValid then
				Rarity:Print(format(L["Validation failed for item: %s"], key))
				numErrors = numErrors + 1
			end
		end
	end

	return numErrors
end

function Validation:IsMetaKey(key)
	-- Why is this stored in the item database!? IDK, but we can't change it easily now without proper schema migrations
	return key ~= "collapsedGroup" and key ~= "collapsed" and key ~= "name"
end

function Validation:IsValidItem(entry)
	local isValidItem = Rarity.DatabaseSchema:IsValidItem(entry)

	local isPet = (entry.type == CONSTANTS.ITEM_TYPES.PET)
	local isMount = (entry.type == CONSTANTS.ITEM_TYPES.MOUNT)

	if isPet and not self:IsValidPet(entry) then
		return false
	end

	if isMount and not self:IsValidMount(entry) then
		return false
	end

	return isValidItem
end

function Validation:IsValidPet(entry)
	return Rarity.DatabaseSchema:IsValidPet(entry)
end

function Validation:IsValidMount(entry)
	return Rarity.DatabaseSchema:IsValidMount(entry)
end

function Validation:ValidatePets()
	Rarity:Debug("Validating pets")
	return self:ValidateGroup(Rarity.db.profile.groups.pets)
end

function Validation:ValidateMounts()
	Rarity:Debug("Validating mounts")
	return self:ValidateGroup(Rarity.db.profile.groups.mounts)
end

function Validation:ValidateCustomItems()
	Rarity:Debug("Validating custom items")
	return self:ValidateGroup(Rarity.db.profile.groups.user)
end

-- tbd remove?
function Validation:ValidateSchema(key, entry)
	if not entry.type then
		local itemType = entry.type -- todo use group name to determine the validator instead
		if itemType == nil then -- Also covers entry.name being nil
			Rarity:Debug(format("Failed to validate item %s (undefined item type)", itemName))
			return false
		end

		return false
	end
end

-- tbd remove?
function Validation:TBD()
	local DB = {
		ItemDB,
		PetDB,
		MountDB
		-- UserDB -- todo
	}

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

-- tbd remove?
function Validation:ValidateEntry(itemName, entry)
	-- Rarity:Debug(format("Verifying item %s", itemName))

	-- if L[itemName] ~= entry.name then -- Keys are never localized, but names always are
	-- 	Rarity:Debug(format("Failed to validate item %s (base name must match DB key)", itemName))
	-- 	return false
	-- end

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
