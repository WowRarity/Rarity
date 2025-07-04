local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_BATTLE_FOR_AZEROTH then
	return {}
end

local holidayEventToysBfA = {
	["Crashin' Thrashin' Battleship)"] = { --Do not fix this typo until attempts can safely be migrated (see #824)
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Crashin' Thrashin' Battleship"],
		itemId = 172223,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		requiresAlliance = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Crashin' Thrashin' Juggernaught"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Crashin' Thrashin' Juggernaught"],
		itemId = 172222,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		requiresHorde = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Greatfather Winter's Hearthstone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Greatfather Winter's Hearthstone"],
		itemId = 162973,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Wild Holly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Wild Holly"],
		itemId = 172219,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayEvents = CONSTANTS.HolidayEvents["Feast of Winter Veil"],
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysBfA)
return holidayEventToysBfA
