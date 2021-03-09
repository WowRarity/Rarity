local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local cataclysmToys = {
	-- Are there really none?
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, cataclysmToys)
