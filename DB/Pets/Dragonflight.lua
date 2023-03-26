local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightPets = {
	["Ohuna Companion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Ohuna Companion"],
		itemId = 200276,
		items = { 200468, 200513, 200515 },
		spellId = 389429,
		creatureId = 189134,
		chance = 100, -- Guess
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Bakar Companion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Bakar Companion"],
		itemId = 200290,
		items = { 200468, 200513, 200515 },
		spellId = 389503,
		creatureId = 189159,
		chance = 100, -- Guess
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Ashenwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ashenwing"],
		npcs = { 200681 },
		itemId = 193374,
		spellId = 375085,
		chance = 20,
		creatureId = 189118,
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 43.6, y = 61.0, L["Bonesifter Marwak"] } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, dragonflightPets)
