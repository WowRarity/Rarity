local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WAR_WITHIN then
	return {}
end

local holidayEventMountsTWW = {
	["Tyrael's Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tyrael's Charger"],
		spellId = 107203,
		itemId = 76755,
		npcs = { 205490 },
		chance = 100,
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
	["Inarius' Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Inarius' Charger"],
		spellId = 1241429,
		itemId = 246264,
		npcs = { 205490 },
		chance = 50,
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

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMountsTWW)
return holidayEventMountsTWW
