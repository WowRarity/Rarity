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
