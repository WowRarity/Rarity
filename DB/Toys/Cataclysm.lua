local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local cataclysmToys = {
	["Loaded Gnomish Dice"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Loaded Gnomish Dice"],
		itemId = 63269,
		chance = 300,
		npcs = { 45174, 49124, 47595, 46320, 48629 },
		pickpocket = true,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.TWILIGHT_HIGHLANDS },
			{ m = CONSTANTS.UIMAPIDS.TOL_BARAD },
			{ m = CONSTANTS.UIMAPIDS.ULDUM_CATACLYSM },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, cataclysmToys)
