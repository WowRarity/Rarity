-- WOW API
local GetMapInfo = C_Map.GetMapInfo

-- Streamlined interface for working with Blizzard's UI map system (world map, zone queries, etc.)
local MapInfo = {
	cachedMapDisplayNames = {}, -- TBD memory usage unlikely to increase because the strings should already be interned?
	invalidMapDisplayNames = {}, -- Once the DB supports classic fully, should probably assert that this is empty
}

-- Helper function (to look up map names more easily)
-- Returns the localized map name, or nil if the uiMapID is invalid
function MapInfo.GetMapNameByID(uiMapID)
	local mapDisplayName = MapInfo.cachedMapDisplayNames[uiMapID]
	if mapDisplayName then
		return mapDisplayName
	end

	local UiMapDetails = GetMapInfo(uiMapID)
	mapDisplayName = UiMapDetails and UiMapDetails.name
	if not mapDisplayName then
		local message = "Failed to GetMapInfo for UI map with ID " .. tostring(uiMapID)
		Rarity:Debug(message)
		-- This shouldn't happen on Retail, but for Classic store them for easier debugging
		-- TODO check RAM usage, disable for releases
		MapInfo.cachedMapDisplayNames[uiMapID] = "Unknown" -- TODO L
		MapInfo.invalidMapDisplayNames[#MapInfo.invalidMapDisplayNames + 1] = uiMapID -- TBD using map + bool here crashes the client? :S
		return nil, message
	end

	MapInfo.cachedMapDisplayNames[uiMapID] = mapDisplayName
	return mapDisplayName
end

Rarity.MapInfo = MapInfo
