local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WARLORDS_OF_DRAENOR then
	return {}
end

local holidayEventMountsWoD = {
	["Minion of Grumpus"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Minion of Grumpus"],
		spellId = 191314,
		itemId = 128671,
		items = { 128670 },
		chance = 100,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		coords = { { m = CONSTANTS.UIMAPIDS.LUNARFALL_GARRISON }, { m = CONSTANTS.UIMAPIDS.FROSTWALL_GARRISON } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMountsWoD)
return holidayEventMountsWoD
