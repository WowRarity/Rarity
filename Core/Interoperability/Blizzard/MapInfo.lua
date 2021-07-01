-- WOW API
local GetMapInfo = C_Map.GetMapInfo

-- Streamlined interface for working with Blizzard's UI map system (world map, zone queries, etc.)
local MapInfo = {}

-- Helper function (to look up map names more easily)
-- Returns the localized map name, or nil if the uiMapID is invalid
function MapInfo.GetMapNameByID(uiMapID)
	local UiMapDetails = GetMapInfo(uiMapID)
	return UiMapDetails and UiMapDetails.name
end

Rarity.MapInfo = MapInfo
