local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local holidayEventPetsDF = {
	["Arfus"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Arfus"],
		spellId = 406225,
		itemId = 211271,
		items = { 209024 },
		chance = 100, -- Blind guess
		groupSize = 5,
		equalOdds = true,
		creatureId = 203463,
		lockDungeonId = 285,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.HALLOWS_END,
		coords = { { m = 435, i = true } },
		sourceText = L["Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."],
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsDF)
