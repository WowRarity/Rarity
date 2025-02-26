require("Tests.Globals")
require("Tests.WOWAPI")

-- Mimicking the WOW client's behavior doesn't work well with the current setup (improve later)
local addonName, addonTable = unpack(require("Tests.RarityCoreSetup"))
_G.RARITY_ADDON_NAME = addonName
_G.RARITY_ADDON_TABLE = addonTable
assert(_G.RARITY_ADDON_NAME == "Rarity", "Unexpected addon name")
assert(_G.RARITY_ADDON_TABLE, "Uninitialized addon table")

local specFiles = {
	"Tests/test-items.spec.lua",
	"Tests/test-database.spec.lua",
	"Tests/test-holiday-events.spec.lua",
	"Tests/test-serialization.spec.lua",
	"Tests/test-toc.spec.lua",
}

local numFailedSections = C_Runtime.RunDetailedTests(specFiles)

os.exit(numFailedSections)
