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
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, MidnightToysAndItems)
return MidnightToysAndItems
