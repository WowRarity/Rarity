local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_DRAGONFLIGHT then
	return {}
end

local holidayEventMountsDragonflight = {
	["Noble Flying Carpet"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Noble Flying Carpet"],
		spellId = 432455,
		itemId = 212599,
		items = { 216874 },
		chance = 100, -- Might be higher after the adjustment? (Needs more data)
		holidayEvents = CONSTANTS.HolidayEvents["Noblegarden"],
		coords = {
			{ m = CONSTANTS.UIMAPIDS.DUROTAR },
			{ m = CONSTANTS.UIMAPIDS.ELWYNN_FOREST },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, holidayEventMountsDragonflight)
return holidayEventMountsDragonflight
