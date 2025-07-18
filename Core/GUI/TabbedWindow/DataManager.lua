local _, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Get Constants from addon table
local Constants = addonTable.TabbedWindowModules and addonTable.TabbedWindowModules.Constants

-- Upvalues for performance
local R = Rarity
local sort2 = Rarity.Utils.Sorting.sort2
local GetItemInfo = _G.C_Item and _G.C_Item.GetItemInfo or _G.GetItemInfo

-- Set up Constants if not already loaded
if not Constants.ITEM_BUTTON then
	Constants.ITEM_BUTTON = {
		ZONE_TEXT_MAX_LENGTH = 18,
		ZONE_TEXT_TRUNCATE_LENGTH = 15,
		PROGRESS_BAR_WIDTH = 90,
	}
end

if not Constants.PROGRESS_THRESHOLDS then
	Constants.PROGRESS_THRESHOLDS = {
		VERY_LIKELY = 75,
		LIKELY = 50,
		MODERATE = 25,
	}
end

if not Constants.COLORS then
	Constants.COLORS = {
		STATUS_FOUND = { 0.2, 0.8, 0.2, 0.8 },
		STATUS_DISABLED = { 0.8, 0.2, 0.2, 0.8 },
		STATUS_TRACKING = { 0.2, 0.4, 0.8, 0.8 },
		STATUS_DEFAULT = { 0.2, 0.2, 0.2, 0.6 },
		PROGRESS_BG = { 0.2, 0.2, 0.2, 0.8 },
		PROGRESS_VERY_LIKELY = { 0.8, 0.2, 0.2, 0.8 },
		PROGRESS_LIKELY = { 1, 0.6, 0, 0.8 },
		PROGRESS_MODERATE = { 1, 1, 0, 0.8 },
		PROGRESS_LOW = { 0.2, 0.8, 0.2, 0.8 },
		HEADER_TEXT = { 1, 1, 1, 1 },
		ZONE_TEXT = { 0.8, 0.8, 0.8, 1 },
		SEARCH_LABEL_TEXT = { 0.9, 0.9, 1, 1 },
	}
end

if not Constants.METHOD_NAMES then
	Constants.METHOD_NAMES = {
		[addonTable.constants.DETECTION_METHODS.NPC] = "NPC",
		[addonTable.constants.DETECTION_METHODS.BOSS] = "Boss",
		[addonTable.constants.DETECTION_METHODS.ZONE] = "Zone",
		[addonTable.constants.DETECTION_METHODS.USE] = "Use",
		[addonTable.constants.DETECTION_METHODS.FISHING] = "Fishing",
		[addonTable.constants.DETECTION_METHODS.MINING] = "Mining",
		[addonTable.constants.DETECTION_METHODS.COLLECTION] = "Collection",
		[addonTable.constants.DETECTION_METHODS.ARCH] = "Archaeology",
		[addonTable.constants.DETECTION_METHODS.SPECIAL] = "Special",
		[addonTable.constants.DETECTION_METHODS.LOOT_TOAST] = "Loot Toast",
	}
end

local DataManager = {}

-- Helper function to validate item data
local function IsValidItem(item)
	return type(item) == "table" and item.enabled ~= false
end

-- Helper function to get zone text with proper fallback
local function GetZoneText(item)
	if not item then
		return ""
	end

	local zoneText = ""
	if item.zones and type(item.zones) == "table" and item.zones[1] then
		local zoneInfo = item.zones[1]
		if type(zoneInfo) == "number" then
			-- It's a zone ID, try to get the name
			local mapInfo = C_Map and C_Map.GetMapInfo and C_Map.GetMapInfo(zoneInfo)
			zoneText = (mapInfo and mapInfo.name) or tostring(zoneInfo)
		else
			-- It's already a zone name
			zoneText = tostring(zoneInfo)
		end
	elseif item.zoneText then
		zoneText = item.zoneText
	elseif item.zone then
		zoneText = item.zone
	end

	-- Truncate long zone names
	local config = Constants.ITEM_BUTTON
	if string.len(zoneText) > config.ZONE_TEXT_MAX_LENGTH then
		zoneText = string.sub(zoneText, 1, config.ZONE_TEXT_TRUNCATE_LENGTH) .. "..."
	end

	return zoneText
end

-- Helper function to get drop chance safely
local function GetDropChance(item)
	if not item then
		return 0.01
	end

	local dropChance = 0.01 -- Default fallback
	if R and R.Statistics and R.Statistics.GetRealDropPercentage then
		local success, result = pcall(R.Statistics.GetRealDropPercentage, item)
		if success and result then
			dropChance = result
		end
	end

	return dropChance
end

-- Helper function to get attempts count
local function GetAttemptCount(item)
	if not item then
		return 0
	end

	local attempts = item.attempts or 0
	if item.lastAttempts then
		attempts = attempts - item.lastAttempts
	end

	return math.max(0, attempts)
end

-- Helper function to calculate likelihood
local function CalculateLikelihood(item)
	local attempts = GetAttemptCount(item)
	local dropChance = GetDropChance(item)

	if attempts <= 0 then
		return 0
	end

	return 100 * (1 - math.pow(1 - dropChance, attempts))
end

-- Helper function to get progress bar color
local function GetProgressBarColor(chance)
	local thresholds = Constants.PROGRESS_THRESHOLDS
	local colors = Constants.COLORS

	if chance >= thresholds.VERY_LIKELY then
		return colors.PROGRESS_VERY_LIKELY
	elseif chance >= thresholds.LIKELY then
		return colors.PROGRESS_LIKELY
	elseif chance >= thresholds.MODERATE then
		return colors.PROGRESS_MODERATE
	else
		return colors.PROGRESS_LOW
	end
end

-- Helper function to get status info
local function GetStatusInfo(item)
	local colors = Constants.COLORS

	if item and item.found then
		return L["Found"], colors.STATUS_FOUND
	elseif item and item.enabled == false then
		return L["Disabled"], colors.STATUS_DISABLED
	else
		return L["Tracking"], colors.STATUS_TRACKING
	end
end

-- Helper function to get method name
local function GetMethodName(item)
	if not item or not item.method then
		return "Unknown"
	end

	return Constants.METHOD_NAMES[item.method] or "Unknown"
end

-- Main data fetching function
function DataManager:GetFilteredItems(tabInfo, filterText)
	local allItems = {}

	-- Validate inputs
	if not tabInfo or not tabInfo.dataSource then
		return allItems
	end

	-- Check if data source exists
	if not R or not R.db or not R.db.profile or not R.db.profile.groups then
		return allItems
	end

	local dataSource = R.db.profile.groups[tabInfo.dataSource]
	if not dataSource then
		return allItems
	end

	-- Convert to array and filter
	for name, item in pairs(dataSource) do
		if IsValidItem(item) and self:MatchesFilter(item, name, filterText) then
			-- Ensure item has a name for sorting
			if not item.name then
				item.name = name
			end
			table.insert(allItems, item)
		end
	end

	-- Sort items with error handling
	local success, sortedItems = pcall(sort2, allItems, self:GetSortMode())
	if not success then
		print("ERROR: Failed to sort items - " .. tostring(sortedItems))
		return allItems
	end

	return sortedItems
end

-- Filter matching function
function DataManager:MatchesFilter(item, name, filterText)
	if not filterText or filterText == "" then
		return true
	end

	local lowerFilter = string.lower(filterText)

	-- Check item name
	if item.name and string.find(string.lower(item.name), lowerFilter) then
		return true
	end

	-- Check key name
	if name and string.find(string.lower(name), lowerFilter) then
		return true
	end

	-- Check zone text
	local zoneText = GetZoneText(item)
	if zoneText and string.find(string.lower(zoneText), lowerFilter) then
		return true
	end

	-- Check method name
	local methodName = GetMethodName(item)
	if methodName and string.find(string.lower(methodName), lowerFilter) then
		return true
	end

	return false
end

-- Get current sort mode
function DataManager:GetSortMode()
	if R and R.db and R.db.profile and R.db.profile.sortMode then
		return R.db.profile.sortMode
	end
	return "name"
end

-- Item data enrichment for display
function DataManager:GetItemDisplayData(item)
	if not item then
		return nil
	end

	local displayData = {
		item = item,
		attempts = GetAttemptCount(item),
		dropChance = GetDropChance(item),
		likelihood = CalculateLikelihood(item),
		zoneText = GetZoneText(item),
		methodName = GetMethodName(item),
	}

	-- Calculate additional display properties
	displayData.progressBarColor = GetProgressBarColor(displayData.likelihood)
	displayData.statusText, displayData.statusColor = GetStatusInfo(item)
	displayData.progressWidth = math.min(displayData.likelihood / 100, 1) * Constants.ITEM_BUTTON.PROGRESS_BAR_WIDTH

	-- Get item info
	if item.itemId then
		local success, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
			pcall(GetItemInfo, item.itemId)

		if success then
			displayData.itemName = itemName
			displayData.itemLink = itemLink
			displayData.itemRarity = itemRarity
			displayData.itemTexture = itemTexture
			displayData.qualityColor = itemRarity
				and itemRarity > 0
				and ITEM_QUALITY_COLORS
				and ITEM_QUALITY_COLORS[itemRarity]
		end
	end

	-- Set display name with quality color
	displayData.displayName = displayData.itemName or item.name or L["Unknown"]
	if displayData.qualityColor and displayData.qualityColor.hex then
		displayData.displayName = displayData.qualityColor.hex .. displayData.displayName .. "|r"
	end

	return displayData
end

-- Tooltip data generation
function DataManager:GetTooltipData(item)
	if not item then
		return nil
	end

	local tooltipData = {
		item = item,
		attempts = GetAttemptCount(item),
		dropChance = GetDropChance(item),
		likelihood = CalculateLikelihood(item),
		zoneText = GetZoneText(item),
	}

	-- Calculate median loots for luck indicator
	if tooltipData.dropChance > 0 then
		tooltipData.medianLoots = math.floor(math.log(1 - 0.5) / math.log(1 - tooltipData.dropChance) + 0.5)
		tooltipData.isLucky = tooltipData.medianLoots >= tooltipData.attempts
	else
		tooltipData.medianLoots = 0
		tooltipData.isLucky = false
	end

	-- Get item info for tooltip
	if item.itemId then
		local success, itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
			pcall(GetItemInfo, item.itemId)

		if success then
			tooltipData.itemName = itemName
			tooltipData.itemLink = itemLink
			tooltipData.itemTexture = itemTexture
		end
	end

	return tooltipData
end

-- Progress link generation for chat
function DataManager:GetProgressLinkText(item)
	if not item then
		return ""
	end

	local displayData = self:GetItemDisplayData(item)
	if not displayData then
		return ""
	end

	local itemLink = displayData.itemLink or item.name
	local attempts = displayData.attempts
	local chance = displayData.likelihood
	local medianLoots = displayData.medianLoots or 0

	local lucky = medianLoots < attempts and L["unlucky"] or L["lucky"]

	local linkText
	if attempts == 1 then
		linkText = format(L["%s: 0/%d attempt so far (%.2f%% - %s)"], itemLink, attempts, chance, lucky)
	elseif attempts <= 0 then
		linkText = format("%s", itemLink)
	else
		linkText = format(L["%s: 0/%d attempts so far (%.2f%% - %s)"], itemLink, attempts, chance, lucky)
	end

	return linkText
end

-- Waypoint data extraction
function DataManager:GetWaypointData(item)
	if not item or not item.coords or type(item.coords) ~= "table" then
		return {}
	end

	local waypoints = {}
	for _, coord in pairs(item.coords) do
		local isValid = true

		-- Check quest completion if applicable
		if coord.q then
			if C_QuestLog and C_QuestLog.IsQuestFlaggedCompleted and C_QuestLog.IsQuestFlaggedCompleted(coord.q) then
				isValid = false
			end
		end

		if isValid and coord.m and coord.x and coord.y then
			local extraName = ""
			if coord.n then
				extraName = " (" .. coord.n .. ")"
			end

			table.insert(waypoints, {
				mapID = coord.m,
				x = coord.x / 100,
				y = coord.y / 100,
				title = (item.name or L["Unknown"]) .. extraName,
				source = "Rarity",
			})
		end
	end

	return waypoints
end

-- Pagination helper
function DataManager:GetPaginatedItems(items, currentPage, itemsPerPage)
	if not items or #items == 0 then
		return {}, 0, 0
	end

	local maxPages = math.max(1, math.ceil(#items / itemsPerPage))
	local safePage = math.min(currentPage, maxPages)

	local startIndex = (safePage - 1) * itemsPerPage + 1
	local endIndex = math.min(startIndex + itemsPerPage - 1, #items)

	local pageItems = {}
	for i = startIndex, endIndex do
		table.insert(pageItems, items[i])
	end

	return pageItems, safePage, maxPages
end

-- Validation functions
function DataManager:ValidateTabInfo(tabInfo)
	return tabInfo and tabInfo.dataSource and type(tabInfo.dataSource) == "string"
end

function DataManager:ValidateItem(item)
	return item and type(item) == "table"
end

-- Error handling wrapper
function DataManager:SafeExecute(func, ...)
	local success, result = pcall(func, ...)
	if not success then
		print("ERROR: DataManager execution failed - " .. tostring(result))
		return nil
	end
	return result
end

-- Statistics helpers
function DataManager:GetItemStatistics(items)
	if not items or #items == 0 then
		return {
			total = 0,
			found = 0,
			tracking = 0,
			disabled = 0,
		}
	end

	local stats = { total = #items, found = 0, tracking = 0, disabled = 0 }

	for _, item in ipairs(items) do
		if item.found then
			stats.found = stats.found + 1
		elseif item.enabled == false then
			stats.disabled = stats.disabled + 1
		else
			stats.tracking = stats.tracking + 1
		end
	end

	return stats
end

-- Store in addon table
if not addonTable.TabbedWindowModules then
	addonTable.TabbedWindowModules = {}
end

addonTable.TabbedWindowModules.DataManager = DataManager
