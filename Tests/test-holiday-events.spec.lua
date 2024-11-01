local SharedConstants = loadfile("DB/SharedConstants.lua")("Rarity", {})
local HolidayEvents = loadfile("Core/HolidayEvents.lua")("Rarity", {})

describe("HolidayEvents", function()
	describe("IsItemAvailableToday", function()
		before(function()
			Rarity.holiday_textures = {}
		end)

		local DARKMOON_FAIRE_ITEM = {
			holidayTexture = SharedConstants.HOLIDAY_TEXTURES.DARKMOON_FAIRE,
		}
		local ITEM_WITHOUT_HOLIDAY_TEXTURE = {}
		local ITEM_WITH_MULTIPLE_HOLIDAY_TEXTURES = {
			holidayTexture = {
				[SharedConstants.ART_TEXTURES.TWENTIETH_ANNIVERSARY_START] = true,
				[SharedConstants.ART_TEXTURES.TWENTIETH_ANNIVERSARY_ONGOING] = true,
				[SharedConstants.ART_TEXTURES.TWENTIETH_ANNIVERSARY_END] = true,
			},
		}

		it("should return true if the item requires an active holiday event that is currently enabled", function()
			Rarity.holiday_textures[SharedConstants.ART_TEXTURES.DMF_ONGOING] = true
			assertTrue(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it("should return false if the item requires a specific holiday event to be active, but it is not", function()
			assertFalse(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it(
			"should return false if only holiday events other than the one required by the item are currently active",
			function()
				Rarity.holiday_textures[SharedConstants.ART_TEXTURES.LOVE_ONGOING] = true
				assertFalse(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
			end
		)

		it("should return true if there are active holiday events other than the one required by the item", function()
			Rarity.holiday_textures[SharedConstants.ART_TEXTURES.LOVE_ONGOING] = true
			Rarity.holiday_textures[SharedConstants.ART_TEXTURES.DMF_ONGOING] = true
			assertTrue(HolidayEvents.IsItemAvailableToday(DARKMOON_FAIRE_ITEM))
		end)

		it("should return true if the item doesn't require any holiday event to be active", function()
			assertTrue(HolidayEvents.IsItemAvailableToday(ITEM_WITHOUT_HOLIDAY_TEXTURE))
		end)

		it("should return true if the item uses file data IDs and the holiday event is active", function()
			Rarity.holiday_textures[SharedConstants.ART_TEXTURES.TWENTIETH_ANNIVERSARY_ONGOING] = true
			assertTrue(HolidayEvents.IsItemAvailableToday(ITEM_WITH_MULTIPLE_HOLIDAY_TEXTURES))
		end)

		it("should return false if the item uses file data IDs and the holiday event is inactive", function()
			assertFalse(HolidayEvents.IsItemAvailableToday(ITEM_WITH_MULTIPLE_HOLIDAY_TEXTURES))
		end)
	end)
end)
