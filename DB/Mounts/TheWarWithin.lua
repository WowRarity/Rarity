local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local twwMounts = {
	-- 11.0 mounts
	["Reins of the Sureki Skyrazor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Sureki Skyrazor"],
		itemId = 224147,
		spellId = 451486,
		npcs = { 219778 },
		groupSize = 5,
		equalOdds = true,
		chance = 100, -- No data available
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { i = true, m = CONSTANTS.UIMAPIDS.NERUBAR_PALACE } },
	},
	["Beledar's Spawn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Beledar's Spawn"],
		itemId = 223315,
		spellId = 448941,
		npcs = { 207802 },
		chance = 100, -- No data available
		coords = { { m = CONSTANTS.UIMAPIDS.HALLOWFALL } },
	},
	["Regurgitated Mole Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Regurgitated Mole Reins"],
		itemId = 223501,
		spellId = 449258,
		npcs = { 220285 },
		chance = 100, -- No data available
		coords = { { m = CONSTANTS.UIMAPIDS.THE_RINGING_DEEPS } },
	},
	["Wick's Lead"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Wick's Lead"],
		itemId = 225548,
		spellId = 449264,
		npcs = { 210797 },
		groupSize = 5,
		equalOdds = true,
		chance = 100, -- No data available
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { m = CONSTANTS.UIMAPIDS.DARKFLAME_CLEFT, i = true } },
	},
	["Alunira"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Alunira"],
		itemId = 223270,
		collectedItemId = { 224025 },
		spellId = 447213,
		chance = 10,
		coords = { { m = CONSTANTS.UIMAPIDS.ISLE_OF_DORN } },
	},
	["Dauntless Imperial Lynx"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Dauntless Imperial Lynx"],
		itemId = 223318,
		spellId = 448979,
		items = { 228741 },
		chance = 100, -- No data available
		coords = { { i = true, m = CONSTANTS.UIMAPIDS.HALLOWFALL } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, twwMounts)
