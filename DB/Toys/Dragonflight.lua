local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightToys = {
	--10.0 toys
	["A Collection Of Me"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["A Collection Of Me"],
		itemId = 200148,
		npcs = { 193210, 193176, 193126, 193241 },
		chance = 6,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS, x = 58.4, y = 85.6, L["Phleep"] },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS, x = 37.6, y = 78.0, L["Sandana the Tempest"] },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS, x = 60.6, y = 82.6, L["Innumerable Ruination"] },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS, x = 62.2, y = 81.6, L["Lord Epochbrgl"] },
		},
	},
	["Personal Shell"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Personal Shell"],
		itemId = 198409,
		npcs = { 193133 },
		chance = 2,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 63.2, y = 48.6, L["Sunscale Behemoth"] },
		},
	},
	["Infected Ichor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Infected Ichor"],
		itemId = 200178,
		npcs = { 193128, 197356, 193178 },
		chance = 12,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 90.4, y = 40.0, L["Blightpaw the Depraved"] },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 16.2, y = 33.6, L["High Shaman Rotknuckle"] },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 13.4, y = 22.6, L["Blightfur"] },
		},
	},
	["Aquatic Shades"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Aquatic Shades"],
		itemId = 202042,
		items = { 202102 },
		chance = 2,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 82.2, y = 73.2, L["Immaculate Sac of Swog Treasures"] },
		},
	},
	["The Super Shellkhan Gang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["The Super Shellkhan Gang"],
		itemId = 200999,
		npcs = { 191305 },
		chance = 3,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS, x = 38.4, y = 68.6, L["The Great Shellkhan"] },
		},
	},
	["Notfar's Favorite Food"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Notfar's Favorite Food"],
		itemId = 200160,
		npcs = { 198703 },
		chance = 6,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 20.6, y = 49.6, L["Notfar the Unbearable"] },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, dragonflightToys)
