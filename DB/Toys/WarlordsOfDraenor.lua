local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local wodToys = {
	-- Toys (6.x)
	["Crashin' Thrashin' Cannon Controller"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Crashin' Thrashin' Cannon Controller"],
		itemId = 108633,
		npcs = { 98284 },
		chance = 10,
		questId = 40106,
		coords = { { m = 534, x = 80.6, y = 56.4, n = L["Gondar"] } },
	},
	["Crashin' Thrashin' Mortar Controller"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Crashin' Thrashin' Mortar Controller"],
		itemId = 108634,
		npcs = { 98285 },
		chance = 10,
		questId = 40104,
		coords = { { m = 534, x = 88.1, y = 55.8, n = L["Smashum Grabb"] } },
	},
	["Crashin' Thrashin' Roller Controller"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Crashin' Thrashin' Roller Controller"],
		itemId = 108631,
		npcs = { 98283 },
		chance = 10,
		questId = 40105,
		coords = { { m = 534, x = 83.6, y = 43.6, n = L["Drakum"] } },
	},
	["Fandral's Seed Pouch"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Fandral's Seed Pouch"],
		itemId = 122304,
		npcs = { 52571 },
		chance = 100,
		disableForClass = {
			["DEATHKNIGHT"] = true,
			["DEMONHUNTER"] = true,
			["HUNTER"] = true,
			["MAGE"] = true,
			["MONK"] = true,
			["PALADIN"] = true,
			["PRIEST"] = true,
			["ROGUE"] = true,
			["SHAMAN"] = true,
			["WARLOCK"] = true,
			["WARRIOR"] = true,
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Majordomo Staghelm",
				instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true },
			},
			{
				encounterName = "Majordomo Staghelm",
				instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true },
			},
		},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
		},
		sourceText = L["Will only drop for druids."],
		coords = { { m = 369, x = 50.9, y = 72.4, i = true } },
	},
	["Botani Camouflage"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Botani Camouflage"],
		itemId = 119432,
		questId = 37369, -- Vignette: Protectors of the Grove
		npcs = { 86257 },
		chance = 5,
		coords = { { m = 543, x = 69.2, y = 44.8, n = L["Basten"] } },
	},
	["Outrider's Bridle Chain"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Outrider's Bridle Chain"],
		itemId = 120276,
		questId = 37546,
		npcs = { 81330 },
		chance = 8,
		coords = { { m = CONSTANTS.UIMAPIDS.NAGRAND_DRAENOR } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, wodToys)
