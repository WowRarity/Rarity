require("Tests.Globals")
require("Tests.WOWAPI")
require("Tests.RarityCoreSetup")

local specFiles = {
}

local numFailedSections = C_Runtime.RunDetailedTests(specFiles)

os.exit(numFailedSections)
