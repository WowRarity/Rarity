local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_DRAGONFLIGHT then
	return {}
end

local dragonflightMounts = {
	-- 10.0 mounts
	["Reins of the Liberated Slyvern"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Reins of the Liberated Slyvern"],
		itemId = 201440,
		spellId = 359622,
		npcs = { 195353 },
		chance = 50,
		coords = { { x = 27.0, y = 48.4, n = L["Breezebiter"], m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN } },
	},
	["Plainswalker Bearer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Plainswalker Bearer"],
		spellId = 374196,
		itemId = 192791,
		items = { 200468 },
		chance = 33,
		questId = { 70906, 70006 },
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Verdant Skitterfly"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Verdant Skitterfly"],
		spellId = 374048,
		itemId = 192764,
		chance = 100, -- Blind guess
		sourceText = L["This mount can only drop after hitting renown 25 with Dragonscale Expedition."],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_WAKING_SHORES },
			{ m = CONSTANTS.UIMAPIDS.OHN_AHRAN_PLAINS },
			{ m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN },
			{ m = CONSTANTS.UIMAPIDS.THALDRASZUS },
		},
	},
	["Ancient Salamanther"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Ancient Salamanther"],
		spellId = 374090,
		itemId = 192772,
		npcs = {
			201181,
			200960,
			200584,
			200904,
			200956,
			201013,
			200610,
			200721,
			200911,
			200600,
			200717,
			200978,
			200885,
			200681,
			200579,
			200537,
		},
		chance = 80, --rough guess by looking at wowhead data
		groupSize = 5,
		equalOdds = true,
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 68.6, y = 45.6, n = L["Mad-Eye Carrey"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 45.9, y = 79.7, n = L["Warden Entrix"] }, --The War Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 58.6, y = 48.8, n = L["Vraken the Hunter"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 72.8, y = 67.5, n = L["Veltrax"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 36.8, y = 12.2, n = L["Ookbeard"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 61.7, y = 33.8, n = L["Wyrmslayer Angvardi"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 36.6, y = 32.4, n = L["Duzalgor"] }, --The Support Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 44.0, y = 90.3, n = L["Grugoth the Hullcrusher"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 74.5, y = 54.6, n = L["Volcanakk"] }, --The Siege Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 47.6, y = 20.6, n = L["Reisa the Drowned"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 44.8, y = 79.2, n = L["Galakhad"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 51.9, y = 72.8, n = L["Pyrachniss"] }, --The War Creche
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 59.8, y = 58.8, n = L["Lady Shaz'ra"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 43.6, y = 61.0, n = L["Bonesifter Marwak"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 41.2, y = 13.4, n = L["Ishyra"] },
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 28.2, y = 38.2, n = L["Gahz'raxes"] },
		},
	},
	["Gooey Snailemental"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Gooey Snailemental"],
		spellId = 374157,
		itemId = 192785,
		collectedItemId = { 204352 },
		chance = 50,
		obtain = L["Dropped from the final bosses of Froststone Vault Primal Storm."],
		tooltipNpcs = { 198917, 198916, 198915, 198914 },
		sourceText = L["Combine 50 Leftover Elemental Slime to create the Gooey Snailemental."],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_FORBIDDEN_REACH, x = 59.7, y = 38.5, n = L["Froststone Vault Primal Storm"] },
		},
	},
	-- 10.1 mounts
	["Cobalt Shalewing"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Cobalt Shalewing"],
		itemId = 205203,
		spellId = 408647,
		npcs = { 203625 },
		questId = 75333,
		chance = 100,
		coords = { { x = 42.20, y = 65.17, n = L["Karokta"], m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	["Flaming Shalewing Subject 01"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Flaming Shalewing Subject 01"],
		itemId = 205204,
		spellId = 408651,
		items = { 205368, 205367, 205369, 205372, 205370, 205374 },
		chance = 33, -- An average. Different sources have different chances.
		coords = { { m = CONSTANTS.UIMAPIDS.ZARALEK_CAVERN } },
	},
	-- 10.1.5 mounts
	["Reins of the Scourgebound Vanquisher"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Reins of the Scourgebound Vanquisher"],
		spellId = 414334,
		itemId = 206680,
		items = { 207583 },
		chance = 500,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Perfected Juggernaut"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Perfected Juggernaut"],
		spellId = 414328,
		itemId = 206679,
		items = { 207583 },
		chance = 500,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Felstorm Dragon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Felstorm Dragon"],
		spellId = 414326,
		itemId = 206676,
		items = { 207583 },
		chance = 500,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Sulfur Hound's Leash"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Sulfur Hound's Leash"],
		spellId = 414327,
		itemId = 206678,
		items = { 207583 },
		chance = 500,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Gold-Toed Albatross"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Gold-Toed Albatross"],
		spellId = 414324,
		itemId = 206675,
		items = { 207583 },
		chance = 500,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Reins of the Ravenous Black Gryphon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Reins of the Ravenous Black Gryphon"],
		spellId = 414323,
		itemId = 206674,
		items = { 207583 },
		chance = 500,
		requiresAlliance = true,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	["Horn of the White War Wolf"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Horn of the White War Wolf"],
		spellId = 414316,
		itemId = 206673,
		items = { 207583 },
		chance = 500,
		requiresHorde = true,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THALDRASZUS } },
	},
	--10.2
	["Reins of the Winter Night Dreamsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Winter Night Dreamsaber"],
		spellId = 424476,
		itemId = 210059,
		chance = 10,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Snowfluff Dreamtalon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Snowfluff Dreamtalon"],
		spellId = 427043,
		itemId = 210775,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Evening Sun Dreamsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Evening Sun Dreamsaber"],
		spellId = 424479,
		itemId = 210058,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Blossoming Dreamstag"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Blossoming Dreamstag"],
		spellId = 423871,
		itemId = 209947,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Springtide Dreamtalon"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Springtide Dreamtalon"],
		spellId = 426955,
		itemId = 210769,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Morning Flourish Dreamsaber"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Morning Flourish Dreamsaber"],
		spellId = 424482,
		itemId = 210057,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of the Rekindled Dreamstag"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.SPECIAL,
		name = L["Reins of the Rekindled Dreamstag"],
		spellId = 423877,
		itemId = 209950,
		chance = 10,
		sourceText = L["This item can also be purchased from a vendor."],
		coords = { { m = CONSTANTS.UIMAPIDS.THE_EMERALD_DREAM } },
	},
	["Reins of Anu'relos, Flame's Guidance."] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of Anu'relos, Flame's Guidance"],
		spellId = 428195,
		itemId = 210061,
		npcs = { 99999 },
		tooltipNpcs = { 204931 },
		chance = 100,
		statisticId = { 19386 },
		lockBossName = "Fyrakk",
		instanceDifficulties = {
			[CONSTANTS.INSTANCE_DIFFICULTIES.MYTHIC_RAID] = true,
		},
		groupSize = 5,
		equalOdds = true,
		coords = { { m = CONSTANTS.UIMAPIDS.AMIRDRASSIL_RAID, i = true } },
		wasGuaranteed = true,
	},
	-- 10.2.5
	["Clayscale Hornstrider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Clayscale Hornstrider"],
		spellId = 432610,
		itemId = 212645,
		npcs = { 208029 },
		chance = 200,
		coords = { { m = CONSTANTS.UIMAPIDS.THE_AZURE_SPAN } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, dragonflightMounts)
return dragonflightMounts
