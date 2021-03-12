ItemDB = {}
ItemDB.mounts = {
	name = L["Mounts"]
}
ItemDB.pets = {
	name = L["Battle Pets"]
}
ItemDB.toys = {
	name = L["Toys & Items"]
}

-- Add any item that doesn't yet exist, which in our case means ALL items since there shouldn't be duplicate entries
-- The database is split to make it more easily maintainable, but the individual partitions have no overlap
function ItemDB.MergeItems(sourceTable, items)
	for key, item in pairs(items) do
		sourceTable[key] = item
	end
end

Rarity.ItemDB = ItemDB

dofile("DB/Mounts/HolidayEvents.lua")
dofile("DB/Mounts/Classic.lua")
dofile("DB/Mounts/TheBurningCrusade.lua")
dofile("DB/Mounts/WrathOfTheLichKing.lua")
dofile("DB/Mounts/Cataclysm.lua")
dofile("DB/Mounts/MistsOfPandaria.lua")
dofile("DB/Mounts/WarlordsOfDraenor.lua")
dofile("DB/Mounts/Legion.lua")
dofile("DB/Mounts/BattleForAzeroth.lua")
dofile("DB/Mounts/Shadowlands.lua")

dofile("DB/Pets/HolidayEvents.lua")
dofile("DB/Pets/Classic.lua")
dofile("DB/Pets/TheBurningCrusade.lua")
dofile("DB/Pets/WrathOfTheLichKing.lua")
dofile("DB/Pets/Cataclysm.lua")
dofile("DB/Pets/MistsOfPandaria.lua")
dofile("DB/Pets/WarlordsOfDraenor.lua")
dofile("DB/Pets/Legion.lua")
dofile("DB/Pets/BattleForAzeroth.lua")
dofile("DB/Pets/Shadowlands.lua")

dofile("DB/Toys/HolidayEvents.lua")
dofile("DB/Toys/Classic.lua")
dofile("DB/Toys/TheBurningCrusade.lua")
dofile("DB/Toys/WrathOfTheLichKing.lua")
dofile("DB/Toys/Cataclysm.lua")
dofile("DB/Toys/MistsOfPandaria.lua")
dofile("DB/Toys/WarlordsOfDraenor.lua")
dofile("DB/Toys/Legion.lua")
dofile("DB/Toys/BattleForAzeroth.lua")
dofile("DB/Toys/Shadowlands.lua")


databaseAfterRefactoringAndMerging = Rarity.ItemDB