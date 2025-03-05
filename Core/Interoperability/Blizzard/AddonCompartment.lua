local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

--- WoW API
local LoadAddOn = _G.C_AddOns.LoadAddOn

local AddonCompartment = {}

function AddonCompartment.OnClick()
	Rarity:TryShowOptionsUI()
end

function AddonCompartment.OnEnter()
	-- Might want to display a tooltip here if the behavior differs from the default /rarity slash command
end

function AddonCompartment.OnLeave()
	-- Might want to display a tooltip here if the behavior differs from the default /rarity slash command
end

-- No way around polluting the global namespace for these, AFAICT
_G.Rarity_OnAddonCompartmentClick = AddonCompartment.OnClick
_G.Rarity_OnAddonCompartmentEnter = AddonCompartment.OnEnter
_G.Rarity_OnAddonCompartmentLeave = AddonCompartment.OnLeave

Rarity.AddonCompartment = AddonCompartment
