--- Sorting.lua
-- Anything used for sorting (it's a mess...)
local _, addonTable = ...

-- Locals
local Sorting = {}

-- Upvalues
local R = Rarity
local CONSTANTS = addonTable.constants
-- Lua APIs
local type = type
local pairs = pairs
local Round = Round

local catOrder = {
	[CONSTANTS.ITEM_CATEGORIES.HOLIDAY] = 0,
	[CONSTANTS.ITEM_CATEGORIES.CLASSIC] = 1,
	[CONSTANTS.ITEM_CATEGORIES.TBC] = 2,
	[CONSTANTS.ITEM_CATEGORIES.WOTLK] = 3,
	[CONSTANTS.ITEM_CATEGORIES.CATA] = 4,
	[CONSTANTS.ITEM_CATEGORIES.MOP] = 5,
	[CONSTANTS.ITEM_CATEGORIES.WOD] = 6,
	[CONSTANTS.ITEM_CATEGORIES.LEGION] = 7,
	[CONSTANTS.ITEM_CATEGORIES.BFA] = 8,
	[CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS] = 9
}

local function compareCategory(a, b)
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end
	if (a.cat or "") == (b.cat or "") then
		return (a.name or "") < (b.name or "")
	end
	return (catOrder[a.cat or 0] or 0) < (catOrder[b.cat or 0] or 0)
end

local function compareDifficulty(a, b)
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end

	local item
	item = a
	local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
	local medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
	local median1 = medianLoots

	item = b
	dropChance = Rarity.Statistics.GetRealDropPercentage(item)
	medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
	local median2 = medianLoots

	return (median1 or 0) < (median2 or 0)
end

local function compareProgress(a, b)
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end

	local item
	item = a
	local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
	local medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
	local median1 = medianLoots
	local progress1 = 0
	if item.attempts or 0 > 0 then
		progress1 = 100 * (1 - math.pow(1 - dropChance, item.attempts or 0))
	end

	item = b
	dropChance = Rarity.Statistics.GetRealDropPercentage(item)
	medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
	local median2 = medianLoots
	local progress2 = 0
	if item.attempts or 0 > 0 then
		progress2 = 100 * (1 - math.pow(1 - dropChance, item.attempts or 0))
	end

	return progress1 > progress2
end

local function compareName(a, b)
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end
	return (a.name or "") < (b.name or "")
end

local function compareNum(a, b)
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end
	return (a.num or 0) < (b.num or 0)
end

-- These don't exist when the utils are loaded, but we want to cache them here for performance reasons
local Waypoints
local GetZoneInfoForItem

local function compareZone(a, b)

	Waypoints = Waypoints or Rarity.Waypoints
	GetZoneInfoForItem = GetZoneInfoForItem or Waypoints.GetZoneInfoForItem -- To initialize on the first call

	-- Sort by zone text, unless there are multiple zones. Those go at the bottom, sorted by number of zones.
	-- If the item is in your current zone as well as one or more other zones,
	-- we sort it alphabetically instead of putting it at the bottom.
	if not a or not b then
		return 0
	end
	if type(a) ~= "table" or type(b) ~= "table" then
		return 0
	end
	-- We want to upvalue the API calls for performance reasons, so we have to pass "self" manually here
	Rarity.Profiling:StartTimer("compareZone_GetZoneInfoForItem")
	local zoneInfoA = GetZoneInfoForItem(Waypoints, a)
	local zoneInfoB = GetZoneInfoForItem(Waypoints, b)
	Rarity.Profiling:EndTimer("compareZone_GetZoneInfoForItem")


	Rarity.Profiling:StartTimer("compareZone_compareZoneTexts")
	local zoneTextA, inMyZoneA, zoneColorA, numZonesA = zoneInfoA.zoneText, zoneInfoA.inMyZone, zoneInfoA.zoneColor, zoneInfoA.numZones
	local zoneTextB, inMyZoneB, zoneColorB, numZonesB = zoneInfoB.zoneText, zoneInfoB.inMyZone, zoneInfoB.zoneColor, zoneInfoB.numZones
	if numZonesA > 1 and inMyZoneA ~= true then
		zoneTextA = "ZZZZZZZZZZZZZZ"
	end
	if numZonesB > 1 and inMyZoneB ~= true then
		zoneTextB = "ZZZZZZZZZZZZZZ"
	end
	if numZonesA < 10 and numZonesA > 1 and inMyZoneA ~= true then
		zoneTextA = zoneTextA .. "0"
	end
	if numZonesB < 10 and numZonesB > 1 and inMyZoneB ~= true then
		zoneTextB = zoneTextB .. "0"
	end
	if numZonesA > 1 and inMyZoneA ~= true then
		zoneTextA = zoneTextA .. numZonesA
	end
	if numZonesB > 1 and inMyZoneB ~= true then
		zoneTextB = zoneTextB .. numZonesB
	end
	Rarity.Profiling:EndTimer("compareZone_compareZoneTexts")
	return (zoneTextA or "") < (zoneTextB or "")
end

function Sorting:SortGroup(group, method)

	if method == CONSTANTS.SORT_METHODS.SORT_NONE then return self:DebugNoOp(group) end

	Rarity.Profiling:StartTimer("SortGroup")
	local sortedGroup = group
	if method == CONSTANTS.SORT_METHODS.SORT_NAME then
		sortedGroup = self:sort(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_DIFFICULTY then
		sortedGroup = self:sort_difficulty(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_CATEGORY then
		sortedGroup = self:sort_category(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_ZONE then
		Rarity.Profiling:StartTimer("compareZone")
		sortedGroup = self:sort_zone(group)
		Rarity.Profiling:EndTimer("compareZone")
	elseif method == CONSTANTS.SORT_METHODS.SORT_PROGRESS then
		sortedGroup = self:sort_progress(group)
	end
	Rarity.Profiling:EndTimer("SortGroup")

	return sortedGroup
end

-- Minimum impact NO OP "sort" (for debugging purposes); introduced since disabling sorting entirely didn't work
function Sorting:DebugNoOp(t)

	local nt = {}
	local n = 0

	for k, v in pairs(t) do
		if type(v) == "table" and v.name then
			n = n + 1
			nt[n] = v
		end
	end

	return nt
end

local function sort_copy_with(t, comparator)
	local nt = {}
	local n = 0
	for _, v in pairs(t) do
		if type(v) == "table" and v.name then
			n = n + 1
			nt[n] = v
		end
	end
	table.sort(nt, comparator)
	return nt
end

function Sorting:sort(t)
	return sort_copy_with(t, compareName)
end

function Sorting.sort2(t)
	return sort_copy_with(t, compareNum)
end

function Sorting:sort_difficulty(t)
	return sort_copy_with(t, compareDifficulty)
end

function Sorting:sort_progress(t)
	return sort_copy_with(t, compareProgress)
end

function Sorting:sort_category(t)
	return sort_copy_with(t, compareCategory)
end

function Sorting:sort_zone(t)
	return sort_copy_with(t, compareZone)
end

Rarity.Utils.Sorting = Sorting
return Sorting
