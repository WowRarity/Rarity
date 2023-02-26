local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightMounts = {
	-- 10.0 mounts
	["Reins of the Liberated Slyvern"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Liberated Slyvern"],
		itemId = 201440,
		spellId = 359622,
		npcs = { 195353 },
		chance = 50,
		coords = { { x = 27.0, y = 48.4, n = L["Breezebiter"], m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN } },
	},
	["Plainswalker Bearer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Plainswalker Bearer"],
		spellId = 374196,
		itemId = 192791,
		items = { 200468 },
		chance = 33,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Verdant Skitterfly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Verdant Skitterfly"],
		spellId = 374048,
		itemId = 192764,
		chance = 100, -- Blind guess
		sourceText = L["This mount can only drop after hitting renown 25 with Dragonscale Expedition."],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, dragonflightMounts)
