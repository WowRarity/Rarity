local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WARLORDS_OF_DRAENOR then
	return {}
end

local holidayEventPetsWoD = {
	["Frightened Bush Chicken"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Frightened Bush Chicken"],
		spellId = 171500,
		itemId = 116403,
		items = { 116404 },
		chance = 33,
		creatureId = 85846,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.PILGRIMS_BOUNTY,
		coords = {
			{ m = 523, x = 60, y = 34.2 },
			{ m = 1, x = 46.4, y = 13.8 },
			{ m = 89, x = 61.8, y = 46.4 },
			{ m = 88, x = 31, y = 69.6 },
			{ m = 37, x = 33.8, y = 50.8 },
			{ m = 998, x = 65.2, y = 13.8 },
			{ m = 37, x = 33.6, y = 50.6 },
			{ m = 998, x = 63.4, y = 9 },
		},
	},
	["Grumpling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Grumpling"],
		spellId = 191967,
		itemId = 128770,
		obtain = L["Obtained by opening Snow Mound in Frostfire Ridge"],
		chance = 20,
		creatureId = 97229,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		coords = { { m = 525, x = 45.8, y = 26.6, n = L["Snow Mound"] } },
	},
	["Syd the Squid"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Syd the Squid"],
		spellId = 170774,
		itemId = 116064,
		items = { 116062 },
		chance = 50,
		creatureId = 85527,
		sourceText = L["This bag is rewarded for completing the pet battle daily offered by Christoph VonFeasel at the Darkmoon Faire."],
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
		questId = 36471,
		coords = { { m = 407, x = 47.4, y = 62.2, n = L["Christoph VonFeasel"] } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsWoD)
return holidayEventPetsWoD
