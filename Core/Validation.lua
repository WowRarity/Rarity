local _, addonTable = ...

local Validation = {}

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

function Validation:ValidateItemDB()
	local ItemDB = Rarity.db.profile.groups.items
	local PetDB = Rarity.db.profile.groups.pets
	local MountDB = Rarity.db.profile.groups.mounts
	local UserDB = Rarity.db.profile.groups.user
	local DB = {ItemDB, PetDB, MountDB}

	Rarity:Print(L["Verifying item database..."])

	local numErrors = 0

	for category, entry in pairs(DB) do
		for item, fields in pairs(entry) do
			if type(fields) == "table" then
				Rarity:Debug(format(L["Verifying entry: %s ..."], item))
				local isEntryValid = Rarity.Validation:VerifyEntry(fields)
				if not isEntryValid then -- Skip pseudo-groups... Another artifact that has to be worked around, I guess
					Rarity:Print(format(L["Verification failed for entry: %s"], item))
					numErrors = numErrors + 1
				end
			end
		end
	end

	if numErrors == 0 then
		Rarity:Print(L["Verification complete! Everything appears to be in order..."])
	else
		Rarity:Print(format(L["Verfication failed with %d errors!"], numErrors))
	end
end

-- Upvalues
local pairs = pairs
local tostring = tostring
local assert = assert

-- Locals
local CONSTANTS = addonTable.constants
-- TODO Rename
function Validation:VerifyEntry(entry)
	-- print("Verifying entry for item: " .. tostring(entry and entry.name))

	local schema = Rarity.DatabaseSchema

	local itemType = entry.type
	if schema[itemType] == nil then
		print(tostring(itemType) .. " is not a valid item type")
		return false
	end

	-- The most basic check: Make sure all required fields are set
	for type, fields in pairs(schema) do
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
		if (schema.ANY[key] == nil) and (schema[itemType][key] == nil) then
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
