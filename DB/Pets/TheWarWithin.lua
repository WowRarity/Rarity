local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local twwPets = {
	-- 11.0 pets
	["Bop"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Bop"],
		npcs = { 218523, 214661 },
		itemId = 223155,
		spellId = 446024,
		chance = 5, -- No data available
		creatureId = 222318,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { m = CONSTANTS.UIMAPIDS.CINDERBREW_MEADERY, i = true } },
	},
	["Writhing Transmutagen"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Writhing Transmutagen"],
		itemId = 223487,
		spellId = 446059,
		chance = 20, -- No data available
		creatureId = 222359,
	},
	-- 11.0.7 pets
	["Crackleroar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		chance = 100,
		creatureId = 235124,
		itemId = 234379,
		name = L["Crackleroar"],
		npcs = { 230827, 231353 },
		spellId = 1213821,
		coords = { { m = CONSTANTS.UIMAPIDS.SIREN_ISLE } },
	},
	["Proper Parrot"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		chance = 100,
		creatureId = 148542,
		itemId = 166358,
		name = L["Proper Parrot"],
		npcs = { 229169, 227644, 229189, 229171, 228582, 229168, 228583, 228580, 229190 },
		spellId = 288054,
		coords = { { m = CONSTANTS.UIMAPIDS.SIREN_ISLE } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, twwPets)
