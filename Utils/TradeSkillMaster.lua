local _, addonTable = ...
if not addonTable then
	return
end

-- Upvalues
local TSM_Interface = {}

-- Lua APIs
local format = string.format

-- WOW APIs
local GetItemInfo = GetItemInfo

--- Attempts to determine whether or not the TSM_API can safely be used (it's probably not perfect)
-- @return True if the required functionality appears to be loaded; false (nil) otherwise
function TSM_Interface:IsLoaded()
	-- JIT access to allow lazy loading of TSM without breaking the feature
	if not TSM_API then
		return
	end

	local GetCustomPriceValue = TSM_API.GetCustomPriceValue
	local FormatMoneyString = TSM_API.FormatMoneyString
	local ToItemString = TSM_API.ToItemString
	local GetPriceSourceKeys = TSM_API.GetPriceSourceKeys

	if not (GetCustomPriceValue and FormatMoneyString and ToItemString and GetPriceSourceKeys) then
		Rarity:Print(
			"Failed to load one or more of the required TSM_APIs. TSM integration will not work until this is fixed, so please report the error :)"
		)
		Rarity:Print("In the meantime, you can disable the feature to hide all messages pertaining to it")
		return
	end

	return true
end

--- Checks whether or not a given price source is recognized by the TSM_API
-- @param priceSource A string representing the price source
-- @return True if TSM recognized the price source; false (nil) otherwise
function TSM_Interface:IsValidPriceSource(priceSource)
	if not type(priceSource) == "string" then
		return
	end

	if not self:IsLoaded() then
		return
	end

	local knownPriceSources = {}
	knownPriceSources = TSM_API.GetPriceSourceKeys(knownPriceSources)
	for _, knownSource in ipairs(knownPriceSources) do
		-- TODO: Wasteful. Do it only once?
		knownPriceSources[knownSource] = true -- Reusing this as a LUT to save some memory
	end

	if not knownPriceSources[priceSource] then
		return
	end
	return true
end

--- Retrieves an item's current market price as stored by the TradeSkillMaster addon
-- Note: Not sure how this works for items that have multiple versions (it's up to TSM to deal with it)
-- @param itemID The ID of the item for which a price should be returned
-- @param priceSource A string representing a TSM_API price source
-- @param[opt] formatAsString A boolean value indicating whether or not the retrieved price should be formatted in a human-readable way
-- @return A string representing the item's DBMarket price; nil if TSM didn't have one for this item
function TSM_Interface:GetMarketPrice(itemID, priceSource, formatAsString)
	if not (type(itemID) == "number" and type("priceSource") == "string") then
		Rarity:Debug("Usage: GetMarketPrice(itemID, priceSource)")
		return
	end

	formatAsString = (formatAsString == nil) and true or formatAsString

	if not self:IsLoaded() then
		return
	end

	if not self:IsValidPriceSource(priceSource) then
		Rarity:Debug(format("Failed to GetMarketPrice for item %d and priceSource %s (not recognized)", itemID, priceSource))
		return
	end

	local itemLink = select(2, GetItemInfo(itemID))
	if type(itemLink) ~= "string" then
		Rarity:Debug(format("Attempting to use an invalid itemLink for item %d", itemID))
		return
	end

	local itemString = TSM_API.ToItemString(itemLink)
	if type(itemString) ~= "string" then
		Rarity:Debug(format("Attempting to use an invalid itemString for item %d", itemID))
		return
	end

	local marketPrice, errorMessage = TSM_API.GetCustomPriceValue(priceSource, itemString)
	if errorMessage then
		Rarity:Debug(
			format(
				"Error while retrieving price for item %d (%s) from price source %s via TSM_API: %s",
				itemID,
				itemLink,
				priceSource,
				errorMessage
			)
		)
	end

	if marketPrice and formatAsString then
		marketPrice = TSM_API.FormatMoneyString(marketPrice)
	end

	return marketPrice
end

Rarity.Utils.TSM_Interface = TSM_Interface
return TSM_Interface
