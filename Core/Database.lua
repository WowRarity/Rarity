local _, addonTable = ...

local pairs = pairs
local tostring = tostring

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

-- The "purge" command/logic should also be turned into a migration instead of running on demand
-- Ideally, they'd be version-dependent as well. Note: Rarity.MINOR_VERSION is zero in development
-- Since migrating from SVN to Git no one reviewed the versioning scheme, so this needs some thought
local migrations = {
	-- Beware: Although safe to apply unconditionally, if there are too many it might impact loading times
	["Crashin' Thrashin' Battleship) -> Crashin' Thrashin' Battleship"] = function()
		local old = Rarity.db.profile.groups.items["Crashin' Thrashin' Battleship)"]
		if not old then
			return nil, "No source entry (already patched?)"
		end

		-- It should probably also move the recorded attempts (dates/characters)? That's far riskier, though
		local new = Rarity.db.profile.groups.items["Crashin' Thrashin' Battleship"]
		if not new then
			return nil, "No destination entry (Retail DB copied to Classic?)"
		end

		Rarity.db.profile.groups.items["Crashin' Thrashin' Battleship"] = old
		Rarity.db.profile.groups.items["Crashin' Thrashin' Battleship)"] = nil
		return true, "OK"
	end,
}

function Database:ApplyMigrations()
	for name, migration in pairs(migrations) do
		Rarity:Debug("[DB] " .. name)
		local result, message = migration()
		Rarity:Debug("Result: " .. tostring(result) .. " - Message: " .. tostring(message))
	end
end

function Database.IsItemAvailableToFactionGroup(item, englishFactionGroupName)
	local isHorde = (englishFactionGroupName == "Horde")
	local isAlliance = (englishFactionGroupName == "Alliance")

	if not item.requiresAlliance and not item.requiresHorde then
		return true
	end

	if item.requiresAlliance and isAlliance then
		return true
	end

	if item.requiresHorde and isHorde then
		return true
	end

	return false
end

Rarity.Database = Database
return Database
