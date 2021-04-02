local _, addonTable = ...

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local dbicon = LibStub("LibDBIcon-1.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local qtip = LibStub("LibQTip-1.0")

-- Upvalues
local R = Rarity
local GUI = Rarity.GUI
local CONSTANTS = addonTable.constants

local dataobj =
	ldb:NewDataObject(
	"Rarity",
	{
		type = "data source",
		text = L["Loading"],
		label = "Rarity",
		tocname = "Rarity",
		icon = [[Interface\Icons\spell_nature_forceofnature]]
	}
)
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
				Rarity:ShowDelayedTooltip()
			end
		)
	else
		Rarity:ShowQuicktip()
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
		-- Show options
		Rarity:Debug("Loading Rarity_Options addon")
		LoadAddOn("Rarity_Options")
		if R.optionsFrame then
			-- Thanks, Blizzard (https://www.wowinterface.com/forums/showthread.php?t=54599)
			InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
			InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
		else
			R:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		end
	elseif IsControlKeyDown() and isLeftButton then
		Rarity.GUI:SelectNextSortOrder()
	elseif
		((self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_CLICK and isRightButton) or
			(self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_HOVER and isLeftButton))
	 then
		-- Toggle progress bar visibility
		R.db.profile.bar.visible = not R.db.profile.bar.visible
		Rarity.GUI:UpdateBar()
		Rarity.GUI:UpdateText()
	elseif self.db.profile.tooltipActivation == CONSTANTS.TOOLTIP.ACTIVATION_METHOD_CLICK and isLeftButton then
		if qtip:IsAcquired("RarityTooltip") then
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
		dataobj.text =
			L["Loading"] ..
			" (" .. format("%d%%", Rarity.Caching:GetPrimedItems() / Rarity.Caching:GetItemsToPrime() * 100) .. ")"
		return
	end

	self:ProfileStart()
	local attempts, dropChance, chance

	local trackedItem = Rarity.Tracking:GetTrackedItem(1)
	if not trackedItem or (trackedItem and not trackedItem.itemId) then
		dataobj.text = L["None"]
		return
	end

	-- Feed text
	local itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(trackedItem.itemId)
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

	-- Bar 1
	if not chance then
		chance = 0
	end
	if chance > 100 then
		chance = 100
	end
	if chance < 0 then
		chance = 0
	end
	local text = format("%s: %d (%.2f%%)", itemName or trackedItem.name, attempts, chance)
	if not self.bar then
		self.bar =
			self.barGroup:NewCounterBar(
			"Track",
			text,
			chance,
			100,
			itemTexture or [[Interface\Icons\spell_nature_forceofnature]]
		)
	else
		self.bar:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
		self.bar:SetLabel(text)
		self.bar:SetValue(chance, 100)
	end
	if self.hadBarTwo then -- If we've transitioning from 2 bars to 1, hiding/showing the bars collapses them
		self.barGroup:Hide()
		if self.db.profile.bar.visible then
			self.barGroup:Show()
		end
	end

	-- Bar 2
	local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)
	if trackedItem2 == nil or trackedItem2.itemId == nil then
		self.barGroup:RemoveBar("Track2")
		self.bar2 = nil
	else
		self.hadBarTwo = true
		_, -- itemName,
			_, -- itemLink,
			itemRarity,
			itemLevel,
			itemMinLevel,
			itemType,
			itemSubType,
			itemStackCount,
			itemEquipLoc,
			itemTexture,
			itemSellPrice = GetItemInfo(trackedItem2.itemId)
		attempts = 0
		if trackedItem2.attempts then
			attempts = trackedItem2.attempts
		end
		if trackedItem2.lastAttempts then
			attempts = attempts - trackedItem2.lastAttempts
		end
		if trackedItem2.realAttempts and trackedItem2.found and not trackedItem2.repeatable then
			attempts = trackedItem2.realAttempts
		end
		if trackedItem2.found and not trackedItem2.repeatable then
			chance = 1.0
		else
			if trackedItem2.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
				chance = (trackedItem2.attempts or 0) / (trackedItem2.chance or 100)
				if chance < 0 then
					chance = 0
				end
				if chance > 1 then
					chance = 1
				end
				chance = chance * 100
			else
				dropChance = Rarity.Statistics.GetRealDropPercentage(trackedItem2)
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
		text = format("%s: %d (%.2f%%)", trackedItem2.name or "", attempts, chance)
		if not self.bar2 then
			self.bar2 =
				self.barGroup:NewCounterBar(
				"Track2",
				text,
				chance,
				100,
				itemTexture or [[Interface\Icons\spell_nature_forceofnature]]
			)
		else
			self.bar2:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
			self.bar2:SetLabel(text)
			self.bar2:SetValue(chance, 100)
		end
	end
	self:ProfileStop("UpdateText: %fms")
end
