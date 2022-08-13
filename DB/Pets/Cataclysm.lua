local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local cataclysmPets = {
	-- 4.x
	["Elementium Geode"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Elementium Geode"],
		spellId = 93838,
		itemId = 67282,
		obtain = L["Obtained by mining Elementium Vein"],
		chance = 2000,
		creatureId = 50722,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.DEEPHOLM },
			{ m = CONSTANTS.UIMAPIDS.TWILIGHT_HIGHLANDS },
			{ m = CONSTANTS.UIMAPIDS.ULDUM_CATACLYSM },
			{ m = CONSTANTS.UIMAPIDS.TOL_BARAD_PENINSULA },
			{ m = CONSTANTS.UIMAPIDS.TOL_BARAD },
		},
	},
	["Fox Kit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Fox Kit"],
		spellId = 90637,
		itemId = 64403,
		npcs = { 47676 },
		chance = 1000,
		creatureId = 48641,
		coords = { { m = 245 } },
	},
	["Mr. Grubbs"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Mr. Grubbs"],
		spellId = 93739,
		itemId = 66076,
		items = { 61387 },
		chance = 50,
		creatureId = 50586,
		coords = { { m = 23 } },
	},
	["Scorched Stone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Scorched Stone"],
		spellId = 45890,
		itemId = 34955,
		items = { 71631 },
		chance = 20,
		creatureId = 25706,
		coords = { { m = 338, x = 47, y = 90.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, cataclysmPets)
