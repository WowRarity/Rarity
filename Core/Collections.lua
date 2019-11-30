local _, addonTable = ...

local Collections = {}

-- Upvalues
local R = Rarity
-- Lua APIs
local pairs = pairs
local type = type
local select = select
-- WOW APIs
local PlayerHasToy = PlayerHasToy
local C_TransmogCollection = C_TransmogCollection

function Collections:ScanTransmog(reason)
	self = Rarity
	self:Debug("Scanning transmog (" .. (reason or "") .. ")")

	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.itemId and not vv.repeatable and select(2, C_TransmogCollection.GetItemInfo(vv.itemId)) then -- Don't scan for items that aren't gear that have a transmog collection appearance
						if C_TransmogCollection.PlayerHasTransmog(vv.itemId) then -- You have the appearance of the item you're tracking
							vv.known = true
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end
end

function Collections:ScanToys(reason)
	self = Rarity
	self:Debug("Scanning toys (" .. (reason or "") .. ")")

	-- Load the Collections add-on if needed
	if not Rarity.toysScanned then
		if not ToyBox_OnLoad then
			self:Debug("Loading Blizzard_Collections addon so the ToyBox can be scanned")
			UIParentLoadAddOn("Blizzard_Collections")
		end
	end

	-- Scan all Rarity items to see if we already have a toy
	Rarity.toysScanned = true
	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.itemId and not vv.repeatable then
						if PlayerHasToy(vv.itemId) then
							vv.known = true
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end
end

Rarity.Collections = Collections
return Collections
