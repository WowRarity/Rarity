local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local wotlkPets = {
	-- 3.x
	["Deviate Hatchling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Deviate Hatchling"],
		spellId = 67414,
		itemId = 48114,
		npcs = { 3636, 3637 },
		chance = 500,
		creatureId = 35395,
		blackMarket = true,
		coords = { { m = 279 } },
	},
	["Giant Sewer Rat"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Giant Sewer Rat"],
		spellId = 59250,
		itemId = 43698,
		zones = { "Cantrips & Crows", "Circle of Wills", "The Underbelly", "The Black Market" },
		chance = 1000,
		requiresPool = false,
		blackMarket = true,
		creatureId = 31575,
		coords = { { m = 125 } },
	},
	["Gundrak Hatchling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Gundrak Hatchling"],
		spellId = 67415,
		itemId = 48116,
		npcs = { 29334 },
		chance = 1000,
		creatureId = 35400,
		blackMarket = true,
		coords = { { m = 121 } },
	},
	["Razzashi Hatchling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.ZONE,
		name = L["Razzashi Hatchling"],
		spellId = 67420,
		itemId = 48126,
		zones = { "224", "50", "210" },
		chance = 5000,
		creatureId = 35394,
		blackMarket = true,
		coords = { { m = 224 }, { m = 50 }, { m = 210 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, wotlkPets)
