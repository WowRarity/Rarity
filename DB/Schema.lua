local Item = Rarity.Item

local DatabaseSchema = {}

function DatabaseSchema:IsValidItem(entry)
	if not Item:HasAllRequiredFields(entry) then
		Rarity:Print("Required fields are missing")
		return false
	end

	if not Item:IsPersonalLoot(entry) then
		Rarity:Print("Personal loot settings are inconsistent")
		return false
	end

	if not Item:HasOnlyValidFields(entry) then
		Rarity:Print("Unsupported fields are set")
		return false
	end

	if Item:IsHolidayItem(entry) and not Item:IsValidHolidayItem(entry) then
		Rarity:Print("Holiday event settings are inconsistent")
		return false
	end

	if not Item:IsHolidayItem(entry) and Item:IsUsingHolidayProperties(entry) then
		Rarity:Print("Found item using holiday properties, but it's not a holiday item")
		return false
	end

	if Item:IsCollectionItem(entry) and not Item:IsValidCollectionItem(entry) then
		Rarity:Print("Item is using Collection method, but the collectedItemId is not set correctly")
		return false
	end

	if Item:IsArchaeologyItem(entry) and not Item:IsValidArchaeologyItem(entry) then
		Rarity:Print("Archaeology settings are inconsistent")
		return false
	end

	if Item:HasUseMethod(entry) and not Item:IsValidUseMethodItem(entry) then
		Rarity:Print("Found item with use method, but the containers (field:items) are not set or are invalid.")
		return false
	end

	if Item:IsCovenantSpecificItem(entry) and not Item:IsValidCovenantItem(entry) then
		Rarity:Print("Covenant settings are inconsistent")
		return false
	end

	if Item:IsZoneItem(entry) and not Item:IsValidZoneItem(entry) then
		Rarity:Print("Item is using method for 'any mob in a zone' detection, but the Zones are not set correctly")
		return false
	end

	if Item:IsFishingItem(entry) and not Item:IsValidFishingItem(entry) then
		Rarity:Print("Found Fishing item, but the Zones to track in are not set correctly")
		return false
	end

	if Item:HasNPCMethod(entry) and not Item:IsValidNPCItem(entry) then
		Rarity:Print("Found item using NPC method, but the list of NPCs to track is invalid")
		return false
	end

	if Item:HasBossMethod(entry) and not Item:IsValidNPCItem(entry) then
		Rarity:Print("Found item using BOSS method, but the list of NPCs to track is invalid")
		return false
	end

	if Item:HasWaypointData(entry) and not Item:HasValidWaypoints(entry) then
		Rarity:Print("Waypoint data is inconsistent")
		return false
	end

	if not Item:HasWaypointData(entry) then
		Rarity:Print("Waypoint (zone) data is missing")
		return false
	end

	return true
end

function DatabaseSchema:IsValidPet(entry)
	if not Item:IsPet(entry) then
		Rarity:Print("Item is not of type PET")
		return false
	end

	if not entry.spellId then
		Rarity:Print("Expected field spellId is missing")
		return false
	end

	if not entry.creatureId then
		Rarity:Print("Expected field creatureId is missing")
		return false
	end

	return true
end

function DatabaseSchema:IsValidMount(entry)
	if not Item:IsMount(entry) then
		Rarity:Print("Item is not of type MOUNT")
		return false
	end

	if not entry.spellId then
		Rarity:Print("Expected field spellId is missing")
		return false
	end

	return true
end

Rarity.DatabaseSchema = DatabaseSchema
