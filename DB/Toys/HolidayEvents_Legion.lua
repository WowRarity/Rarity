local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_LEGION then
	return {}
end

local holidayEventToysLegion = {
	["Blight Boar Microphone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Blight Boar Microphone"],
		itemId = 151265,
		npcs = { 122899 },
		chance = 10,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
		coords = { { m = 407, x = 65.6, y = 67 } },
		questId = { 47767 },
	},
	["Disposable Winter Veil Suits"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Disposable Winter Veil Suits"],
		itemId = 139337,
		items = { 116762 },
		chance = 50,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Hearthstation (Horde)"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Hearthstation"],
		itemId = 151344,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		requiresHorde = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Hearthstation (Alliance)"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Hearthstation"],
		itemId = 151343,
		items = { 116762 },
		chance = 100, -- Blind guess
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		requiresAlliance = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Toy Weapon Set (Horde)"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Toy Weapon Set"],
		itemId = 151348,
		items = { 116762 },
		chance = 200, -- Guess
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		requiresHorde = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
	["Toy Weapon Set (Alliance)"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Toy Weapon Set"],
		itemId = 151349,
		items = { 116762 },
		chance = 200, -- Guess
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL,
		questId = { 6983, 7043 },
		requiresAlliance = true,
		coords = { { m = CONSTANTS.UIMAPIDS.HILLSBRAD_FOOTHILLS, x = 43.6, y = 39.6 } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, holidayEventToysLegion)
return holidayEventToysLegion
