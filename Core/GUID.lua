local _, addonTable = ...

local GUID = {}

function Rarity:GetNPCIDFromGUID(guid)
	if guid then
		local unit_type, _, _, _, _, mob_id = strsplit("-", guid)
		if unit_type == "Pet" or unit_type == "Player" then
			return 0
		end
		return (guid and mob_id and tonumber(mob_id)) or 0
	end
	return 0
end

return GUID