local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_CATACLYSM then
	return {}
end

local holidayEventPetsCataclysm = {
	["Lump of Coal"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Lump of Coal"],
		spellId = 103125,
		itemId = 73797,
		items = { 116762 },
		chance = 50,
		creatureId = 55215,
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = 87, x = 33.2, y = 67.8 }, { m = 25, x = 42.4, y = 41 }, { m = 86, x = 54.4, y = 77 } },
	},
	["Sea Pony"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Sea Pony"],
		spellId = 103588,
		itemId = 73953,
		zones = { "407" },
		chance = 1000,
		requiresPool = false,
		creatureId = 55386,
		holidayEvents = CONSTANTS.HolidayEvents["Darkmoon Faire"],
		coords = { { m = 407 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsCataclysm)
return holidayEventPetsCataclysm
