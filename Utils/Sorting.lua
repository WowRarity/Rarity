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
      Precompute expensive calculations used by comparators during sorting
  ]]
local precompCache = setmetatable({}, { __mode = "k" })
-- Weak keys to allow items to be GC'd if they are tables.

-- Helper to get (from cache or by computing) data for an item based on sort configuration
local function prepForSort(item, sortConfigKey, precomputer)
	if not item or type(item) ~= "table" then
		-- We shouldn't be getting unexpected items here, but if it happens,
		-- we need to avoid adding them in the cache as they can't be weak keys reliably.
		return precomputer(item)
	end

	if not precompCache[item] then
		precompCache[item] = {}
	end
	if not precompCache[item][sortConfigKey] then
		precompCache[item][sortConfigKey] = precomputer(item)
	end
	return precompCache[item][sortConfigKey]
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
			itemsToSort[n] = prepForSort(item, sortConfig.key, sortConfig.precomputer)
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

	  Each configuration has:
		- key: A key used to identify the sort configuration
		- precomputer: A function that takes an item and returns a table:
			{
				original: The original item, and
				computed: A table containing any computed values needed for sorting.
			}
		- comparator: A comparator that takes two items as decorated by the precomputer.
			Comparators return true iff the first item comes before the second item.
  ]]

--[[ Sorting by name, alphabetically
	No precomputation needed, as we can just compare the names directly.
  ]]
local sortConfigName = {
	key = "name",
	precomputer = function(item)
		return {
			original = item,
			computed = {},
		}
	end,
	comparator = function(dA, dB)
		return dA.original.name < dB.original.name
	end,
}

--[[ Sorting by category
	Holidays first, then expansions from oldest to newest.
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
	[""] = math_huge, -- Unknown categories sort last
}

local sortConfigCategory = {
	key = "category",
	precomputer = function(item)
		return {
			original = item,
			computed = {
				catOrder = catOrder[item.cat or ""] or math_huge,
			},
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

--[[ Sorting by difficulty, i.e. median number of attempts
	By rounding to the nearest integer, items with nearly the same
		dropChance (e.g. 0.00334 vs. 0.00333) are considered tied.
	Presumably, drop data may be approximate or emperical, so
		we impute that such cases are actually the same drop chance.

	We also use the fact that the expected median number of attempts:
		ln(0.5) / ln(1-p)
	is extremely close to:
		ln(2) * (1/p - 1/2)
		= 0.69314718056 * (1.0/p - 0.5)
	e.g. https://www.desmos.com/calculator/qtl8sajrz7
  ]]
local sortConfigDifficulty = {
	key = "difficulty",
	precomputer = function(item)
		local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
		return {
			original = item,
			computed = {
				median = (dropChance <= 0 and math_huge) or (dropChance >= 0.5 and 1) or (Round(
					0.69314718056 * (1.0 / dropChance - 0.5)
				)),
			},
		}
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

--[[ Sorting by progress, i.e. probability of success so far
	Equivalent to (reverse) probability of failure given number of attempts
		(1 - p) ^ attempts, where p = dropChance.
	Also, using log likelihood,
		log((1 - p) ^ attempts)
		= attempts * log(1 - p)
	is faster than math.pow(1 - dropChance, attempts), as Lua
	does not distinguish between float and int exponentiation,
	so pow(b,a) is internally calculated as exp(a * log(b)) anyway.
  ]]
local sortConfigProgress = {
	key = "progress",
	precomputer = function(item)
		local dropChance = R.Statistics.GetRealDropPercentage(item)
		local attempts = item.attempts or 0
		local LN_ALWAYS = 0 -- log(1) = 0
		local LN_NEVER = -math_huge -- log(0) = -inf
		return {
			original = item,
			computed = {
				logPfail = ((attempts == 0 or dropChance <= 0) and LN_ALWAYS)
					or ((dropChance >= 1) and LN_NEVER)
					or attempts * math_log(1 - dropChance),
			},
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

--[[ Sorting by zone
	- Items found in a single zone are sorted alphabetically by zone name.
	- Items found in multiple zones are last, sorted by the number of zones.
	- Exception: Items found in the current zone are grouped with that zone,
	  even if they are also found elsewhere.
  ]]
local sortConfigZone = {
	key = "zone",
	precomputer = function(item)
		return {
			original = item,
			computed = {
				zoneInfo = R.Waypoints:GetZoneInfoForItem(item),
			},
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

--[[ Sorting an item's attempts ("finds") by index number
	Unlike the others, this is used to sort an item's finds table (item.finds),
		not a table of items in R.DB.Item structure
  ]]
local sortConfigFindNum = {
	key = "num",
	precomputer = function(item)
		return {
			original = item,
			computed = {
				num = item.num or 0,
			},
		}
	end,
	comparator = function(dA, dB)
		return dA.computed.num < dB.computed.num
	end,
}

--[[
      Public-facing functions
  ]]

-- Minimum impact NO OP "sort" (for debugging purposes)
function Sorting.DebugNoOp(t)
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

-- Item sorting functions
-- Sort by item name
function Sorting.sort(t)
	return createSortedList(t, sortConfigName)
end

function Sorting.sort_difficulty(t)
	return createSortedList(t, sortConfigDifficulty)
end

function Sorting.sort_progress(t)
	return createSortedList(t, sortConfigProgress)
end

function Sorting.sort_category(t)
	return createSortedList(t, sortConfigCategory)
end

function Sorting.sort_zone(t)
	return createSortedList(t, sortConfigZone)
end

-- Sort by .num field, used by item.finds tables
function Sorting.sort_num(t)
	return createSortedList(t, sortConfigFindNum)
end

local sortMethodMap = {
	[CONSTANTS.SORT_METHODS.SORT_NAME] = Sorting.sort,
	[CONSTANTS.SORT_METHODS.SORT_DIFFICULTY] = Sorting.sort_difficulty,
	[CONSTANTS.SORT_METHODS.SORT_CATEGORY] = Sorting.sort_category,
	[CONSTANTS.SORT_METHODS.SORT_ZONE] = Sorting.sort_zone,
	[CONSTANTS.SORT_METHODS.SORT_PROGRESS] = Sorting.sort_progress,
	[CONSTANTS.SORT_METHODS.SORT_NONE] = Sorting.DebugNoOp,
}

function Sorting.SortGroup(group, method)
	local sortMethod = sortMethodMap[method]

	if not sortMethod then
		Rarity:Debug(format("Sorting.SortGroup called with unknown method %s", method))
		sortMethod = Sorting.DebugNoOp
	end

	Rarity.Profiling:StartTimer("SortGroup")
	local sortedGroup = sortMethod(group)
	Rarity.Profiling:EndTimer("SortGroup")

	return sortedGroup
end

Rarity.Utils.Sorting = Sorting
return Sorting
