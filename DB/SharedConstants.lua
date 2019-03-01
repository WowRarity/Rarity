local addonName, addonTable = ...

-- Set up shared constants (for ease of use, mainly)
addonTable.constants = addonTable.constants or {}

local C = addonTable.constants

-- Misc. stuff for the detailed lockout storage / defeat detection
C.DEFEAT_DETECTION = {
	MODE_OR = 1,
	MODE_AND = 2,
}

addonTable.constants = C
-- Embedded mapIDs: It's best to avoid hardcoding these in case of yet another re-mapping on Blizzard's end...
C.UIMAPIDS = {
	
	ARATHI_HIGHLANDS = 14,
	DARKSHORE = 62,
	
	FROSTFIRE_RIDGE = 525,
	
	KROKUUN = 830,
	MACAREE = 882,
	ANTORAN_WASTES = 885,

}
