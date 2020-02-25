local _, addonTable = ...

--- Tracking.lua
-- TODO: LuaDoc
local Tracking = {}

-- Globals
local R = Rarity
-- Locals
local trackedItems = {}
local lastAttemptItem
local lastAttemptTime
-- WOW APIs
local format = format
local GetTime = GetTime
-- Constants
local DUAL_TRACK_THRESHOLD = 5 -- TODO: No idea what this number is supposed to mean...
Tracking.DUAL_TRACK_THRESHOLD = DUAL_TRACK_THRESHOLD

-- Returns the first tracked item by default
function Tracking:GetTrackedItem(index)
	index = index or 1
	return trackedItems[index]
end

function Tracking:GetTrackedItems()
	return trackedItems
end

-- Default: First item (only two were originally supported)
-- Note: If there are multiple, empty entries in between might cause weirdness.
-- But that's a problem for later... Right now there's always one, and sometimes a second one
function Tracking:SetTrackedItem(item, index)
	if not item then
		Rarity:Debug("Usage: SetTrackedItem(item, [index]")
		return
	end

	index = index or 1

	local itemID = item.itemId
	local itemName = item.name
	Rarity:Debug("Setting tracked item to " .. tostring(itemID) .. " (" .. tostring(itemName) .. ")")

	trackedItems[index] = item
end

function Tracking:Update(item)
	self = Rarity
	local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)
	self:ProfileStart2()
	if not item or not item.itemId then
		return
	end
	if self.db.profile.trackedItem == item.itemId then
		return
	end -- Already tracking this item
	self.db.profile.trackedItem = item.itemId
	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.itemId == item.itemId then
						self.db.profile.trackedGroup = k
					end
				end
			end
		end
	end
	Rarity.Tracking:FindTrackedItem()
	if lastAttemptItem and lastAttemptItem ~= item and GetTime() - (lastAttemptTime or 0) <= DUAL_TRACK_THRESHOLD then
		Rarity.Tracking:SetTrackedItem(lastAttemptItem, 2)
		self:Debug("Setting second tracked item to " .. lastAttemptItem.name)
	else
		if trackedItem2 then
			self:Debug("Clearing second tracked item")
			Rarity.Tracking:SetTrackedItem(nil, 2)
		end
	end
	Rarity.GUI:UpdateText()
	--if self:InTooltip() then self:ShowTooltip() end
	self:ProfileStop2("UpdateTrackedItem: %fms")
end

function Tracking:SetLastAttemptItem(item)
	lastAttemptItem = item
end

function Tracking:GetLastAttemptItem()
	return lastAttemptItem
end

function Tracking:SetLastAttemptTime(time)
	lastAttemptTime = time
end

function Tracking:GetLastAttemptTime()
	return lastAttemptTime
end

-- Sets the tracked item stored in the SavedVariables
-- TODO: What's up with the Hyacinth Macaw? Leaving it at "None" might be a better default?
function Tracking:FindTrackedItem()
	self = Rarity
	Rarity.Tracking:SetTrackedItem(self.db.profile.groups.pets["Parrot Cage (Hyacinth Macaw)"])

	local trackedItem = Rarity.Tracking:GetTrackedItem()
	if self.db.profile.trackedGroup and self.db.profile.groups[self.db.profile.trackedGroup] then
		if self.db.profile.trackedItem then
			for k, v in pairs(self.db.profile.groups[self.db.profile.trackedGroup]) do
				if type(v) == "table" and v.itemId and v.itemId == self.db.profile.trackedItem then
					Rarity.Tracking:SetTrackedItem(v)
					if self.db.profile.debugMode then
						self:Debug("Setting first tracked item to " .. v.name)
						R.trackedItem = trackedItem -- This seems entirely pointless?
					end
					return v
				end
			end
		end
	end
end

Rarity.Tracking = Tracking
return Tracking
