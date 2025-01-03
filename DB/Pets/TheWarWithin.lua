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
	["Bouncer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Bouncer"],
		itemId = 222971,
		spellId = 446434,
		creatureId = 222532,
		chance = 100,
		coords = {
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
		},
	},
	["Wriggle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Wriggle"],
		itemId = 221496,
		spellId = 446464,
		creatureId = 222078,
		chance = 100,
		coords = {
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
		},
	},
	["Chester"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Chester"],
		itemId = 221820,
		spellId = 447016,
		creatureId = 222883,
		chance = 100,
		coords = {
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
		},
	},
	["Violet Sporbit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Violet Sporbit"],
		itemId = 225337,
		spellId = 446498,
		creatureId = 222590,
		chance = 100,
		coords = {
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
		},
	},
	["Sneef"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TWW,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Sneef"],
		itemId = 223624,
		spellId = 449475,
		creatureId = 223718,
		chance = 100,
		coords = {
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
			{ i = true, m = CONSTANTS.UIMAPIDS.AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, twwPets)
