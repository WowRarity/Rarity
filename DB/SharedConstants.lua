local addonName, addonTable = ...

-- Set up shared constants (for ease of use, mainly)
-- Note: Don't change the string values, refactoring is only partially complete (search all files to see)
-- They were originally hardcoded EVERYWHERE and are also used directly as keys in the DB...
addonTable.constants = addonTable.constants or {}

local C = addonTable.constants

-- Types of items
C.TOOLTIP = { ACTIVATION_METHOD_HOVER = "ACTIVATION_METHOD_HOVER",
              ACTIVATION_METHOD_CLICK = "ACTIVATION_METHOD_CLICK" }

-- Misc. stuff for the detailed lockout storage / defeat detection
C.DEFEAT_DETECTION = { MODE_OR = 1, MODE_AND = 2 }

-- Embedded mapIDs: It's best to avoid hardcoding these in case of yet another re-mapping on Blizzard's end...
C.UIMAPIDS = {
	-- Dummy Zone (For items that can be obtained anywhere.)
	NONE = 0,
	-- Classic Zones
	ARATHI_HIGHLANDS = 14,
	HILLSBRAD_FOOTHILLS = 25,
	DARKSHORE = 62,
	SILITHUS = 81,
	-- Wrath of the Lich King Zones
	DRAGONBLIGHT = 115,
	GRIZZLY_HILLS = 116,
	HOWLING_FJORD = 117,
	ICECROWN = 118,
	SHOLAZAR_BASIN = 119,
	ZUL_DRAK = 121,
	HROTHGARS_LANDING = 170,
	--
	DEEPHOLM = 207,
	TWILIGHT_HIGHLANDS = 241,
	TOL_BARAD = 244,
	TOL_BARAD_PENINSULA = 245,
	ULDUM_CATACLYSM = 249,
	MAGISTERS_TERRACE_GRAND_MAGISTERS_ASYLUM = 348,
	MAGISTERS_TERRACE_OBSERVATION_GROUNDS = 349,
	-- Mists of Pandaria Zones
	JADE_FOREST = 371,
	VALLEY_OF_THE_FOUR_WINDS = 376,
	KUNLAI_SUMMIT = 379,
	TOWNLONG_STEPPES = 388,
	VALE_OF_ETERNAL_BLOSSOMS_MOP = 390,
	KRASARANG_WILDS = 418,
	DREAD_WASTES = 422,
	-- Warlords of Draenor Zones
	FROSTFIRE_RIDGE = 525,
	NAGRAND_DRAENOR = 550,
	LUNARFALL_GARRISON = 582,
	FROSTWALL_GARRISON = 590,
	-- Legion Zones
	AZSUNA = 630,
	STORMHEIM = 634,
	VALSHARAH = 641,
	HIGHMOUNTAIN = 650,
	SURAMAR = 680,
	SKYHOLD = 695,
	KROKUUN = 830,
	MACAREE = 882,
	ANTORAN_WASTES = 885,
	-- Legion Instances
	SEAT_OF_THE_TRIUMVIRATE = 903,
	-- Battle for Azeroth Zones
	ZANDALAR = 875,
	KULTIRAS = 876,
	ATALDAZAR = 934,
	FREEHOLD = 936,
	TOLDAGOR = 974,
	KINGS_REST = 1004,
	TEMPLE_OF_SETHRALISS = 1043,
	THE_UNDERROT = 1042,
	BORALUS = 1161,
	DAZARALOR = 1165,
	BATTLE_FOR_DAZARALOR_RAID = 1364,
	NAZJATAR = 1355,
	MECHAGON_ISLAND = 1462,
	MECHAGON_ISLAND_DUNGEON = 1490,
	NAZMIR = 863,
	VOLDUN = 864,
	ZULDAZAR = 862,
	TIRAGARDE_SOUND = 895,
	DRUSTVAR = 896,
	STORMSONG_VALLEY = 942,
	THE_ETERNAL_PALACE = 1515,
	ULDUM = 1527,
	VALE_OF_ETERNAL_BLOSSOMS = 1530,
	HORRIFIC_VISION_OF_STORMWIND = 1470,
	HORRIFIC_VISION_OF_ORGRIMMAR = 1469,
	NYALOTHA = 1582, -- Generic (doesn't matter which subzone, as waypoints inside of instances can no longer be set)
	BASTION = 1533,
	REVENDRETH = 1525,
	MALDRAXXUS = 1536,
	ARDENWEALD = 1565,
	THE_MAW = 1543,
	TORGHAST = 1751,
	THE_NECROTIC_WAKE = 1666,
	MISTS_OF_TIRNA_SCITHE = 1669,
	PLAGUEFALL = 1674,
	SANGUINE_DEPTHS = 1675,
	CASTLE_NATHRIA = 1735,
	KORTHIA = 1961,
	TAZAVESH_THE_VEILED_MARKET = 1989,
	SANCTUM_OF_DOMINATION = 1998,
	ZERETH_MORTIS = 1970,
}

-- Types of items
C.ITEM_TYPES = { MOUNT = "MOUNT", PET = "PET", ITEM = "ITEM" }

-- Types of different detection methods
C.DETECTION_METHODS = {
	NPC = "NPC",
	BOSS = "BOSS",
	ZONE = "ZONE",
	USE = "USE",
	FISHING = "FISHING",
	ARCH = "ARCH",
	SPECIAL = "SPECIAL",
	MINING = "MINING",
	COLLECTION = "COLLECTION",
	LOOT_TOAST = "LOOT_TOAST", -- Unused/NYI (but we'll get there later)
}

-- Categories (expansions-based, with some special types of items)
C.ITEM_CATEGORIES = {
	CLASSIC = "BASE",
	TBC = "TBC",
	WOTLK = "WOTLK",
	CATA = "CATA",
	MOP = "MOP",
	WOD = "WOD",
	LEGION = "LEGION",
	BFA = "BFA",
	SHADOWLANDS = "SHADOWLANDS",
	HOLIDAY = "HOLIDAY",
}

-- Instance difficulties
C.INSTANCE_DIFFICULTIES = {
	NONE = 0,
	HEROIC_DUNGEON = 2,
	RAID_10_NORMAL = 3,
	RAID_25_NORMAL = 4,
	RAID_10_HEROIC = 5,
	RAID_25_HEROIC = 6,
	LEGACY_LFR = 7,
	NORMAL_RAID = 14, -- Normal (Raids)
	HEROIC_RAID = 15, -- Heroic (Raids)
	MYTHIC_RAID = 16, -- Mythic (Raids)
	LFR = 17,
	MYTHIC_DUNGEON = 23, -- Mythic 5-player instance
	TIMEWALKING_DUNGEON = 24, -- Timewalking 5-player instance
	TIMEWALKING_RAID = 33,
}

-- LDB feed text
C.LDB_TEXT_STYLES = { FEED_MINIMAL = "FEED_MINIMAL", FEED_VERBOSE = "FEED_VERBOSE" }

C.TOOLTIP_POSITIONS = { TIP_LEFT = "TIP_LEFT", TIP_RIGHT = "TIP_RIGHT", TIP_HIDDEN = "TIP_HIDDEN" }

C.SORT_METHODS = {
	SORT_NONE = "None",
	SORT_NAME = "SORT_NAME",
	SORT_DIFFICULTY = "SORT_DIFFICULTY",
	SORT_PROGRESS = "SORT_PROGRESS",
	SORT_CATEGORY = "SORT_CATEGORY",
	SORT_ZONE = "SORT_ZONE",
}

C.COVENANT_IDS = { KYRIAN = 1, VENTHYR = 2, NIGHT_FAE = 3, NECROLORD = 4 }

C.HOLIDAY_TEXTURES = {
	WINTERS_VEIL = "Calendar_WinterVeil",
	DARKMOON_FAIRE = "calendar_darkmoonfaireterokkar",
	DAY_OF_THE_DEAD = "Calendar_DayOfTheDead",
	BREWFEST = "Calendar_Brewfest",
	HALLOWS_END = "Calendar_HallowsEnd",
	PILGRIMS_BOUNTY = "Calendar_HarvestFestival",
	WOW_ANNIVERSARY = "calendar_anniversary",
	LOVE_IS_IN_THE_AIR = "Calendar_LoveInTheAir",
	LUNAR_FESTIVAL = "Calendar_LunarFestival",
	NOBLEGARDEN = "Calendar_Noblegarden",
	CHILDRENS_WEEK = "Calendar_ChildrensWeek",
	MIDSUMMER_FESTIVAL = "Calendar_Midsummer",
	FIREWORKS = "calendar_fireworks", -- What is this used for?
	PIRATES_DAY = "Calendar_PiratesDay",
}

C.ARCHAEOLOGY_RACES = {
	DRUST = 1,
	ZANDALARI = 2,
	DEMONIC = 3,
	HIGHMOUNTAIN_TAUREN = 4,
	HIGHBORNE = 5,
	OGRE = 6,
	DRAENOR_CLANS = 7,
	ARAKKOA = 8,
	MOGU = 9,
	PANDAREN = 10,
	MANTID = 11,
	VRYKUL = 12,
	TROLL = 13,
	TOL_VIR = 14,
	ORC = 15,
	NERUBIAN = 16,
	NIGHT_ELF = 17,
	FOSSIL = 18,
	DRAENEI = 19,
	DWARF = 20,
}

-- This doesn't really belong here and needs streamlining anyway, but for now this is the best place.
-- Tooltip Filters (Note: Currently, this system is merely a stub. but more (and custom) filters may be added in the future)
-- These are used to decide whether the tooltip should be extended to display information about an CONSTANTS.ITEM_TYPES.ITEM for the NPCs listed in its tooltipNpcs table. Useful if we want to draw attention to an CONSTANTS.ITEM_TYPES.ITEM, but not every player can obtain it
local GetInstanceInfo = GetInstanceInfo
C.TOOLTIP_FILTERS = {
	IS_SPELL_KNOWN = IsSpellKnown,
	IS_PLAYER_IN_LFR = function()
		-- Returns true if the player is in a LFR instance
		local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID,
		      instanceGroupSize = GetInstanceInfo()
		return (difficulty == 7 or difficulty == 17) -- Legacy or regular LFR
	end,
}

-- Tooltip actions (used for modifiers)
-- Building on the previous system, this extension can be used to adjust tooltips dynamically without adding separate logic to the addon's core
C.TOOLTIP_ACTIONS = {
	OVERRIDE_TOOLTIP_NPCS = function(entry, newTooltipNpcs) -- Overwrites all tooltip NPCs
		-- Sanity checks
		if not (entry and type(entry) == "table" and newTooltipNpcs and type(newTooltipNpcs) == "number" or
				type(newTooltipNpcs) == "table") then
			Rarity:Debug("Action OVERRIDE_TOOLTIP_NPCS failed! Required parameters: entry, newTooltipNpcs")
			return
		end

		-- The tooltipNpcs field needs to be a table (for backwards compatibiliy) even if it's only one CONSTANTS.DETECTION_METHODS.NPC
		entry.tooltipNpcs = (type(newTooltipNpcs) == "table") and newTooltipNpcs or { newTooltipNpcs }
		return entry
	end,
}

C.Colors = {
	Red = { r = 1.0, g = 0.2, b = 0.2 },
	Blue = { r = 0.4, g = 0.4, b = 1.0 },
	Green = { r = 0.2, g = 1.0, b = 0.2 },
	Yellow = { r = 1.0, g = 1.0, b = 0.2 },
	Gray = { r = 0.5, g = 0.5, b = 0.5 },
	Black = { r = 0.0, g = 0.0, b = 0.0 },
	White = { r = 1.0, g = 1.0, b = 1.0 },
}

-- Legacy method of sharing constants (awkward, but better than not sharing them I guess)
-- DEPRECATED: Use Rarity.Enum instead
addonTable.constants = C

-- More consistent with Blizzard's method as of Shadowlands (global Enum table); it's probably easier to use, as well
Rarity.Enum = C
