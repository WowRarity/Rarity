  ----------------------------------------------------------------------------------------------------------------------
    -- This program is free software: you can redistribute it and/or modify
    -- it under the terms of the GNU General Public License as published by
    -- the Free Software Foundation, either version 3 of the License, or
    -- (at your option) any later version.

    -- This program is distributed in the hope that it will be useful,
    -- but WITHOUT ANY WARRANTY; without even the implied warranty of
    -- MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    -- GNU General Public License for more details.

    -- You should have received a copy of the GNU General Public License
    -- along with this program.  If not, see <http://www.gnu.org/licenses/>.
----------------------------------------------------------------------------------------------------------------------

local addonName, addon = ...
if not addon then return end


-- Upvalues
local pairs = pairs
local tostring = tostring
local assert = assert

-- "Soft" assert - don't raise an error (as debugging them is simply more annoying)
local function assert_soft(condition, message)

	if not condition then
		print("ASSERTION FAILED: " .. tostring(message))
	end

end

-- Locals
-- Format: fieldName = isRequiredField (optional if set to FALSE)
local DBH = {

	itemTypes = {
	
		-- Specific fields for each item type
		PET = {
			spellId = true,
			creatureId = true,
		},
		MOUNT = {
			spellId = true,
		},
		ITEM = { -- TODO: Internally, the item type TOY doesn't exist...
			isToy = true,
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
			totalFinds = false,
			time = false,
			items = false,
			excludedMaps = false,
			npcs = false,
		
		},
	
	},
	

}

function DBH:VerifyEntry(entry)

	print("Verifying entry for item: " .. tostring(entry and entry.name))

	local itemType = entry.type
	assert_soft(self.itemTypes[itemType] ~= nil, tostring(itemType) .. " is not a valid item type" )

	-- The most basic check: Make sure all required fields are set
	for key, value in pairs(self.itemTypes) do
		
		if self.itemTypes.ANY[key] or self.itemTypes[itemType][key] then
			assert_soft(entry[key] ~= nil, tostring(key) .. " is a required field and must be set")
		end
		
	end
	
	-- Additional check: Allow only valid fields (result: Alert if something was entered incorrectly while updating the DB...)
	for key, value in pairs(entry) do
		
		assert_soft( (self.itemTypes.ANY[key] ~= nil) or (self.itemTypes[itemType][key] ~= nil), tostring(key) .. " is an invalid field and cannot be set")
		-- TODO: Type checking, validation etc. here (if ever implemented)
		
	end
	
	return true

end


function DBH:GetExportString(entry)

	local isValidEntry = self:VerifyEntry(entry)
	assert_soft(isValidEntry, "Cannot export an invalid entry")
	
	local exportString = "[\"" .. entry.name .. "\"] = {/n"
	
	for key, value in pairs(entry) do -- Assemble the string
	
		exportString = exportString .. key .. " = ".. value .. ","
	
	end

	exportString = exportString .. "},\n"
	
	return exportString

end


addon.DatabaseMaintenanceHelper = DBH