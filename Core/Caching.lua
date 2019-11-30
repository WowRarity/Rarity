local _, addonTable = ...


local Caching = {}


-- Upvalues
local UnitFactionGroup = UnitFactionGroup


function Caching:IsHorde()
	if Rarity.isHorde == nil then
		local englishFaction, localizedFaction = UnitFactionGroup("player")
		if englishFaction == "Horde" then Rarity.isHorde = true else Rarity.isHorde = false end
	end
	return Rarity.isHorde
end


Rarity.Caching = Caching
return Caching