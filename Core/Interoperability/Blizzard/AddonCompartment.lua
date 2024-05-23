local AddonCompartment = {}

function AddonCompartment.OnClick()
	print("[Placeholder] Rarity.AddonCompartment.OnClick triggered")
end

function AddonCompartment.OnEnter()
	print("[Placeholder] Rarity.AddonCompartment.OnEnter triggered")
end

function AddonCompartment.OnLeave()
	print("[Placeholder] Rarity.AddonCompartment.OnLeave triggered")
end

-- No way around polluting the global namespace for these, AFAICT
_G.Rarity_OnAddonCompartmentClick = AddonCompartment.OnClick
_G.Rarity_OnAddonCompartmentEnter = AddonCompartment.OnEnter
_G.Rarity_OnAddonCompartmentLeave = AddonCompartment.OnLeave

Rarity.AddonCompartment = AddonCompartment
