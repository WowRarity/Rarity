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
local tostring = tostring
local type = type
local tinsert = table.insert
local tremove = table.remove
local time = time
local min = min
local max = max


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
		TOY = {
			isToy = true,
		},
		
		-- Fields that are valid for all types of items
		ANY = {
		
			-- index = true, -- always defaults to the displayed name, for now
			
			name = true,
			cat = true,
			type = true,
			method = true,
			chance = true,
			itemId = true,
			
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
		
		},
	
	},
	

}


addon.DatabaseMaintenanceHelper = DBH