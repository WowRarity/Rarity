local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local toysAndItems = {
	 -- TODO Review this and move (or remove) them
	-- Pickpocketing
	--["Pickpocket Test"] =                               { cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC, type = CONSTANTS.ITEM_TYPES.ITEM, method = CONSTANTS.DETECTION_METHODS.NPC, name = "Light Feather", itemId = 17056, npcs = { 3115, 3116, }, chance = 100,  pickpocket = true, }, -- Dustwind Harpy and Dustwind Pillager in Razorwind Canyon (Durotar 50 27)
	--["Decahedral Dwarven Dice"] =                       { cat = CONSTANTS.ITEM_CATEGORIES.WOTLK, type = CONSTANTS.ITEM_TYPES.ITEM, method = CONSTANTS.DETECTION_METHODS.NPC, name = L["Decahedral Dwarven Dice"], itemId = 36863, npcs = { 27357, 27367, 32149, }, chance = 100, pickpocket = true, },
	--["Loaded Gnomish Dice"] =                           { cat = CONSTANTS.ITEM_CATEGORIES.CATA, type = CONSTANTS.ITEM_TYPES.ITEM, method = CONSTANTS.DETECTION_METHODS.NPC, name = L["Loaded Gnomish Dice"], itemId = 63269, npcs = { 58612, 49124, 47595, 46320, }, chance = 300, pickpocket = true, },
	--["Worn Troll Dice"] =                               { cat = CONSTANTS.ITEM_CATEGORIES.WOTLK, type = CONSTANTS.ITEM_TYPES.ITEM, method = CONSTANTS.DETECTION_METHODS.NPC, name = L["Worn Troll Dice"], itemId = 36862, npcs = { 34839, 34728, 23660, 34734, 26550, 27260, 28504, 34838, 39438, 29880, 28417, 28123, 23655, 27424, 28388, }, chance = 300, pickpocket = true, },
}

local ItemDB = {}
ItemDB.mounts = {
	name = L["Mounts"]
}
ItemDB.pets = {
	name = L["Battle Pets"]
}
ItemDB.toys = {
	name = L["Toys & Items"]
}

-- Add any item that doesn't yet exist, which in our case means ALL items since there shouldn't be duplicate entries
-- The database is split to make it more easily maintainable, but the individual partitions have no overlap
function ItemDB.MergeItems(sourceTable, items)
	for key, item in pairs(items) do
		sourceTable[key] = item
	end
end

Rarity.ItemDB = ItemDB
