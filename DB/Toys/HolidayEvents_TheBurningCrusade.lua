local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_BURNING_CRUSADE then
	return {}
end

local holidayEventToysTBC = {
	["Crashin' Thrashin' Racer Controller"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Crashin' Thrashin' Racer Controller"],
		itemId = 37710,
		items = { 116762 },
		chance = 50,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysTBC)
return holidayEventToysTBC
