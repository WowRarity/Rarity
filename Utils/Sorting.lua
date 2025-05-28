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
	[CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS] = 9,
	[CONSTANTS.ITEM_CATEGORIES.DRAGONFLIGHT] = 10,
	[CONSTANTS.ITEM_CATEGORIES.TWW] = 11,
}

local function compareCategory(a, b)
	if (a.cat or "") == (b.cat or "") then
		return (a.name or "") < (b.name or "")
	end
	return (catOrder[a.cat or 0] or 0) < (catOrder[b.cat or 0] or 0)
end

local function compareDifficulty(a, b)
	local dropChanceA = Rarity.Statistics.GetRealDropPercentage(a)
	local dropChanceB = Rarity.Statistics.GetRealDropPercentage(b)

	return dropChanceA < dropChanceB
	-- The following tiebreaks equal cases (alphabetical)
	-- but is much slower and doesn't add much value:
	--[[
	-- If can't round to become equal, then we can skip the full calculation
	if math.abs(dropChanceA - dropChanceB) > min(dropChanceA, dropChanceB) then
		return dropChanceA < dropChanceB
	end

	local medianA = Round(math.log(1 - 0.5) / math.log(1 - dropChanceA))
	local medianB = Round(math.log(1 - 0.5) / math.log(1 - dropChanceB))

	return (medianA or 0) < (medianB or 0)
	]]
end

local function compareProgress(a, b)
	-- Optimization: probability of not having dropped; more progress = less chance
	local chanceA = a.attempts and math.pow(1 - Rarity.Statistics.GetRealDropPercentage(a), a.attempts) or 0
	local chanceB = b.attempts and math.pow(1 - Rarity.Statistics.GetRealDropPercentage(b), b.attempts) or 0

	return chanceA < chanceB
end

local function compareName(a, b)
	return (a.name or "") < (b.name or "")
end

local function compareNum(a, b)
	return (a.num or 0) < (b.num or 0)
end

local function compareZone(a, b)
	--- Alphabetical, if item is found in a single zone.
	--- If the item comes from multiple zones, it goes at the bottom,
	--- sorted by the count of how many zones it is found in.
	--- Exception: items in the zone we're currently in get grouped with that zone
	--- even if they are found in other zones as well.
	local zoneInfoA = R.Waypoints:GetZoneInfoForItem(a)
	local zoneInfoB = R.Waypoints:GetZoneInfoForItem(b)

	if zoneInfoA.numZones > 1 and not zoneInfoA.inMyZone then
		if zoneInfoB.numZones > 1 and not zoneInfoB.inMyZone then
			return zoneInfoA.numZones < zoneInfoB.numZones
		else
			return false
		end
	elseif zoneInfoB.numZones > 1 and not zoneInfoB.inMyZone then
		return true
	end

	return (zoneInfoA.zoneText or "") < (zoneInfoB.zoneText or "")
end

function Sorting:SortGroup(group, method)
	if method == CONSTANTS.SORT_METHODS.SORT_NONE then
		return self:DebugNoOp(group)
	end

	Rarity.Profiling:StartTimer("SortGroup")
	local sortedGroup = group
	if method == CONSTANTS.SORT_METHODS.SORT_NAME then
		sortedGroup = self:sort(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_DIFFICULTY then
		sortedGroup = self:sort_difficulty(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_CATEGORY then
		sortedGroup = self:sort_category(group)
	elseif method == CONSTANTS.SORT_METHODS.SORT_ZONE then
		sortedGroup = self:sort_zone(group)
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
