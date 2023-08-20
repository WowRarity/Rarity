local Database = loadfile("Core/Database.lua")("Rarity", {})

local ITEM_THAT_REQUIRES_ALLIANCE = {
	requiresAlliance = true,
}
local ITEM_THAT_REQUIRES_HORDE = {
	requiresHorde = true,
}
local ITEM_THAT_REQUIRES_BOTH = {
	requiresAlliance = true,
	requiresHorde = true,
}

describe("Database", function()
	describe("IsItemAvailableToFactionGroup", function()
		it("should return true for Alliance players if the item doesn't require any given faction", function()
			assertTrue(Database.IsItemAvailableToFactionGroup({}, "Alliance"))
		end)

		it("should return true for Horde players if the item doesn't require any given faction", function()
			assertTrue(Database.IsItemAvailableToFactionGroup({}, "Alliance"))
		end)

		it("should return true for Alliance players if the item requires Alliance", function()
			assertTrue(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_ALLIANCE, "Alliance"))
		end)

		it("should return false for Horde players if the item requires Alliance", function()
			assertFalse(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_ALLIANCE, "Horde"))
		end)

		it("should return false for Alliance players if the item requires Horde", function()
			assertFalse(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_HORDE, "Alliance"))
		end)

		it("should return true for Horde players if the item requires Horde", function()
			assertTrue(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_HORDE, "Horde"))
		end)

		it("should return true for Alliance players if the item requires both factions", function()
			assertTrue(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_BOTH, "Alliance"))
		end)

		it("should return true for Horde players if the item requires both factions", function()
			assertTrue(Database.IsItemAvailableToFactionGroup(ITEM_THAT_REQUIRES_BOTH, "Horde"))
		end)
	end)
end)
