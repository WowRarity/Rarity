local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_MIDNIGHT then
	return {}
end

local MidnightToysAndItems = {
	-- 12.0 items and toys


	
	}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.toys, MidnightToysAndItems)
return MidnightToysAndItems
