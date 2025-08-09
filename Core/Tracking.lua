local _, addonTable = ...

--- Tracking.lua
-- TODO: LuaDoc
local Tracking = {}

-- Globals
local R = Rarity
-- Locals
local trackedItems = {} -- Simple array of item IDs
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
	if trackedItems[index] then
		-- Look up the actual item data from the groups
		return self:FindItemById(trackedItems[index])
	end
	return nil
end

function Tracking:GetTrackedItems()
	return trackedItems
end

function Tracking:AddTrackedItem(item)
	if not item or not item.itemId then
		return
	end

	-- Check if already tracking
	for i, id in ipairs(trackedItems) do
		if id == item.itemId then
			return -- Already tracking
		end
	end

	-- Add to the end
	table.insert(trackedItems, item.itemId)

	-- Enforce max elements (use existing bar system)
	local maxElements = Rarity.db.profile.bar.maxElements or 25
	if #trackedItems > maxElements then
		table.remove(trackedItems, 1) -- Remove oldest
	end

	-- Save to database
	Rarity.db.profile.trackedItems = trackedItems

	-- Update the GUI
	Rarity.GUI:UpdateText()
end

function Tracking:RemoveTrackedItem(itemId)
	for i, id in ipairs(trackedItems) do
		if id == itemId then
			table.remove(trackedItems, i)
			-- Save to database
			Rarity.db.profile.trackedItems = trackedItems
			Rarity.GUI:UpdateText()
			break
		end
	end
end

-- Helper function to find item data
function Tracking:FindItemById(itemId)
	self = Rarity
	for groupName, group in pairs(self.db.profile.groups) do
		if type(group) == "table" then
			for itemName, item in pairs(group) do
				if type(item) == "table" and item.itemId == itemId then
					return item
				end
			end
		end
	end
	return nil
end

function Tracking:Update(item)
	self = Rarity
	self.Profiling:StartTimer("Tracking.Update")

	if not item or not item.itemId then
		return
	end

	-- Use the new simple system
	Rarity.Tracking:AddTrackedItem(item)

	self.Profiling:EndTimer("Tracking.Update")
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

	-- Load saved tracked items from database
	if self.db.profile.trackedItems and type(self.db.profile.trackedItems) == "table" then
		trackedItems = self.db.profile.trackedItems
	else
		-- Initialize empty array if no saved data
		trackedItems = {}
	end

	-- Initialize with default item if no tracked items exist
	if #trackedItems == 0 then
		local defaultItem = self.db.profile.groups.pets["Parrot Cage (Hyacinth Macaw)"]
		if defaultItem then
			Rarity.Tracking:AddTrackedItem(defaultItem)
		end
	end

	-- Legacy support: Load old single trackedItem if no new array exists
	if #trackedItems == 0 and self.db.profile.trackedItem then
		local item = Rarity.Tracking:FindItemById(self.db.profile.trackedItem)
		if item then
			Rarity.Tracking:AddTrackedItem(item)
		end
	end
end

Rarity.Tracking = Tracking
return Tracking
