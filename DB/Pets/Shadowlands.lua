local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local shadowlandsPets = {
	-- 9.0 Pets
	["Feasting Larva"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Feasting Larva"],
		npcs = {162528},
		spellId = 335977,
		itemId = 181266,
		chance = 25,
		creatureId = 172137,
		questId = 58768,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 42.27, y = 53.90, n = L["Smorgas the Feaster"]}
		}
	},
	["Writhing Spine"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Writhing Spine"],
		npcs = {158406},
		spellId = 335979,
		itemId = 181267,
		chance = 33,
		creatureId = 172139,
		questId = 58006,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 61.6, y = 76.4, n = L["Scunner"]}
		}
	},
	["Foulwing Buzzer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Foulwing Buzzer"],
		npcs = {159753},
		spellId = 336031,
		itemId = 181283,
		chance = 20,
		creatureId = 172155,
		questId = 58004,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 54.0, y = 18.4, n = L["Ravenomous"]}
		}
	},
	["Sharpclaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Sharpclaw"],
		npcs = {172521},
		spellId = 341495,
		itemId = 183410,
		chance = 20,
		creatureId = 174084,
		questId = 62210,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW, x = 55.8, y = 67.5, n = L["Sanngror the Torturer"]}
		}
	},
	["Blushing Spiderling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Blushing Spiderling"],
		npcs = {155779},
		spellId = 333794,
		itemId = 180584,
		chance = 50,
		creatureId = 171117,
		questId = 56877,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 42.8, y = 79.2, n = L["Tomb Burster"]}
		}
	},
	["Boneweave Hatchling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Boneweave Hatchling"],
		npcs = {159886},
		spellId = 335764,
		itemId = 181172,
		chance = 33,
		creatureId = 171986,
		questId = 58003,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 55.5, y = 23.6, n = L["Sister Chelicerae"]}
		}
	},
	["Bucket of Primordial Sludge"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Bucket of Primordial Sludge"],
		npcs = {166292},
		spellId = 333799,
		itemId = 180588,
		chance = 11,
		creatureId = 171121,
		questId = 59823,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 35.8, y = 32.6, n = L["Bog Beast"]}
		}
	},
	["Animated Tome"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Animated Tome"],
		npcs = {160675},
		spellId = 333797,
		itemId = 180587,
		chance = 20,
		creatureId = 171120,
		questId = 58213,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 37.6, y = 68.7, n = L["Scrivener Lenua"]}
		}
	},
	["Invertebrate Oil"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Invertebrate Oil"],
		npcs = {157312},
		spellId = 336021,
		itemId = 181270,
		chance = 40,
		creatureId = 172149,
		questId = 61724,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 58.6, y = 74.2, n = L["Oily Invertebrate"]}
		}
	},
	["Shy Melvin"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Shy Melvin"],
		npcs = {162711},
		spellId = 335969,
		itemId = 181263,
		chance = 3,
		creatureId = 172134,
		questId = 58868,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 76.8, y = 57.0, n = L["Deadly Dapperling"]}
		}
	},
	["Corpselouse Larva"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Corpselouse Larva"],
		npcs = {162528},
		spellId = 335974,
		itemId = 181265,
		chance = 100,
		creatureId = 172136,
		questId = 58768,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS, x = 42.27, y = 53.90, n = L["Smorgas the Feaster"]}
		}
	},
	["Contained Essence of Dread"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Contained Essence of Dread"],
		npcs = {154330},
		spellId = 341492,
		itemId = 183407,
		chance = 8,
		creatureId = 174081,
		questId = 57509,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW, x = 19.8, y = 46.0, n = L["Eternas the Tormentor"]}
		}
	},
	["Tower Deathroach"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tower Deathroach"],
		npcs = {155250, 155251, 156239},
		spellId = 340721,
		itemId = 183115,
		chance = 25,
		creatureId = 173849,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Devoured Wader"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Devoured Wader"],
		itemId = 180869,
		spellId = 335083,
		creatureId = 171714,
		npcs = {171041, 171013, 171040},
		chance = 20,
		questId = 61001,
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION}
		}
	},
	["Lost Featherling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Lost Featherling"],
		itemId = 184397,
		spellId = 345741,
		creatureId = 175560,
		npcs = {157054, 156559, 156560, 157212},
		chance = 150,
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION}
		},
		requiresCovenant = true,
		requiredCovenantID = CONSTANTS.COVENANT_IDS.KYRIAN
	},
	["Bottled Up Rage"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Bottled Up Rage"],
		itemId = 180585,
		spellId = 333795,
		creatureId = 171118,
		npcs = {170048, 165175},
		chance = 20,
		questId = {60729},
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 49.84, y = 35.02, n = L["Manifestation of Wrath"]},
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 67.8, y = 82, n = L["Prideful Hulk"]}
		}
	},
	["Undying Deathroach"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Undying Deathroach"],
		itemId = 183408,
		items = {184395},
		spellId = 341493,
		creatureId = 174082,
		chance = 20,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Decaying Mawrat"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Decaying Mawrat"],
		itemId = 183409,
		items = {184395},
		spellId = 341494,
		creatureId = 174083,
		chance = 20,
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Frenzied Mawrat"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Frenzied Mawrat"],
		itemId = 183192,
		spellId = 341293,
		creatureId = 173990,
		npcs = {151329, 153165, 151331},
		chance = 100,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Maw Stalker"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Maw Stalker"],
		itemId = 183194,
		spellId = 341295,
		creatureId = 173991,
		npcs = {159755, 151331, 169859, 171422},
		chance = 200,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Hissing Deathroach"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Hissing Deathroach"],
		itemId = 183116,
		spellId = 340722,
		creatureId = 173850,
		npcs = {155251, 156239, 155250},
		chance = 33,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Severs"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Severs"],
		itemId = 183117,
		spellId = 340723,
		creatureId = 173851,
		npcs = {159190, 157122, 171422, 155945},
		chance = 400,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Lightbinders"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Lightbinders"],
		itemId = 180586,
		spellId = 333796,
		creatureId = 171119,
		npcs = {164388, 160604, 165687},
		chance = 1000, -- It's about 5% from the rare, but two sources with different drop rates aren't currently supported
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH, x = 25.8, y = 48.4, n = L["Amalgamation of Light"]}
		}
	},
	["Crimson Dredwing Pup"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Crimson Dredwing Pup"],
		itemId = 180602,
		spellId = 333865,
		creatureId = 171150,
		npcs = {161206, 169154, 163893, 156077, 156395, 165290},
		chance = 2000,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	["Jar of Ashes"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Jar of Ashes"],
		itemId = 183193,
		spellId = 341292,
		creatureId = 173989,
		npcs = {153165, 151329, 151331},
		chance = 100,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Maw Crawler"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Maw Crawler"],
		itemId = 183191,
		spellId = 341289,
		creatureId = 173988,
		npcs = {153451, 156015, 155945, 153165, 169859},
		chance = 200,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Torghast Lurker"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Torghast Lurker"],
		itemId = 183195,
		spellId = 341298,
		creatureId = 173992,
		npcs = {152995, 170418, 153174, 153011, 153382},
		chance = 100,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
	["Stonewing Dredwing Pup"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Stonewing Dredwing Pup"],
		itemId = 180601,
		items = {180648},
		spellId = 339590,
		creatureId = 173502,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	["Hungry Burrower"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Hungry Burrower"],
		itemId = 180635,
		items = {180649},
		spellId = 334149,
		creatureId = 171242,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARDENWEALD}
		}
	},
	["Larion Cub"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Larion Cub"],
		itemId = 184399,
		items = {180647},
		spellId = 345744,
		creatureId = 175564,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION}
		}
	},
	["Micromancer's Mystical Cowl"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Micromancer's Mystical Cowl"],
		itemId = 181269,
		items = {180646},
		spellId = 336020,
		creatureId = 172148,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Sludge Feeler"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Sludge Feeler"],
		itemId = 181271,
		spellId = 336022,
		creatureId = 172150,
		npcs = {99999},
		tooltipNpcs = {164267},
		statisticId = {14398},
		chance = 100,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.PLAGUEFALL}
		}
	},
	["Vial of Roiling Emotions"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC, -- Is this actually correct? Can't use statistics to reliably detect this, because there aren't any
		name = L["Vial of Roiling Emotions"],
		itemId = 180591,
		spellId = 333802,
		creatureId = 171124,
		npcs = {162102},
		-- tooltipNpcs = { 162102 }, -- Not needed if using NPC instead of BOSS
		chance = 100,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.SANGUINE_DEPTHS}
		}
	},
	["Spinemaw Gormling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Spinemaw Gormling"],
		itemId = 183623,
		spellId = 341519,
		creatureId = 174089,
		npcs = {99999},
		tooltipNpcs = {164517},
		statisticId = {14395},
		chance = 100,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MISTS_OF_TIRNA_SCITHE}
		}
	},
	["Skittering Venomspitter"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Skittering Venomspitter"],
		itemId = 181173,
		spellId = 335765,
		creatureId = 171987,
		chance = 75,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Bubbling Pustule"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Bubbling Pustule"],
		itemId = 181262,
		spellId = 335966,
		creatureId = 172132,
		chance = 33,
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Silvershell Snapper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Silvershell Snapper"],
		itemId = 180856,
		spellId = 335050,
		creatureId = 171693,
		chance = 20,
		tooltipNpcs = {163460},
		questId = {62650},
		sourceText = L["This can be looted after killing Dionae."],
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION, x = 41.5, y = 49.1, n = L["Stewart's Stewpendous Stew"]}
		}
	},
	["Trapped Stonefiend"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Trapped Stonefiend"],
		itemId = 180592,
		spellId = 333803,
		creatureId = 171125,
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	["Larion Pouncer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Larion Pouncer"],
		itemId = 184401,
		spellId = 345742,
		creatureId = 175562,
		npcs = {156340},
		questId = 61634,
		chance = 25,
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION, x = 22.6, y = 22.8, n = L["Larionrider Orstus"]}
		}
	},
	["Soullocked Sinstone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Soullocked Sinstone"],
		itemId = 180589,
		spellId = 333800,
		creatureId = 171122,
		chance = 20,
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	["Luminous Webspinner"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Luminous Webspinner"],
		itemId = 181171,
		spellId = 335762,
		creatureId = 171985,
		chance = 25, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Stony's Infused Ruby"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Stony's Infused Ruby"],
		itemId = 183855,
		spellId = 339674,
		creatureId = 173536,
		chance = 100, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.REVENDRETH}
		}
	},
	["Lucy's Lost Collar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Lucy's Lost Collar"],
		itemId = 184507,
		spellId = 346192,
		creatureId = 175715,
		npcs = {175390},
		chance = 100, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION},
			{m = CONSTANTS.UIMAPIDS.ARDENWEALD},
			{m = CONSTANTS.UIMAPIDS.REVENDRETH},
			{m = CONSTANTS.UIMAPIDS.MALDRAXXUS}
		}
	},
	["Pommel Jewel of Remornia"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Pommel Jewel of Remornia"],
		itemId = 183395,
		spellId = 341302,
		creatureId = 173994,
		npcs = {99999},
		tooltipNpcs = {168938, 167406},
		chance = 33,
		statisticId = {14455, 14458}, -- Normal and LFR are the only two confirmed sources.
		groupSize = 10,
		equalOdds = true,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Sire Denathrius",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true
				}
			},
			{
				encounterName = "Sire Denathrius",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
				}
			}
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.CASTLE_NATHRIA, i = true}
		}
	},
	["Gilded Wader"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Gilded Wader"],
		itemId = 180866,
		spellId = 335076,
		creatureId = 171710,
		chance = 300, -- Estimate
		coords = {
			{m = CONSTANTS.UIMAPIDS.BASTION}
		}
	},
	-- 9.1 pets
	["Eye of Extermination"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Eye of Extermination"],
		itemId = 186555,
		spellId = 353649,
		creatureId = 179233,
		npcs = {99999},
		tooltipNpcs = {180018},
		chance = 100, -- Blind guess
		statisticId = {15143}, -- Mythic is only confirmed source.
		groupSize = 25,
		equalOdds = true,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Eye of the Jailer",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true
				}
			},
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.SANCTUM_OF_DOMINATION, i = true}
		}
	},
	["Eye of Allseeing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Eye of Allseeing"],
		itemId = 186554,
		spellId = 353648,
		creatureId = 179232,
		npcs = {99999},
		tooltipNpcs = {180018},
		chance = 100, -- Blind guess
		statisticId = {15140, 15143, 15142, 15141}, -- All difficulties.
		groupSize = 10,
		equalOdds = true,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Eye of the Jailer",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true
				}
			},
			{
				encounterName = "Eye of the Jailer",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true
				}
			},
			{
				encounterName = "Eye of the Jailer",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true
				}
			},
			{
				encounterName = "Eye of the Jailer",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
				}
			},
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.SANCTUM_OF_DOMINATION, i = true}
		}
	},
	["Irongrasp"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Irongrasp"],
		itemId = 186558,
		spellId = 353639,
		creatureId = 179222,
		npcs = {99999},
		tooltipNpcs = {175727},
		chance = 100, -- Blind guess
		statisticId = {15155, 15153, 15154, 15152}, -- All difficulties.
		groupSize = 10,
		equalOdds = true,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Soulrender Dormazain",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true
				}
			},
			{
				encounterName = "Soulrender Dormazain",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true
				}
			},
			{
				encounterName = "Soulrender Dormazain",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true
				}
			},
			{
				encounterName = "Soulrender Dormazain",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
				}
			},
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.SANCTUM_OF_DOMINATION, i = true}
		}
	},
	["Mawsworn Minion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Mawsworn Minion"],
		itemId = 186550,
		spellId = 353658,
		creatureId = 179240,
		npcs = {99999},
		tooltipNpcs = {15990},
		chance = 100, -- Blind guess
		statisticId = {15169, 15171, 15172, 15170}, -- All difficulties.
		groupSize = 10,
		equalOdds = true,
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true,
			[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
		},
		lockoutDetails = {
			mode = CONSTANTS.DEFEAT_DETECTION.MODE_AND,
			{
				encounterName = "Kel'Thuzad",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true
				}
			},
			{
				encounterName = "Kel'Thuzad",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.HEROIC_RAID] = true
				}
			},
			{
				encounterName = "Kel'Thuzad",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.NORMAL_RAID] = true
				}
			},
			{
				encounterName = "Kel'Thuzad",
				instanceDifficulties = {
					[CONSTANTS.INSTANCE_DIFFICULTIES.LFR] = true
				}
			},
		},
		coords = {
			{m = CONSTANTS.UIMAPIDS.SANCTUM_OF_DOMINATION, i = true}
		}
	},
	["Mosscoated Hopper"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Mosscoated Hopper"],
		itemId = 186541,
		items = {186650},
		spellId = 353664,
		creatureId = 179252,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.KORTHIA}
		}
	},
	["Rook"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Rook"],
		itemId = 186552,
		items = {187029},
		spellId = 353661,
		creatureId = 179242,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Fodder"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Fodder"],
		itemId = 186557,
		items = {185992},
		spellId = 353529,
		creatureId = 179171,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Gizmo"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Gizmo"],
		itemId = 186534,
		spellId = 353525,
		creatureId = 179166,
		npcs = {175646},
		chance = 100, -- Blind guess
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		coords = {
			{m = CONSTANTS.UIMAPIDS.TAZAVESH_THE_VEILED_MARKET, n = L["P.O.S.T. Master"]}
		}
	},
	["Invasive Buzzer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Invasive Buzzer"],
		itemId = 186547,
		items = {185991},
		spellId = 353569,
		creatureId = 179180,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Copperback Etherwyrm"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Copperback Etherwyrm"],
		itemId = 186546,
		items = {185993},
		spellId = 353451,
		creatureId = 179132,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW}
		}
	},
	["Gnashtooth"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Gnashtooth"],
		itemId = 186538,
		items = {187028},
		spellId = 353666,
		creatureId = 179255,
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.KORTHIA}
		}
	},
	["Amaranthine Stinger"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Amaranthine Stinger"],
		itemId = 186449,
		spellId = 353570,
		creatureId = 179181,
		npcs = {177979},
		chance = 25, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW, n = L["Gralebboih"]}
		}
	},
	["Golden Eye"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Golden Eye"],
		itemId = 186564,
		spellId = 353644,
		creatureId = 179228,
		npcs = {177132},
		chance = 100, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.THE_MAW, n = L["Helsworn Soulseeker"]}
		}
	},
	["Korthian Specimen"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Korthian Specimen"],
		itemId = 186542,
		spellId = 353663,
		creatureId = 179251,
		npcs = {177336},
		chance = 50, -- Blind guess
		questId = 64442,
		coords = {
			{m = CONSTANTS.UIMAPIDS.KORTHIA, x = 30.3, y = 54.9, n = L["Cave Entrance"]},
			{m = CONSTANTS.UIMAPIDS.KORTHIA, x = 27.75, y = 59.27, n = L["Zelnithop"]}
		}
	},
	["Grappling Gauntlet"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Grappling Gauntlet"],
		itemId = 186559,
		spellId = 353638,
		creatureId = 179220,
		npcs = {
			177321,
			177323,
			177164,
			177397,
			178671,
			178744,
			177805,
			179260,
			178727,
			177244,
			179305,
			179284,
			179217,
			177292,
			177293,
			177201,
			161849,
			170694,
			175708,
			166398,
			170157,
			167323,
			173138,
			175702,
			167322,
			175697,
			157824,
		},
		chance = 200, -- Blind guess
		coords = {
			{m = CONSTANTS.UIMAPIDS.KORTHIA},
			{m = CONSTANTS.UIMAPIDS.THE_MAW},
			{m = CONSTANTS.UIMAPIDS.ARDENWEALD},
		}
	},
	["Squibbles"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Squibbles"],
		itemId = 184867,
		items = {184866},
		spellId = 348561,
		creatureId = 176662,
		chance = 50, -- Blind guess
		questId = 63435,
		sourceText = L[
			"This bag is rewarded for completing the pet battle daily offered by Anthea at the Temple of the White Tiger in Kun-Lai Summit."
		],
		coords = {
			{m = CONSTANTS.UIMAPIDS.KUNLAI_SUMMIT}
		}
	},
	["Gilded Darknight"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Gilded Darknight"],
		itemId = 186549,
		spellId = 353656,
		creatureId = 179239,
		npcs = {179526, 176578, 179433},
		chance = 7,
		sourceText = L["This item can only drop in the Adamant Vaults section of Torghast."],
		coords = {
			{m = CONSTANTS.UIMAPIDS.TORGHAST}
		}
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, shadowlandsPets)
