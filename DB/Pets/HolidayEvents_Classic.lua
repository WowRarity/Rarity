local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local holidayEventPetsClassic = {
	["Green Helper Box"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Green Helper Box"],
		spellId = 26533,
		itemId = 21301,
		items = { 21310 },
		chance = 4,
		creatureId = 15698,
		sourceText = L["Available starting December 25th"],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 8768 },
		coords = {
			zoneOverride = L["Greatfather Winter's Tree"],
			{ m = 87, x = 33.5, y = 66 },
			{ m = 86, x = 49.3, y = 78.4 },
		},
		christmasOnly = true,
	},
	["Jingling Bell"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Jingling Bell"],
		spellId = 26529,
		itemId = 21308,
		items = { 21310 },
		chance = 4,
		creatureId = 15706,
		sourceText = L["Available starting December 25th"],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		coords = {
			zoneOverride = L["Greatfather Winter's Tree"],
			{ m = 87, x = 33.5, y = 66 },
			{ m = 86, x = 49.3, y = 78.4 },
		},
		questId = { 8768 },
		christmasOnly = true,
	},
	["Red Helper Box"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Red Helper Box"],
		spellId = 26541,
		itemId = 21305,
		items = { 21310 },
		chance = 4,
		creatureId = 15705,
		sourceText = L["Available starting December 25th"],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 8768 },
		coords = {
			zoneOverride = L["Greatfather Winter's Tree"],
			{ m = 87, x = 33.5, y = 66 },
			{ m = 86, x = 49.3, y = 78.4 },
		},
		christmasOnly = true,
	},
	["Snowman Kit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Snowman Kit"],
		spellId = 26045,
		itemId = 21309,
		items = { 21310 },
		chance = 4,
		creatureId = 15710,
		sourceText = L["Available starting December 25th"],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 8768 },
		coords = {
			zoneOverride = L["Greatfather Winter's Tree"],
			{ m = 87, x = 33.5, y = 66 },
			{ m = 86, x = 49.3, y = 78.4 },
		},
		christmasOnly = true,
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsClassic)
return holidayEventPetsClassic
