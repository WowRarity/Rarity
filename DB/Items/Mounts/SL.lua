local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local shadowlandsMounts = {
	-- Holiday
	["Minion of Grumpus"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Minion of Grumpus"],
		spellId = 191314,
		itemId = 128671,
		items = {128670},
		chance = 100,
		holidayTexture = CONSTANTS.HOLIDAY_TEXTURES.WINTERS_VEIL
	},
	-- 1.x
	["Deathcharger's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Deathcharger's Reins"],
		spellId = 17481,
		itemId = 13335,
		npcs = {99999},
		tooltipNpcs = {45412},
		chance = 100,
		statisticId = {1097},
		bonusSatchel = true,
		blackMarket = true,
		coords = {{m = 317, x = 38.6, y = 20, i = true}}
	},
	["Red Qiraji Resonating Crystal"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CLASSIC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Red Qiraji Resonating Crystal"],
		spellId = 26054,
		itemId = 21321,
		npcs = {15311, 15250, 15247, 15246, 15264, 15262, 15277, 15312, 15252, 15249},
		chance = 100,
		coords = {{m = 319, i = true}}
	},
	-- 2.x
	["Ashes of Al'ar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Ashes of Al'ar"],
		spellId = 40192,
		itemId = 32458,
		npcs = {99999},
		tooltipNpcs = {19622},
		chance = 100,
		statisticId = {1088},
		blackMarket = true,
		coords = {{m = 334, x = 50.6, y = 15.2, i = true}}
	},
	["Fiery Warhorse's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Fiery Warhorse's Reins"],
		spellId = 36702,
		itemId = 30480,
		npcs = {16152},
		chance = 100,
		blackMarket = true,
		lockBossName = "Attumen the Huntsman",
		coords = {{m = 350, x = 46.6, y = 82.6, i = true}}
	},
	["Reins of the Raven Lord"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Raven Lord"],
		spellId = 41252,
		itemId = 32768,
		npcs = {23035},
		chance = 67,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true
		},
		bonusSatchel = true,
		blackMarket = true,
		lockBossName = "Anzu",
		coords = {{m = 258, x = 32.6, y = 54.5, i = true}}
	},
	["Swift White Hawkstrider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.TBC,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Swift White Hawkstrider"],
		spellId = 46628,
		itemId = 35513,
		npcs = {24664},
		chance = 33,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true
		},
		sourceText = L["Heroic difficulty"],
		bonusSatchel = true,
		blackMarket = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MAGISTERS_TERRACE_GRAND_MAGISTERS_ASYLUM, x = 8.6, y = 50.2, i = true},
			{m = CONSTANTS.UIMAPIDS.MAGISTERS_TERRACE_OBSERVATION_GROUNDS, i = true}
		}
	},
	-- 3.x
	["Invincible's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Invincible's Reins"],
		spellId = 72286,
		itemId = 50818,
		npcs = {99999},
		tooltipNpcs = {36597},
		chance = 100,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_HEROIC] = true},
		statisticId = {4688},
		sourceText = L["25-player heroic"],
		blackMarket = true,
		wasGuaranteed = true,
		lockBossName = "The Lich King",
		coords = {{m = 191, x = 49.8, y = 52.8, i = true}}
	},
	["Mimiron's Head"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Mimiron's Head"],
		spellId = 63796,
		itemId = 45693,
		npcs = {33288},
		statisticId = {2869, 2883},
		chance = 100,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true},
		sourceText = L["Dropped by Yogg-Saron in Ulduar with no Keepers assisting"],
		wasGuaranteed = true,
		blackMarket = true,
		lockBossName = "Yogg-Saron",
		coords = {{m = 150, x = 68, y = 40.8, i = true}}
	},
	["Reins of the Azure Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Azure Drake"],
		spellId = 59567,
		itemId = 43952,
		npcs = {99999},
		tooltipNpcs = {28859},
		chance = 100,
		statisticId = {1391, 1394},
		sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"],
		blackMarket = true,
		lockBossName = "Malygos",
		coords = {{m = 141, x = 39, y = 51.8, i = true}}
	},
	["Reins of the Blue Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Blue Drake"],
		spellId = 59568,
		itemId = 43953,
		npcs = {99999},
		tooltipNpcs = {28859},
		chance = 100,
		statisticId = {1391, 1394},
		sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"],
		bonusSatchel = true,
		blackMarket = true,
		lockBossName = "Malygos",
		coords = {{m = 141, x = 39, y = 51.8, i = true}}
	},
	["Reins of the Blue Proto-Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Blue Proto-Drake"],
		spellId = 59996,
		itemId = 44151,
		npcs = {26693, 174062},
		chance = 77,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.NONE] = true
		},
		sourceText = L["Heroic difficulty"],
		bonusSatchel = true,
		blackMarket = true,
		lockBossName = "Skadi the Ruthless",
		coords = {{m = 136, x = 68.4, y = 36.2, i = true}, {m = CONSTANTS.UIMAPIDS.ICECROWN, x = 57.6, y = 56}}
	},
	["Reins of the Grand Black War Mammoth Alliance"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Grand Black War Mammoth"],
		spellId = 61465,
		itemId = 43959,
		npcs = {99999},
		tooltipNpcs = {35013, 33993, 31125, 38433},
		chance = 100,
		requiresAlliance = true,
		statisticId = {1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658},
		sourceText = L[
			"Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."
		],
		lockBossName = "Archavon the Stone Watcher",
		coords = {
			{m = 156, x = 36, y = 55.4, i = true},
			{m = 156, x = 62.6, y = 55.4, i = true},
			{m = 156, x = 49.2, y = 17, i = true},
			{m = 156, x = 62.6, y = 36.8, i = true}
		}
	},
	["Reins of the Grand Black War Mammoth Horde"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Grand Black War Mammoth"],
		spellId = 61467,
		itemId = 44083,
		npcs = {99999},
		tooltipNpcs = {35013, 33993, 31125, 38433},
		chance = 100,
		requiresHorde = true,
		statisticId = {1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658},
		sourceText = L[
			"Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."
		],
		lockBossName = "Archavon the Stone Watcher",
		coords = {
			{m = 156, x = 36, y = 55.4, i = true},
			{m = 156, x = 62.6, y = 55.4, i = true},
			{m = 156, x = 49.2, y = 17, i = true},
			{m = 156, x = 62.6, y = 36.8, i = true}
		}
	},
	["Reins of the Green Proto-Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Reins of the Green Proto-Drake"],
		spellId = 61294,
		itemId = 44707,
		items = {39883},
		chance = 20,
		sourceText = L[
			"Contained in Cracked Egg, which is obtained by becoming Revered with The Oracles, purchasing a Mysterious Egg from their reputation vendor, and waiting three days. The mount has a 5% chance to appear in the Cracked Egg."
		],
		bonusSatchel = true,
		blackMarket = true,
		coords = {{m = 119, x = 54.6, y = 56.2}}
	},
	["Reins of the Onyxian Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Onyxian Drake"],
		spellId = 69395,
		itemId = 49636,
		npcs = {99999},
		tooltipNpcs = {10184},
		chance = 100,
		statisticId = {1098},
		sourceText = L["Any raid size"],
		blackMarket = true,
		lockBossName = "Onyxia",
		coords = {{m = 248, x = 68, y = 31.4, i = true}}
	},
	["Reins of the White Polar Bear"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Reins of the White Polar Bear"],
		spellId = 54753,
		itemId = 43962,
		items = {44751, 69903},
		chance = 33,
		sourceText = L[
			"Contained in Hyldnir Spoils, which is rewarded for completing daily quests given by Gretta the Arbiter in Brunnhildar Village, Storm Peaks. The mount has a 3% chance to appear in Hyldnir Spoils."
		],
		bonusSatchel = true,
		blackMarket = true,
		coords = {{m = 120, x = 50.8, y = 65.6}}
	},
	["Sea Turtle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOTLK,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Sea Turtle"],
		spellId = 64731,
		itemId = 46109,
		zones = {
			"116",
			"127",
			"115",
			"117",
			"114",
			"119",
			"245",
			"241",
			"249",
			"207",
			"198",
			"418",
			"371",
			"376",
			"379",
			"390",
			"422",
			"388",
			"407",
			"554",
			"507",
			"504",
			"433"
		},
		chance = 10000,
		requiresPool = true,
		sourceText = L["Obtained very rarely by fishing in pools located in any expansion zone (not Classic zones)"],
		coords = {
			{m = 116},
			{m = 127},
			{m = 115},
			{m = 117},
			{m = 114},
			{m = 119},
			{m = 245},
			{m = 241},
			{m = 249},
			{m = 207},
			{m = 198},
			{m = 418},
			{m = 371},
			{m = 376},
			{m = 379},
			{m = 390},
			{m = 422},
			{m = 388},
			{m = 407},
			{m = 554},
			{m = 507},
			{m = 504},
			{m = 433}
		}
	},
	-- 4.x
	["Armored Razzashi Raptor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Armored Razzashi Raptor"],
		spellId = 96491,
		itemId = 68823,
		npcs = {52151},
		chance = 100,
		sourceText = L["Heroic difficulty"],
		lockBossName = "Bloodlord Mandokir",
		coords = {{m = 337, x = 60.4, y = 79.9, i = true}}
	},
	["Experiment 12-B"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Experiment 12-B"],
		spellId = 110039,
		itemId = 78919,
		npcs = {99999},
		tooltipNpcs = {55294},
		chance = 100,
		statisticId = {6161, 6162},
		sourceText = L["Dropped by Ultraxion in Dragon Soul (any raid size or difficulty)"],
		lockBossName = "Ultraxion",
		coords = {{m = 409, x = 49.6, y = 57.6, i = true}}
	},
	["Flametalon of Alysrazor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Flametalon of Alysrazor"],
		spellId = 101542,
		itemId = 71665,
		npcs = {99999},
		tooltipNpcs = {52530},
		chance = 100,
		statisticId = {5970, 5971},
		sourceText = L["Any raid size or difficulty"],
		blackMarket = true,
		lockBossName = "Alysrazor",
		coords = {{m = 367, x = 64.3, y = 38, i = true}}
	},
	["Fossilized Raptor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.ARCH,
		name = L["Fossilized Raptor"],
		spellId = 84751,
		itemId = 60954,
		raceId = 18,
		chance = 30,
		sourceText = L["Obtained as a rare project for the Fossil branch of archaeology"],
		coords = {
			{m = 1},
			{m = 7},
			{m = 10},
			{m = 12},
			{m = 13},
			{m = 14},
			{m = 15},
			{m = 17},
			{m = 18},
			{m = 21},
			{m = 22},
			{m = 23},
			{m = 25},
			{m = 26},
			{m = 27},
			{m = 32},
			{m = 36},
			{m = 37},
			{m = 42},
			{m = 47},
			{m = 48},
			{m = 49},
			{m = 50},
			{m = 51},
			{m = 52},
			{m = 56},
			{m = 57},
			{m = 62},
			{m = 63},
			{m = 64},
			{m = 65},
			{m = 66},
			{m = 69},
			{m = 70},
			{m = 71},
			{m = 76},
			{m = 77},
			{m = 78},
			{m = 80},
			{m = 81},
			{m = 83},
			{m = 84},
			{m = 85},
			{m = 87},
			{m = 88},
			{m = 89},
			{m = 998},
			{m = 94},
			{m = 95},
			{m = 97},
			{m = 103},
			{m = 106},
			{m = 110},
			{m = 122},
			{m = 124},
			{m = 179},
			{m = 198},
			{m = 199},
			{m = 201},
			{m = 202},
			{m = 203},
			{m = 204},
			{m = 205},
			{m = 210},
			{m = 217},
			{m = 218},
			{m = 224},
			{m = 241},
			{m = 244},
			{m = 245},
			{m = 249},
			{m = 327},
			{m = 338},
			{m = 425},
			{m = 427},
			{m = 460},
			{m = 461},
			{m = 462},
			{m = 463},
			{m = 465},
			{m = 467},
			{m = 468},
			{m = 469}
		}
	},
	["Life-Binder's Handmaiden"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Life-Binder's Handmaiden"],
		spellId = 107845,
		itemId = 77069,
		npcs = {99999},
		chance = 100,
		statisticId = {6168},
		sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (heroic, any raid size)"],
		wasGuaranteed = true,
		blackMarket = true,
		lockBossName = "Madness of Deathwing",
		coords = {{m = 409, i = true}}
	},
	["Reins of the Blazing Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Blazing Drake"],
		spellId = 107842,
		itemId = 77067,
		npcs = {99999},
		chance = 100,
		statisticId = {6167, 6168},
		sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (any raid size or difficulty)"],
		blackMarket = true,
		lockBossName = "Madness of Deathwing",
		coords = {{m = 409, i = true}}
	},
	["Reins of the Drake of the North Wind"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Drake of the North Wind"],
		spellId = 88742,
		itemId = 63040,
		npcs = {43873},
		chance = 100,
		sourceText = L["Any difficulty"],
		blackMarket = true,
		coords = {{m = 325, x = 51.9, y = 82.1, i = true}}
	},
	["Reins of the Drake of the South Wind"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Drake of the South Wind"],
		spellId = 88744,
		itemId = 63041,
		npcs = {99999},
		tooltipNpcs = {46753},
		chance = 100,
		statisticId = {5576, 5577},
		sourceText = L["Any raid size or difficulty"],
		blackMarket = true,
		lockBossName = "Al'Akir",
		coords = {{m = 328, x = 47.5, y = 50.1, i = true}}
	},
	["Reins of the Grey Riding Camel"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Grey Riding Camel"],
		spellId = 88750,
		itemId = 63046,
		chance = 20,
		sourceText = L[
			"Guaranteed drop from Dormus the Camel-Hoarder. Accessing this encounter requires finding a rare Mysterious Camel Figurine in Uldum. These are difficult to spot and, when clicked, have a small chance to grant you access to the Dormus encounter. Rarity will count how many Figurines you've found if you mouseover them."
		],
		coords = {{m = 249}}
	},
	["Reins of the Vitreous Stone Drake"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Vitreous Stone Drake"],
		spellId = 88746,
		itemId = 63043,
		npcs = {43214},
		chance = 100,
		sourceText = L["Any difficulty"],
		blackMarket = true,
		coords = {{m = 324, x = 37, y = 44.7, i = true}}
	},
	["Scepter of Azj'Aqir"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.ARCH,
		name = L["Scepter of Azj'Aqir"],
		spellId = 92155,
		itemId = 64883,
		raceId = 14,
		chance = 500,
		sourceText = L["Obtained as a very rare project for the Tol'vir branch of archaeology"],
		coords = {{m = 249}}
	},
	["Smoldering Egg of Millagazor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Smoldering Egg of Millagazor"],
		spellId = 97493,
		itemId = 69224,
		npcs = {99999},
		tooltipNpcs = {52409},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_HEROIC] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_HEROIC] = true
		},
		chance = 100,
		statisticId = {5976, 5977},
		wasGuaranteed = true,
		blackMarket = true,
		coords = {{m = 367, x = 50.7, y = 15.3, i = true}}
	},
	["Swift Zulian Panther"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.CATA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Swift Zulian Panther"],
		spellId = 96499,
		itemId = 68824,
		npcs = {52059},
		chance = 100,
		sourceText = L["Heroic difficulty"],
		lockBossName = "High Priestess Kilnara",
		coords = {{m = 337, x = 48, y = 20, i = true}}
	},
	-- 5.x
	["Clutch of Ji-Kun"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Clutch of Ji-Kun"],
		spellId = 139448,
		itemId = 95059,
		npcs = {99999},
		tooltipNpcs = {69712},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_HEROIC] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_HEROIC] = true
		},
		chance = 50,
		statisticId = {8171, 8169, 8172, 8170},
		sourceText = L["All raid formats except Raid Finder"],
		lockBossName = "Ji-Kun",
		coords = {{m = 510, x = 49.7, y = 41.6, i = true}}
	},
	["Kor'kron Juggernaut"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Kor'kron Juggernaut"],
		spellId = 148417,
		itemId = 104253,
		npcs = {99999},
		tooltipNpcs = {71865},
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true},
		chance = 100,
		statisticId = {8638, 8637},
		sourceText = L["Mythic difficulty"],
		wasGuaranteed = true,
		lockBossName = "Garrosh Hellscream",
		coords = {{m = 567, x = 49.4, y = 71.3, i = true}}
	},
	["Reins of the Amber Primordial Direhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Amber Primordial Direhorn"],
		spellId = 138424,
		itemId = 94230,
		npcs = {69841},
		chance = 20,
		sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."],
		coords = {
			{m = 418, x = 39.08, y = 67.13},
			{m = 422, x = 47.47, y = 61.32},
			{m = 388, x = 36.53, y = 85.67},
			{m = 379, x = 75.09, y = 67.65},
			{m = 371, x = 52.73, y = 18.99}
		}
	},
	["Reins of the Astral Cloud Serpent"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Astral Cloud Serpent"],
		spellId = 127170,
		itemId = 87777,
		npcs = {99999},
		tooltipNpcs = {60410},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_HEROIC] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_HEROIC] = true
		},
		chance = 100,
		statisticId = {6797, 6798, 7924, 7923},
		sourceText = L["Dropped by Elegon in Mogu'shan Vaults (all raid formats except Raid Finder)"],
		blackMarket = true,
		lockBossName = "Elegon",
		coords = {{m = 471, x = 21.7, y = 51.1, i = true}}
	},
	["Reins of the Bone-White Primal Raptor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Reins of the Bone-White Primal Raptor"],
		spellId = 138640,
		itemId = 94290,
		collectedItemId = 94288,
		chance = 9999,
		obtain = L["Dropped from dinosaurs on Isle of Giants"],
		tooltipNpcs = {
			69992,
			70013,
			70012,
			70015,
			70014,
			70006,
			69925,
			69993,
			70004,
			70005,
			70007,
			70020,
			70016,
			69983,
			70017,
			70019,
			70018,
			70011,
			70009,
			69991,
			70021,
			70010,
			70008
		},
		sourceText = L[
			"Earned by giving 9999 Giant Dinosaur Bones to Ku'ma on Isle of Giants. Giant Dinosaur bones drop from all dinosaurs and Zandalari Dinomancers on Isle of Giants."
		],
		coords = {{m = 507}}
	},
	["Reins of the Cobalt Primordial Direhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Cobalt Primordial Direhorn"],
		spellId = 138423,
		itemId = 94228,
		npcs = {99999},
		tooltipNpcs = {69161},
		questId = 32519,
		chance = 2000,
		statisticId = {8147},
		enableCoin = true,
		worldBossFactionless = true,
		coords = {{m = 507, x = 50.6, y = 54.4}}
	},
	["Reins of the Heavenly Onyx Cloud Serpent"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Heavenly Onyx Cloud Serpent"],
		spellId = 127158,
		itemId = 87771,
		npcs = {99999},
		tooltipNpcs = {60491},
		questId = 32099,
		chance = 2000,
		statisticId = {6989},
		enableCoin = true,
		worldBossFactionless = true,
		blackMarket = true,
		coords = {
			{
				m = 379,
				x = 53.7,
				y = 64.7
			}
		}
	},
	["Reins of the Jade Primordial Direhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Jade Primordial Direhorn"],
		spellId = 138426,
		itemId = 94231,
		npcs = {69842},
		chance = 20,
		sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."],
		coords = {
			{m = 418, x = 39.08, y = 67.13},
			{m = 422, x = 47.47, y = 61.32},
			{m = 388, x = 36.53, y = 85.67},
			{m = 379, x = 75.09, y = 67.65},
			{m = 371, x = 52.73, y = 18.99}
		}
	},
	["Reins of the Slate Primordial Direhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Slate Primordial Direhorn"],
		spellId = 138425,
		itemId = 94229,
		npcs = {69769},
		chance = 20,
		sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."],
		coords = {
			{m = 418, x = 39.08, y = 67.13},
			{m = 422, x = 47.47, y = 61.32},
			{m = 388, x = 36.53, y = 85.67},
			{m = 379, x = 75.09, y = 67.65},
			{m = 371, x = 52.73, y = 18.99}
		}
	},
	["Reins of the Thundering Cobalt Cloud Serpent"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Thundering Cobalt Cloud Serpent"],
		spellId = 139442,
		itemId = 95057,
		npcs = {99999},
		tooltipNpcs = {69099},
		questId = 32518,
		chance = 2000,
		statisticId = {8146},
		enableCoin = true,
		worldBossFactionless = true,
		blackMarket = true,
		coords = {{m = 504, x = 60.5, y = 37.3}}
	},
	["Reins of the Thundering Onyx Cloud Serpent"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Thundering Onyx Cloud Serpent"],
		spellId = 148476,
		itemId = 104269,
		npcs = {73167},
		chance = 100,
		sourceText = L["Players have a personal loot chance to obtain this item."],
		coords = {{m = 554, x = 67.8, y = 59}}
	},
	["Son of Galleon's Saddle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Son of Galleon's Saddle"],
		spellId = 130965,
		itemId = 89783,
		npcs = {99999},
		tooltipNpcs = {62346},
		questId = 32098,
		chance = 2000,
		statisticId = {6990},
		enableCoin = true,
		worldBossFactionless = true,
		coords = {{m = 376, x = 71.6, y = 64.4}}
	},
	["Spawn of Horridon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.MOP,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Spawn of Horridon"],
		spellId = 136471,
		itemId = 93666,
		npcs = {99999},
		tooltipNpcs = {68476},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_NORMAL] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_10_HEROIC] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.RAID_25_HEROIC] = true
		},
		chance = 66,
		statisticId = {8151, 8149, 8152, 8150},
		sourceText = L["All raid formats except Raid Finder"],
		lockBossName = "Horridon",
		coords = {{m = 508, x = 26.8, y = 78.7, i = true}}
	},
	-- 6.x
	["Armored Razorback"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Armored Razorback"],
		spellId = 171630,
		itemId = 116669,
		npcs = {95044, 95054, 95053, 95056},
		chance = 30,
		sourceText = L[
			'Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'
		],
		questId = {39287, 39288, 39289, 39290},
		defeatAllQuests = true,
		coords = {
			{m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"]},
			{m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"]},
			{m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"]},
			{m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"]}
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"]
		}
	},
	["Bristling Hellboar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Bristling Hellboar"],
		spellId = 190690,
		itemId = 128481,
		collectedItemId = 124099,
		chance = 5000,
		obtain = L["Dropped from monsters in Fang'rila"],
		tooltipNpcs = {92922, 92466, 89747, 89695, 89746, 92481},
		sourceText = L[
			"Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."
		],
		coords = {{m = 534, x = 55.2, y = 74.8}}
	},
	["Garn Steelmaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Garn Steelmaw"],
		spellId = 171836,
		itemId = 116779,
		items = {116980, 122163},
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = {37640, 38482},
		defeatAllQuests = true,
		coords = {zoneOverride = L["Draenor Garrison"], {m = 579}, {m = 585}},
		defeatSteps = {[37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"]}
	},
	["Giant Coldsnout"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Giant Coldsnout"],
		spellId = 171635,
		itemId = 116673,
		items = {116980, 122163},
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = {37640, 38482},
		defeatAllQuests = true,
		coords = {zoneOverride = L["Draenor Garrison"], {m = 579}, {m = 585}},
		defeatSteps = {[37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"]}
	},
	["Reins of the Crimson Water Strider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Reins of the Crimson Water Strider"],
		spellId = 127271,
		itemId = 87791,
		collectedItemId = {117397, 127994, 116820, 116818, 116819, 116821, 122696, 116817, 116822},
		chance = 100,
		obtain = L["Fished anywhere in Draenor (except your garrison) with the help of Nat Pagle"],
		sourceText = L[
			"Lunkers can be fished anywhere in Draenor (except in your garrison) after you've obtained a level 3 Fishing Shack and acquired Nat Pagle as a follower."
		],
		coords = {
			{m = 572},
			{m = 588},
			{m = 525},
			{m = 543},
			{m = 550},
			{m = 539},
			{m = 542},
			{m = 622},
			{m = 535},
			{m = 534},
			{m = 624}
		}
	},
	["Riding Turtle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Riding Turtle"],
		spellId = 30174,
		itemId = 23720,
		npcs = {81171, 85715},
		chance = 200,
		sourceText = L[
			"After upgrading your garrison's Fishing Shack to level 3, fish up 5 minnows to summon a Cavedweller which can drop this mount."
		],
		coords = {zoneOverride = L["Draenor Garrison"], {m = 579}, {m = 585}}
	},
	["Shadowhide Pearltusk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Shadowhide Pearltusk"],
		spellId = 171624,
		itemId = 116663,
		items = {116980, 122163},
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = {37640, 38482},
		defeatAllQuests = true,
		coords = {zoneOverride = L["Draenor Garrison"], {m = 579}, {m = 585}},
		defeatSteps = {[37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"]}
	},
	["Smoky Direwolf"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Smoky Direwolf"],
		spellId = 171843,
		itemId = 116786,
		items = {116980, 122163},
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = {37640, 38482},
		defeatAllQuests = true,
		coords = {zoneOverride = L["Draenor Garrison"], {m = 579}, {m = 585}},
		defeatSteps = {[37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"]}
	},
	["Tundra Icehoof"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tundra Icehoof"],
		spellId = 171619,
		itemId = 116658,
		npcs = {95044, 95054, 95053, 95056},
		chance = 30,
		sourceText = L[
			'Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'
		],
		questId = {39287, 39288, 39289, 39290},
		defeatAllQuests = true,
		coords = {
			{m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"]},
			{m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"]},
			{m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"]},
			{m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"]}
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"]
		}
	},
	["Warsong Direfang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Warsong Direfang"],
		spellId = 171837,
		itemId = 116780,
		npcs = {95044, 95054, 95053, 95056},
		chance = 30,
		sourceText = L[
			'Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'
		],
		questId = {39287, 39288, 39289, 39290},
		defeatAllQuests = true,
		coords = {
			{m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"]},
			{m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"]},
			{m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"]},
			{m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"]}
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"]
		}
	},
	["Wild Goretusk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Wild Goretusk"],
		spellId = 171633,
		itemId = 116671,
		collectedItemId = 124099,
		chance = 1000,
		obtain = L["Dropped from monsters in Fang'rila"],
		tooltipNpcs = {92922, 92466, 89747, 89695, 89746, 92481},
		sourceText = L[
			"Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."
		],
		coords = {{m = 534, x = 55.2, y = 74.8}}
	},
	-- 7.0
	--["Brinedeep Bottom-Feeder"] =                       { cat = CONSTANTS.ITEM_CATEGORIES.LEGION, type = CONSTANTS.ITEM_TYPES.MOUNT, method = CONSTANTS.DETECTION_METHODS.COLLECTION, name = L["Brinedeep Bottom-Feeder"], spellId = 214791, itemId = 138811, collectedItemId = { 138777, }, chance = 100, },
	["Cloudwing Hippogryph"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Cloudwing Hippogryph"],
		spellId = 242881,
		itemId = 147806,
		items = {152102},
		chance = 20
	},
	["Highmountain Elderhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Highmountain Elderhorn"],
		spellId = 242874,
		itemId = 147807,
		items = {152104},
		chance = 20
	},
	["Leywoven Flying Carpet"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Leywoven Flying Carpet"],
		spellId = 233364,
		itemId = 143764,
		items = {152105},
		chance = 20
	},
	["Torn Invitation"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Torn Invitation"],
		spellId = 171850,
		itemId = 140495,
		chance = 200,
		questId = 43943,
		sourceText = L["The quest starter item for Reins of the Llothien Prowler"],
		coords = {{m = 680}}
	},
	["Valarjar Stormwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Valarjar Stormwing"],
		spellId = 242882,
		itemId = 147805,
		items = {152106},
		chance = 20
	},
	["Wild Dreamrunner"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Wild Dreamrunner"],
		spellId = 242875,
		itemId = 147804,
		items = {152103},
		chance = 20
	},
	-- 7.1
	["Smoldering Ember Wyrm"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Smoldering Ember Wyrm"],
		spellId = 231428,
		itemId = 142552,
		npcs = {114895},
		chance = 5,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		lockDungeonId = 1475,
		lockBossName = "Nightbane",
		coords = {
			{m = 814, i = true}
		}
	},
	-- 7.3
	["Lambent Mana Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Lambent Mana Ray"],
		itemId = 152844,
		spellId = 253107,
		npcs = {126867},
		chance = 30,
		questId = 48705,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 34.01, y = 47.83, n = L["Venomtail Skyfin"]}
		}
	},
	["Maddened Chaosrunner"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Maddened Chaosrunner"],
		itemId = 152814,
		spellId = 253058,
		npcs = {126852},
		chance = 30,
		questId = 48695,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 55.65, y = 59.95, n = L["Wrangler Kravos"]}
		}
	},
	["Vile Fiend"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Vile Fiend"],
		itemId = 152790,
		spellId = 243652,
		npcs = {127288},
		chance = 30,
		questId = 48821,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 62.96, y = 24.86, n = L["Houndmaster Kerrax"]}
		}
	},
	["Crimson Slavermaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Crimson Slavermaw"],
		itemId = 152905,
		spellId = 253661,
		npcs = {122958},
		chance = 30,
		questId = 49183,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 61.78, y = 36.97, n = L["Blistermaw"]}
		}
	},
	["Biletooth Gnasher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Biletooth Gnasher"],
		itemId = 152903,
		spellId = 253660,
		npcs = {126040, 126199},
		chance = 30,
		questId = {48809, 48810},
		defeatAllQuests = true,
		defeatSteps = {
			[48809] = L["Puscilla"],
			[48810] = L["Vrax'thul"]
		},
		sourceText = format(
			L["Has a chance to drop from either %s or %s on Argus. Each can be looted once per day."],
			L["Puscilla"],
			L["Vrax'thul"]
		),
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 64.42, y = 20.35, q = 48809, n = L["Puscilla"]},
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 53.06, y = 36.12, q = 48810, n = L["Vrax'thul"]}
		}
	},
	["Acid Belcher "] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Acid Belcher"],
		itemId = 152904,
		spellId = 253662,
		npcs = {126912},
		chance = 30,
		questId = 48721,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 49.79, y = 9.40, n = L["Skreeg the Devourer"]}
		}
	},
	["Scintillating Mana Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Scintillating Mana Ray"],
		spellId = 253109,
		itemId = 152840,
		items = {153191},
		chance = 16,
		sourceText = L[
			"Contained in Cracked Fel-Spotted Egg, which is obtained by defeating any of the panthara rares on Argus, looting a Fel-Spotted Egg from them, and waiting five days. Each mount has a 6% chance to appear in the Cracked Fel-Spotted Egg, and each pet has a 20% chance to appear in it."
		],
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 64.32, y = 48.62, n = L["Varga"]},
			{m = CONSTANTS.UIMAPIDS.KROKUUN, x = 70.21, y = 34.38, n = L["Naroua"]},
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 43.55, y = 49.19, n = L["Sabuul"]}
		}
	},
	["Felglow Mana Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Felglow Mana Ray"],
		spellId = 253108,
		itemId = 152841,
		items = {153191},
		chance = 16,
		sourceText = L[
			"Contained in Cracked Fel-Spotted Egg, which is obtained by defeating any of the panthara rares on Argus, looting a Fel-Spotted Egg from them, and waiting five days. Each mount has a 6% chance to appear in the Cracked Fel-Spotted Egg, and each pet has a 20% chance to appear in it."
		],
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 64.32, y = 48.62, n = L["Varga"]},
			{m = CONSTANTS.UIMAPIDS.KROKUUN, x = 70.21, y = 34.38, n = L["Naroua"]},
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 43.55, y = 49.19, n = L["Sabuul"]}
		}
	},
	["Darkspore Mana Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Darkspore Mana Ray"],
		spellId = 235764,
		itemId = 152843,
		items = {153191},
		chance = 16,
		sourceText = L[
			"Contained in Cracked Fel-Spotted Egg, which is obtained by defeating any of the panthara rares on Argus, looting a Fel-Spotted Egg from them, and waiting five days. Each mount has a 6% chance to appear in the Cracked Fel-Spotted Egg, and each pet has a 20% chance to appear in it."
		],
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 64.32, y = 48.62, n = L["Varga"]},
			{m = CONSTANTS.UIMAPIDS.KROKUUN, x = 70.21, y = 34.38, n = L["Naroua"]},
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 43.55, y = 49.19, n = L["Sabuul"]}
		}
	},
	["Vibrant Mana Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Vibrant Mana Ray"],
		spellId = 253106,
		itemId = 152842,
		items = {153191},
		chance = 16,
		sourceText = L[
			"Contained in Cracked Fel-Spotted Egg, which is obtained by defeating any of the panthara rares on Argus, looting a Fel-Spotted Egg from them, and waiting five days. Each mount has a 6% chance to appear in the Cracked Fel-Spotted Egg, and each pet has a 20% chance to appear in it."
		],
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES, x = 64.32, y = 48.62, n = L["Varga"]},
			{m = CONSTANTS.UIMAPIDS.KROKUUN, x = 70.21, y = 34.38, n = L["Naroua"]},
			{m = CONSTANTS.UIMAPIDS.MACAREE, x = 43.55, y = 49.19, n = L["Sabuul"]}
		}
	},
	["Pond Nettle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Pond Nettle"],
		zones = {"885", "830", "882"},
		spellId = 253711,
		itemId = 152912,
		chance = 2000,
		requiresPool = false,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ANTORAN_WASTES},
			{m = CONSTANTS.UIMAPIDS.KROKUUN},
			{m = CONSTANTS.UIMAPIDS.MACAREE}
		}
	},
	["Avenging Felcrusher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Avenging Felcrusher"],
		spellId = 254259,
		itemId = 153044,
		items = {152923},
		chance = 20
	},
	["Blessed Felcrusher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Blessed Felcrusher"],
		spellId = 254258,
		itemId = 153043,
		items = {152923},
		chance = 20
	},
	["Glorious Felcrusher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Glorious Felcrusher"],
		spellId = 254069,
		itemId = 153042,
		items = {152923},
		chance = 20
	},
	--- 8.0

	["Witherbark Direwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Witherbark Direwing"],
		itemId = 163706,
		spellId = 279868,
		npcs = {142692},
		chance = 33,
		questId = {53091, 53517},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 67.48, y = 60.58, n = L["Nimar the Slayer"]}
		}
	},
	["Lil' Donkey"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Lil' Donkey"],
		itemId = 163646,
		spellId = 279608,
		npcs = {142423},
		chance = 33,
		questId = {53014, 53518},
		coords = {
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 27.46,
				y = 55.89,
				n = L["Overseer Krix"] .. " - " .. L["Horde controls Stromgarde"]
			},
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 33.04,
				y = 37.49,
				n = L["Overseer Krix"] .. " - " .. L["Alliance controls Stromgarde"]
			},
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 33.44, y = 36.94, n = L["Cave Entrance"]}
		}
	},
	["Skullripper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Skullripper"],
		itemId = 163645,
		spellId = 279611,
		npcs = {142437},
		chance = 33,
		questId = {53022, 53526},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 57.15, y = 45.75, n = L["Skullripper"]}
		}
	},
	["Swift Albino Raptor"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Swift Albino Raptor"],
		itemId = 163644,
		spellId = 279569,
		npcs = {142709},
		chance = 33,
		questId = {53083, 53504},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 67.06, y = 65.89, n = L["Beastrider Kama"]}
		}
	},
	["Highland Mustang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Highland Mustang"],
		itemId = 163579,
		spellId = 279456,
		npcs = {142741},
		chance = 33,
		questId = 53085,
		requiresAlliance = true,
		coords = {
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 53.97,
				y = 56.96,
				n = L["Doomrider Helgrim"] .. " - " .. L["Alliance controls Stromgarde"] .. " - " .. L["Alliance only"]
			}
		}
	},
	["Broken Highland Mustang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Broken Highland Mustang"],
		itemId = 163578,
		spellId = 279457,
		npcs = {142739},
		chance = 33,
		questId = 53088,
		requiresHorde = true,
		coords = {
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 49.27,
				y = 40.05,
				n = L["Knight-Captain Aldrin"] .. " - " .. L["Horde controls Stromgarde"] .. " - " .. L["Horde only"]
			}
		}
	},
	["Captured Dune Scavenger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Captured Dune Scavenger"],
		itemId = 163576,
		spellId = 237286,
		npcs = {
			128682,
			123774,
			136191,
			134429,
			129778,
			134427,
			129652,
			134560,
			134103,
			128678,
			123773,
			134559,
			123775,
			128749,
			127406,
			122746,
			123864,
			136545,
			122782,
			123863
		},
		chance = 3000,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VOLDUN}
		}
	},
	["Chewed-On Reins of the Terrified Pack Mule"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Chewed-On Reins of the Terrified Pack Mule"],
		itemId = 163574,
		spellId = 260174,
		npcs = {
			131534,
			133892,
			133889,
			141642,
			131519,
			137134,
			133736,
			131530,
			131529
		},
		chance = 4000,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DRUSTVAR}
		}
	},
	["Reins of a Tamed Bloodfeaster"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of a Tamed Bloodfeaster"],
		itemId = 163575,
		spellId = 243795,
		npcs = {
			126888,
			126187,
			133077,
			122239,
			127919,
			120607,
			136639,
			127224,
			136293,
			133279,
			133063,
			128734,
			127928,
			120606,
			124547,
			124688
		},
		chance = 3000,
		coords = {
			{m = CONSTANTS.UIMAPIDS.NAZMIR}
		}
	},
	["Goldenmane's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Goldenmane's Reins"],
		itemId = 163573,
		spellId = 260175,
		npcs = {
			129750,
			131646,
			135585,
			138167,
			138332,
			141143,
			137202,
			138168,
			130641,
			131166,
			138226,
			130897,
			135584,
			140209,
			137893,
			138170,
			137156,
			130006,
			131404,
			136158,
			130039,
			132226,
			138340,
			137155,
			130531
		},
		chance = 3000,
		coords = {
			{m = CONSTANTS.UIMAPIDS.STORMSONG_VALLEY}
		}
	},
	-- 8.1

	["Ashenvale Chimaera"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ashenvale Chimaera"],
		itemId = 166432,
		spellId = 288495,
		npcs = {148787},
		chance = 20,
		questId = {54695, 54696},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 56.4, y = 30.8, n = L["Alash'anir"]}
		}
	},
	["Caged Bear"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Caged Bear"],
		itemId = 166438,
		spellId = 288438,
		npcs = {149652},
		chance = 20,
		questId = {54883},
		requiresAlliance = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 49.2, y = 24.8, n = L["Agathe Wyrmwood"] .. " - " .. L["Alliance only"]}
		}
	},
	["Blackpaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Blackpaw"],
		itemId = 166428,
		spellId = 288438,
		npcs = {149660},
		chance = 20,
		requiresHorde = true,
		questId = {54890},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 49.2, y = 24.8, n = L["Blackpaw"] .. " - " .. L["Horde only"]}
		}
	},
	["Captured Kaldorei Nightsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Captured Kaldorei Nightsaber"],
		itemId = 166437,
		spellId = 288505,
		npcs = {149655},
		chance = 20,
		questId = {54886},
		requiresAlliance = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 50.6, y = 32.6, n = L["Croz Bloodrage"] .. " - " .. L["Alliance only"]}
		}
	},
	["Kaldorei Nightsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Kaldorei Nightsaber"],
		itemId = 166435,
		spellId = 288505,
		npcs = {149663},
		chance = 20,
		questId = {54892},
		requiresHorde = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 39.9, y = 33.0, n = L["Shadowclaw"] .. " - " .. L["Horde only"]}
		}
	},
	["Umber Nightsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Umber Nightsaber"],
		itemId = 166803,
		spellId = 288503,
		npcs = {148037},
		chance = 20,
		questId = {54431},
		requiresHorde = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 42, y = 77.6, n = L["Athil Dewfire"] .. " - " .. L["Horde only"]}
		}
	},
	["Captured Umber Nightsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Captured Umber Nightsaber"],
		itemId = 166434,
		spellId = 288503,
		npcs = {147701},
		chance = 20,
		questId = {54277},
		requiresAlliance = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 63.7, y = 20.9, n = L["Moxo the Beheader"] .. " - " .. L["Alliance only"]}
		}
	},
	-- 8.2 Mounts
	["Royal Snapdragon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Royal Snapdragon"],
		spellId = 294038,
		itemId = 169198,
		items = {169940, 169939},
		chance = 19
	},
	["Rusted Keys to the Junkheap Drifter"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Rusted Keys to the Junkheap Drifter"],
		itemId = 168370,
		spellId = 297157,
		npcs = {152182},
		chance = 200,
		questId = {55811},
		coords = {
			{m = CONSTANTS.UIMAPIDS.MECHAGON_ISLAND, x = 65.8, y = 79.6, n = L["Rustfeather"]}
		}
	},
	["Rusty Mechanocrawler"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Rusty Mechanocrawler"],
		itemId = 168823,
		spellId = 291492,
		npcs = {154342, 151934},
		chance = 333,
		questId = {55512},
		coords = {
			{m = CONSTANTS.UIMAPIDS.MECHAGON_ISLAND, x = 52.0, y = 41.4, n = L["Arachnoid Harvester"]}
		}
	},
	["Silent Glider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Silent Glider"],
		itemId = 169163,
		spellId = 300149,
		npcs = {152290},
		chance = 200,
		questId = {56298}
	},
	["Mechagon Peacekeeper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Mechagon Peacekeeper"],
		spellId = 299158,
		itemId = 168826,
		npcs = {150190},
		chance = 200,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "HK-8 Aerial Oppression Unit",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true
				}
			}
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.MECHAGON_ISLAND_DUNGEON, i = true}
		}
	},
	-- 8.3 Mounts
	["Xinlao"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Xinlao"],
		itemId = 174840,
		spellId = 316723,
		npcs = {157466},
		chance = 100,
		questId = {57363},
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 34.15, y = 68.05, n = L["Anh-De the Loyal"]}
		}
	},
	["Reins of the Drake of the Four Winds"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Drake of the Four Winds"],
		itemId = 174641,
		spellId = 315847,
		npcs = {157134},
		chance = 100,
		questId = {57259},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 73.96, y = 83.52, n = L["Ishak of the Four Winds"]}
		}
	},
	["Malevolent Drone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Malevolent Drone"],
		itemId = 174769,
		spellId = 316337,
		npcs = {162147},
		chance = 100,
		questId = {58696},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 30.85, y = 49.71, n = L["Corpse Eater"]}
		}
	},
	["Clutch of Ha-Li"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Clutch of Ha-Li"],
		itemId = 173887,
		spellId = 312751,
		npcs = {157153},
		chance = 100,
		questId = {57344},
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 36.6, y = 37.6, n = L["Ha-Li"]}
		}
	},
	["Ren's Stalwart Hound"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ren's Stalwart Hound"],
		itemId = 174841,
		spellId = 316722,
		npcs = {157160},
		chance = 100,
		questId = {57345},
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 10, y = 33, n = L["Houndlord Ren"]}
		}
	},
	["Waste Marauder"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Waste Marauder"],
		itemId = 174753,
		spellId = 316275,
		npcs = {157146},
		chance = 100,
		questId = {57273},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 68.23, y = 31.97, n = L["Rotfeaster"]}
		}
	},
	["Slightly Damp Pile of Fur"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Slightly Damp Pile of Fur"],
		itemId = 174842,
		spellId = 298367,
		npcs = {138794},
		chance = 100,
		groupSize = 3,
		equalOdds = true,
		questId = {53000},
		coords = {
			{m = CONSTANTS.UIMAPIDS.VOLDUN, x = 44.6, y = 56.2, n = L["Dunegorger Kraulok"]}
		}
	},
	["Mail Muncher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Mail Muncher"],
		itemId = 174653,
		spellId = 315987,
		npcs = {160708},
		tooltipNpcs = {160708},
		chance = 100,
		coords = {
			{m = CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_STORMWIND},
			{m = CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_ORGRIMMAR}
		}
	},
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
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
	-- MOUNTS: Requires a group (some of these may be soloable by certain classes, but not in general)
	--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

	-- Holiday
	["Big Love Rocket"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Big Love Rocket"],
		spellId = 71342,
		itemId = 50250,
		items = {54537},
		chance = 3333,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."
		],
		lockDungeonId = 288,
		coords = {{m = 310, x = 40.8, y = 52.6, i = true}}
	},
	["Great Brewfest Kodo"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Great Brewfest Kodo"],
		spellId = 49379,
		itemId = 37828,
		items = {54535, 117393},
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."
		],
		lockDungeonId = 287,
		coords = {{m = 243, x = 46.6, y = 60, i = true}}
	},
	["Swift Brewfest Ram"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Swift Brewfest Ram"],
		spellId = 43900,
		itemId = 33977,
		items = {54535, 117393},
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."
		],
		lockDungeonId = 287,
		coords = {{m = 242, x = 46.6, y = 60, i = true}}
	},
	["The Horseman's Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["The Horseman's Reins"],
		spellId = 48025,
		itemId = 37012,
		items = {117392},
		chance = 200,
		groupSize = 5,
		equalOdds = true,
		sourceText = L[
			"Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."
		],
		lockDungeonId = 285,
		coords = {{m = 435, i = true}}
	},
	-- 6.x
	["Felsteel Annihilator"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Felsteel Annihilator"],
		spellId = 182912,
		itemId = 123890,
		npcs = {99999},
		tooltipNpcs = {91331},
		chance = 100,
		wasGuaranteed = true,
		statisticId = {10252},
		lockBossName = "Archimonde",
		coords = {{m = 670, x = 58.4, y = 53.3, i = true}}
	},
	["Garn Nighthowl"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Garn Nighthowl"],
		spellId = 171851,
		itemId = 116794,
		npcs = {81001},
		chance = 1,
		coords = {{m = 525, x = 16, y = 53.2}}
	},
	["Ironhoof Destroyer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Ironhoof Destroyer"],
		spellId = 171621,
		itemId = 116660,
		npcs = {99999},
		tooltipNpcs = {77325},
		chance = 100,
		wasGuaranteed = true,
		statisticId = {9365},
		lockBossName = "Blackhand",
		coords = {{m = 600, x = 48.4, y = 34.5, i = true}}
	},
	["Solar Spirehawk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Solar Spirehawk"],
		spellId = 171828,
		itemId = 116771,
		npcs = {99999},
		tooltipNpcs = {87493, 83746},
		chance = 500,
		statisticId = {9279},
		worldBossFactionless = true,
		questId = 37464,
		coords = {
			{
				m = 542,
				x = 34.98,
				y = 38.65
			}
		}
	},
	["Reins of the Infinite Timereaver"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Infinite Timereaver"],
		spellId = 201098,
		itemId = 133543,
		npcs = {
			-- NPCs marked with * can't be looted; they CONSTANTS.DETECTION_METHODS.USE a workaround and are detected via checking their achievement criteria. The entry here is mostly for the tooltip display....
			-- CONSTANTS.ITEM_CATEGORIES.TBC Dungeons
			---- Magister's Terrace
			24723, -- Selin Fireheart
			24744, -- Vexallus
			24560, -- Priestess Velrissa
			24664, -- Kael'thas Sunstrider
			---- The Slave Pens
			17941, -- Mennu the Betrayer
			17991, -- Rokmar the Crackler
			17942, -- Quagmirran
			---- The Shattered Halls
			16807, -- Grand Warlock Nethekurse
			20923, -- Blood Guard Porung
			16809, -- Warbringer O'mrogg
			16808, -- Warchief Kargath Bladefist
			---- The Mana Tombs
			18341, -- Pandemonius
			18343, -- Tavarok
			18344, -- Nexus-Prince Shaffar
			22930, -- Yor
			---- The Black Morass
			17879, -- Chrono Lord Deja
			17880, -- Temporus
			17881, -- Aeonus
			---- The Arcatraz
			20870, -- Zereketh the Unbound
			20885, -- Dalliah the Doomsayer
			20886, -- Wrath-Scryer Soccothrates
			20912, -- Harbinger Skyriss
			-- CONSTANTS.ITEM_CATEGORIES.WOTLK Dungeons
			---- Pit of Saron
			36494, -- Forgemaster Garfrost
			36476, -- Ick
			36658, -- Scourgelord Tyrannus
			---- Utgarde Pinnacle
			26668, -- Svala Sorrowgrave
			26687, -- Gortok Palehoof
			26693, -- Skadi the Ruthless
			26861, -- King Ymiron
			---- The Nexus
			26731, -- Grand Magus Telestra
			26763, -- Anomalus
			26794, -- Ormorok the Tree-Shaper
			26723, -- Keristrasza
			26796, -- Commander Stoutbeard
			26798, -- Commander Kolurg
			---- Halls of Lightning
			28586, -- General Bjarngrim
			28587, -- Volkhan
			28546, -- Ionar
			28923, -- Loken
			---- Gundrak
			29304, -- Slad'ran
			29573, -- Drakkari Elemental
			29305, -- Moorabi
			29306, -- Gal'darah
			29932, -- Eck the Ferocious
			---- Ahn'kahet: The Old Kingdom
			29309, -- Elder Nadox
			29308, -- Prince Taldaram
			29310, -- Jedoga Shadowseeker
			29311, -- Herald Volazj
			30258, -- Amanitar
			-- CONSTANTS.ITEM_CATEGORIES.CATA Dungeons
			---- Throne of the Tides
			40586, -- Lady Naz'jar
			40765, -- Commander Ulthok
			40788, -- Mindbender Ghur'sha
			44566, -- Ozumat *
			---- The Vortex Pinnacle
			43878, -- Grand Vizier Ertan
			43873, -- Altairus
			43875, -- Asaad
			---- The Stonecore
			43438, -- Corborus
			43214, -- Slabhide
			42188, -- Ozruk
			42333, -- High Priestess Azil
			---- Lost City of the Tol'vir
			44577, -- General Husam
			43612, -- High Prophet Barim
			44819, -- Siamat
			49045, -- Augh
			---- Grim Batol
			39625, -- General Umbriss
			40177, -- Forgemaster Throngus
			40319, -- Drahga Shadowburner
			40484, -- Erudax
			---- End Time
			54431, -- Echo of Baine
			54445, -- Echo of Jaina
			54123, -- Echo of Sylvanas
			54544, -- Echo of Tyrande
			54432, -- Murozond *
			-- CONSTANTS.ITEM_CATEGORIES.MOP Timewalking
			---- Gate of the Setting Sun
			56906, -- Saboteur Kip'tilak
			56589, -- Striker Ga'dok
			56636, -- Commander Ri'mok
			56877, -- Raigonn
			---- Temple of the Jade Serpent
			56448, -- Wise Mari
			59051, -- Strife (Trial of the Yaungol)
			58826, -- Zao Sunseeker (Champion of the Five Suns)
			56732, -- Liu Flameheart
			56439, -- Sha of Doubt
			---- Stormstout Brewery
			56637, -- Ook-ook
			56717, -- Hoptallus
			59479, -- Yan-Zhu the Uncasked
			---- Siege of Niuzao Temple
			61567, -- Vizier Jin'bak
			61634, -- Commander Vo'jak
			61485, -- General Pa'valak
			62205, -- Wing Leader Ner'onok
			---- Shado-Pan Monastery
			56747, -- Gu Cloudstrike
			56541, -- Master Snowdrift *
			56719, -- Sha of Violence
			56884, -- Taran Zhu *
			---- Mogu'shan Palace
			61444, -- Ming the Cunning *
			61243, -- Gekkan *
			61398, -- Xin the Weaponmaster
			-- WoD Timewalking
			---- The Everbloom
			83846, -- Yalnu
			82682, -- Archmage Sol
			84550, -- Xeri'tac
			83894, -- Dulhu
			81522, -- Witherbark
			---- Bloodmaul Slag Mines
			74366, -- Forgemaster Gog'duh
			74787, -- Slave Watcher Crushto
			75786, -- Roltall
			74790, -- GugÄrokk
			---- Iron Docks
			81305, -- Fleshrender Nok'gar
			80816, -- Ahri'ok Dugru
			79852, -- Oshir
			83612, -- Skulloc
			---- Auchindoun
			75839, -- Vigilant Kaathar
			76177, -- Soulbinder Nyami
			75927, -- Azzakel
			77734, -- Teron'gor
			---- Shadowmoon Burial Grounds
			75509, -- Sadana Bloodfury
			75829, -- Nhallish
			75452, -- Bonemaw
			76407, -- Ner'zhul
			---- Skyreach
			75964, -- Ranjit
			76141, -- Araknath
			76379, -- Rukhran
			76266 -- High Sage Viryx
		},
		chance = 4000,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true},
		coords = {
			{m = 348, i = true},
			{m = 265, i = true},
			{m = 246, i = true},
			{m = 272, i = true},
			{m = 273, i = true},
			{m = 269, i = true},
			{m = 184, i = true},
			{m = 136, i = true},
			{m = 129, i = true},
			{m = 138, i = true},
			{m = 153, i = true},
			{m = 132, i = true},
			{m = 322, i = true},
			{m = 325, i = true},
			{m = 324, i = true},
			{m = 277, i = true},
			{m = 293, i = true},
			{m = 401, i = true},
			{m = 437, i = true},
			{m = 429, i = true},
			{m = 439, i = true},
			{m = 457, i = true},
			{m = 443, i = true},
			{m = 453, i = true}
		}
	},
	-- 7.x
	["Abyss Worm"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Abyss Worm"],
		spellId = 232519,
		itemId = 143643,
		npcs = {99999},
		tooltipNpcs = {115767},
		chance = 100,
		groupSize = 3,
		equalOdds = true,
		statisticId = {11893, 11894, 11895, 11896},
		coords = {{m = 851, i = true}}
	},
	["Living Infernal Core"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Living Infernal Core"],
		sourceText = L["All raid formats except Raid Finder"],
		spellId = 213134,
		itemId = 137574,
		npcs = {99999},
		tooltipNpcs = {
			105503,
			104154 -- Gul'dan (normal)
		},
		chance = 100,
		groupSize = 3,
		equalOdds = true,
		statisticId = {10979, 10980, 10978},
		coords = {{m = 772, i = true}}
	},
	["Midnight's Eternal Reins"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Midnight's Eternal Reins"],
		spellId = 229499,
		itemId = 142236,
		npcs = {114262},
		chance = 100,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		lockDungeonId = 1475,
		lockBossName = "Attumen the Huntsman",
		coords = {{m = 794, i = true}}
	},
	["Fiendish Hellfire Core"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Fiendish Hellfire Core"],
		spellId = 171827,
		itemId = 137575,
		npcs = {99999},
		tooltipNpcs = {105503, 111022}, -- Gul'dan / The Demon Within (Mythic only)
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true},
		chance = 100,
		wasGuaranteed = true,
		groupSize = 3,
		equalOdds = true,
		statisticId = {10980},
		coords = {{m = 772, i = true}}
	},
	["Antoran Charhound"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Antoran Charhound"],
		spellId = 253088,
		itemId = 152816,
		npcs = {99999},
		tooltipNpcs = {126915, 126916},
		chance = 100,
		groupSize = 3,
		equalOdds = true,
		statisticId = {12118, 11957, 11958, 11959},
		coords = {{m = 910, i = true}}
	},
	["Shackled Ur'zul"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.LEGION,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Shackled Ur'zul"],
		spellId = 243651,
		itemId = 152789,
		npcs = {99999},
		tooltipNpcs = {130352}, -- Argus the Unmaker
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true},
		chance = 100,
		wasGuaranteed = true,
		groupSize = 3,
		equalOdds = true,
		statisticId = {11986},
		coords = {{m = 910, i = true}}
	},
	-- 8.0 Mounts

	["Sharkbait's Favorite Crackers"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Sharkbait's Favorite Crackers"],
		spellId = 254813,
		itemId = 159842,
		npcs = {99999},
		tooltipNpcs = {126983},
		statisticId = {12752},
		chance = 200,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.FREEHOLD, i = true}
		}
	},
	["Underrot Crawg Harness"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Underrot Crawg Harness"],
		spellId = 273541,
		itemId = 160829,
		npcs = {99999},
		tooltipNpcs = {133007},
		statisticId = {12745},
		chance = 200,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_UNDERROT, i = true}
		}
	},
	["Mummified Raptor Skull"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Mummified Raptor Skull"],
		spellId = 266058,
		itemId = 159921,
		npcs = {99999},
		tooltipNpcs = {136160},
		statisticId = {12763},
		chance = 200,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.KINGS_REST, i = true}
		}
	},
	["Twilight Avenger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Twilight Avenger"],
		spellId = 279466,
		itemId = 163584,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Craghorn Chasm-Leaper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Craghorn Chasm-Leaper"],
		spellId = 279467,
		itemId = 163583,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Qinsho's Eternal Hound"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Qinsho's Eternal Hound"],
		spellId = 279469,
		itemId = 163582,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Squawks"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Squawks"],
		spellId = 254811,
		itemId = 163586,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Surf Jelly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Surf Jelly"],
		spellId = 278979,
		itemId = 163585,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Great Sea Ray"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Great Sea Ray"],
		spellId = 278803,
		itemId = 163131,
		chance = 10000,
		zones = {
			"896", -- Drustvar
			"895", -- Tiragarde
			"942", -- SSValley
			"862", -- Zuldazar
			"863", -- Nazmir
			"864", -- Vol'dun
			"875", -- Zandalar
			"876", -- Kul'tiras
			"974", -- Tol'Dagor
			"1161", -- Boralus
			"1364", -- Battle for Dazar'alor (Raid)
			"1462", -- Mechagon Island
			"1165" -- Dazar'alor
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DRUSTVAR},
			{m = CONSTANTS.UIMAPIDS.TIRAGARDE_SOUND},
			{m = CONSTANTS.UIMAPIDS.STORMSONG_VALLEY},
			{m = CONSTANTS.UIMAPIDS.ZULDAZAR},
			{m = CONSTANTS.UIMAPIDS.NAZMIR},
			{m = CONSTANTS.UIMAPIDS.VOLDUN},
			{m = CONSTANTS.UIMAPIDS.ZANDALAR},
			{m = CONSTANTS.UIMAPIDS.KULTIRAS},
			{m = CONSTANTS.UIMAPIDS.TORDAGOR},
			{m = CONSTANTS.UIMAPIDS.BORALUS},
			{m = CONSTANTS.UIMAPIDS.BATTLE_FOR_DAZARALOR_RAID},
			{m = CONSTANTS.UIMAPIDS.MECHAGON_ISLAND},
			{m = CONSTANTS.UIMAPIDS.DAZARALOR}
		}
	},
	-- 8.1 Mounts

	["G.M.O.D."] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["G.M.O.D."],
		spellId = 289083,
		itemId = 166518,
		npcs = {99999},
		tooltipNpcs = {144796},
		tooltipModifier = {
			condition = CONSTANTS.TOOLTIP_FILTERS.IS_PLAYER_IN_LFR,
			action = CONSTANTS.TOOLTIP_ACTIONS.OVERRIDE_TOOLTIP_NPCS,
			value = 146409
		},
		chance = 100,
		groupSize = 5,
		equalOdds = true,
		statisticId = {13372, 13373, 13374, 13379},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Mekkatorque",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true
				}
			},
			{
				encounterName = "Mekkatorque",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true
				}
			},
			{
				encounterName = "Mekkatorque",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true
				}
			},
			{
				encounterName = "Lady Jaina Proudmoore",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
				}
			}
		},
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true, -- Normal (Raids)
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true, -- Heroic (Raids)
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true, -- Mythic (Raids)
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true -- LFR
		},
		coords = {
			{m = 1364, i = true}
		}
	},
	["Risen Mare"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Risen Mare"],
		spellId = 288722,
		itemId = 166466,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Island Thunderscale"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Island Thunderscale"],
		spellId = 288721,
		itemId = 166467,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Bloodgorged Hunter"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Bloodgorged Hunter"],
		spellId = 288720,
		itemId = 166468,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
	},
	["Stonehide Elderhorn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Stonehide Elderhorn"],
		spellId = 288712,
		itemId = 166470,
		npcs = 99999,
		chance = 100,
		equalOdds = true,
		groupSize = 3
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