if not Rarity then return end
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"

R.string_types = {
 [MOUNT] = L["Mount"],
 [PET] = L["Companion"],
 [ITEM] = L["Item"],
}

-- Methods of obtaining
local NPC = "NPC"
local BOSS = "BOSS"
local ZONE = "ZONE"
local USE = "USE"
local FISHING = "FISHING"
local ARCH = "ARCH"
local SPECIAL = "SPECIAL"
local MINING = "MINING"

-- Sort modes
local SORT_NAME = "SORT_NAME"
local SORT_DIFFICULTY = "SORT_DIFFICULTY"
local SORT_PROGRESS = "SORT_PROGRESS"

R.string_methods = {
 [NPC] = L["Drops from NPC(s)"],
 [BOSS] = L["Drops from a boss requiring a group"],
 [ZONE] = L["Drops from any mob in a zone"],
 [USE] = L["Obtained by using an item or opening a container"],
 [FISHING] = L["Obtained by fishing"],
 [ARCH] = L["Obtained as an archaeology project"],
 [SPECIAL] = L["Special case"],
 [MINING] = L["Obtained by mining"],
}

-- Archaeology races
R.string_archraces = {
 [1] = L["Dwarf"],
 [2] = L["Draenei"],
 [3] = L["Fossil"],
 [4] = L["Night Elf"],
 [5] = L["Nerubian"],
 [6] = L["Orc"],
 [7] = L["Tol'vir"],
 [8] = L["Troll"],
 [9] = L["Vrykul"],
 [10] = L["Other"],
}

-- Feed text
local FEED_MINIMAL = "FEED_MINIMAL"
local FEED_NORMAL = "FEED_NORMAL"
local FEED_VERBOSE = "FEED_VERBOSE"

-- Tooltip position
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"


function R:PrepareDefaults()

	self.defaults = {
		profile = {
			minimap = { hide = true },

   enableAnnouncements = true,
   feedText = FEED_NORMAL,
   itemTip = TIP_LEFT,
   statusTip = TIP_RIGHT,
   sortMode = SORT_NAME,

   trackedGroup = "pets",
   trackedItem = 8494,

   bar = {
    point = "TOPLEFT",
    relativePoint = "TOPLEFT",
    x = 100,
    y = -100,
    width = 150,
    height = 12,
    scale = 1.0,
    visible = false,
    anchor = true,
    locked = false,
   },

   groups = {

    mounts = {
     name = L["Mounts"],

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     -- Soloable (some of these may be challenging to solo for certain classes, but in general they should be soloable)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

     ["Fiery Warhorse's Reins"] =               { type = MOUNT, method = NPC, name = GetItemInfo(30480) or L["Fiery Warhorse's Reins"], spellId = 36702, itemId = 30480, npcs = { 16152 }, chance = 100, },
     ["Reins of the Blue Proto-Drake"] =        { type = MOUNT, method = NPC, name = GetItemInfo(44151) or L["Reins of the Blue Proto-Drake"], spellId = 59996, itemId = 44151, npcs = { 26693 }, chance = 77, heroic = true, },
     ["Reins of the Raven Lord"] =              { type = MOUNT, method = NPC, name = GetItemInfo(32768) or L["Reins of the Raven Lord"], spellId = 41252, itemId = 32768, npcs = { 23035 }, chance = 67, heroic = true, },
     ["Reins of the Vitreous Stone Drake"] =    { type = MOUNT, method = NPC, name = GetItemInfo(63043) or L["Reins of the Vitreous Stone Drake"], spellId = 88746, itemId = 63043, npcs = { 43214 }, chance = 100, },
     ["Reins of the Drake of the North Wind"] = { type = MOUNT, method = NPC, name = GetItemInfo(63040) or L["Reins of the Drake of the North Wind"], spellId = 88742, itemId = 63040, npcs = { 43873 }, chance = 100, },
     ["Reins of the White Polar Bear"] =        { type = MOUNT, method = USE, name = GetItemInfo(43962) or L["Reins of the White Polar Bear"], spellId = 54753, itemId = 43962, items = { 44751, 69903 }, chance = 50, },
     ["Sea Turtle"] =                           { type = MOUNT, method = FISHING, name = GetItemInfo(46109) or L["Sea Turtle"], spellId = 64731, itemId = 46109, zones = { "Grizzly Hills", "Crystalsong Forest", "Dragonblight", "Howling Fjord", "Borean Tundra", "Sholazar Basin", "Tol Barad Peninsula", "Twilight Highlands", "Uldum", "Deepholm", "Mount Hyjal", "Krasarang Wilds", "The Jade Forest", "Valley of the Four Winds", "Kun-Lai Summit", "Vale of Eternal Blossoms", "Dread Wastes", "Townlong Steppes", "Darkmoon Island" }, chance = 10000, requiresPool = true, },
     ["Scepter of Azj'Aqir"] =                  { type = MOUNT, method = ARCH, name = GetItemInfo(64883) or L["Scepter of Azj'Aqir"], spellId = 92155, itemId = 64883, raceId = 7, chance = 500, },
     ["Fossilized Raptor"] =                    { type = MOUNT, method = ARCH, name = GetItemInfo(60954) or L["Fossilized Raptor"], spellId = 84751, itemId = 60954, raceId = 3, chance = 30, },
     ["Swift White Hawkstrider"] =              { type = MOUNT, method = NPC, name = GetItemInfo(35513) or L["Swift White Hawkstrider"], spellId = 46628, itemId = 35513, npcs = { 24664 }, chance = 33, heroic = true, --[[statisticId = { 1082 },]] },
     ["Deathcharger's Reins"] =                 { type = MOUNT, method = NPC, name = GetItemInfo(13335) or L["Deathcharger's Reins"], spellId = 17481, itemId = 13335, npcs = { 45412 }, chance = 100, --[[statisticId = { 1097 },]] },
     ["Red Qiraji Resonating Crystal"] =        { type = MOUNT, method = NPC, name = GetItemInfo(21321) or L["Red Qiraji Resonating Crystal"], spellId = 26054, itemId = 21321, npcs = { 15311, 15250, 15247, 15246, 15264, 15262, 15277, 15312, 15252, 15249 }, chance = 100, },
     ["Reins of the Green Proto-Drake"] =       { type = MOUNT, method = USE, name = GetItemInfo(44707) or L["Reins of the Green Proto-Drake"], spellId = 61294, itemId = 44707, items = { 39883 }, chance = 20, },
     ["Reins of the Grey Riding Camel"] =       { type = MOUNT, method = SPECIAL, name = GetItemInfo(63046) or L["Reins of the Grey Riding Camel"], spellId = 88750, itemId = 63046, obtain = L["Obtained from Mysterious Camel Figurines"], chance = 20, },
     ["Ashes of Al'ar"] =                       { type = MOUNT, method = BOSS, name = GetItemInfo(32458) or L["Ashes of Al'ar"], spellId = 40192, itemId = 32458, npcs = { 9999 }, chance = 100, statisticId = { 1088 }, },
     ["Reins of the Azure Drake"] =             { type = MOUNT, method = BOSS, name = GetItemInfo(43952) or L["Reins of the Azure Drake"], spellId = 59567, itemId = 43952, npcs = { 9999 }, chance = 100, statisticId = { 1391, 1394 }, },
     ["Reins of the Blue Drake"] =              { type = MOUNT, method = BOSS, name = GetItemInfo(43953) or L["Reins of the Blue Drake"], spellId = 59568, itemId = 43953, npcs = { 9999 }, chance = 100, statisticId = { 1391, 1394 }, },
     ["Reins of the Onyxian Drake"] =           { type = MOUNT, method = BOSS, name = GetItemInfo(49636) or L["Reins of the Onyxian Drake"], spellId = 69395, itemId = 49636, npcs = { 9999 }, chance = 100, statisticId = { 1098 }, },
     ["Swift Zulian Panther"] =                 { type = MOUNT, method = BOSS, name = GetItemInfo(68824) or L["Swift Zulian Panther"], spellId = 96499, itemId = 68824, npcs = { 52059 }, chance = 100, },
     ["Reins of the Grand Black War Mammoth Horde"] = { type = MOUNT, method = BOSS, name = GetItemInfo(44083) or L["Reins of the Grand Black War Mammoth"], spellId = 61467, itemId = 44083, npcs = { 9999 }, chance = 100, requiresHorde = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, doNotUpdateToHighestStat = true, },
     ["Reins of the Grand Black War Mammoth Alliance"] = { type = MOUNT, method = BOSS, name = GetItemInfo(43959) or L["Reins of the Grand Black War Mammoth"], spellId = 61465, itemId = 43959, npcs = { 9999 }, chance = 100, requiresAlliance = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, doNotUpdateToHighestStat = true, },

					-- 4.2
     ["Flametalon of Alysrazor"] =              { type = MOUNT, method = BOSS, name = GetItemInfo(71665) or L["Flametalon of Alysrazor"], spellId = 101542, itemId = 71665, npcs = { 52530 }, chance = 100, statisticId = { 5970, 5971 }, },

					-- 5.2
     ["Reins of the Slate Primordial Direhorn"] = { type = MOUNT, method = NPC, name = GetItemInfo(94229) or L["Reins of the Slate Primordial Direhorn"], spellId = 138425, itemId = 94229, npcs = { 69769 }, chance = 100, },
     ["Reins of the Amber Primordial Direhorn"] = { type = MOUNT, method = NPC, name = GetItemInfo(94230) or L["Reins of the Amber Primordial Direhorn"], spellId = 138424, itemId = 94230, npcs = { 69841 }, chance = 100, },
     ["Reins of the Jade Primordial Direhorn"] = { type = MOUNT, method = NPC, name = GetItemInfo(94231) or L["Reins of the Jade Primordial Direhorn"], spellId = 138426, itemId = 94231, npcs = { 69842 }, chance = 100, },
     ["Reins of the Green Primal Raptor"] =     { type = MOUNT, method = USE, name = GetItemInfo(94293) or L["Reins of the Green Primal Raptor"], spellId = 138643, itemId = 94293, items = { 94295 }, chance = 20, },
     ["Reins of the Black Primal Raptor"] =     { type = MOUNT, method = USE, name = GetItemInfo(94292) or L["Reins of the Black Primal Raptor"], spellId = 138642, itemId = 94292, items = { 94295 }, chance = 20, },
     
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- Requires a group (some of these may be soloable by certain classes, but not in general)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

     ["Invincible's Reins"] =                   { type = MOUNT, method = BOSS, name = GetItemInfo(50818) or L["Invincible's Reins"], spellId = 72286, itemId = 50818, npcs = { 36597 }, chance = 100, heroic = true, raid25 = true, groupSize = 5, statisticId = { 4688 }, },
     ["Mimiron's Head"] =                       { type = MOUNT, method = BOSS, name = GetItemInfo(45693) or L["Mimiron's Head"], spellId = 63796, itemId = 45693, npcs = { 33288 }, chance = 100, raid25 = true, groupSize = 10,  },
     ["The Horseman's Reins"] =                 { type = MOUNT, method = USE, name = GetItemInfo(37012) or L["The Horseman's Reins"], spellId = 48025, itemId = 37012, items = { 54516 }, chance = 666, groupSize = 5, equalOdds = true, },
     ["Big Love Rocket"] =                      { type = MOUNT, method = USE, name = GetItemInfo(50250) or L["Big Love Rocket"], spellId = 71342, itemId = 50250, items = { 54537 }, chance = 666, groupSize = 5, equalOdds = true, },
     ["Armored Razzashi Raptor"] =              { type = MOUNT, method = BOSS, name = GetItemInfo(68823) or L["Armored Razzashi Raptor"], spellId = 96491, itemId = 68823, npcs = { 52151 }, chance = 100, groupSize = 2, },
     ["Reins of the Drake of the South Wind"] = { type = MOUNT, method = BOSS, name = GetItemInfo(63041) or L["Reins of the Drake of the South Wind"], spellId = 88744, itemId = 63041, npcs = { 46753 }, chance = 100, groupSize = 3, statisticId = { 5576, 5577 }, },
     ["Smoldering Egg of Millagazor"] =         { type = MOUNT, method = BOSS, name = GetItemInfo(69224) or L["Smoldering Egg of Millagazor"], spellId = 97493, itemId = 69224, npcs = { 52409 }, chance = 100, groupSize = 5, statisticId = { 5976, 5977 }, },
     ["Experiment 12-B"] =                      { type = MOUNT, method = BOSS, name = GetItemInfo(78919) or L["Experiment 12-B"], spellId = 110039, itemId = 78919, npcs = { 55294 }, chance = 100, groupSize = 3, statisticId = { 6161, 6162 }, },
     ["Reins of the Blazing Drake"] =           { type = MOUNT, method = BOSS, name = GetItemInfo(77067) or L["Reins of the Blazing Drake"], spellId = 107842, itemId = 77067, npcs = { 999999 }, chance = 100, groupSize = 3, statisticId = { 6167, 6168 }, },
     ["Great Brewfest Kodo"] =                  { type = MOUNT, method = USE, name = GetItemInfo(37828) or L["Great Brewfest Kodo"], spellId = 49379, itemId = 37828, items = { 54535 }, chance = 25, groupSize = 5, equalOdds = true, },
     ["Swift Brewfest Ram"] =                   { type = MOUNT, method = USE, name = GetItemInfo(33977) or L["Swift Brewfest Ram"], spellId = 43900, itemId = 33977, items = { 54535 }, chance = 25, groupSize = 5, equalOdds = true, },
     
					-- 5.0
					["Son of Galleon's Saddle"] =              { type = MOUNT, method = BOSS, name = GetItemInfo(89783) or L["Son of Galleon's Saddle"], spellId = 130965, itemId = 89783, npcs = { 99999 }, chance = 100, groupSize = 40, equalOdds = true, statisticId = { 6990 } },
     ["Reins of the Astral Cloud Serpent"] =    { type = MOUNT, method = BOSS, name = GetItemInfo(87777) or L["Reins of the Astral Cloud Serpent"], spellId = 127170, itemId = 87777, npcs = { 99999 }, chance = 100, groupSize = 10, statisticId = { 6797, 6798 } },
     ["Reins of the Heavenly Onyx Cloud Serpent"] = { type = MOUNT, method = BOSS, name = GetItemInfo(87771) or L["Reins of the Heavenly Onyx Cloud Serpent"], spellId = 127158, itemId = 87771, npcs = { 99999 }, chance = 2000, groupSize = 40, equalOdds = true, statisticId = { 6989 } },

     -- 5.2
     ["Reins of the Thundering Cobalt Cloud Serpent"] = { type = MOUNT, method = BOSS, name = GetItemInfo(95057) or L["Reins of the Thundering Cobalt Cloud Serpent"], spellId = 139442, itemId = 95057, npcs = { 99999 }, chance = 2000, groupSize = 40, equalOdds = true, statisticId = { 8146 } },
     ["Reins of the Cobalt Primordial Direhorn"] = { type = MOUNT, method = BOSS, name = GetItemInfo(94228) or L["Reins of the Cobalt Primordial Direhorn"], spellId = 138423, itemId = 94228, npcs = { 99999 }, chance = 2000, groupSize = 40, equalOdds = true, statisticId = { 8147 } },

    },
    pets = {
     name = L["Companions"],
     ["Azure Whelpling"] =                      { type = PET, method = ZONE, name = GetItemInfo(34535) or L["Azure Whelpling"], spellId = 10696, itemId = 34535, zones = { "Winterspring" }, chance = 10000, repeatable = true, },
     ["Disgusting Oozeling"] =                  { type = PET, method = USE, name = GetItemInfo(20769) or L["Disgusting Oozeling"], spellId = 25162, itemId = 20769, items = { 20768 }, chance = 85, repeatable = true, },
     ["Mojo"] =                                 { type = PET, method = USE, name = GetItemInfo(33993) or L["Mojo"], spellId = 43918, itemId = 33993, items = { 33865 }, chance = 10, },
     ["Scorched Stone"] =                       { type = PET, method = USE, name = GetItemInfo(34955) or L["Scorched Stone"], spellId = 45890, itemId = 34955, items = { 71631 }, chance = 20, },
     ["Parrot Cage (Hyacinth Macaw)"] =         { type = PET, method = ZONE, name = GetItemInfo(8494) or L["Parrot Cage (Hyacinth Macaw)"], spellId = 10682, itemId = 8494, zones = { "Stranglethorn Vale", "Northern Stranglethorn", "The Cape of Stranglethorn" }, chance = 10000, repeatable = true, },
     ["Parrot Cage (Green Wing Macaw)"] =       { type = PET, method = NPC, name = GetItemInfo(8492) or L["Parrot Cage (Green Wing Macaw)"], spellId = 10683, itemId = 8492, npcs = { 48522 }, chance = 33, repeatable = true, },
     ["Deviate Hatchling"] =                    { type = PET, method = NPC, name = GetItemInfo(48114) or L["Deviate Hatchling"], spellId = 67414, itemId = 48114, npcs = { 3636, 3637 }, chance = 500, repeatable = true, },
     ["Gundrak Hatchling"] =                    { type = PET, method = NPC, name = GetItemInfo(48116) or L["Gundrak Hatchling"], spellId = 67415, itemId = 48116, npcs = { 29334, 52148 }, chance = 1000, repeatable = true, },
     ["Dark Whelpling"] =                       { type = PET, method = NPC, name = GetItemInfo(10822) or L["Dark Whelpling"], spellId = 10695, itemId = 10822, npcs = { 4324, 42042, 2725, 46916, 7049, 4323, 46914 }, chance = 1000, repeatable = true, },
     ["Tiny Emerald Whelpling"] =               { type = PET, method = NPC, name = GetItemInfo(8498) or L["Tiny Emerald Whelpling"], spellId = 10698, itemId = 8498, npcs = { 740, 741, 39384 }, chance = 1000, repeatable = true, },
     ["Captured Firefly"] =                     { type = PET, method = NPC, name = GetItemInfo(29960) or L["Captured Firefly"], spellId = 36034, itemId = 29960, npcs = { 20197 }, chance = 1000, repeatable = true, },
     ["Phoenix Hatchling"] =                    { type = PET, method = NPC, name = GetItemInfo(35504) or L["Phoenix Hatchling"], spellId = 46599, itemId = 35504, npcs = { 24664 }, chance = 11, },
     ["Sprite Darter Egg"] =                    { type = PET, method = ZONE, name = GetItemInfo(11474) or L["Sprite Darter Egg"], spellId = 15067, itemId = 11474, zones = { "Feralas" }, chance = 10000, },
     ["Fox Kit"] =                              { type = PET, method = NPC, name = GetItemInfo(64403) or L["Fox Kit"], spellId = 90637, itemId = 64403, npcs = { 47676 }, chance = 1000, },
     ["Razzashi Hatchling"] =                   { type = PET, method = ZONE, name = GetItemInfo(48126) or L["Razzashi Hatchling"], spellId = 67420, itemId = 48126, zones = { "Stranglethorn Vale", "Northern Stranglethorn", "The Cape of Stranglethorn" }, chance = 5000, repeatable = true, },
     ["Tiny Crimson Whelpling"] =               { type = PET, method = ZONE, name = GetItemInfo(8499) or L["Tiny Crimson Whelpling"], spellId = 10697, itemId = 8499, zones = { "Wetlands" }, chance = 10000, repeatable = true, },
     ["Cat Carrier (Black Tabby)"] =            { type = PET, method = ZONE, name = GetItemInfo(8491) or L["Cat Carrier (Black Tabby)"], spellId = 10675, itemId = 8491, zones = { "Hillsbrad Foothills" }, chance = 5000, repeatable = true, },
     ["Giant Sewer Rat"] =                      { type = PET, method = FISHING, name = GetItemInfo(43698) or L["Giant Sewer Rat"], spellId = 59250, itemId = 43698, zones = { "Cantrips & Crows", "Circle of Wills", "The Underbelly", "The Black Market" }, chance = 1000, requiresPool = false, },
     ["Mr. Grubbs"] =                           { type = PET, method = USE, name = GetItemInfo(66076) or L["Mr. Grubbs"], spellId = 93739, itemId = 66076, items = { 61387 }, chance = 50, },
     ["Elementium Geode"] =                     { type = PET, method = SPECIAL, name = GetItemInfo(67282) or L["Elementium Geode"], spellId = 93838, itemId = 67282, obtain = L["Obtained by mining Elementium Vein"], chance = 20, },
     ["Sea Pony"] =                             { type = PET, method = FISHING, name = GetItemInfo(73953) or L["Sea Pony"], spellId = 103588, itemId = 73953, zones = { "Darkmoon Island" }, chance = 1000, requiresPool = false, },
     ["Ice Chip"] =                             { type = PET, method = USE, name = GetItemInfo(53641) or L["Ice Chip"], spellId = 74932, itemId = 53641, items = { 54536 }, chance = 25, groupSize = 5, equalOdds = true, },
     ["Toxic Wasteling"] =                      { type = PET, method = USE, name = GetItemInfo(50446) or L["Toxic Wasteling"], spellId = 71840, itemId = 50446, items = { 54537 }, chance = 14, groupSize = 5, equalOdds = true, },
     ["Lump of Coal"] =                         { type = PET, method = USE, name = GetItemInfo(73797) or L["Lump of Coal"], spellId = 103125, itemId = 73797, items = { 73792 }, chance = 50, },
     ["Deviate Hatchling"] =                    { type = PET, method = NPC, name = GetItemInfo(48114) or L["Deviate Hatchling"], spellId = 67414, itemId = 48114, npcs = { 3636, 3637 }, chance = 500, repeatable = true, },

					-- 5.0
     ["Hollow Reed"] =                          { type = PET, method = NPC, name = GetItemInfo(86563) or L["Hollow Reed"], spellId = 126249, itemId = 86563, npcs = { 50776 }, chance = 10, },
     ["Imbued Jade Fragment"] =                 { type = PET, method = NPC, name = GetItemInfo(86564) or L["Imbued Jade Fragment"], spellId = 126251, itemId = 86564, npcs = { 50347 }, chance = 10, },

					-- 5.1
     ["Whistle of Chromatic Bone"] =              { type = PET, method = NPC, name = GetItemInfo(93038) or L["Whistle of Chromatic Bone"], spellId = 93038, itemId = 93038, npcs = { 14020 }, chance = 10, },
     ["Blackwing Banner"] =              { type = PET, method = NPC, name = GetItemInfo(93037) or L["Blackwing Banner"], spellId = 135265, itemId = 93037, npcs = { 12017 }, chance = 10, },
     ["Unscathed Egg"] =              { type = PET, method = NPC, name = GetItemInfo(93036) or L["Unscathed Egg"], spellId = 135263, itemId = 93036, npcs = { 12435 }, chance = 10, },
     ["Anubisath Idol"] =              { type = PET, method = NPC, name = GetItemInfo(93040) or L["Anubisath Idol"], spellId = 135267, itemId = 93040, npcs = { 15276 }, chance = 10, },
     ["Jewel of Maddening Whispers"] =              { type = PET, method = NPC, name = GetItemInfo(93041) or L["Jewel of Maddening Whispers"], spellId = 135268, itemId = 93041, npcs = { 15263 }, chance = 10, },
     ["Viscidus Globule"] =              { type = PET, method = NPC, name = GetItemInfo(93039) or L["Viscidus Globule"], spellId = 135266, itemId = 93039, npcs = { 15299 }, chance = 10, },
     ["Core of Hardened Ash"] =              { type = PET, method = NPC, name = GetItemInfo(93035) or L["Core of Hardened Ash"], spellId = 135261, itemId = 93035, npcs = { 11988 }, chance = 10, },
     ["Mark of Flame"] =              { type = PET, method = NPC, name = GetItemInfo(93033) or L["Mark of Flame"], spellId = 135258, itemId = 93033, npcs = { 12098 }, chance = 10, },
     ["Blazing Rune"] =              { type = PET, method = NPC, name = GetItemInfo(93034) or L["Blazing Rune"], spellId = 135259, itemId = 93034, npcs = { 11982 }, chance = 10, },
     ["Blighted Spore"] =              { type = PET, method = NPC, name = GetItemInfo(93032) or L["Blighted Spore"], spellId = 135255, itemId = 93032, npcs = { 16011 }, chance = 10, },
     ["Dusty Clutch of Eggs"] =              { type = PET, method = NPC, name = GetItemInfo(93030) or L["Dusty Clutch of Eggs"], spellId = 135254, itemId = 93030, npcs = { 15952 }, chance = 10, },
     ["Gluth's Bone"] =              { type = PET, method = NPC, name = GetItemInfo(93029) or L["Gluth's Bone"], spellId = 135257, itemId = 93029, npcs = { 15932 }, chance = 10, },

    },
    items = {
     name = L["Items"],
     ["Mr. Pinchy"] =                           { type = ITEM, method = FISHING, name = GetItemInfo(27388) or L["Mr. Pinchy"], spellId = 33050, itemId = 27388, zones = { "Lake Jorune", "Lake Ere'Noru", "Skethyl Mountains", "Blackwind Landing", "Blackwind Valley", "Skettis", "Blackwind Lake", "Veil Harr'ik", "Veil Ala'rak", "Terokk's Rest" }, chance = 500, requiresPool = true, },
     ["Skyshard"] =                             { type = ITEM, method = ZONE, name = GetItemInfo(86547) or L["Skyshard"], spellId = 90655, itemId = 86547, zones = { "Vale of Eternal Blossoms" }, chance = 1000, repeatable = true, },
     --["Stat Test"] = { type = MOUNT, method = BOSS, name = "Stat Test", spellId = -1, itemId = -1, npcs = { 99999 }, chance = 100, groupSize = 40, equalOdds = true, statisticId = { 107 } },
    },
    user = {
     name = L["Custom"],
     --["Test 1"] =      { type = PET, method = NPC, name = GetItemInfo(25467) or "Test 1", spellId = 10682, itemId = 25467, npcs = { 16520, 16516 }, chance = 100, repeatable = true, },
    },

   }, -- groups

		}, -- profile
	} -- self.defaults

	self.PrepareDefaults = nil
end



