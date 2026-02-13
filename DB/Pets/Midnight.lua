local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if not LE_EXPANSION_MIDNIGHT or LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local midnightPets = {
	["Nova"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		chance = 20,
		creatureId = 264892,
		name = L["Nova"],
		itemId = 264892,
		items = { 267299 },
		spellId = 1272755,
		coords = { { m = CONSTANTS.UIMAPIDS.VOIDSTORM } },
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
		coords = { { m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS_MIDNIGHT } },
	},
	["Bubbly Snapling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Bubbly Snapling"],
		itemId = 260942,
		npcs = { 256201 },
		spellId = 1267090,
		chance = 500,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS_MIDNIGHT },
			{ m = CONSTANTS.UIMAPIDS.ZUL_AMAN_MIDNIGHT },
			{ m = CONSTANTS.UIMAPIDS.VOIDSTORM },
			{ m = CONSTANTS.UIMAPIDS.HARANDAR },
		},
		zones = {
			tostring(CONSTANTS.UIMAPIDS.EVERSONG_WOODS_MIDNIGHT),
			tostring(CONSTANTS.UIMAPIDS.ZUL_AMAN_MIDNIGHT),
			tostring(CONSTANTS.UIMAPIDS.VOIDSTORM),
			tostring(CONSTANTS.UIMAPIDS.HARANDAR),
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, midnightPets)
return midnightPets
