local SharedConstants = loadfile("DB/SharedConstants.lua")(_G.RARITY_ADDON_NAME, _G.RARITY_ADDON_TABLE)
local HolidayEvents = loadfile("Core/HolidayEvents.lua")(_G.RARITY_ADDON_NAME, _G.RARITY_ADDON_TABLE)

describe("HolidayEvents", function()
	describe("IsItemAvailableToday", function()
		before(function()
			Rarity.activeHolidayEvents = {}
		end)

		local DARKMOON_FAIRE_ITEM = {
			holidayEvents = SharedConstants.HolidayEvents["Darkmoon Faire"],
		}
		local ITEM_WITHOUT_HOLIDAY_TEXTURE = {}

		it("should return true if the item requires an active holiday event that is currently enabled", function()
			Rarity.activeHolidayEvents[SharedConstants.HolidayEvents["Darkmoon Faire"][1]] = true
			assertTrue(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it("should return false if the item requires a specific holiday event to be active, but it is not", function()
			assertFalse(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it(
			"should return false if only holiday events other than the one required by the item are currently active",
			function()
				Rarity.activeHolidayEvents[SharedConstants.HolidayEvents["Love is in the Air"][1]] = true
				assertFalse(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
			end
		)

		it("should return true if there are active holiday events other than the one required by the item", function()
			Rarity.activeHolidayEvents[SharedConstants.HolidayEvents["Love is in the Air"][1]] = true
			Rarity.activeHolidayEvents[SharedConstants.HolidayEvents["Darkmoon Faire"][1]] = true
			assertTrue(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it("should return true if the item doesn't require any holiday event to be active", function()
			assertTrue(HolidayEvents.IsItemAvailableToday(ITEM_WITHOUT_HOLIDAY_TEXTURE))
		end)
	end)
end)
