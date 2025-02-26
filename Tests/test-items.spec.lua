local BlizzardTOC = require("Tests.TOC.BlizzardTOC")

local RARITY_CORE_TOC = C_FileSystem.ReadFile("Rarity.toc")
local RarityCoreTOC = BlizzardTOC:DecodeFileContents(RARITY_CORE_TOC)

-- It's not currently possible to load all TOC files in order (due to the various Libs/WOW APIs involved)
-- For now, simulate loading the item DB manually and ignore the distinct lack of robustness here
local loadedDatabaseModules = {}
for index, fileSystemPath in ipairs(RarityCoreTOC.Files) do
	if fileSystemPath:find("^DB") then
		local chunk = assert(loadfile(fileSystemPath))
		local module = chunk and chunk(_G.RARITY_ADDON_NAME, _G.RARITY_ADDON_TABLE)
		assert(type(module) == "table", format("Module %s didn't return a table value", fileSystemPath))
		loadedDatabaseModules[fileSystemPath] = module
	end
end

local function countItems(fileSystemPath)
	local module = loadedDatabaseModules[fileSystemPath]
	assert(module, format("Invalid database module: %s", fileSystemPath))
	return table.count(module)
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

	local expectedItemCountsByExpansion = {
		mounts = {
			HolidayEvents_TheBurningCrusade = countItems("DB/Mounts/HolidayEvents_TheBurningCrusade.lua"),
			HolidayEvents_WrathOfTheLichKing = countItems("DB/Mounts/HolidayEvents_WrathOfTheLichKing.lua"),
			HolidayEvents_WarlordsOfDraenor = countItems("DB/Mounts/HolidayEvents_WarlordsOfDraenor.lua"),
			HolidayEvents_Dragonflight = countItems("DB/Mounts/HolidayEvents_Dragonflight.lua"),

			Classic = countItems("DB/Mounts/Classic.lua"),
			TheBurningCrusade = countItems("DB/Mounts/TheBurningCrusade.lua"),
			WrathOfTheLichKing = countItems("DB/Mounts/WrathOfTheLichKing.lua"),
			Cataclysm = countItems("DB/Mounts/Cataclysm.lua"),
			MistsOfPandaria = countItems("DB/Mounts/MistsOfPandaria.lua"),
			WarlordsOfDraenor = countItems("DB/Mounts/WarlordsOfDraenor.lua"),
			Legion = countItems("DB/Mounts/Legion.lua"),
			BattleForAzeroth = countItems("DB/Mounts/BattleForAzeroth.lua"),
			Shadowlands = countItems("DB/Mounts/Shadowlands.lua"),
			Dragonflight = countItems("DB/Mounts/Dragonflight.lua"),
			TheWarWithin = countItems("DB/Mounts/TheWarWithin.lua"),
		},
		pets = {
			HolidayEvents_Classic = countItems("DB/Pets/HolidayEvents_Classic.lua"),
			HolidayEvents_TheBurningCrusade = countItems("DB/Pets/HolidayEvents_TheBurningCrusade.lua"),
			HolidayEvents_WrathOfTheLichKing = countItems("DB/Pets/HolidayEvents_WrathOfTheLichKing.lua"),
			HolidayEvents_Cataclysm = countItems("DB/Pets/HolidayEvents_Cataclysm.lua"),
			HolidayEvents_MistsOfPandaria = countItems("DB/Pets/HolidayEvents_MistsOfPandaria.lua"),
			HolidayEvents_WarlordsOfDraenor = countItems("DB/Pets/HolidayEvents_WarlordsOfDraenor.lua"),
			HolidayEvents_Dragonflight = countItems("DB/Pets/HolidayEvents_Dragonflight.lua"),
			HolidayEvents_TheWarWithin = countItems("DB/Pets/HolidayEvents_TheWarWithin.lua"),

			Classic = countItems("DB/Pets/Classic.lua"),
			TheBurningCrusade = countItems("DB/Pets/TheBurningCrusade.lua"),
			WrathOfTheLichKing = countItems("DB/Pets/WrathOfTheLichKing.lua"),
			Cataclysm = countItems("DB/Pets/Cataclysm.lua"),
			MistsOfPandaria = countItems("DB/Pets/MistsOfPandaria.lua"),
			WarlordsOfDraenor = countItems("DB/Pets/WarlordsOfDraenor.lua"),
			Legion = countItems("DB/Pets/Legion.lua"),
			BattleForAzeroth = countItems("DB/Pets/BattleForAzeroth.lua"),
			Shadowlands = countItems("DB/Pets/Shadowlands.lua"),
			Dragonflight = countItems("DB/Pets/Dragonflight.lua"),
			TheWarWithin = countItems("DB/Pets/TheWarWithin.lua"),
		},
		toys = {
			HolidayEvents_TheBurningCrusade = countItems("DB/Toys/HolidayEvents_TheBurningCrusade.lua"),
			HolidayEvents_WrathOfTheLichKing = countItems("DB/Toys/HolidayEvents_WrathOfTheLichKing.lua"),
			HolidayEvents_Cataclysm = countItems("DB/Toys/HolidayEvents_Cataclysm.lua"),
			HolidayEvents_MistsOfPandaria = countItems("DB/Toys/HolidayEvents_MistsOfPandaria.lua"),
			HolidayEvents_WarlordsOfDraenor = countItems("DB/Toys/HolidayEvents_WarlordsOfDraenor.lua"),
			HolidayEvents_Legion = countItems("DB/Toys/HolidayEvents_Legion.lua"),
			HolidayEvents_BattleForAzeroth = countItems("DB/Toys/HolidayEvents_BattleForAzeroth.lua"),
			HolidayEvents_Shadowlands = countItems("DB/Toys/HolidayEvents_Shadowlands.lua"),
			HolidayEvents_Dragonflight = countItems("DB/Toys/HolidayEvents_Dragonflight.lua"),

			Classic = countItems("DB/Toys/Classic.lua"),
			TheBurningCrusade = countItems("DB/Toys/TheBurningCrusade.lua"),
			WrathOfTheLichKing = countItems("DB/Toys/WrathOfTheLichKing.lua"),
			Cataclysm = countItems("DB/Toys/Cataclysm.lua"),
			MistsOfPandaria = countItems("DB/Toys/MistsOfPandaria.lua"),
			WarlordsOfDraenor = countItems("DB/Toys/WarlordsOfDraenor.lua"),
			Legion = countItems("DB/Toys/Legion.lua"),
			BattleForAzeroth = countItems("DB/Toys/BattleForAzeroth.lua"),
			Shadowlands = countItems("DB/Toys/Shadowlands.lua"),
			Dragonflight = countItems("DB/Toys/Dragonflight.lua"),
			TheWarWithin = countItems("DB/Toys/TheWarWithin.lua"),
		},
	}
	local expectedItemCounts = {
		-- The group name is an entry of its own (not sure if that can safely be changed now)
		mounts = table_sum(expectedItemCountsByExpansion.mounts) + 1,
		pets = table_sum(expectedItemCountsByExpansion.pets) + 1,
		toys = table_sum(expectedItemCountsByExpansion.toys) + 1,
	}

	describe("Mounts", function()
		it("should register all recognized items by default", function()
			assertEquals(table.count(Rarity.ItemDB.mounts), expectedItemCounts.mounts)
		end)
	end)

	describe("Pets", function()
		it("should register all recognized items by default", function()
			assertEquals(table.count(Rarity.ItemDB.pets), expectedItemCounts.pets)
		end)
	end)

	describe("Toys", function()
		it("should register all recognized items by default", function()
			assertEquals(table.count(Rarity.ItemDB.toys), expectedItemCounts.toys)
		end)
	end)
end)
