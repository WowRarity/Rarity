local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WAR_WITHIN then
	return {}
end

local holidayEventMountsTWW = {
	["Tyrael's Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tyrael's Charger"],
		spellId = 107203,
		itemId = 76755,
		npcs = { 205490 },
		chance = 100,
		holidayEvents = CONSTANTS.HolidayEvents["A Greedy Emissary"],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.STORMWIND_CITY },
			{ m = CONSTANTS.UIMAPIDS.ORGRIMMAR },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.VALDRAKKEN },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.LIBERATION_OF_UNDERMINE },
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
		chance = 50,
		holidayEvents = CONSTANTS.HolidayEvents["A Greedy Emissary"],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.STORMWIND_CITY },
			{ m = CONSTANTS.UIMAPIDS.ORGRIMMAR },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.VALDRAKKEN },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.LIBERATION_OF_UNDERMINE },
		},
	},
	["Brewfest Barrel Bomber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Brewfest Bomber"],
		spellId = 1247662,
		itemId = 248761,
		items = { 54535, 117393 },
		questId = { 91894 },
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."]
			.. " "
			.. L["Only available on the first attempt each day."],
		lockDungeonId = 287,
		holidayTexture = CONSTANTS.HolidayEvents["Brewfest"],
		coords = { { m = 242, x = 46.6, y = 60, i = true } },
	},
	["Love Witch's Sweeper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Love Witch's Sweeper"],
		spellId = 472479,
		itemId = 232926,
		items = { 54537 },
		chance = 666,
		groupSize = 5,
		equalOdds = true,
		holidayEvents = CONSTANTS.HolidayEvents["Love is in the Air"],
		sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."]
			.. " "
			.. L["Only available on the first attempt each day."],
		lockDungeonId = 288,
		coords = { { m = 310, x = 40.8, y = 52.6, i = true } },
	},
	["The Headless Horseman's Ghoulish Charger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["The Headless Horseman's Ghoulish Charger"],
		spellId = 1245198,
		itemId = 247721,
		items = { 209024 },
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L["Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."]
			.. " "
			.. L["Only available on the first attempt each day."],
		lockDungeonId = 285,
		holidayEvents = CONSTANTS.HolidayEvents["Hallow's End"],
		coords = { { m = 435, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMountsTWW)
return holidayEventMountsTWW
