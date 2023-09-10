require("Tests.Globals")
require("Tests.WOWAPI")
require("Tests.RarityCoreSetup")

local specFiles = {
	"Tests/test-database.spec.lua",
	"Tests/test-holiday-events.spec.lua",
	"Tests/test-serialization.spec.lua",
}

local numFailedSections = C_Runtime.RunDetailedTests(specFiles)

os.exit(numFailedSections)
