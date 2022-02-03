local _, addonTable = ...

local Validation = {
	metaKeys = {
		-- Why is this stored in the item database!? IDK, but we can't change it easily now without proper schema migrations
		["collapsedGroup"] = true,
		["collapsed"] = true,
		["name"] = true,
	},
}

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
	return self.metaKeys[key] == true
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

Rarity.Validation = Validation
return Validation
