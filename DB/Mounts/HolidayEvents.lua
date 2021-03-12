local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = Rarity.constants

local holidayEventMounts = {
	["Minion of Grumpus"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Minion of Grumpus"],
		spellId = 191314,
		itemId = 128671,
		items = {128670},
		chance = 100,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL
	},
	["Great Brewfest Kodo"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Great Brewfest Kodo"],
		spellId = 49379,
		itemId = 37828,
		items = {54535, 117393},
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."
		],
		lockDungeonId = 287,
		coords = {{m = 243, x = 46.6, y = 60, i = true}}
	},
	["Swift Brewfest Ram"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Swift Brewfest Ram"],
		spellId = 43900,
		itemId = 33977,
		items = {54535, 117393},
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."
		],
		lockDungeonId = 287,
		coords = {{m = 242, x = 46.6, y = 60, i = true}}
	},
	["The Horseman's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["The Horseman's Reins"],
		spellId = 48025,
		itemId = 37012,
		items = {117392},
		chance = 200,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."
		],
		lockDungeonId = 285,
		coords = {{m = 435, i = true}}
	}
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMounts)
