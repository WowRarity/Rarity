local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local tbcToys = {
	["Orb of the Sin'dorei"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Orb of the Sin'dorei"],
		itemId = 35275,
		npcs = { 24664, 24744, 24723, 24560 },
		chance = 60,
		coords = { { m = 348, i = true } },
	},
	["Time-Lost Figurine"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Time-Lost Figurine"],
		itemId = 32782,
		npcs = { 21838 },
		chance = 10,
		coords = { { m = 108, x = 66.2, y = 77.6 } },
	},
	["Mr. Pinchy"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Mr. Pinchy"],
		spellId = 33050,
		itemId = 27388,
		zones = {
			"Lake Jorune",
			"Lake Ere'Noru",
			"Skethyl Mountains",
			"Blackwind Landing",
			"Blackwind Valley",
			"Skettis",
			"Blackwind Lake",
			"Veil Harr'ik",
			"Veil Ala'rak",
			"Terokk's Rest",
		},
		excludedMaps = {
			[542] = true, -- Spires of Arak (Skettis exists in both Draenor and Outland)
		},
		chance = 500,
		requiresPool = true,
		creatureId = 18839,
		sourceText = L["Obtained by fishing in pools located in Terrokar Forest"],
		coords = { { m = 108 } },
	},
	-- Achievements
	["Old Crafty"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Old Crafty"],
		itemId = 34486,
		zones = { "Orgrimmar" },
		chance = 10000,
		requiresPool = false,
		achievementId = 1836,
		sourceText = L["Obtained by fishing in any water in Orgrimmar"],
		coords = { { m = 85 } },
	},
	["Old Ironjaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Old Ironjaw"],
		itemId = 34484,
		zones = { "Ironforge", "The Forlorn Cavern" },
		chance = 10000,
		requiresPool = false,
		achievementId = 1837,
		sourceText = L["Obtained by fishing in any water in Ironforge"],
		coords = { { m = 87 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, tbcToys)
