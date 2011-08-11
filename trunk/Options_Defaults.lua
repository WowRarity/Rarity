if not Rarity then return end
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"

-- Methods of obtaining
local NPC = "NPC"
local BOSS = "BOSS"
local ZONE = "ZONE"
local USE = "USE"
local FISHING = "FISHING"
local ARCH = "ARCH"

-- Archaeology race IDs
--[[
1 Dwarf
2 Draenei
3 Fossil
4 Night Elf
5 Nerubian
6 Orc
7 Tol'vir
8 Troll
9 Vrykul
10 Other
]]

function R:PrepareDefaults()

	self.defaults = {
		profile = {
			minimap = { hide = true },

   groups = {

    mounts = {
     name = L["Mounts"],
     -- Soloable
     ["Fiery Warhorse's Reins"] =            { type = MOUNT, method = NPC, name = GetItemInfo(30480) or L["Fiery Warhorse's Reins"], spellId = 36702, itemId = 30480, npcs = { 16152 }, chance = 100, },
     ["Reins of the Blue Proto-Drake"] =     { type = MOUNT, method = NPC, name = GetItemInfo(44151) or L["Reins of the Blue Proto-Drake"], spellId = 59996, itemId = 44151, npcs = { 26693 }, chance = 77, heroic = true, },
     ["Reins of the Raven Lord"] =           { type = MOUNT, method = NPC, name = GetItemInfo(32768) or L["Reins of the Raven Lord"], spellId = 41252, itemId = 32768, npcs = { 23035 }, chance = 67, heroic = true, },
     ["Reins of the Vitreous Stone Drake"] = { type = MOUNT, method = NPC, name = GetItemInfo(63043) or L["Reins of the Vitreous Stone Drake"], spellId = 88746, itemId = 63043, npcs = { 43214 }, chance = 100, },
     ["Reins of the White Polar Bear"] =     { type = MOUNT, method = USE, name = GetItemInfo(43962) or L["Reins of the White Polar Bear"], spellId = 54753, itemId = 43962, items = { 44751, 69903 }, chance = 50, },
     ["Sea Turtle"] =                        { type = MOUNT, method = FISHING, name = GetItemInfo(46109) or L["Sea Turtle"], spellId = 64731, itemId = 46109, zones = { "Grizzly Hills", "Crystalsong Forest", "Dragonblight", "Howling Fjord", "Borean Tundra", "Sholazar Basin", "Tol Barad Peninsula", "Twilight Highlands", "Uldum", "Deepholm", "Mount Hyjal" }, chance = 10000, },
     ["Scepter of Azj'Aqir"] =               { type = MOUNT, method = ARCH, name = GetItemInfo(64883) or L["Scepter of Azj'Aqir"], spellId = 92155, itemId = 64883, raceId = 7, chance = 500, },
     ["Swift White Hawkstrider"] =           { type = MOUNT, method = NPC, name = GetItemInfo(35513) or L["Swift White Hawkstrider"], spellId = 46628, itemId = 35513, npcs = { 24664 }, chance = 33, heroic = true, },
     -- Requires a group (some of these are soloable by specific classes, but not in general)
     ["Ashes of Al'ar"] =                    { type = MOUNT, method = BOSS, name = GetItemInfo(32458) or L["Ashes of Al'ar"], spellId = 40192, itemId = 32458, npcs = { 19622 }, chance = 100, groupSize = 3, },
     ["Flametalon of Alysrazor"] =           { type = MOUNT, method = BOSS, name = GetItemInfo(71665) or L["Flametalon of Alysrazor"], spellId = 101542, itemId = 71665, npcs = { 52530 }, chance = 100, groupSize = 10, },
     ["Reins of the Azure Drake"] =          { type = MOUNT, method = BOSS, name = GetItemInfo(43952) or L["Reins of the Azure Drake"], spellId = 59567, itemId = 43952, npcs = { 28859 }, chance = 100, groupSize = 3, },
     ["Reins of the Onyxian Drake"] =        { type = MOUNT, method = BOSS, name = GetItemInfo(49636) or L["Reins of the Onyxian Drake"], spellId = 69395, itemId = 49636, npcs = { 10184 }, chance = 100, groupSize = 3, },
    },
    pets = {
     name = L["Companions"],
     ["Azure Whelpling"] =                   { type = PET, method = ZONE, name = GetItemInfo(34535) or L["Azure Whelpling"], spellId = 10696, itemId = 34535, zones = { "Winterspring" }, chance = 1000, },
     ["Disgusting Oozeling"] =               { type = PET, method = USE, name = GetItemInfo(20769) or L["Disgusting Oozeling"], spellId = 25162, itemId = 20769, items = { 20768 }, chance = 85, },
     ["Mojo"] =                              { type = PET, method = USE, name = GetItemInfo(33993) or L["Mojo"], spellId = 43918, itemId = 33993, items = { 33865 }, chance = 10, },
    },
    items = {
    },
    user = {
    },

   }, -- groups

		}, -- profile
	} -- self.defaults

	self.PrepareDefaults = nil
end



