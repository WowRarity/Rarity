local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_DRAGONFLIGHT then
	return {}
end

local holidayEventMountsDragonflight = {
	["Noble Flying Carpet"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Noble Flying Carpet"],
		spellId = 432455,
		itemId = 212599,
		items = { 216874 },
		chance = 100, -- Might be higher after the adjustment? (Needs more data)
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.NOBLEGARDEN,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.DUROTAR },
			{ m = CONSTANTS.UIMAPIDS.ELWYNN_FOREST },
		},
	},
	["Tyrael's Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tyrael's Charger"],
		spellId = 107203,
		itemId = 76755,
		npcs = { 205490 },
		chance = 100, 
		},
	},
	["Inarius' Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Inarius' Charger"],
		spellId = 1241429,
		itemId = 246264,
		npcs = { 205490 },
		chance = 100, 
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMountsDragonflight)
return holidayEventMountsDragonflight
