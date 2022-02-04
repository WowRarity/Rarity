local _, addonTable = ...

local Testing = {}

-- Upvalues
--- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
--- WOW API
local IsAddOnLoaded = IsAddOnLoaded
local LoadAddOn = LoadAddOn

function Testing:RunTestSuite()
	Rarity:Debug("Attempting to run the integrated test suite")

	if not self:IsFrameworkAvailable() then
		Rarity:Print("The Rarity_Tests addon is required in order to run the test suite.")
		return
	end

	Rarity:RunTests() -- Added by the Rarity_Tests addon, if present

	Rarity:Debug("Finished running the integrated test suite")
end

function Testing:IsFrameworkAvailable()
	local isFrameworkLoaded = IsAddOnLoaded("Rarity_Tests") or self:LoadFrameworkOnDemand()
	return isFrameworkLoaded
end

function Testing:LoadFrameworkOnDemand()
	Rarity:Debug("Loading Rarity_Tests addon to initialize the testing framework")
	local isLoaded, reason = LoadAddOn("Rarity_Tests")
	if not isLoaded then
		Rarity:Debug("Failed to load Rarity_Tests addon (reason: %s)", reason)
	end

	return isLoaded
end

Rarity.Testing = Testing
return Testing
