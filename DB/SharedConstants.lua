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
