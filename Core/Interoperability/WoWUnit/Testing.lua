local _, addonTable = ...

local Testing = {
	TEST_GROUP_NAME = "RarityIntegrationTests",
	FAUX_TRIGGER_EVENT = "PLAYER_LOGIN", -- We don't really run any tests on login, since the groups aren't created yet
}

-- Upvalues
--- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
--- WOW API
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = C_AddOns.LoadAddOn

function Testing:RunIntegrationTests()
	Rarity:Debug("Attempting to run the full integration test suite")

	if not self:IsFrameworkAvailable() then
		Rarity:Debug(
			"The WoWUnit addon is required in order to run integration tests. Please download it from CurseForge or GitHub and make sure it's enabled before trying again!"
		)
		return
	end

	if not self:IsFrameworkInitialized() then
		self:InitializeFramework()
	end

	WoWUnit:RunTests(self.FAUX_TRIGGER_EVENT)

	Rarity:Debug("Finished running the full integration test suite")
end

function Testing:IsFrameworkAvailable()
	local isFrameworkLoaded = IsAddOnLoaded("WoWUnit") or self:LoadFrameworkOnDemand()
	return isFrameworkLoaded
end

function Testing:LoadFrameworkOnDemand()
	Rarity:Debug("Loading WoWUnit addon to initialize the testing framework")
	local isLoaded, reason = LoadAddOn("WoWUnit")
	if not isLoaded then
		Rarity:Debug("Failed to load WoWUnit addon (reason: %s)", reason)
	end

	return isLoaded
end

function Testing:IsFrameworkInitialized()
	return WoWUnit:HasGroup(self.TEST_GROUP_NAME) and self.testSuite
end

function Testing:InitializeFramework()
	local testSuite = WoWUnit:NewGroup(self.TEST_GROUP_NAME, self.FAUX_TRIGGER_EVENT) -- We don't want them to run automatically, ever
	if not testSuite then
		Rarity:Debug("Failed to create test group (already initialized?)")
		return
	end

	self.testSuite = testSuite
end

Rarity.Testing = Testing
return Testing
