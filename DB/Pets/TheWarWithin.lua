local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WAR_WITHIN then
	return {}
end

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
		chance = 30,
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
		chance = 1000,
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
	-- 11.1 pets
	["Craboom"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Craboom"],
		chance = 5,
		creatureId = 238393,
		itemId = 236768,
		npcs = { 226396 },
		spellId = 1220834,
		coords = { { m = CONSTANTS.UIMAPIDS.OPERATION_FLOODGATE } },
		groupSize = 5,
		equalOdds = true,
	},
	["Viridian Mechasaur"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		chance = 33,
		creatureId = 231456,
		name = L["Viridian Mechasaur"],
		itemId = 232838,
		items = { 233557 },
		spellId = 471944,
		coords = { { m = CONSTANTS.UIMAPIDS.UNDERMINE, x = 25.6, y = 38.2, n = L["Angelo Rustbin"] } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, twwPets)
return twwPets
