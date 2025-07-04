local _, addonTable = ...

local CONSTANTS = Rarity.Enum
local pairs = pairs

local HolidayEvents = {}

function HolidayEvents.IsItemAvailableToday(item)
	if not item.holidayEvents then
		return true
	end

	for _, calendarEventID in pairs(item.holidayEvents) do
		if Rarity.activeHolidayEvents[calendarEventID] then
			return true
		end
	end

	return false
end

Rarity.HolidayEvents = HolidayEvents
return HolidayEvents
