local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightMounts = {
	-- 10.0 mounts
	["Reins of the Liberated Slyvern"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Liberated Slyvern"],
		itemId = 201440,
		spellId = 359622,
		npcs = { 195353 },
		chance = 50,
		coords = { { x = 27.0, y = 48.4, n = L["Breezebiter"], m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN } },
	},
	["Plainswalker Bearer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Plainswalker Bearer"],
		spellId = 374196,
		itemId = 192791,
		items = { 200468 },
		chance = 33,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Verdant Skitterfly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Verdant Skitterfly"],
		spellId = 374048,
		itemId = 192764,
		chance = 100, -- Blind guess
		sourceText = L["This mount can only drop after hitting renown 25 with Dragonscale Expedition."],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Ancient Salamanther"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ancient Salamanther"],
		spellId = 374090,
		itemId = 192772,
		npcs = {
			201181,
			200960,
			200584,
			200904,
			200956,
			201013,
			200610,
			200721,
			200911,
			200600,
			200717,
			200978,
			200885,
			200681,
			200579,
			200537,
		},
		chance = 80, --rough guess by looking at wowhead data
		groupSize = 5,
		equalOdds = true,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 68.6, y = 45.6, n = L["Mad-Eye Carrey"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 45.9, y = 79.7, n = L["Warden Entrix"] }, --The War Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 58.6, y = 48.8, n = L["Vraken the Hunter"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 72.8, y = 67.5, n = L["Veltrax"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 36.8, y = 12.2, n = L["Ookbeard"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 61.7, y = 33.8, n = L["Wyrmslayer Angvardi"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 36.6, y = 32.4, n = L["Duzalgor"] }, --The Support Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 44.0, y = 90.3, n = L["Grugoth the Hullcrusher"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 74.5, y = 54.6, n = L["Volcanakk"] }, --The Siege Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 47.6, y = 20.6, n = L["Reisa the Drowned"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 44.8, y = 79.2, n = L["Galakhad"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 51.9, y = 72.8, n = L["Pyrachniss"] }, --The War Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 59.8, y = 58.8, n = L["Lady Shaz'ra"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 43.6, y = 61.0, n = L["Bonesifter Marwak"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 41.2, y = 13.4, n = L["Ishyra"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 28.2, y = 38.2, n = L["Gahz'raxes"] },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, dragonflightMounts)
