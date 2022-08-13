local _, addonTable = ...

--- Basic DB abstraction layer.
-- Intended to manage the currently active profile without having to worry about AceDB  and its shenanigans.
local Database = {}

-- Upvalues
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

--- These items were at one point officially part of the addon's item database, but subsequently removed (usually because they weren't actually rare drops or Blizzard never added them to the live servers).
local obsoleteItems = {
	items = {
		-- Removed because they aren't actually a rare drop, but guaranteed (no point in tracking them)
		["Ocean Simulator"] = true,
		["Eternal Palace Dining Set"] = true,
		-- Removed because they were never available to begin with (Blizzard didn't add them to live servers)
		["Regenerating Banana Bunch"] = true,
		["Kojo's Master Matching Set"] = true,
		["Jinyu Light Globe"] = true,
		["Words of Akunda"] = true,
	},
	pets = {
		["Tiny Emerald Whelpling"] = true, -- Blizzard renamed this to "Emerald Whelpling" (data is not transfered)
		["Mr. Pinchy"] = true, -- Not actually removed, but moved to the items category apparently? (data is not transfered)
	},
}

--- Removes unused (dangling) entries from the DB.
-- These could cause issues if kept around and keeping them in mind when working on new features isn't necessary nor helpful.
-- TODO: Direct access of the AceDB tables is kind of awkward, think of a better way to streamline the APIs
function Database:PurgeObsoleteEntries()
	for groupName, items in pairs(obsoleteItems) do
		for itemKey, isObsolete in pairs(items) do
			Rarity:Print(format(L["Removing data for obsolete item %s"], itemKey))
			Rarity.db.profile.groups[groupName][itemKey] = nil
		end
	end
end

Rarity.Database = Database
return Database
