local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local classicToys = {
	-- Piccolo of the Flaming Fire?
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, classicToys)
