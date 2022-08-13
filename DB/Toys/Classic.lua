local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local classicToys = {
	["Piccolo of the Flaming Fire"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Piccolo of the Flaming Fire"],
		itemId = 13379,
		npcs = { 10558 },
		chance = 4,
		coords = { { m = 317, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, classicToys)
