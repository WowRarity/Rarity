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
local setmetatable = setmetatable
local Round = Round
local table_sort = table.sort
local math_log = math.log
local math_huge = math.huge

--[[
      Cache to precompute expensive calculations for sorting
  ]]
local precomputedValuesCache = setmetatable({}, { __mode = "k" })
-- Weak keys to allow items to be GC'd if they are tables.

-- Helper to get (from cache or by computing) data for an item based on sort configuration
local function getOrComputeSortData(item, sortConfigKey, precomputeFunction)
	if not item or type(item) ~= "table" then
		-- We shouldn't be getting unexpected items here, but if it happens,
		-- we need to avoid adding them in the cache as they can't be weak keys reliably.
		return precomputeFunction(item)
	end

	if not precomputedValuesCache[item] then
		precomputedValuesCache[item] = {}
	end
	if not precomputedValuesCache[item][sortConfigKey] then
		precomputedValuesCache[item][sortConfigKey] = precomputeFunction(item)
	end
	return precomputedValuesCache[item][sortConfigKey]
end

-- Generic function to create a sorted list using decorate-sort-undecorate
local function createSortedList(originalTable, sortConfig)
	local itemsToSort = {}
	local n = 0 -- The actual count of items added to items_to_sort
	if type(originalTable) ~= "table" then
		return {}
	end
	for _, item in pairs(originalTable) do
		-- Only sort the items that seem to be our expected format
		if type(item) == "table" and item.name then
			n = n + 1
			local computedData = getOrComputeSortData(item, sortConfig.key, sortConfig.precomputer)
			itemsToSort[n] = { original = item, computed = computedData }
		end
	end

	if n == 0 then
		return {}
	end

	table_sort(itemsToSort, sortConfig.comparator)

	local sortedFinalList = {}
	for i = 1, n do
		sortedFinalList[i] = itemsToSort[i].original
	end
	return sortedFinalList
end

--[[
      Sort Configurations
  ]]
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

local sortConfigCategory = {
	key = "category",
	precomputer = function(item)
		return {
			catOrder = catOrder[item.cat or ""] or 999, -- Unknown categories sort last
		}
	end,
	comparator = function(dA, dB)
		if dA.computed.catOrder < dB.computed.catOrder then
			return true
		end
		if dA.computed.catOrder > dB.computed.catOrder then
			return false
		end
		return dA.original.name < dB.original.name
	end,
}

--[[
	By rounding to the nearest integer, we create ties when
	items are nearly the same dropChance (e.g. 0.00334 vs. 0.00333).
	Presumably, the data may be approximate or estimated, so
	we impute that such cases are really the same drop chance.

	We also use the fact that the expected median number of attempts:
		ln(0.5) / ln(1-p)
	is extremely close to:
		ln(2) * (1/p - 1/2)
		= 0.69314718056 * (1.0/p - 0.5)
	See: https://www.desmos.com/calculator/qtl8sajrz7
]]
local sortConfigDifficulty = {
	key = "difficulty",
	precomputer = function(item)
		local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
		local computed = {
			median = (dropChance <= 0 and 1e7) or (dropChance >= 0.5 and 1) or Round(
				0.69314718056 * (1.0 / dropChance - 0.5)
			),
		}
		return computed
	end,
	comparator = function(dA, dB)
		if dA.computed.median < dB.computed.median then
			return true
		end
		if dA.computed.median > dB.computed.median then
			return false
		end
		return dA.original.name < dB.original.name
	end,
}

local sortConfigProgress = {
	key = "progress",
	precomputer = function(item)
		local dropChance = R.Statistics.GetRealDropPercentage(item)
		local attempts = item.attempts or 0
		local logPfail
		-- Using log probabilities is faster than math.pow(1 - dropChance, attempts)
		-- due to library apparently not using approaches for integer exponents
		-- and thus would be calculating pow(b,a) = exp(a * log(b)) anyway
		if dropChance >= 1 then -- Guaranteed drop
			-- Full progress if attempted, but none if not
			logPfail = (attempts > 0) and -math_huge or 0
		elseif dropChance <= 0 or attempts == 0 then -- No progress made
			logPfail = 0
		else -- Standard case: 0 < dropChance < 1 and attempts > 0
			logPfail = attempts * math_log(1 - dropChance)
		end
		return {
			logPfail = logPfail,
		}
	end,
	comparator = function(dA, dB)
		if dA.computed.logPfail < dB.computed.logPfail then
			return true
		end
		if dA.computed.logPfail > dB.computed.logPfail then
			return false
		end
		return dA.original.name < dB.original.name
	end,
}

local sortConfigName = {
	key = "name",
	precomputer = function(item) -- No precomputation needed for name itself
		return {}
	end,
	comparator = function(dA, dB)
		return dA.original.name < dB.original.name
	end,
}

local sortConfigNum = {
	key = "num",
	precomputer = function(item)
		return {
			num = item.num or 0,
		}
	end,
	comparator = function(dA, dB)
		if dA.computed.num < dB.computed.num then
			return true
		end
		if dA.computed.num > dB.computed.num then
			return false
		end
		return dA.original.name < dB.original.name
	end,
}

-- For items found in a single zone, sort alphabetically by that zone.
-- If the item comes from multiple zones, it goes at the bottom,
--  sorted by the count of how many zones it is found in.
-- Exception: items in the zone we're currently in get grouped with that zone
--  even if they are found in other zones as well.
local sortConfigZone = {
	key = "zone",
	precomputer = function(item)
		return {
			zoneInfo = R.Waypoints:GetZoneInfoForItem(item),
		}
	end,
	comparator = function(dA, dB)
		local a = dA.computed
		local b = dB.computed
		local treatAAsMultizone = a.zoneInfo.numZones > 1 and not a.zoneInfo.inMyZone
		local treatBAsMultizone = b.zoneInfo.numZones > 1 and not b.zoneInfo.inMyZone

		if treatAAsMultizone then
			if treatBAsMultizone then
				if a.zoneInfo.numZones < b.zoneInfo.numZones then
					return true
				end
				if a.zoneInfo.numZones > b.zoneInfo.numZones then
					return false
				end
				return dA.original.name < dB.original.name
			else
				return false -- multizone goes last
			end
		elseif treatBAsMultizone then
			return true
		else
			-- Both are single-zone or in current zone.
			local zoneTextA = a.zoneInfo.zoneText or ""
			local zoneTextB = b.zoneInfo.zoneText or ""
			if zoneTextA < zoneTextB then
				return true
			end
			if zoneTextA > zoneTextB then
				return false
			end
			return dA.original.name < dB.original.name
		end
	end,
}

--[[
      Public-facing functions
  ]]

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

-- Minimum impact NO OP "sort" (for debugging purposes)
function Sorting:DebugNoOp(t)
	local nt = {}
	local n = 0
	for _, v in pairs(t) do
		if type(v) == "table" and v.name then
			n = n + 1
			nt[n] = v
		end
	end
	return nt
end

function Sorting:sort(t)
	return createSortedList(t, sortConfigName)
end

function Sorting.sort2(t) -- was a static method before
	return createSortedList(t, sortConfigNum)
end

function Sorting:sort_difficulty(t)
	return createSortedList(t, sortConfigDifficulty)
end

function Sorting:sort_progress(t)
	return createSortedList(t, sortConfigProgress)
end

function Sorting:sort_category(t)
	return createSortedList(t, sortConfigCategory)
end

function Sorting:sort_zone(t)
	return createSortedList(t, sortConfigZone)
end

Rarity.Utils.Sorting = Sorting
return Sorting
