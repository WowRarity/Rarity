local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local MidnightMounts = {
	-- 12.0 mounts
	["Sanguine Harrower"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Sanguine Harrower"],
		itemId = 260635,
		spellId = 1266700,
		npcs = { 244272,244272,256923,256925,256808,256770,245044,238498,256922,256924,256926,257027,245182,256821 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.VOIDSTORM } },
		},
		["Augmented Stormray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Augmented Stormray"],
		itemId = 257085,
		spellId = 1261155,
		npcs = { 244272,244272,256923,256925,256808,256770,245044,238498,256922,256924,256926,257027,245182,256821 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.VOIDSTORM } },
			},
		["Lost Nether Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Lost Nether Drake"],
		zones = { "2405" },
		spellId = 3363,
		itemId = 260916,
		chance = 2000,
		requiresPool = false,
		coords = {	{ m = CONSTANTS.UIMAPIDS.VOIDSTORM },
				},
		["Amani Sharptalon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Amani Sharptalon"],
		itemId = 257152,
		spellId = 1261316,
		npcs = { 242023,242025,245975,242031,242033,242035,242027,245692,242024,242028,247976,242032,242034,242026,245691 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.ZULAMAN } },
					},
		["Escaped Witherbark Pango"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Escaped Witherbark Pango"],
		itemId = 257200,
		spellId = 1261351,
		npcs = { 242023,242025,245975,242031,242033,242035,242027,245692,242024,242028,247976,242032,242034,242026,245691 },
		chance = 5,
		coords = { { m = CONSTANTS.UIMAPIDS.ZULAMAN } },
		},
		["Cerulean Hawkstrider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Cerulean Hawkstrider"],
		itemId = 257156,
		spellId = 1261323,
		npcs = { 246332,240129,250719,250754,250841,250826,255302,255348,246633,250582,250683,250876,250780,250806,255329 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS } },
		},
			["Cobalt Dragonhawk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Cobalt Dragonhawk"],
		itemId = 257147,
		spellId = 1261302,
		npcs = { 246332,240129,250719,250754,250841,250826,255302,255348,246633,250582,250683,250876,250780,250806,255329 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.EVERSONG_WOODS } },
		},
			["Vibrant Petalwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Vibrant Petalwing"],
		itemId = 252012,
		spellId = 1253927,
		npcs = { 248741,249849,249962,250086,250226,250246,250321,250358,249844,249902,249997,250180,250231,250317,250347,246735 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.HARANDAR } },
		},
			["Rootstalker Grimlynx"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Rootstalker Grimlynx"],
		itemId = 246735,
		spellId = 1243597,
		npcs = { 248741,249849,249962,250086,250226,250246,250321,250358,249844,249902,249997,250180,250231,250317,250347 },
		chance = 25,
		coords = { { m = CONSTANTS.UIMAPIDS.HARANDAR } },
		},
	}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, MidnightMounts)
return MidnightMounts
