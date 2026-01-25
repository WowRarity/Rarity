local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local MidnightPets = {
	-- 12.0 pets
	["Nova"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		chance = 20,
		creatureId = 264892,
		name = L["Nova"],
		itemId = 257695,
		items = { 267299 },
		spellId = 1272755,
		coords = { { m = CONSTANTS.UIMAPIDS.MASTERS_PERCH } },
	},
		["Princess Bloodshed"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		chance = 20,
		creatureId = 258281,
		name = L["Princess Bloodshed"],
		itemId = 265609,
		npcs = { 255348 },
		spellId = 1276430,
		coords = { { m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS } },
	}
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, MidnightPets)
return MidnightPets
