local addonName, addonTable = ...

-- Set up shared constants (for ease of use, mainly)
addonTable.constants = addonTable.constants or {}

local C = addonTable.constants

-- Misc. stuff for the detailed lockout storage / defeat detection
C.DEFEAT_DETECTION = {
	MODE_OR = 1,
	MODE_AND = 2,
}

-- Embedded mapIDs: It's best to avoid hardcoding these in case of yet another re-mapping on Blizzard's end...
C.UIMAPIDS = {
	
	ARATHI_HIGHLANDS = 14,
	DARKSHORE = 62,
	
	FROSTFIRE_RIDGE = 525,
	
	KROKUUN = 830,
	MACAREE = 882,
	ANTORAN_WASTES = 885,

}

-- Types of items
C.ITEM_TYPES = {
	MOUNT = "MOUNT",
	PET = "PET",
	ITEM = "ITEM",
}

-- Instance difficulties
C.INSTANCE_DIFFICULTIES = {
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

addonTable.constants = C