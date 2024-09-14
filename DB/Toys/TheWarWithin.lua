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
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Malfunctioning Mechsuit"],
		npcs = { 219440, 213119 },
		itemId = 226683,
		spellId = 442358,
		chance = 1, -- No data available
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { m = CONSTANTS.UIMAPIDS.THE_STONEVAULT, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, twwToysAndItems)
