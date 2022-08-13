local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local classicMounts = {
	["Deathcharger's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Deathcharger's Reins"],
		spellId = 17481,
		itemId = 13335,
		npcs = { 99999 },
		tooltipNpcs = { 45412 },
		chance = 100,
		statisticId = { 1097 },
		bonusSatchel = true,
		blackMarket = true,
		coords = { { m = 317, x = 38.6, y = 20, i = true } },
	},
	["Red Qiraji Resonating Crystal"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Red Qiraji Resonating Crystal"],
		spellId = 26054,
		itemId = 21321,
		npcs = { 15311, 15250, 15247, 15246, 15264, 15262, 15277, 15312, 15252, 15249 },
		chance = 100,
		coords = { { m = 319, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, classicMounts)
