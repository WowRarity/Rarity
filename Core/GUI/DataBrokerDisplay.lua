local _, addonTable = ...

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local dbicon = LibStub("LibDBIcon-1.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")

-- Upvalues
local R = Rarity
local GUI = Rarity.GUI
local CONSTANTS = addonTable.constants

--- WoW API
local GetItemInfo = _G.C_Item.GetItemInfo
local LoadAddOn = _G.C_AddOns.LoadAddOn

local dataobj = ldb:NewDataObject("Rarity", {
	type = "data source",
	text = L["Loading"],
	label = "Rarity",
	tocname = "Rarity",
	icon = [[Interface\Icons\spell_nature_forceofnature]],
})
GUI.dataobj = dataobj

function GUI:RegisterDataBroker()
	dbicon:Register("Rarity", dataobj, Rarity.db.profile.minimap)
end

function dataobj.OnEnter(self)
	Rarity.frame = self
	if Rarity.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_HOVER then
		Rarity.tooltipOpenDelay = true
		-- The following will queue opening of the tooltip based on a user set delay that triggers on mouseover.
		C_Timer.After(
			Rarity.db.profile.tooltipShowDelay or 0.1, -- Delay in seconds
			function()
				Rarity.GUI:ShowDelayedTooltip()
			end
		)
	else
		Rarity:ShowQuicktip()
	end
end

-- Helper function to open the Tooltip GUI unless the delayed opening has been aborted meanwhile.
function GUI:ShowDelayedTooltip()
	if Rarity.tooltipOpenDelay == true then
		Rarity:ShowTooltip()
	end
end

function dataobj.OnLeave(self)
	Rarity.tooltipOpenDelay = false -- Set false to abort any pending Tooltip openings that is called in ShowDelayedTooltip()
end

function dataobj:OnClick(button)
	self = Rarity
	local isRightButton = button == "RightButton"
	local isLeftButton = button == "LeftButton"

	if IsShiftKeyDown() and isLeftButton then
		Rarity:TryShowOptionsUI()
	elseif IsControlKeyDown() and isLeftButton then
		Rarity.GUI:SelectNextSortOrder()
	elseif
		(self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_CLICK and isRightButton)
		or (self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_HOVER and isLeftButton)
	then
		Rarity.GUI:ToggleProgressBar()
	elseif self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_CLICK and isLeftButton then
		if Rarity.Tooltips:IsTooltipAcquired("RarityTooltip") then
			Rarity:HideTooltip()
		else
			Rarity:HideQuicktip()
			Rarity:ShowTooltip()
		end
	end
end

function GUI:UpdateText()
	dataobj = self.dataobj

	self = Rarity

	if not Rarity.Caching:IsReady() then
		dataobj.text = L["Loading"]
			.. " ("
			.. format("%d%%", Rarity.Caching:GetPrimedItems() / Rarity.Caching:GetItemsToPrime() * 100)
			.. ")"
		return
	end

	self.Profiling:StartTimer("GUI.UpdateText")
	local attempts, dropChance, chance

	local trackedItem = Rarity.Tracking:GetTrackedItem(1)
	if not trackedItem or (trackedItem and not trackedItem.itemId) then
		dataobj.text = L["None"]
		return
	end

	-- Feed text
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
		GetItemInfo(trackedItem.itemId)
	if not itemTexture then
		dataobj.icon = [[Interface\Icons\spell_nature_forceofnature]]
	else
		dataobj.icon = itemTexture
	end
	attempts = 0
	if trackedItem.attempts then
		attempts = trackedItem.attempts
	end
	if trackedItem.lastAttempts then
		attempts = attempts - trackedItem.lastAttempts
	end
	if trackedItem.realAttempts and trackedItem.found and not trackedItem.repeatable then
		attempts = trackedItem.realAttempts
	end

	attempts = min(attempts, 2 ^ 31 - 1) -- Workaround to stop invalid attempt counts from breaking the addon; the correct count can be obtained by updating manually. It should also be restored automatically (at some point...) if the addon loads without errors. See issue: https://github.com/SacredDuckwhale/Rarity/issues/43) - This is mostly relevant for the two Archaeology mounts that may have invalid entries after the API was changed and not updated in the addon for quite some time

	if trackedItem.found and not trackedItem.repeatable then
		if trackedItem.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			dataobj.text = L["Collection complete!"]
		else
			if attempts == 1 then
				dataobj.text = format(L["Found on your first attempt!"], attempts)
			else
				dataobj.text = format(L["Found after %d attempts!"], attempts)
			end
		end
		chance = 100.0
	else
		if trackedItem.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			chance = (trackedItem.attempts or 0) / (trackedItem.chance or 100)
			if chance < 0 then
				chance = 0
			end
			if chance > 1 then
				chance = 1
			end
			chance = chance * 100
			dataobj.text = format(L["%d collected - %.2f%%"], attempts, chance)
		else
			dropChance = Rarity.Statistics.GetRealDropPercentage(trackedItem)
			chance = 100 * (1 - math.pow(1 - dropChance, attempts))
			if self.db.profile.feedText == CONSTANTS.LDB_TEXT_STYLES.FEED_MINIMAL then
				if attempts == 1 then
					dataobj.text = format(L["%d attempt"], attempts)
				else
					dataobj.text = format(L["%d attempts"], attempts)
				end
			elseif self.db.profile.feedText == CONSTANTS.LDB_TEXT_STYLES.FEED_VERBOSE then
				if attempts == 1 then
					dataobj.text = format(L["%s: %d attempt - %.2f%%"], itemLink or trackedItem.name, attempts, chance)
				else
					dataobj.text = format(L["%s: %d attempts - %.2f%%"], itemLink or trackedItem.name, attempts, chance)
				end
			else
				if attempts == 1 then
					dataobj.text = format(L["%d attempt - %.2f%%"], attempts, chance)
				else
					dataobj.text = format(L["%d attempts - %.2f%%"], attempts, chance)
				end
			end
		end
	end

	-- Update all progress bars using the new system
	Rarity.GUI:UpdateBars()
	self.Profiling:EndTimer("GUI.UpdateText")
end

function GUI:UpdateBars()
	self = Rarity

	-- Clear all existing bars
	for i = 1, 10 do -- Clear up to 10 bars
		self.barGroup:RemoveBar("Track" .. i)
	end

	-- Get all tracked items
	local allTrackedItems = Rarity.Tracking:GetTrackedItems()

	-- Create bars for each tracked item
	for i, itemId in ipairs(allTrackedItems) do
		local item = Rarity.Tracking:FindItemById(itemId)
		if item then
			local attempts, dropChance, chance = Rarity.GUI:CalculateItemStats(item)
			local itemName, _, _, _, _, _, _, _, _, itemTexture = GetItemInfo(item.itemId)

			local text = format("%s: %d (%.2f%%)", itemName or item.name, attempts, chance)

			self.barGroup:NewCounterBar(
				"Track" .. i,
				text,
				chance,
				100,
				itemTexture or [[Interface\Icons\spell_nature_forceofnature]]
			)
		end
	end

	-- Reapply group settings and color gradient
	Rarity.GUI:UpdateBar()
end

-- Helper function to calculate item statistics
function GUI:CalculateItemStats(item)
	local attempts = 0
	if item.attempts then
		attempts = item.attempts
	end
	if item.lastAttempts then
		attempts = attempts - item.lastAttempts
	end
	if item.realAttempts and item.found and not item.repeatable then
		attempts = item.realAttempts
	end

	attempts = min(attempts, 2 ^ 31 - 1)

	local chance = 0
	local dropChance
	if item.found and not item.repeatable then
		chance = 100.0
	else
		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			chance = (item.attempts or 0) / (item.chance or 100)
			if chance < 0 then
				chance = 0
			end
			if chance > 1 then
				chance = 1
			end
			chance = chance * 100
		else
			dropChance = Rarity.Statistics.GetRealDropPercentage(item)
			chance = 100 * (1 - math.pow(1 - dropChance, attempts))
		end
	end

	if not chance then
		chance = 0
	end
	if chance > 100 then
		chance = 100
	end
	if chance < 0 then
		chance = 0
	end

	return attempts, dropChance, chance
end
