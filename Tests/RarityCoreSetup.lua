LE_EXPANSION_CLASSIC = 1
LE_EXPANSION_BURNING_CRUSADE = 2
LE_EXPANSION_WRATH_OF_THE_LICH_KING = 3
LE_EXPANSION_CATACLYSM = 4
LE_EXPANSION_MISTS_OF_PANDARIA = 5
LE_EXPANSION_WARLORDS_OF_DRAENOR = 6
LE_EXPANSION_LEGION = 7
LE_EXPANSION_BATTLE_FOR_AZEROTH = 8
LE_EXPANSION_SHADOWLANDS = 9
LE_EXPANSION_DRAGONFLIGHT = 10
LE_EXPANSION_WAR_WITHIN = 11
LE_EXPANSION_MIDNIGHT = 12
LE_EXPANSION_LEVEL_CURRENT = LE_EXPANSION_MIDNIGHT

-- Can't use require since it doesn't support dots as part of the directory name
dofile("Libs/LibStub/LibStub.lua")
dofile("Libs/CallbackHandler-1.0/CallbackHandler-1.0.lua")

dofile("Libs/LibBars-1.0/LibBars-1.0.lua")
dofile("Libs/LibCompress/LibCompress.lua")
dofile("Libs/LibSink-2.0/LibSink-2.0/LibSink-2.0.lua")

dofile("Libs/AceAddon-3.0/AceAddon-3.0.lua")
dofile("Libs/AceBucket-3.0/AceBucket-3.0.lua")
dofile("Libs/AceConsole-3.0/AceConsole-3.0.lua")
dofile("Libs/AceEvent-3.0/AceEvent-3.0.lua")
dofile("Libs/AceLocale-3.0/AceLocale-3.0.lua")
dofile("Libs/AceSerializer-3.0/AceSerializer-3.0.lua")
dofile("Libs/AceTimer-3.0/AceTimer-3.0.lua")

local aceAddonObject = _G.LibStub("AceAddon-3.0"):NewAddon(
	"Rarity",
	"AceConsole-3.0",
	"AceEvent-3.0",
	"AceTimer-3.0",
	"LibSink-2.0",
	"AceBucket-3.0",
	"LibBars-1.0",
	"AceSerializer-3.0"
)
aceAddonObject.Utils = {}

local addonName = "Rarity"
local addonTable = {
	privateAceAddonObject = aceAddonObject,
}

_G.Rarity = aceAddonObject

dofile("Locales.lua")
dofile("Utils/PrettyPrint.lua")

return { addonName, addonTable }
