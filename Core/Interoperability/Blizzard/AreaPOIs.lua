local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

local GetAreaPOIInfo = C_AreaPoiInfo.GetAreaPOIInfo
local GetBestMapForUnit = C_Map.GetBestMapForUnit

local format = string.format
local ipairs = ipairs

local AreaPOIs = {}

function AreaPOIs.HasActiveAreaPOIs(areaPOIs)
	if not areaPOIs then
		return false
	end

	local currentMapID = GetBestMapForUnit("player")
	for index, areaPointOfInterestID in ipairs(areaPOIs) do
		local info = GetAreaPOIInfo(currentMapID, areaPointOfInterestID)
		if info ~= nil then
			Rarity:Debug(format("Detected active area POI %d", areaPointOfInterestID))
			return true
		end
	end

	return false
end

Rarity.AreaPOIs = AreaPOIs
