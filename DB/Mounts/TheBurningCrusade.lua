local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local tbcMounts = {
	-- 2.x
	["Ashes of Al'ar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Ashes of Al'ar"],
		spellId = 40192,
		itemId = 32458,
		npcs = { 99999 },
		tooltipNpcs = { 19622 },
		chance = 100,
		statisticId = { 1088 },
		blackMarket = true,
		coords = { { m = 334, x = 50.6, y = 15.2, i = true } },
	},
	["Fiery Warhorse's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Fiery Warhorse's Reins"],
		spellId = 36702,
		itemId = 30480,
		npcs = { 16152 },
		chance = 100,
		blackMarket = true,
		lockBossName = "Attumen the Huntsman",
		coords = { { m = 350, x = 46.6, y = 82.6, i = true } },
	},
	["Reins of the Raven Lord"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Raven Lord"],
		spellId = 41252,
		itemId = 32768,
		npcs = { 23035 },
		chance = 67,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true,
		},
		bonusSatchel = true,
		blackMarket = true,
		lockBossName = "Anzu",
		coords = { { m = 258, x = 32.6, y = 54.5, i = true } },
	},
	["Swift White Hawkstrider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Swift White Hawkstrider"],
		spellId = 46628,
		itemId = 35513,
		npcs = { 24664 },
		chance = 33,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true,
		},
		sourceText = L["Heroic difficulty"],
		bonusSatchel = true,
		blackMarket = true,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.MAGISTERS_TERRACE_GRAND_MAGISTERS_ASYLUM, x = 8.6, y = 50.2, i = true },
			{ m = CONSTANTS.UIMAPIDS.MAGISTERS_TERRACE_OBSERVATION_GROUNDS, i = true },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, tbcMounts)
