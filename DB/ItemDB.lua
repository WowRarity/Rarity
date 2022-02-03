local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local ItemDB = {}
ItemDB.mounts = { name = L["Mounts"] }
ItemDB.pets = { name = L["Battle Pets"] }
ItemDB.toys = { name = L["Toys & Items"] }

-- Add any item that doesn't yet exist, which in our case means ALL items since there shouldn't be duplicate entries
-- The database is split to make it more easily maintainable, but the individual partitions have no overlap
function ItemDB.MergeItems(sourceTable, items)
	for key, item in pairs(items) do
		sourceTable[key] = item
	end
end

Rarity.ItemDB = ItemDB
