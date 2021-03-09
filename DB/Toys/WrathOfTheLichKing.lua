local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local wotlkToys = {
	-- Toys (3.x)
	["Frenzyheart Brew"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Frenzyheart Brew"],
		itemId = 44719,
		items = {44718},
		chance = 4,
		sourceText = L[
			"Contained in Ripe Disgusting Jar, which is obtained by becoming Revered with Frenzyheart Tribe, purchasing a Disgusting Jar from their reputation vendor, and waiting three days."
		],
		coords = {{m = 119, x = 55, y = 69}}
	},
	["Unusual Compass"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Unusual Compass"],
		itemId = 45984,
		items = {46007},
		chance = 20,
		coords = {{m = 125, x = 52.6, y = 65.6}}
	}
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, wotlkToys)
