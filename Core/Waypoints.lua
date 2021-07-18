-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- WOW API
local GetBestMapForUnit = C_Map.GetBestMapForUnit

-- Rarity API
local Colorize = Rarity.Utils.String.Colorize
local Count = Rarity.Utils.Table.Count
local GetMapNameByID = Rarity.MapInfo.GetMapNameByID

local format = format
local type = type
local pairs = pairs

-- Constants
local green = Rarity.Enum.Colors.Green
local gray = Rarity.Enum.Colors.Gray

local Waypoints = {}

function Waypoints:GetZoneInfoForItem(item)
	Rarity.Profiling:StartTimer("GetZoneInfoForItem")
	local zoneInfo = {
		zoneText = self:GetZoneTextForItem(item),
		inMyZone = self:IsItemInCurrentZone(item),
		zoneColor = (self:IsItemInCurrentZone(item) and green) or gray,
		numZones = self:GetNumZonesForItem(item)
	}
	Rarity.Profiling:EndTimer("GetZoneInfoForItem")
	return zoneInfo
end

function Waypoints:GetZoneTextForItem(item)
	Rarity.Profiling:StartTimer("GetZoneTextForItem")
	if not self:HasItemWaypoints(item) then
		Rarity.Profiling:EndTimer("GetZoneTextForItem")
		return ""
	end

	if item.coords.zoneOverride ~= nil then
		Rarity.Profiling:EndTimer("GetZoneTextForItem")
		return item.coords.zoneOverride
	end

	local numZones = self:GetNumZonesForItem(item)
	if numZones == 1 then
		-- Convoluted much? Oh well, simplify later I guess (separate issue)
		local mapID = self:GetFirstMapForItem(item)
		Rarity.Profiling:EndTimer("GetZoneTextForItem")
		return GetMapNameByID(mapID)
	end

	if not self:IsItemInCurrentZone(item) then
		Rarity.Profiling:EndTimer("GetZoneTextForItem")
		return format(L["%d |4zone:zones;"], numZones)
	end

	local currentZone = GetBestMapForUnit("player")
	-- TBD: Why use gray if it'll be overridden with green due to being in the current zone?
	Rarity.Profiling:EndTimer("GetZoneTextForItem")
	return GetMapNameByID(currentZone) .. " " .. Colorize(format("+%d", numZones - 1), gray)
end

function Waypoints:IsItemInCurrentZone(item)

	Rarity.Profiling:StartTimer("IsItemInCurrentZone")

	if not self:HasItemWaypoints(item) then
		Rarity.Profiling:EndTimer("IsItemInCurrentZone")
		return false
	end -- We don't know for sure, but the effect is the same

	local mapIDs = self:GetMapsForItem(item) or {}
	-- DevTools_Dump(mapIDs)
	local currentZone = GetBestMapForUnit("player")
	Rarity.Profiling:EndTimer("IsItemInCurrentZone")
	return mapIDs[currentZone]
end

function Waypoints:GetNumZonesForItem(item)
	Rarity.Profiling:StartTimer("GetNumZonesForItem")
	local mapIDs = self:GetMapsForItem(item) or {}
	local count =  Count(mapIDs)
	Rarity.Profiling:EndTimer("GetNumZonesForItem")
	return count
end

function Waypoints:HasItemWaypoints(item)
	Rarity.Profiling:StartTimer("HasItemWaypoints")
	-- Is valid waypoint entry
	-- TBD: Use DB schema validation logic for this? No need to reinvent the wheel
	local hasWaypointsEntry = (item.coords ~= nil and type(item.coords) == "table")
	if not hasWaypointsEntry then
		Rarity.Profiling:EndTimer("HasItemWaypoints")
		return false
	end

	-- Has at least one assigned map ID (TBD: is this actually an optional field?)
	local hasWaypointMapID = false -- At least one (slightly awkward, should streamline this later?)
	for waypointID, waypointData in pairs(item.coords) do
		if type(waypointData) == "table" and waypointData.m ~= nil then
			hasWaypointMapID = true
		end
	end

	Rarity.Profiling:EndTimer("HasItemWaypoints")
	return hasWaypointMapID
end

function Waypoints:GetFirstMapForItem(item)
	Rarity.Profiling:StartTimer("GetFirstMapForItem")
	if not self:HasItemWaypoints(item) then
		Rarity.Profiling:EndTimer("GetFirstMapForItem")
		return
	end

	for waypointID, waypointData in pairs(item.coords) do
		local mapID = waypointData.m
		if mapID then -- Skip those that don't have a mapID (not sure if that actually exists?)
			Rarity.Profiling:EndTimer("GetFirstMapForItem")
			return mapID
		end
	end
	Rarity.Profiling:EndTimer("GetFirstMapForItem")
end

function Waypoints:GetMapsForItem(item)
	Rarity.Profiling:StartTimer("GetMapsForItem")
	if not self:HasItemWaypoints(item) then
		Rarity.Profiling:EndTimer("GetMapsForItem")
		return
	end

	local waypointMapIDs = {}
	for waypointID, waypointData in pairs(item.coords) do
		local mapID = waypointData.m
		if mapID then
			waypointMapIDs[mapID] = true
		end
	end

	Rarity.Profiling:EndTimer("GetMapsForItem")
	return waypointMapIDs
end

Rarity.Waypoints = Waypoints
