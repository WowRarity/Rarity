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

	if not Item:HasZone(entry) then
		Rarity:Print("Zone is missing")
		return false
	end

	if Item:IsCollectionItem(entry) and not Item:IsUsingCollectionProperties(entry) then
		Rarity:Print("Collection settings are inconsistent")
		return false
	end

	if not Item:IsCollectionItem(entry) and Item:IsUsingCollectionProperties(entry) then
		Rarity:Print("Found item using collection properties, but it's not a collection item")
		return false
	end

	if Item:IsArchaeologyItem(entry) and not Item:IsUsingArchaeologyProperties(entry) then
		Rarity:Print("Archaeology settings are inconsistent")
		return false
	end

	if not Item:IsArchaeologyItem(entry) and Item:IsUsingArchaeologyProperties(entry) then
		Rarity:Print("Found item using Archaeology properties, but it's not a Archaeology item")
		return false
	end

	if Item:HasUseMethod(entry) and not Item:HasUseMethodProperties(entry) then
		Rarity:Print("Found item with use method, but it isn't assigned any items to use.")
		return false
	end

	if not Item:HasUseMethod(entry) and Item:HasUseMethodProperties(entry) then
		Rarity:Print("Found item with properties belonging to the use method, but it's not right method.")
		return false
	end

	if Item:IsCovenantSpecificItem(entry) and not Item:IsUsingCovenantProperties(entry) then
		Rarity:Print("Covenant settings are inconsistent")
		return false
	end

	if not Item:IsCovenantSpecificItem(entry) and Item:IsUsingCovenantProperties(entry) then
		Rarity:Print("Found item using Covenant properties, but it's not a Covenant specific item")
		return false
	end

	if Item:IsZoneItem(entry) and not Item:IsUsingZoneProperties(entry) then
		Rarity:Print("Zone settings are inconsistent")
		return false
	end

	if Item:IsFishingItem(entry) and not Item:IsUsingFishingProperties(entry) and not Item:IsUsingZoneProperties(entry) then
		Rarity:Print("Fishing settings are inconsistent")
		return false
	end

	if not Item:IsFishingItem(entry) and Item:IsUsingFishingProperties(entry) then
		Rarity:Print("Found item using fishing properties, but it's not a fishing item")
		return false
	end

	if Item:IsUsingZoneProperties(entry) and not (Item:IsZoneItem(entry) or Item:IsFishingItem(entry)) then
		Rarity:Print("Found item using zone properties, but it's not a zone or fishing item")
		return false
	end

	if Item:HasNPCMethod(entry) and not Item:IsUsingNPCProperties(entry) then
		Rarity:Print("NPC settings are inconsistent")
		return false
	end

	if Item:HasBossMethod(entry) and not Item:IsUsingNPCProperties(entry) then
		Rarity:Print("BOSS settings are inconsistent")
		return false
	end

	if Item:IsUsingNPCProperties(entry) and not (Item:HasNPCMethod(entry) or Item:HasBossMethod(entry) or Item:HasSpecialMethod(entry)) then
		Rarity:Print("Found item using NPC properties, but it's not a BOSS or NPC item")
		return false
	end

	if Item:IsUsingCoordsProperties(entry) then
		if not Item:HasBothXYCoordinates(entry) then
			Rarity:Print("X/Y coordinates are inconsistent")
			return false
		end
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
