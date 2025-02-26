local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MISTS_OF_PANDARIA then
	return {}
end

local holidayEventPetsMoP = {
	["Darkmoon Eye"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Darkmoon Eye"],
		spellId = 132789,
		itemId = 91040,
		items = { 91086 },
		chance = 50,
		creatureId = 67332,
		sourceText = L["This bag is rewarded for completing the pet battle daily offered by Jeremy Feasel at the Darkmoon Faire."],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
		questId = 32175,
		coords = { { m = 407, x = 47.8, y = 62.6, n = L["Jeremy Feasel"] } },
	},
	["Rotten Helper Box"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Rotten Helper Box"],
		spellId = 148567,
		itemId = 104317,
		items = { 116762 },
		chance = 100,
		creatureId = 73741,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		coords = { { m = 87, x = 33.2, y = 67.8 }, { m = 25, x = 42.4, y = 41 }, { m = 86, x = 54.4, y = 77 } },
	},
	["Moon Moon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Moon Moon"],
		spellId = 144761,
		itemId = 101570,
		npcs = { 71992 },
		chance = 17,
		creatureId = 72160,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
		coords = { { m = CONSTANTS.UIMAPIDS.DARKMOON_ISLAND, x = 39.8, y = 44.4, n = L["Moonfang"] } },
	},
	["Darkmoon Rabbit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Darkmoon Rabbit"],
		spellId = 114090,
		itemId = 80008,
		npcs = { 58336 },
		chance = 10,
		creatureId = 59358,
		coords = { { m = CONSTANTS.UIMAPIDS.DARKMOON_ISLAND, x = 75.6, y = 86.8 } },
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsMoP)
return holidayEventPetsMoP
