local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_CATACLYSM then
	return {}
end

local holidayEventToysCataclysm = {
	["MiniZep Controller"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["MiniZep Controller"],
		itemId = 46709,
		items = { 116762 },
		chance = 50,
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysCataclysm)
return holidayEventToysCataclysm
