local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WRATH_OF_THE_LICH_KING then
	return {}
end

local holidayEventToysWrath = {
	["The Heartbreaker"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["The Heartbreaker"],
		itemId = 50471,
		items = { 54537 },
		chance = 83,
		groupSize = 5,
		equalOdds = true,
		sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."],
		lockDungeonId = 288,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.LOVE_IS_IN_THE_AIR,
		coords = { { m = 310, x = 40, y = 52.6, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysWrath)
return holidayEventToysWrath
