-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- WOW API
local GetBestMapForUnit = C_Map.GetBestMapForUnit

-- Rarity API
local Colorize = Rarity.Utils.String.Colorize
local Count = Rarity.Utils.Table.Count
local GetMapNameByID = Rarity.MapInfo.GetMapNameByID

-- Constants
local green = Rarity.Enum.Colors.Green
local gray = Rarity.Enum.Colors.Gray

local Waypoints = {}

function Waypoints:GetZoneInfoForItem(item)
	local zoneInfo = {
		zoneText = self:GetZoneTextForItem(item),
		inMyZone = self:IsItemInCurrentZone(item),
		zoneColor = (self:IsItemInCurrentZone(item) and green) or gray,
		numZones = self:GetNumZonesForItem(item)
	}
	return zoneInfo
end

function Waypoints:GetZoneTextForItem(item)
	if not self:HasItemWaypoints(item) then
		return ""
	end

	if item.coords.zoneOverride ~= nil then
		return item.coords.zoneOverride
	end

	local numZones = self:GetNumZonesForItem(item)
	if numZones == 1 then
		-- Convoluted much? Oh well, simplify later I guess (separate issue)
		local mapID = self:GetFirstMapForItem(item)
		return GetMapNameByID(mapID)
	end

	if not self:IsItemInCurrentZone(item) then
		return format(L["%d |4zone:zones;"], numZones)
	end

	local currentZone = GetBestMapForUnit("player")
	-- TBD: Why use gray if it'll be overridden with green due to being in the current zone?
	return GetMapNameByID(currentZone) .. " " .. Colorize(format("+%d", numZones - 1), gray)
end

function Waypoints:IsItemInCurrentZone(item)
	if not self:HasItemWaypoints(item) then
		return false
	end -- We don't know for sure, but the effect is the same

	local mapIDs = self:GetMapsForItem(item) or {}
	-- DevTools_Dump(mapIDs)
	local currentZone = GetBestMapForUnit("player")
	return mapIDs[currentZone]
end

function Waypoints:GetNumZonesForItem(item)
	local mapIDs = self:GetMapsForItem(item) or {}
	return Count(mapIDs)
end

function Waypoints:HasItemWaypoints(item)
	-- Is valid waypoint entry
	-- TBD: Use DB schema validation logic for this? No need to reinvent the wheel
	local hasWaypointsEntry = (item.coords ~= nil and type(item.coords) == "table")
	if not hasWaypointsEntry then
		return false
	end

	-- Has at least one assigned map ID (TBD: is this actually an optional field?)
	local hasWaypointMapID = false -- At least one (slightly awkward, should streamline this later?)
	for waypointID, waypointData in pairs(item.coords) do
		if type(waypointData) == "table" and waypointData.m ~= nil then
			hasWaypointMapID = true
		end
	end

	return hasWaypointMapID
end

function Waypoints:GetFirstMapForItem(item)
	if not self:HasItemWaypoints(item) then
		return
	end

	for waypointID, waypointData in pairs(item.coords) do
		local mapID = waypointData.m
		if mapID then -- Skip those that don't have a mapID (not sure if that actually exists?)
			return mapID
		end
	end
end

function Waypoints:GetMapsForItem(item)
	if not self:HasItemWaypoints(item) then
		return
	end

	local waypointMapIDs = {}
	for waypointID, waypointData in pairs(item.coords) do
		local mapID = waypointData.m
		if mapID then
			waypointMapIDs[mapID] = true
		end
	end

	return waypointMapIDs
end

Rarity.Waypoints = Waypoints
