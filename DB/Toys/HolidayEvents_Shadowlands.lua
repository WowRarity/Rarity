local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_SHADOWLANDS then
	return {}
end

local holidayEventToysShadowlands = {
	["Rockin' Rollin' Racer Customizer 19.9.3"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Rockin' Rollin' Racer Customizer 19.9.3"],
		itemId = 187422,
		items = { 116762 },
		chance = 50,
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Wreath-A-Rang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Wreath-A-Rang"],
		itemId = 178530,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Falling Star Flinger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Falling Star Flinger"],
		itemId = 191925,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Falling Star Catcher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Falling Star Catcher"],
		itemId = 191937,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysShadowlands)
return holidayEventToysShadowlands
