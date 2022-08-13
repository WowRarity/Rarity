-- This is just a stub and could be turned into a proper test later, if needed
local UNIT_TYPES = {
	CREATURE = "Creature",
	PET = "Pet",
	GAME_OBJECT = "GameObject",
	VEHICLE = "Vehicle",
	VIGNETTE = "Vignette",
}

local UNIT_GUID_SEPARATOR = "-"
-- GUID Format: <unitType>-<token2>-<...> etc
local FIND_FIRST_GUID_TOKEN_PATTERN = "([^-]+)%" .. UNIT_GUID_SEPARATOR

local someUnitGUID = "Creature-0-1465-0-2105-448-000043F59F" -- Post-WOD format; before that the unitType was a number (now enum)?
local unitType = someUnitGUID:match(FIND_FIRST_GUID_TOKEN_PATTERN)

assert(unitType == UNIT_TYPES.CREATURE, "Expected unit type Creature, but actually it's " .. tostring(unitType))
