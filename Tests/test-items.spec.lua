local BlizzardTOC = require("Tests.TOC.BlizzardTOC")

local RARITY_CORE_TOC = C_FileSystem.ReadFile("Rarity.toc")
local RarityCoreTOC = BlizzardTOC:DecodeFileContents(RARITY_CORE_TOC)

-- It's not currently possible to load all TOC files in order (due to the various Libs/WOW APIs involved)
-- For now, simulate loading the item DB manually and ignore the distinct lack of robustness here
local loadedDatabaseModules = {}
for index, fileSystemPath in ipairs(RarityCoreTOC.Files) do
	if fileSystemPath:find("^DB") then
		local chunk = assert(loadfile(fileSystemPath))
		-- All modules should return a table (fix later)
		local module = chunk and chunk(_G.RARITY_ADDON_NAME, _G.RARITY_ADDON_TABLE) or {}
		loadedDatabaseModules[fileSystemPath] = module
	end
end

-- These could probably be obtained from the DBC files, but it's not worth the effort
-- They aren't currently exported as shared constants (would increase memory usage)
local bonusRollCurrencies = {
	ELDER_CHARM_OF_GOOD_FORTUNE = 697,
	MOGU_RUNE_OF_FATE = 752,
	WARFORGED_SEAL = 776,
	SEAL_OF_TEMPERED_FATE = 994,
	SEAL_OF_INEVITABLE_FATE = 1129,
	SEAL_OF_BROKEN_FATE = 1273,
	SEAL_OF_WARTORN_FATE = 1580,
}

local function table_sum(values)
	local sum = 0

	for key, count in pairs(values) do
		sum = sum + count
	end

	return sum
end

describe("ItemDB", function()
	local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

	describe("Nodes", function()
		it("should register all recognized bonus roll currencies by default", function()
			assertEquals(table.count(Rarity.coins), table.count(bonusRollCurrencies))
			for name, currencyID in pairs(bonusRollCurrencies) do
				assert(Rarity.coins[currencyID], format("Missing bonus roll currency: %s", name))
			end
		end)

		it("should register all recognized fishing nodes by default", function()
			local numExpectedEntries = 128
			assertEquals(table.count(Rarity.fishnodes), numExpectedEntries)

			for name, isEnabled in pairs(Rarity.fishnodes) do
				assert(isEnabled, format("Entry'%s' should be enabled", name))
				assert(L[name], format("Missing localization phrase for entry '%s'", name))
				assert(L[name] == name, format("Unexpected localization phrase '%s' for entry '%s'", L[name], name))
			end
		end)

		it("should register all recognized mining nodes by default", function()
			local numExpectedEntries = 57
			assertEquals(table.count(Rarity.miningnodes), numExpectedEntries)

			for name, isEnabled in pairs(Rarity.miningnodes) do
				assert(isEnabled, format("Entry'%s' should be enabled", name))
				assert(L[name], format("Missing localization phrase for entry '%s'", name))
				assert(L[name] == name, format("Unexpected localization phrase '%s' for entry '%s'", L[name], name))
			end
		end)

		it("should register all recognized world objects by default", function()
			local numExpectedEntries = 55
			assertEquals(table.count(Rarity.opennodes), numExpectedEntries)

			for name, isEnabled in pairs(Rarity.opennodes) do
				assert(isEnabled, format("Entry'%s' should be enabled", name))
				assert(L[name], format("Missing localization phrase for entry '%s'", name))
				assert(L[name] == name, format("Unexpected localization phrase '%s' for entry '%s'", L[name], name))
			end
		end)
	end)

	describe("Mounts", function()
		-- These should be derived automatically, but not yet (DNT the DB to avoid merge conflicts)
		local expectedItemCountsByExpansion = {
			mounts = {
				["DB\\Mounts\\HolidayEvents.lua"] = 6,
				["DB\\Mounts\\Classic.lua"] = 2,
				["DB\\Mounts\\TheBurningCrusade.lua"] = 4,
				["DB\\Mounts\\WrathOfTheLichKing.lua"] = 11,
				["DB\\Mounts\\Cataclysm.lua"] = 13,
				["DB\\Mounts\\MistsOfPandaria.lua"] = 13,
				["DB\\Mounts\\WarlordsOfDraenor.lua"] = 16,
				["DB\\Mounts\\Legion.lua"] = 27,
				["DB\\Mounts\\BattleForAzeroth.lua"] = 46,
				["DB\\Mounts\\Shadowlands.lua"] = 44,
				["DB\\Mounts\\Dragonflight.lua"] = 23,
				["DB\\Mounts\\TheWarWithin.lua"] = 7,
			},
			pets = {
				["DB\\Pets\\HolidayEvents.lua"] = 18,
				["DB\\Pets\\Classic.lua"] = 8,
				["DB\\Pets\\TheBurningCrusade.lua"] = 8,
				["DB\\Pets\\WrathOfTheLichKing.lua"] = 4,
				["DB\\Pets\\Cataclysm.lua"] = 4,
				["DB\\Pets\\MistsOfPandaria.lua"] = 62,
				["DB\\Pets\\WarlordsOfDraenor.lua"] = 41,
				["DB\\Pets\\Legion.lua"] = 57,
				["DB\\Pets\\BattleForAzeroth.lua"] = 132,
				["DB\\Pets\\Shadowlands.lua"] = 63,
				["DB\\Pets\\Dragonflight.lua"] = 35,
				["DB\\Pets\\TheWarWithin.lua"] = 4,
			},
			toys = {
				["DB\\Toys\\HolidayEvents.lua"] = 35,
				["DB\\Toys\\Classic.lua"] = 1,
				["DB\\Toys\\TheBurningCrusade.lua"] = 5,
				["DB\\Toys\\WrathOfTheLichKing.lua"] = 4,
				["DB\\Toys\\Cataclysm.lua"] = 1,
				["DB\\Toys\\MistsOfPandaria.lua"] = 20,
				["DB\\Toys\\WarlordsOfDraenor.lua"] = 6,
				["DB\\Toys\\Legion.lua"] = 37,
				["DB\\Toys\\BattleForAzeroth.lua"] = 50,
				["DB\\Toys\\Shadowlands.lua"] = 40,
				["DB\\Toys\\Dragonflight.lua"] = 20,
				["DB\\Toys\\TheWarWithin.lua"] = 4,
			},
		}
		local expectedItemCounts = {
			-- The group name is an entry of its own (not sure if that can safely be changed now)
			mounts = table_sum(expectedItemCountsByExpansion.mounts) + 1,
			pets = table_sum(expectedItemCountsByExpansion.pets) + 1,
			toys = table_sum(expectedItemCountsByExpansion.toys) + 1,
		}

		it("should register all recognized items by default", function()
			assertEquals(table.count(Rarity.ItemDB.mounts), expectedItemCounts.mounts)
			assertEquals(table.count(Rarity.ItemDB.pets), expectedItemCounts.pets)
			assertEquals(table.count(Rarity.ItemDB.toys), expectedItemCounts.toys)
		end)
	end)
end)
