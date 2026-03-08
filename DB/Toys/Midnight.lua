local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if not LE_EXPANSION_MIDNIGHT or LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local midnightToys = {
	["Nether-Warped Egg"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Nether-Warped Egg"],
		itemId = 268730,
		chance = 2500,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS_MIDNIGHT },
			{ m = CONSTANTS.UIMAPIDS.ZUL_AMAN_MIDNIGHT },
			{ m = CONSTANTS.UIMAPIDS.VOIDSTORM },
			{ m = CONSTANTS.UIMAPIDS.SLAYERS_RISE },
			{ m = CONSTANTS.UIMAPIDS.HARANDAR },
		},
		zones = {
			tostring(CONSTANTS.UIMAPIDS.EVERSONG_WOODS_MIDNIGHT),
			tostring(CONSTANTS.UIMAPIDS.ZUL_AMAN_MIDNIGHT),
			tostring(CONSTANTS.UIMAPIDS.VOIDSTORM),
			tostring(CONSTANTS.UIMAPIDS.SLAYERS_RISE),
			tostring(CONSTANTS.UIMAPIDS.HARANDAR),
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, midnightToys)
return midnightToys
