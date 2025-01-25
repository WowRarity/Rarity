local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local twwToysAndItems = {
	-- 11.0 items and toys
	["Crackling Shard"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.ZONE,
		name = L["Crackling Shard"],
		itemId = 224025,
		spellId = 450842, -- Irrelevant
		zones = { tostring(CONSTANTS.UIMAPIDS.ISLE_OF_DORN) },
		chance = 2000,
		sourceText = L["Dropped by any mob in Isle of Dorn (except minor mobs). 10 of these can be combined to pierce Alunira's shield, allowing combat and a guaranteed drop of Alunira."],
		coords = { { m = CONSTANTS.UIMAPIDS.ISLE_OF_DORN } },
		repeatable = true,
	},
	["Malfunctioning Mechsuit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Malfunctioning Mechsuit"],
		npcs = { 99999 },
		tooltipNpcs = { 219440, 213119 },
		statisticId = { 40722 },
		itemId = 226683,
		spellId = 442358,
		chance = 200,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { m = CONSTANTS.UIMAPIDS.THE_STONEVAULT, i = true } },
	},
	-- 11,0.7 items and toys
	["Glittering Vault Shard"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Glittering Vault Shard"],
		itemId = 235017,
		npcs = {
			228159, -- Gunnlod the Sea-Drinker
			231368, -- Ksvir the Forgotten
			227550, -- Shardsong
		},
		chance = 10,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORGOTTEN_VAULT } },
	},
	["Cyclonic Runekey"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Cyclonic Runekey"],
		itemId = 232569,
		npcs = {
			231357, -- Zek'ul the Shipbreaker
		},
		chance = 100,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORGOTTEN_VAULT } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, twwToysAndItems)
