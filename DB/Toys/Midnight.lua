local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local MidnightToysAndItems = {
	-- 12.0 items and toys
	["Mysterious Skyshards"] = { --this may not track with the addon changes in 12.0--
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.ZONE,
		name = L["Mysterious Skyshards"],
		itemId = 255826,
		spellId = 1259475, -- Irrelevant
		zones = { tostring(CONSTANTS.UIMAPIDS.HARANDAR) },
		chance = 1000,
		sourceText = L["Dropped by any mob in Harandar (except minor mobs). 500 of these can be combined to pierce Alunira's shield, allowing combat and a guaranteed drop of Echo of Aln'sharan."],
		coords = { { m = CONSTANTS.UIMAPIDS.HARANDAR } },
		repeatable = true,
	},
	["Nether-Warped Egg"] = { --need to doublke check that this is the mount drop--
		cat = CONSTANTS.ITEM_CATEGORIES.MIDNIGHT,
		type = CONSTANTS.ITEM_TYPES.ITEM,
		method = CONSTANTS.DETECTION_METHODS.FISHING,
		name = L["Nether-Warped Egg"],
		itemId = 268730,
		chance = 2500,
		sourceText = L["Chance to drop from a chest which can be fished up in any Midnight Zone."],
		zones = {
			"2395", -- Eversong woods
			"2437", -- Zulaman
			"2405", -- Voidstorm
			"2576", -- HARANDAR
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, MidnightToysAndItems)
return MidnightToysAndItems
