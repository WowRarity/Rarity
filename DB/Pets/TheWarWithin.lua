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
		npcs = { 218523 },
		itemId = 223155,
		spellId = 446024,
		chance = 5, -- No data available
		creatureId = 222318,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true },
		coords = { { m = CONSTANTS.UIMAPIDS.CINDERBREW_MEADERY, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, twwPets)
