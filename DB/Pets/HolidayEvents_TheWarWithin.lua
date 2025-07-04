local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WAR_WITHIN then
	return {}
end

local holidayEventPetsTWW = {
	["Grunch"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		spellId = 471121,
		items = { 116762 },
		itemId = 232531,
		creatureId = 233564,
		chance = 150,
		name = L["Grunch"],
		sourceText = L["Available starting December 25th"],
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = 87, x = 33.2, y = 67.8 }, { m = 25, x = 42.4, y = 41 }, { m = 86, x = 54.4, y = 77 } },
	},
	["Baa'lial Soulstone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		spellId = 411791,
		npcs = { 205490 },
		itemId = 206018,
		creatureId = 205637,
		chance = 4,
		name = L["Baa'lial Soulstone"],
		holidayEvents = CONSTANTS.HolidayEvents["A Greedy Emissary"],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.STORMWIND_CITY },
			{ m = CONSTANTS.UIMAPIDS.ORGRIMMAR },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.VALDRAKKEN },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.LIBERATION_OF_UNDERMINE },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsTWW)
return holidayEventPetsTWW
