local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WRATH_OF_THE_LICH_KING then
	return {}
end

local holidayEventPetsWrath = {
	["Ice Chip"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Ice Chip"],
		spellId = 74932,
		itemId = 53641,
		items = { 54536, 117394 },
		chance = 25,
		groupSize = 5,
		equalOdds = true,
		creatureId = 40198,
		lockDungeonId = 286,
		holidayEvents = CONSTANTS.HolidayEvents["Midsummer Fire Festival"],
		coords = { { m = 265, x = 31.2, y = 50.8, i = true, n = L["Ahune"] } },
	},
	["Toxic Wasteling"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.HOLIDAY,
		type = CONSTANTS.ITEM_TYPES.PET,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Toxic Wasteling"],
		spellId = 71840,
		itemId = 50446,
		items = { 54537 },
		chance = 14,
		groupSize = 5,
		equalOdds = true,
		creatureId = 38374,
		lockDungeonId = 288,
		holidayEvents = CONSTANTS.HolidayEvents["Love is in the Air"],
		coords = { { m = 310, x = 40.8, y = 52.6, i = true } },
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.pets, holidayEventPetsWrath)
return holidayEventPetsWrath
