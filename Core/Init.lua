--- Init.lua
-- Initialisation of the global addon structures

-- Load dependencies
-- Note: Ideally, this would be saved in the addon table
-- It'll remain global for the time being in order to maintain backwards compatibility
Rarity =
	LibStub("AceAddon-3.0"):NewAddon(
	"Rarity",
	"AceConsole-3.0",
	"AceEvent-3.0",
	"AceTimer-3.0",
	"LibSink-2.0",
	"AceBucket-3.0",
	"LibBars-1.0",
	"AceSerializer-3.0"
)
-- Rarity.MINOR_VERSION = tonumber(("$Revision: 650 $"):match("%d+"))  -- Disabled after switching entirely to Git (from SVN)
local projectVersion, noReplacements = (GetAddOnMetadata("Rarity", "Version"):match("r%d+") or "r0"):gsub("r", "") -- e.g., r654	1 (the second value can be discarded)
Rarity.MINOR_VERSION = tonumber(projectVersion)

-- Set up modules
Rarity.Statistics = {}
Rarity.Utils = {}

-- Global lookup tables (will be replaced eventually, but let's maintain backwards compatibility for now)
Rarity.items = {}
Rarity.architems = {}
Rarity.bosses = {}
Rarity.guids = {}
Rarity.npcs_to_items = {}
Rarity.zones = {}
Rarity.items_to_items = {}
Rarity.bagitems = {}
Rarity.tempbagitems = {}
Rarity.used = {}
