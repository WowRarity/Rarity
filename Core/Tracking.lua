local _, addonTable = ...

--- Tracking.lua
-- TODO: LuaDoc
local Tracking = {}

-- Globals
local R = Rarity
-- Locals
local trackedItems = {}
-- WOW API
local format = format

-- Returns the first tracked item by default
function Tracking:GetTrackedItem(index)
	index = index or 1
	return trackedItems[index]
end

function Tracking:GetTrackedItems()
	return trackedItems
end

-- Default: First item (only two were originally supported)
-- Note: If there are multiple, empty entries in between might cause weirdness.
-- But that's a problem for later... Right now there's always one, and sometimes a second one
function Tracking:SetTrackedItem(item, index)
	index = index or 1
	Rarity:Debug(format("Setting tracked item %d to %s", index, item and item.name or "<unknown>"))
	trackedItems[index] = item
end

Rarity.Tracking = Tracking
return Tracking
