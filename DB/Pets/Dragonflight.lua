local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightPets = {
	["Ohuna Companion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Ohuna Companion"],
		itemId = 200276,
		items = { 200468, 200513, 200515 },
		questId = {
			-- 69998,
			70906, -- Purple bag
			-- 70009,
			71136, -- Blue bag
			-- 70007,
			71137, -- Green bag
		},
		spellId = 389429,
		creatureId = 189134,
		chance = 100, -- Guess
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Bakar Companion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Bakar Companion"],
		itemId = 200290,
		items = { 200468, 200513, 200515 },
		questId = {
			-- 69998,
			70906, -- Purple bag
			-- 70009,
			-- 69999,
			71136, -- Blue bag
			-- 70007,
			71137, -- Green bag
		},
		spellId = 389503,
		creatureId = 189159,
		chance = 100, -- Guess
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Ashenwing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ashenwing"],
		npcs = { 200681 },
		itemId = 193374,
		spellId = 375085,
		chance = 20,
		creatureId = 189118,
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 43.6, y = 61.0, n = L["Bonesifter Marwak"] } },
	},
	["Gilded Mechafrog"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Gilded Mechafrog"],
		itemId = 204079,
		items = { 203699, 203700 },
		spellId = 403072,
		creatureId = 202484,
		sourceText = L["Inside Zskera Vaults, collect Neltharion Gift Tokens for Prototype Tinker-Tron in order to receive Tattered Gift Package, which can drop the Gilded Mechafrog pet."],
		chance = 25,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 29.2, y = 53.0, n = L["Entrance to Zskera Vault"] },
		},
	},
	["Dust Spirit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Dust Spirit"],
		itemId = 201260,
		items = { 201297 },
		spellId = 374755,
		creatureId = 198271,
		sourceText = L["Collect Encaged Earthen Soul and wait 15min until it turns into Docile Earthen Soul, then open it for a chance at the pet."],
		chance = 50,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES, x = 52.8, y = 30.6, n = L["Earthshatter Elemental"] } },
	},
	["Blaze Spirit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Blaze Spirit"],
		itemId = 201261,
		items = { 201298 },
		spellId = 374840,
		creatureId = 198272,
		sourceText = L["Collect Encaged Fiery Soul and wait 15min until it turns into Docile Fiery Soul, then open it for a chance at the pet."],
		chance = 50,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 79.4, y = 38.2, n = L["Fire Elemental"] } },
	},
	["Gale Spirit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Gale Spirit"],
		itemId = 201262,
		items = { 201296 },
		spellId = 374883,
		creatureId = 198273,
		sourceText = L["Collect Encaged Airy Soul and wait 15min until it turns into Docile Airy Soul, then open it for a chance at the pet."],
		chance = 50,
		coords = { { m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 23.2, y = 37.6, n = L["Stormbound Colossus"] } },
	},
	["Tide Spirit"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Tide Spirit"],
		itemId = 201265,
		items = { 201299 },
		spellId = 374751,
		creatureId = 198269,
		sourceText = L["Collect Encaged Frosty Soul and wait 15min until it turns into Docile Frosty Soul, then open it for a chance at the pet."],
		chance = 50,
		coords = { { m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 55.2, y = 76.7, n = L["Force of the Springs"] } },
	},
	["Scruffles"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Scruffles"],
		npcs = { 200584 },
		itemId = 193364,
		spellId = 375047,
		chance = 25,
		creatureId = 189115,
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 58.6, y = 48.8, n = L["Vraken the Hunter"] } },
	},
	["Wakyn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Wakyn"],
		npcs = { 200960 },
		itemId = 191930,
		spellId = 371594,
		chance = 20,
		creatureId = 188821,
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 45.9, y = 79.7, n = L["Warden Entrix"] } },
	},
	["Luvvy"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Luvvy"],
		npcs = { 200742 },
		itemId = 193235,
		spellId = 374895,
		chance = 25,
		creatureId = 189106,
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 55.8, y = 51.6, n = L["Luttrok"] } },
	},
	["Doomrubble"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Doomrubble"],
		spellId = 418039,
		itemId = 208008,
		items = { 207583 },
		chance = 500,
		creatureId = 208634,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Briarhorn Hatchling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Briarhorn Hatchling"],
		spellId = 418029,
		itemId = 208012,
		items = { 207583 },
		chance = 500,
		creatureId = 208624,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Obsidian Warwhelp"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Obsidian Warwhelp"],
		spellId = 418045,
		itemId = 208011,
		items = { 207583 },
		chance = 500,
		creatureId = 208637,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Jeepers"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Jeepers"],
		spellId = 418038,
		itemId = 208010,
		items = { 207583 },
		chance = 500,
		creatureId = 208631,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Gill'dan"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Gill'dan"],
		spellId = 418036,
		itemId = 208009,
		items = { 207583 },
		chance = 500,
		creatureId = 208630,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Killbot 9000"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Killbot 9000"],
		spellId = 418041,
		itemId = 208013,
		items = { 207583 },
		chance = 500,
		creatureId = 208636,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["N'Ruby"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["N'Ruby"],
		spellId = 418050,
		itemId = 208138,
		items = { 207583 },
		chance = 500,
		creatureId = 208639,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Shaggy"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Shaggy"],
		spellId = 371534,
		itemId = 191915,
		items = { 204383 },
		chance = 66,
		creatureId = 188709,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH } },
	},
	["Echo of the Heights"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Echo of the Heights"],
		npcs = {
			184444,
			184453,
			184461,
			185147,
			185168,
			185350,
			185353,
			185357,
			185465,
			186109,
			186239,
			186512,
			186594,
			186598,
			186599,
			186600,
			186602,
			186604,
			186605,
			186606,
			186607,
			186609,
			186612,
			186620,
			186624,
			186626,
			186627,
			186628,
			186630,
			186632,
			186638,
			186684,
			186724,
			186727,
			186728,
			186735,
			186783,
			186859,
			187306,
			187366,
			187599,
			187600,
			187602,
			187813,
			187867,
			187868,
			187886,
			187889,
			187919,
			187923,
			187928,
			187932,
			188009,
			188014,
			188044,
			190737,
			190738,
			190776,
			190778,
			190779,
			190780,
			190991,
			190995,
			190996,
			191129,
			191476,
			191479,
			191507,
			191508,
			191637,
			191654,
			191658,
			191661,
			191677,
			191678,
			191680,
			191898,
			191899,
			191902,
			191940,
			192340,
			192341,
			192582,
			192694,
			192696,
			192699,
			192700,
			192702,
			192703,
			193198,
			193244,
			193522,
			193664,
			193688,
			193967,
			194119,
			194120,
			194797,
			194798,
			194912,
			195448,
			195814,
			195815,
			195836,
			195837,
			195839,
			196336,
			196398,
			196772,
			196835,
			196972,
			196973,
			197075,
			197076,
			197088,
			197118,
			197119,
			197120,
			197121,
			197122,
			197123,
			197124,
			197125,
			197126,
			197128,
			197129,
			197130,
			197131,
			197132,
			197133,
			197134,
			197135,
			197138,
			197139,
			197142,
			197169,
			197344,
			197353,
			197354,
			197356,
			198343,
			199298,
			201535,
			201537,
			201538,
			201540,
			201549,
			201550,
			201552,
			201554,
			201555,
			201556,
			201557,
			201558,
			201559,
			203741,
			203743,
			203744,
			203745,
			203746,
			203747,
			203748,
			203754,
			203755,
			203756,
		},
		itemId = 200263,
		spellId = 389384,
		chance = 1000,
		creatureId = 189132,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.THE_PRIMALIST_FUTURE },
		},
	},
	["Echo of the Depths"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Echo of the Depths"],
		npcs = {
			184444,
			184453,
			184461,
			185147,
			185168,
			185353,
			185357,
			185465,
			186109,
			186109,
			186239,
			186512,
			186594,
			186598,
			186599,
			186600,
			186602,
			186604,
			186605,
			186606,
			186607,
			186609,
			186612,
			186620,
			186624,
			186626,
			186627,
			186628,
			186630,
			186632,
			186684,
			186724,
			186727,
			186728,
			186735,
			186783,
			186859,
			187306,
			187366,
			187599,
			187600,
			187602,
			187813,
			187867,
			187868,
			187886,
			187889,
			187919,
			187923,
			187928,
			187932,
			188009,
			188014,
			188044,
			190737,
			190738,
			190776,
			190779,
			190780,
			190991,
			190995,
			190996,
			191129,
			191363,
			191476,
			191479,
			191507,
			191508,
			191654,
			191658,
			191661,
			191677,
			191679,
			191680,
			191898,
			191899,
			191902,
			192334,
			192340,
			192341,
			192582,
			192694,
			192696,
			192699,
			192700,
			192702,
			192703,
			193139,
			193198,
			193244,
			193522,
			193664,
			193688,
			193776,
			194119,
			194120,
			194797,
			194798,
			194912,
			195448,
			195815,
			195836,
			195837,
			195838,
			195839,
			196193,
			196336,
			196398,
			196772,
			196834,
			196835,
			196973,
			197075,
			197076,
			197088,
			197118,
			197119,
			197120,
			197121,
			197122,
			197123,
			197124,
			197125,
			197126,
			197128,
			197129,
			197130,
			197131,
			197132,
			197133,
			197134,
			197135,
			197136,
			197138,
			197139,
			197142,
			197169,
			197344,
			197353,
			197354,
			197356,
			197902,
			198343,
			199298,
			201535,
			201537,
			201538,
			201539,
			201540,
			201549,
			201550,
			201552,
			201553,
			201554,
			201555,
			201556,
			201557,
			201558,
			201559,
			201561,
			203744,
			203745,
			203747,
			203748,
			203750,
			203752,
			203754,
		},
		itemId = 200260,
		spellId = 389378,
		chance = 1000,
		creatureId = 189130,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.THE_PRIMALIST_FUTURE },
		},
	},
	["Echo of the Inferno"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Echo of the Inferno"],
		npcs = {
			184444,
			184453,
			184461,
			185147,
			185168,
			185350,
			185353,
			185357,
			185465,
			186512,
			186594,
			186599,
			186600,
			186602,
			186604,
			186605,
			186606,
			186607,
			186609,
			186612,
			186620,
			186624,
			186626,
			186627,
			186628,
			186632,
			186638,
			186684,
			186724,
			186727,
			186728,
			186735,
			186783,
			186792,
			186859,
			187306,
			187366,
			187599,
			187600,
			187602,
			187813,
			187867,
			187868,
			187886,
			187889,
			187919,
			187923,
			187928,
			187932,
			188009,
			188014,
			190737,
			190738,
			190776,
			190779,
			190780,
			190991,
			190995,
			190996,
			191129,
			191363,
			191476,
			191479,
			191479,
			191507,
			191508,
			191637,
			191654,
			191658,
			191661,
			191672,
			191677,
			191678,
			191680,
			191898,
			191899,
			191901,
			191902,
			192334,
			192340,
			192341,
			192371,
			192582,
			192694,
			192696,
			192699,
			192700,
			192702,
			192703,
			193198,
			193244,
			193522,
			193664,
			193688,
			193776,
			193967,
			194119,
			194797,
			194798,
			194912,
			195448,
			195815,
			195836,
			195837,
			195839,
			196336,
			196772,
			196835,
			196973,
			197075,
			197076,
			197087,
			197118,
			197119,
			197120,
			197121,
			197122,
			197123,
			197124,
			197125,
			197126,
			197128,
			197129,
			197130,
			197131,
			197132,
			197133,
			197134,
			197135,
			197136,
			197138,
			197139,
			197140,
			197142,
			197169,
			197344,
			197353,
			197354,
			197356,
			197902,
			198343,
			199298,
			201535,
			201537,
			201538,
			201539,
			201540,
			201549,
			201550,
			201552,
			201553,
			201554,
			201555,
			201556,
			201557,
			201558,
			201559,
			201561,
			203743,
			203747,
			203753,
			203754,
			203755,
			203756,
			203757,
		},
		itemId = 200255,
		spellId = 389363,
		chance = 1000,
		creatureId = 189112,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.THE_PRIMALIST_FUTURE },
		},
	},
	["Echo of the Cave"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Echo of the Cave"],
		npcs = {
			184444,
			184453,
			184461,
			185147,
			185168,
			185350,
			185353,
			185357,
			185465,
			186109,
			186239,
			186512,
			186594,
			186599,
			186600,
			186602,
			186604,
			186605,
			186606,
			186607,
			186608,
			186609,
			186612,
			186620,
			186624,
			186626,
			186627,
			186628,
			186630,
			186632,
			186684,
			186724,
			186727,
			186728,
			186735,
			186783,
			186792,
			186859,
			187306,
			187366,
			187599,
			187600,
			187602,
			187813,
			187867,
			187868,
			187886,
			187889,
			187919,
			187923,
			187928,
			187932,
			188009,
			188014,
			188044,
			190737,
			190738,
			190776,
			190778,
			190779,
			190780,
			190991,
			190995,
			190996,
			191129,
			191363,
			191479,
			191507,
			191508,
			191637,
			191654,
			191658,
			191661,
			191677,
			191678,
			191680,
			191898,
			191899,
			191902,
			192334,
			192340,
			192341,
			192582,
			192694,
			192696,
			192699,
			192700,
			192702,
			192703,
			193152,
			193198,
			193244,
			193664,
			194119,
			194120,
			194797,
			194798,
			194912,
			195448,
			195814,
			195815,
			195836,
			195837,
			195839,
			196193,
			196336,
			196398,
			196772,
			196834,
			196835,
			197075,
			197076,
			197087,
			197088,
			197091,
			197092,
			197118,
			197119,
			197120,
			197121,
			197122,
			197123,
			197124,
			197125,
			197126,
			197128,
			197129,
			197130,
			197131,
			197132,
			197133,
			197134,
			197135,
			197136,
			197138,
			197139,
			197140,
			197142,
			197169,
			197344,
			197353,
			197356,
			197902,
			198343,
			199298,
			201535,
			201537,
			201538,
			201539,
			201540,
			201550,
			201552,
			201553,
			201554,
			201555,
			201556,
			201557,
			201558,
			201561,
			203739,
			203740,
			203741,
			203742,
			203750,
			203754,
		},
		itemId = 200183,
		spellId = 389143,
		chance = 1000,
		creatureId = 192258,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
			{ m = CONSTANTS.UIMAPIDS.THE_PRIMALIST_FUTURE },
		},
	},
	["Ambre"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ambre"],
		itemId = 205003,
		spellId = 407921,
		creatureId = 204221,
		chance = 50,
		npcs = {
			201673, -- Kretchenwrath
			203411, -- Shadeisethal
		},
		questId = 75467,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 75.6, y = 69.6, n = L["Kretchenwrath"] },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 58.6, y = 31.8, n = L["Shadeisethal"] },
		},
	},
	["Blaise"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Blaise"],
		itemId = 205002,
		spellId = 407918,
		creatureId = 204217,
		chance = 50,
		npcs = {
			201673, -- Kretchenwrath
			203411, -- Shadeisethal
		},
		questId = 75467,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS, x = 75.6, y = 69.6, n = L["Kretchenwrath"] },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN, x = 58.6, y = 31.8, n = L["Shadeisethal"] },
		},
	},
	["Ridged Shalewing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ridged Shalewing"],
		itemId = 205147,
		spellId = 408251,
		creatureId = 204339,
		chance = 20,
		questId = 75333,
		npcs = {
			203625, -- Karokta
		},
		coords = { { x = 42.20, y = 65.17, n = L["Karokta"], m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	["Skaarn"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Skaarn"],
		itemId = 205152,
		spellId = 408264,
		creatureId = 204345,
		chance = 20,
		questId = 75266,
		npcs = {
			203462, -- Kob'rok
		},
		coords = { { x = 65.2, y = 55.8, n = L["Kob'rok"], m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	["Aquapo"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Aquapo"],
		itemId = 205154,
		spellId = 408308,
		creatureId = 204359,
		chance = 20,
		questId = 75271,
		npcs = {
			203468, -- Aquifon
		},
		coords = { { x = 48.4, y = 75, n = L["Aquifon"], m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	["Teardrop Moth"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Teardrop Moth"],
		itemId = 205159,
		spellId = 408317,
		creatureId = 204363,
		chance = 20,
		questId = 75297,
		npcs = {
			203593, -- Underlight Queen
		},
		coords = { { x = 58, y = 69.2, n = L["Underlight Queen"], m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	["Devourer Lobstrok"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Devourer Lobstrok"],
		itemId = 205026,
		spellId = 408039,
		creatureId = 204269,
		items = {
			205367, -- Indebted Researcher's Gift
			205368, -- Thankful Researcher's Gift
			205369, -- Appreciative Researcher's Gift
			205374, -- Thankful Researcher's Scrounged Goods
			205372, -- Indebted Researcher's Scrounged Goods
			205371, -- Appreciative Researcher's Scrounged Goods
			205370, -- Researcher's Gift
			205373, -- Researcher's Scrounged Goods
		},
		chance = 7, -- Average over all the containers (not exactly accurate...)
		coords = { { m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, dragonflightPets)
