local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WAR_WITHIN then
	return {}
end

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
		chance = 1000,
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
	-- 11.1 toys
	["Explosive Hearthstone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Explosive Hearthstone"],
		itemId = 236687,
		chance = 25,
		npcs = { 99999 },
		tooltipNpcs = { 230322 },
		lockBossName = "Stix Bunkjunker",
		statisticId = { 41311, 41312, 41313, 41314 },
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true,
		},
		coords = { { i = true, m = CONSTANTS.UIMAPIDS.LIBERATION_OF_UNDERMINE } },
		groupSize = 10,
		equalOdds = true,
	},
	-- 11.2 toys
	["Cosmic Hearthstone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Cosmic Hearthstone"],
		itemId = 246565,
		chance = 25,
		npcs = { 99999 },
		tooltipNpcs = { 230322 },
		lockBossName = "Dimensius",
		statisticId = { 41663, 41662, 41661, 41664 },
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true,
		},
		coords = { { i = true, m = CONSTANTS.UIMAPIDS.MANAFORGE_OMEGA } },
		groupSize = 10,
		equalOdds = true,
	},
	["Chowdar's Favorite Ribbon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Cyclonic Runekey"],
		itemId = 242323,
		npcs = { 232098 },
		chance = 10,
		coords = { { m = CONSTANTS.UIMAPIDS.KARESH } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, twwToysAndItems)
return twwToysAndItems
