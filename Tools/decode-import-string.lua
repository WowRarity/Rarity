-- The serialization module requires some setup, which should probably be removed eventually
require("Tests.Globals")
require("Tests.WOWAPI")
require("Tests.RarityCoreSetup")

local Serialization = loadfile("Core/Serialization.lua")("Rarity", {})

local transform = require("transform")
local cyan = transform.cyan

local importString = arg[1]
assert(importString, "No input string provided as first argument")

print()
printf("Decoding import string: %s", cyan(importString))

local item = Serialization:DeserializeItemString(importString)
dump(item)
