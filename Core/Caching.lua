local _, addonTable = ...

local Caching = {}

-- Locals
local IsInitializing = true
local itemsPrimed = 0
local itemsToPrime = 100
local playerClass
-- Upvalues
local UnitFactionGroup = UnitFactionGroup

function Caching:IsHorde()
	if Rarity.isHorde == nil then
		local englishFaction, localizedFaction = UnitFactionGroup("player")
		if englishFaction == "Horde" then
			Rarity.isHorde = true
		else
			Rarity.isHorde = false
		end
	end
	return Rarity.isHorde
end

function Caching:IsAlliance()
	if Rarity.isAlliance == nil then
		local englishFaction, localizedFaction = UnitFactionGroup("player")
		if englishFaction == "Alliance" then
			Rarity.isAlliance = true
		else
			Rarity.isAlliance = false
		end
	end
	return Rarity.isAlliance
end

function Caching:IsReady()
	return not IsInitializing
end

function Caching:SetReadyState(status)
	IsInitializing = not status
end

function Caching:SetPrimedItems(number)
	itemsPrimed = number
end

function Caching:GetPrimedItems()
	return itemsPrimed
end

function Caching:SetItemsToPrime(number)
	itemsToPrime = number
end

function Caching:GetItemsToPrime()
	return itemsToPrime
end

function Caching:GetPlayerClass()
	return playerClass
end

function Caching:SetPlayerClass(class)
	playerClass = class
end

Rarity.Caching = Caching
return Caching
