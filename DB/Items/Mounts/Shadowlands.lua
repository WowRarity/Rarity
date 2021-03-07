local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local shadowlandsMounts = {
	-- 9.0 Mounts
	["Horrid Dredwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Horrid Dredwing"],
		itemId = 180461,
		spellId = 332882,
		npcs = {165290},
		chance = 100,
		questId = {59612},
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 46.0, y = 78.5, n = L["Harika the Horrid"]}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.VENTHYR
	},
	-- ["Bonehoof Tauralus"] = { -- NYI as of 21/01/2021 ?
	-- 	cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
	-- 	type = CONSTANTS.ITEM_TYPES.MOUNT,
	-- 	method = CONSTANTS.DETECTION_METHODS.NPC,
	-- 	name = L["Bonehoof Tauralus"],
	-- 	itemId = 182075,
	-- 	spellId = 332457,
	-- 	npcs = { 162586 },
	-- 	chance = 100,
	-- 	coords = {
	-- 		{ m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 44.2, y = 51.2, n = L["Tahonta"] },
	-- 	},
	-- 	requiresCovenant = true,
	-- 	requiredCovenantID = CONSTANTS.COVENANT_IDS.NECROLORD
	-- },

	["Hopecrusher Gargon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Hopecrusher Gargon"],
		itemId = 180581,
		spellId = 312753,
		npcs = {166679},
		chance = 100,
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 51.98, y = 51.80, n = L["Hopecrusher"]}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.VENTHYR
	},
	["Reins of the Colossal Slaughterclaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Reins of the Colossal Slaughterclaw"],
		spellId = 327405,
		itemId = 182081,
		items = {180646},
		chance = 20, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Amber Ardenmoth"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Amber Ardenmoth"],
		spellId = 342666,
		itemId = 183800,
		items = {180649},
		chance = 20, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARDENWEALD}
		}
	},
	["Phalynx of Humility"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Phalynx of Humility"],
		spellId = 334386,
		itemId = 180762,
		items = {356818},
		chance = 50,
		questId = {61688},
		sourceText = L["This mount can only drop for Kyrians. Requires channeling anima to Temple of Purity."],
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION, x = 60.23, y = 78.11, n = L["Penitence of Purity"]}
		}
	},
	["Bulbous Necroray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Bulbous Necroray"],
		spellId = 344574,
		itemId = 184160,
		items = {184158},
		chance = 10, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Pestilent Necroray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Pestilent Necroray"],
		spellId = 344575,
		itemId = 184162,
		items = {184158},
		chance = 10, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Infested Necroray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Infested Necroray"],
		spellId = 344576,
		itemId = 184161,
		items = {184158},
		chance = 10, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Silessa's Battle Harness"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Silessa's Battle Harness"],
		spellId = 333023,
		itemId = 183798,
		chance = 100,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	-- 9.0 Mounts
	["Endmire Flyer Tether"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Endmire Flyer Tether"],
		itemId = 180582,
		spellId = 332905,
		npcs = {166521},
		chance = 100,
		questId = {59869},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 62.0, y = 47.0, n = L["Famu the Infinite"]}
		}
	},
	["Wild Glimmerfur Prowler"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Wild Glimmerfur Prowler"],
		itemId = 180730,
		spellId = 334366,
		npcs = {168647},
		chance = 100,
		questId = {61632},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARDENWEALD, x = 30.4, y = 55.2, n = L["Valfir the Unrelenting"]}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.NIGHT_FAE
	},
	["Predatory Plagueroc"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Predatory Plagueroc"],
		itemId = 182080,
		spellId = 336045,
		npcs = {162741},
		chance = 33,
		questId = {58872},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 31.4, y = 35.6, n = L["Gieger"]}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.NECROLORD
	},
	["Slime-Covered Reins of the Hulking Deathroc"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Slime-Covered Reins of the Hulking Deathroc"],
		itemId = 182079,
		spellId = 336042,
		npcs = {157309},
		chance = 33,
		questId = {61720},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 58.6, y = 74.2, n = L["Violet Mistake"]}
		}
	},
	["Gorespine"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Gorespine"],
		itemId = 182084,
		spellId = 332480,
		npcs = {162690},
		chance = 50,
		questId = {58851},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 65.8, y = 35.3, n = L["Nerissa Heartless"]}
		}
	},
	["Blisterback Bloodtusk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Blisterback Bloodtusk"],
		itemId = 182085,
		spellId = 332478,
		npcs = {162819},
		chance = 33,
		questId = {58889},
		tooltipNpcs = {162818},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 33.6, y = 80.6, n = L["Warbringer Mal'Korak"]}
		}
	},
	["Armored Bonehoof Tauralus"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Armored Bonehoof Tauralus"],
		itemId = 181815,
		spellId = 332466,
		npcs = {168147},
		chance = 100, -- Estimate
		questId = {58784},
		tooltipNpcs = {168148},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 50.67, y = 47.37, n = L["Sabriel the Bonecleaver"]}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.NECROLORD
	},
	-- Note: This appears to not have made it to live, so I'm disabling it until further notice
	-- ["Bonecleaver's Skullboar"] = {
	-- 	cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
	-- 	type = CONSTANTS.ITEM_TYPES.MOUNT,
	-- 	method = CONSTANTS.DETECTION_METHODS.NPC,
	-- 	name = L["Bonecleaver's Skullboar"],
	-- 	itemId = 182083,
	-- 	spellId = 332482,
	-- 	npcs = { 168147 },
	-- 	chance = 100,	-- Estimate
	-- 	questId = { 58784 },
	-- 	tooltipNpcs = { 168148 },
	-- 	groupSize = 5,
	-- 	equalOdds = true,
	-- 	coords = {
	-- 		{ m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 50.67, y = 47.37, n = L["Sabriel the Bonecleaver"] },
	-- 	},
	-- },

	["Mawsworn Soulhunter"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Mawsworn Soulhunter"],
		itemId = 184167,
		spellId = 312762,
		npcs = {174861},
		chance = 100, -- Estimate
		questId = 63433,
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW, x = 53.5, y = 79.5, n = L["Gorged Shadehound"]}
		}
	},
	["Gnawed Reins of the Battle-Bound Warhound"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Gnawed Reins of the Battle-Bound Warhound"],
		itemId = 184062,
		spellId = 344228,
		npcs = {162873, 162880, 162875, 162853, 162874, 162872},
		chance = 100, -- Estimate
		questId = 62786,
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 50.67, y = 47.37, n = L["Theatre of Pain"]}
		}
	},
	["Marrowfang's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Marrowfang's Reins"],
		spellId = 336036,
		itemId = 181819,
		npcs = {99999},
		tooltipNpcs = {162693},
		statisticId = {14404},
		chance = 100,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_NECROTIC_WAKE}
		}
	},
	["Impressionable Gorger Spawn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Impressionable Gorger Spawn"],
		itemId = 180583,
		spellId = 333027,
		npcs = {160821},
		chance = 100, -- Estimate,
		questId = 58259,
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 38.60, y = 72.00, n = L["Worldedge Gorger"]}
		}
	},
	["Ascended Skymane"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Ascended Skymane"],
		spellId = 342335,
		itemId = 183741,
		items = {354175},
		chance = 20,
		tooltipNpcs = {170834, 170835, 170833, 170832, 170836},
		questId = {60933},
		groupSize = 5,
		equalOdds = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION, x = 53.50, y = 88.37, n = L["Cache of the Ascended"]}
		}
	}
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, shadowlandsMounts)
