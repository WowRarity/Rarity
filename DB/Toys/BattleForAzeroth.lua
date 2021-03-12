local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = Rarity.constants

local bfaToys = {

	["Oomgut Ritual Drum"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Oomgut Ritual Drum"],
		itemId = 163795,
		chance = 250,
		groupSize = 3,
		equalOdds = true
	},
	["Whiskerwax Candle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Whiskerwax Candle"],
		itemId = 163924,
		chance = 250,
		groupSize = 3,
		equalOdds = true
	},
	-- ["Yaungol Oil Stove"] = { -- NYI as of 18/01/19
	-- cat = CONSTANTS.ITEM_CATEGORIES.BFA,
	-- type = CONSTANTS.ITEM_TYPES.ITEM,
	-- isToy = true,
	-- method = CONSTANTS.DETECTION_METHODS.SPECIAL,
	-- name = L["Yaungol Oil Stove"],
	-- itemId = 164371,
	-- chance = 250,
	-- groupSize = 3,
	-- },

	-- ["Jinyu Light Globe"] = { -- NYI as of 18/01/19
	-- cat = CONSTANTS.ITEM_CATEGORIES.BFA,
	-- type = CONSTANTS.ITEM_TYPES.ITEM,
	-- isToy = true,
	-- method = CONSTANTS.DETECTION_METHODS.SPECIAL,
	-- name = L["Jinyu Light Globe"],
	-- itemId = 164372,
	-- chance = 250,
	-- groupSize = 3,
	-- },

	["Enchanted Soup Stone"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Enchanted Soup Stone"],
		itemId = 164373,
		chance = 250,
		groupSize = 3,
		equalOdds = true
	},
	["Magic Monkey Banana"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Magic Monkey Banana"],
		itemId = 164374,
		chance = 250,
		groupSize = 3,
		equalOdds = true
	},
	["Bad Mojo Banana"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Bad Mojo Banana"],
		itemId = 164375,
		chance = 250,
		groupSize = 3,
		equalOdds = true
	},
	-- ["Regenerating Banana Bunch"] = { -- NYI as of 18/01/19
	-- cat = CONSTANTS.ITEM_CATEGORIES.BFA,
	-- type = CONSTANTS.ITEM_TYPES.ITEM,
	-- isToy = true,
	-- method = CONSTANTS.DETECTION_METHODS.SPECIAL,
	-- name = L["Regenerating Banana Bunch"],
	-- itemId = 164377,
	-- chance = 250,
	-- groupSize = 3,
	-- },

	["Brazier Cap"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Brazier Cap"],
		itemId = 163713,
		npcs = {142662},
		questId = {53060, 53511},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 79.6, y = 30.3, n = L["Geomancer Flintdagger"]}
		}
	},
	["Molok Morion"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Molok Morion"],
		itemId = 163775,
		npcs = {141942},
		questId = {53057, 53516},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 47.6, y = 77.9, n = L["Molok the Crusher"]}
		}
	},
	["Kovork Kostume"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Kovork Kostume"],
		itemId = 163750,
		npcs = {142684},
		questId = {53089, 53514},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 25, y = 49.1, n = L["Kovork"]},
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 28.8, y = 45.4, n = L["Cave Entrance"]}
		}
	},
	["Witherbark Gong"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Witherbark Gong"],
		itemId = 163745,
		npcs = {142682},
		questId = {53094, 53530},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 62.8, y = 80.8, n = L["Zalas Witherbark"]}
		}
	},
	["Coldrage's Cooler"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Coldrage's Cooler"],
		itemId = 163744,
		npcs = {142112},
		questId = {53058, 53513},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 49.31, y = 84.26, n = L["Kor'gresh Coldrage"]},
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 48, y = 79, n = L["Cave Entrance"]}
		}
	},
	["Magic Fun Rock"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Magic Fun Rock"],
		itemId = 163741,
		npcs = {142683},
		questId = {53092, 53524},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 43, y = 57, n = L["Ruul Onestone"]}
		}
	},
	["Syndicate Mask"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Syndicate Mask"],
		itemId = 163738,
		npcs = {142690},
		questId = {53093, 53525},
		chance = 30,
		coords = {
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 50.8,
				y = 40.85,
				n = L["Singer"] .. " - " .. L["Alliance controls Stromgarde"]
			},
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 50.7,
				y = 57.48,
				n = L["Singer"] .. " - " .. L["Horde controls Stromgarde"]
			}
		}
	},
	["Spectral Visage"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Spectral Visage"],
		itemId = 163736,
		npcs = {142725},
		questId = {53087, 53512},
		chance = 30,
		coords = {
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 26.7,
				y = 32.6,
				n = L["Horrific Apparition"] .. " - " .. L["Alliance controls Stromgarde"]
			},
			{
				m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS,
				x = 19.5,
				y = 60.9,
				n = L["Horrific Apparition"] .. " - " .. L["Horde controls Stromgarde"]
			}
		}
	},
	["Foul Belly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Foul Belly"],
		itemId = 163735,
		npcs = {142686},
		questId = {53086, 53509},
		chance = 30,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 23.1, y = 46.7, n = L["Foulbelly"]},
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 29, y = 45.5, n = L["Cave Entrance"]}
		}
	},
	["Toy Siege Tower"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Toy Siege Tower"],
		itemId = 163828,
		npcs = {138122},
		questId = {53001, 53002}, -- Loot lockout
		chance = 100, -- Need more data. Until then, this is a blind guess...
		groupSize = 3,
		equalOdds = true,
		requiresAlliance = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 37.09, y = 39.21, n = L["Doom's Howl"]}
		},
		enableCoin = true
	},
	["Toy War Machine"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Toy War Machine"],
		itemId = 163829,
		npcs = {137374},
		questId = {53001, 53002}, -- Loot Lockout
		chance = 100, -- Blind guess :|
		groupSize = 3,
		equalOdds = true,
		requiresHorde = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ARATHI_HIGHLANDS, x = 37.09, y = 39.21, n = L["The Lion's Roar"]}
		},
		enableCoin = true
	},
	-- 8.1 Toys

	["Azerite Firework Launcher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Azerite Firework Launcher"],
		itemId = 166877,
		items = {166298},
		chance = 8,
		coords = {
			{m = CONSTANTS.UIMAPIDS.SILITHUS, x = 42.19, y = 44.26, n = L["Magni Bronzebeard"]}
		}
	},
	["Bowl of Glowing Pufferfish"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Bowl of Glowing Pufferfish"],
		itemId = 166704,
		items = {166245},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.STORMSONG_VALLEY},
			{m = CONSTANTS.UIMAPIDS.ZULDAZAR}
		}
	},
	-- ["Kojo's Master Matching Set"] = { -- Note: NYI as of 19/04/2019
	-- cat = CONSTANTS.ITEM_CATEGORIES.BFA,
	-- type = CONSTANTS.ITEM_TYPES.ITEM,
	-- isToy = true,
	-- method = CONSTANTS.DETECTION_METHODS.USE,
	-- name = L["Kojo's Master Matching Set"],
	-- itemId = 166851,
	-- items = { 166245 },
	-- chance = 10,
	-- },

	["Warbeast Kraal Dinner Bell"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Warbeast Kraal Dinner Bell"],
		itemId = 166701,
		items = {166292},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ZULDAZAR}
		}
	},
	["For da Blood God!"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["For da Blood God!"],
		itemId = 166308,
		items = {166282},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.NAZMIR}
		}
	},
	["Goldtusk Inn Breakfast Buffet"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Goldtusk Inn Breakfast Buffet"],
		itemId = 166703,
		items = {166290},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VOLDUN}
		}
	},
	-- ["Words of Akunda"] = { -- Note: NYI as of 19/04/2019
	-- cat = CONSTANTS.ITEM_CATEGORIES.BFA,
	-- type = CONSTANTS.ITEM_TYPES.ITEM,
	-- isToy = true,
	-- method = CONSTANTS.DETECTION_METHODS.USE,
	-- name = L["Words of Akunda"],
	-- itemId = 165021,
	-- items = { 166290 },
	-- chance = 10,
	-- },

	["Meerah's Jukebox"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Meerah's Jukebox"],
		itemId = 166880,
		items = {166290},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VOLDUN}
		}
	},
	["Rallying War Banner"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Rallying War Banner"],
		itemId = 166879,
		items = {166299, 166300},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.BORALUS},
			{m = CONSTANTS.UIMAPIDS.DAZARALOR}
		}
	},
	["Bewitching Tea Set"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Bewitching Tea Set"],
		itemId = 166808,
		items = {166297},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.DRUSTVAR}
		}
	},
	["Proudmoore Music Box"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Proudmoore Music Box"],
		itemId = 166702,
		items = {166295},
		chance = 10,
		coords = {
			{m = CONSTANTS.UIMAPIDS.TIRAGARDE_SOUND}
		}
	},
	["Detoxified Blight Grenade"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Detoxified Blight Grenade"],
		itemId = 166785,
		npcs = {148031},
		chance = 10,
		questId = {54428, 54429},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 40.9, y = 56.5, n = L["Gren Tornfur"]}
		}
	},
	["Highborne Memento"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Highborne Memento"],
		itemId = 166790,
		npcs = {147435, 147845},
		chance = 10,
		questId = {54309, 54252},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 45.7, y = 86.9, n = L["Commander Drald"] .. " - " .. L["Alliance only"]},
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 62.0, y = 16.2, n = L["Thelar Moonstrike"] .. " - " .. L["Horde only"]}
		}
	},
	["Narassin's Soul Gem"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Narassin's Soul Gem"],
		itemId = 166784,
		npcs = {147708},
		chance = 10,
		questId = {54278, 54279},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 58.3, y = 24.9, n = L["Athrikus Narassin"]}
		}
	},
	["Twiddle Twirler: Sentinel's Glaive"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Twiddle Twirler: Sentinel's Glaive"],
		itemId = 166787,
		npcs = {148025},
		chance = 10,
		questId = {54426, 54427},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 37.9, y = 76.2, n = L["Commander Ral'esh"]}
		}
	},
	["Twiddle Twirler: Shredder Blade"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Twiddle Twirler: Shredder Blade"],
		itemId = 166788,
		npcs = {148103, 149141},
		chance = 10,
		questId = {54452, 54768},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 42.0, y = 77.6, n = L["Burninator Mark V"] .. " - " .. L["Alliance only"]},
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 32.9, y = 84, n = L["Sapper Odette"] .. " - " .. L["Horde only"]}
		}
	},
	-- 8.2 Toys
	["Mechagonian Sawblades"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Mechagonian Sawblades"],
		itemId = 167931,
		npcs = {152007},
		chance = 20,
		questId = {55369}
	},
	["Shadescale"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Shadescale"],
		itemId = 170187,
		npcs = {152552},
		chance = 10,
		questId = {56295},
		coords = {
			{m = CONSTANTS.UIMAPIDS.NAZJATAR, x = 62.74, y = 8.09, n = L["Shassera"]}
		}
	},
	["Shirakess Warning Sign"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Shirakess Warning Sign"],
		itemId = 170196,
		npcs = {154148},
		chance = 7,
		questId = {56106},
		coords = {
			{m = CONSTANTS.UIMAPIDS.NAZJATAR, x = 66, y = 23, n = L["Tidemistress Leth'sindra"]}
		}
	},
	["Judgment of Mechagon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Judgment of Mechagon"],
		itemId = 169347,
		npcs = {154225},
		chance = 7,
		questId = {56182},
		coords = {
			{m = CONSTANTS.UIMAPIDS.MECHAGON_ISLAND, x = 57.21, y = 58.38, n = L["The Rusty Prince"]}
		}
	},
	["Flopping Fish"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Flopping Fish"],
		itemId = 170203,
		items = {169940, 169939},
		chance = 8
	},
	["Memento of the Deeps"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Memento of the Deeps"],
		itemId = 170469,
		items = {169940, 169939},
		chance = 10
	},
	["Zanj'ir Weapon Rack"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		npcs = {
			155860,
			154194,
			155689,
			155920,
			152621,
			155813,
			153962,
			153739,
			153960,
			153738,
			154312,
			152883,
			153753,
			153352,
			153300,
			152884,
			152881,
			152827,
			150541,
			153741,
			153740,
			154310,
			152906,
			154311,
			153299,
			155619,
			154222,
			152724,
			153027,
			153019,
			153303,
			153311,
			155840,
			152962,
			152963
		},
		name = L["Zanj'ir Weapon Rack"],
		itemId = 170199,
		chance = 400
	},
	["Underlight Sealamp"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		npcs = {
			153078,
			153080,
			151946,
			145324,
			153334
		},
		name = L["Underlight Sealamp"],
		itemId = 170476,
		chance = 10
	},
	-- 8.3 Toys
	["Overly Sensitive Void Spectacles"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Overly Sensitive Void Spectacles"],
		itemId = 174926,
		npcs = {158284},
		chance = 20,
		coords = {
			{m = CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_STORMWIND}
		}
	},
	["Hell-Bent Bracers"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Hell-Bent Bracers"],
		itemId = 169303,
		npcs = {158636},
		chance = 20, -- Blind guess (no data)
		questId = {57688},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 49.35, y = 82.29, n = L["The Grand Executor"]}
		}
	},
	["Budget K'thir Disguise"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Budget K'thir Disguise"],
		itemId = 174874,
		npcs = {157473},
		chance = 20, -- Blind guess (no data)
		questId = {57438},
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 50, y = 88, n = L["Yiphrim the Will Ravager"]},
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 50, y = 88, n = L["Yiphrim the Will Ravager"]},
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 55, y = 79, n = L["Yiphrim the Will Ravager"]}
		}
	},
	["Trans-mogu-rifier"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Trans-mogu-rifier"],
		itemId = 174873,
		npcs = {155958},
		chance = 20, -- Blind guess (no data)
		questId = {58507},
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 29.13, y = 22.07, n = L["Tashara"]}
		}
	},
	--
	["Void-Touched Souvenir Totem"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		isToy = true,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Void-Touched Souvenir Totem"],
		itemId = 174924,
		chance = 100, -- Blind guess (no data)
		coords = {
			{m = CONSTANTS.UIMAPIDS.HORRIFIC_VISION_OF_ORGRIMMAR}
		}
	},
	-- 8.0
	["Pterrordax Egg"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Pterrordax Egg"],
		itemId = 157782,
		npcs = {
			128658,
			122114,
			126618,
			126702,
			128653,
			122113,
			135853,
			120593,
			128647,
			128343,
			125207,
			135852,
			128434,
			131718
		},
		chance = 2500,
		unique = true,
		requiresHorde = true,
		sourceText = L["Starts a series of quests that ultimately award Kua'fon's Harness (Pterrordax mount)"],
		coords = {
			{m = CONSTANTS.UIMAPIDS.NAZMIR},
			{m = CONSTANTS.UIMAPIDS.ZULDAZAR},
			{m = CONSTANTS.UIMAPIDS.DAZARALOR},
			{m = CONSTANTS.UIMAPIDS.VOLDUN},
			{m = CONSTANTS.UIMAPIDS.ATALDAZAR}
		}
	},
	-- 8.3
	["Pristine Cloud Serpent Scale"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Pristine Cloud Serpent Scale"],
		itemId = 174230,
		npcs = {157162},
		chance = 100,
		questId = {57346},
		unique = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 22.09, y = 24.03, n = L["Cave Entrance"]},
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 21.16, y = 14.53, n = L["Rei Lun"]}
		}
	},
	["Zan-Tien Lasso"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Zan-Tien Lasso"],
		itemId = 174927,
		npcs = {
			157345, -- Zan-Tien Subjugator
			153095, -- Zan-Tien Caller
			153099, -- Baruk Protector
			153094, -- Zan-Tien Raider
			157101, -- Xigan <Zan-Tien General>
			157103, -- Tsah'tal <Dokani General>
			155957, -- Baruk Stoneshaper
			156675, -- Zan-Tien Scout
			157097, -- Solux <Baruk General>
			153106, -- Dokani Bloodshaper
			153107, -- Dokani Shadewalker
			157156, -- Torsheg <Zan-Tien Warlord>
			157443, -- Xiln the Mountain
			157171, -- Heixi the Stonelord
			157291, -- Spymaster Hul'ach
			157160 -- Houndlord Ren
		},
		chance = 100,
		unique = true,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS}
		},
		sourceText = L["Can be used to capture the Ivory Cloud Serpent"]
	},


	["All-Seeing Right Eye"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["All-Seeing Right Eye"],
		npcs = {158633},
		itemId = 175142,
		questId = {57680},
		chance = 75,
		coords = {
			{m = CONSTANTS.UIMAPIDS.ULDUM, x = 55, y = 51, n = L["Gaze of N'Zoth"]}
		},
		sourceText = format(L["Shares a spawn with %s"], L["Foul Observer"])
		-- Combine with X to create Y
		-- Only available during the X assault
	},
	["All-Seeing Left Eye"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["All-Seeing Left Eye"],
		npcs = {154495},
		itemId = 175141,
		questId = {56303},
		chance = 75,
		coords = {
			{m = CONSTANTS.UIMAPIDS.VALE_OF_ETERNAL_BLOSSOMS, x = 52.51, y = 62.14, n = L["Will of N'zoth"]}
		}
	},


	["Viable Cobra Egg"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Viable Cobra Egg"],
		itemId = 160832,
		npcs = {133384},
		chance = 50,
		equalOdds = true,
		instanceDifficulties = {[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_DUNGEON] = true},
		groupSize = 5,
		sourceText = L["Dropped by Merektha in Temple of Sethraliss. Will hatch into Spawn of Merektha pet after three days."],
		coords = {
			{m = CONSTANTS.UIMAPIDS.TEMPLE_OF_SETHRALISS, i = true}
		}
	},
	["Nightwreathed Egg"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.BFA,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Nightwreathed Egg"],
		itemId = 166525,
		npcs = {149659, 149662},
		chance = 7,
		questId = {54891, 54889},
		coords = {
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 39.5, y = 34.4, n = L["Orwell Stevenson"] .. " - " .. L["Alliance only"]},
			{m = CONSTANTS.UIMAPIDS.DARKSHORE, x = 50.6, y = 32.6, n = L["Grimhorn"] .. " - " .. L["Horde only"]}
		},
		sourceText = L["Will hatch into Nightwreathed Watcher pet after five days."]
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, bfaToys)
