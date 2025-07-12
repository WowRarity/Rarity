local _, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Get Constants from addon table
local Constants = addonTable.TabbedWindowModules and addonTable.TabbedWindowModules.Constants

-- Upvalues
local R = Rarity

-- Get DataManager from addon table (will be available since loaded first)
local DataManager = addonTable.TabbedWindowModules and addonTable.TabbedWindowModules.DataManager
local colorize = Rarity.Utils.String.Colorize

local EventHandler = {}

-- Initialize event handler
function EventHandler:Initialize(windowController)
	self.windowController = windowController
	self.dataManager = DataManager
	self.activeTooltip = nil
end

-- Item button enter event
function EventHandler:OnItemButtonEnter(button)
	if not button or not button.itemData then
		return
	end

	-- Create tooltip if needed
	if not self.activeTooltip and R and R.Tooltips then
		self.activeTooltip = R.Tooltips:AcquireTooltip("RarityItemTooltip", 2, "LEFT", "RIGHT")
	end

	-- Position and show tooltip
	if self.activeTooltip then
		self.activeTooltip:ClearAllPoints()
		self.activeTooltip:SetPoint("LEFT", button, "RIGHT", Constants.TOOLTIP.OFFSET_X, Constants.TOOLTIP.OFFSET_Y)
		self:PopulateTooltip(button.itemData)
	end
end

-- Item button leave event
function EventHandler:OnItemButtonLeave(button)
	if self.activeTooltip then
		self.activeTooltip:Hide()
		if R and R.Tooltips then
			R.Tooltips:ReleaseTooltip(self.activeTooltip)
		end
		self.activeTooltip = nil
	end
end

-- Item button click event
function EventHandler:OnItemButtonClick(button, mouseButton)
	if not button or not button.itemData then
		return
	end

	local item = button.itemData

	-- Handle modifier key combinations
	if IsShiftKeyDown() then
		self:HandleShiftClick(item)
	elseif IsControlKeyDown() then
		self:HandleControlClick(item)
	elseif mouseButton == "LeftButton" then
		self:HandleLeftClick(item)
	elseif mouseButton == "RightButton" then
		self:HandleRightClick(item)
	end
end

-- Handle Shift+Click (link to chat)
function EventHandler:HandleShiftClick(item)
	if not item or not item.itemId then
		return
	end

	local linkText = self.dataManager:GetProgressLinkText(item)
	if linkText and linkText ~= "" then
		ChatEdit_InsertLink(linkText)
	end
end

-- Handle Ctrl+Click (create waypoints)
function EventHandler:HandleControlClick(item)
	if not item or not TomTom or not TomTom.AddWaypoint then
		return
	end

	local waypoints = self.dataManager:GetWaypointData(item)
	local added = 0

	for _, waypoint in ipairs(waypoints) do
		local success = pcall(TomTom.AddWaypoint, TomTom, waypoint.mapID, waypoint.x, waypoint.y, {
			title = waypoint.title,
			source = waypoint.source,
		})

		if success then
			added = added + 1
		end
	end

	if added > 0 and R and R.Print then
		R:Print(format(L["Added %d waypoint(s) for %s"], added, item.name or L["Unknown"]))
	end
end

-- Handle Left Click (toggle tracking)
function EventHandler:HandleLeftClick(item)
	if not item or not R or not R.Tracking then
		return
	end

	local isTracked = self:IsItemTracked(item)

	if isTracked then
		self:RemoveFromTracking(item)
	else
		self:AddToTracking(item)
	end

	-- Refresh display
	if self.windowController and self.windowController.RefreshContent then
		self.windowController:RefreshContent()
	end
end

-- Handle Right Click (show context menu)
function EventHandler:HandleRightClick(item)
	-- Could implement context menu here
	-- For now, treat as left click
	self:HandleLeftClick(item)
end

-- Check if item is tracked
function EventHandler:IsItemTracked(item)
	if not item or not item.itemId or not R or not R.Tracking then
		return false
	end

	local allTrackedItems = R.Tracking:GetTrackedItems()
	if not allTrackedItems then
		return false
	end

	for _, trackedItemId in ipairs(allTrackedItems) do
		if trackedItemId == item.itemId then
			return true
		end
	end

	return false
end

-- Add item to tracking
function EventHandler:AddToTracking(item)
	if not item or not R or not R.Tracking then
		return
	end

	local success = pcall(R.Tracking.AddTrackedItem, R.Tracking, item)
	if success and R.Print then
		R:Print(format(L["Now tracking %s"], item.name or L["Unknown"]))
	end
end

-- Remove item from tracking
function EventHandler:RemoveFromTracking(item)
	if not item or not item.itemId or not R or not R.Tracking then
		return
	end

	local success = pcall(R.Tracking.RemoveTrackedItem, R.Tracking, item.itemId)
	if success and R.Print then
		R:Print(format(L["No longer tracking %s"], item.name or L["Unknown"]))
	end
end

-- Populate tooltip with item data
function EventHandler:PopulateTooltip(item)
	if not item or not self.activeTooltip then
		return
	end

	local tooltip = self.activeTooltip
	tooltip:Clear()

	-- Get tooltip data
	local tooltipData = self.dataManager:GetTooltipData(item)
	if not tooltipData then
		return
	end

	-- Header with item name and icon
	local headerText = tooltipData.itemLink or item.name or L["Unknown"]
	if tooltipData.itemTexture then
		tooltip:AddHeader(headerText, "|T" .. tooltipData.itemTexture .. ":22|t")
	else
		tooltip:AddHeader(headerText)
	end

	-- Basic item information
	self:AddBasicItemInfo(tooltip, item, tooltipData)

	-- Current session info
	self:AddSessionInfo(tooltip, item, tooltipData)

	-- Zone information
	self:AddZoneInfo(tooltip, tooltipData)

	-- Instructions
	self:AddInstructions(tooltip, item)

	tooltip:Show()
end

-- Add basic item information to tooltip
function EventHandler:AddBasicItemInfo(tooltip, item, tooltipData)
	if item.method == addonTable.constants.DETECTION_METHODS.COLLECTION then
		tooltip:AddLine(
			colorize(
				format(L["Collect %d %s"], item.chance or 100, tooltipData.itemName or item.name),
				Constants.COLORS.HEADER_TEXT
			)
		)
	else
		tooltip:AddLine(colorize(format(L["1 in %d chance"], item.chance or 100), Constants.COLORS.HEADER_TEXT))
	end

	if item.method ~= addonTable.constants.DETECTION_METHODS.COLLECTION and tooltipData.medianLoots then
		tooltip:AddLine(
			colorize(
				format(L["Lucky if you obtain in %d or less"], tooltipData.medianLoots),
				Constants.COLORS.ZONE_TEXT
			)
		)
	end
end

-- Add session information to tooltip
function EventHandler:AddSessionInfo(tooltip, item, tooltipData)
	tooltip:AddSeparator(1, 1, 1, 1, 1)
	tooltip:AddLine(colorize(L["Current Session"], Constants.COLORS.SEARCH_LABEL_TEXT))

	if item.method == addonTable.constants.DETECTION_METHODS.COLLECTION then
		tooltip:AddLine(format(L["Collected"] .. ": %d", tooltipData.attempts))
		if tooltipData.attempts > 0 then
			local collectionChance = 100 * (tooltipData.attempts / (item.chance or 100))
			collectionChance = math.min(100, math.max(0, collectionChance))
			tooltip:AddLine(format(L["Progress"] .. ": %.2f%%", collectionChance))
		end
	else
		tooltip:AddLine(format(L["Attempts"] .. ": %d", tooltipData.attempts))
		if tooltipData.attempts > 0 then
			tooltip:AddLine(format(L["Chance so far"] .. ": %.2f%%", tooltipData.likelihood))
		end
	end
end

-- Add zone information to tooltip
function EventHandler:AddZoneInfo(tooltip, tooltipData)
	if tooltipData.zoneText and tooltipData.zoneText ~= "" then
		tooltip:AddSeparator(1, 1, 1, 1, 1)
		tooltip:AddLine(L["Found in: "] .. colorize(tooltipData.zoneText, Constants.COLORS.HEADER_TEXT))
	end
end

-- Add instructions to tooltip
function EventHandler:AddInstructions(tooltip, item)
	tooltip:AddSeparator(1, 1, 1, 1, 1)
	tooltip:AddLine(colorize(L["Click to track/untrack this item"], Constants.COLORS.ZONE_TEXT))
	tooltip:AddLine(colorize(L["Shift-Click to link your progress to chat"], Constants.COLORS.ZONE_TEXT))

	if item.coords and TomTom and TomTom.AddWaypoint then
		tooltip:AddLine(colorize(L["Ctrl-Click to create TomTom waypoint(s)"], Constants.COLORS.ZONE_TEXT))
	end
end

-- Search text changed event
function EventHandler:OnSearchTextChanged(text)
	if not self.windowController then
		return
	end

	-- Update filter and refresh
	self.windowController.filterText = text or ""
	self.windowController.currentPage = 1

	if self.windowController.RefreshContent then
		self.windowController:RefreshContent()
	end
end

-- Tab selection event
function EventHandler:OnTabSelected(tabIndex)
	if not self.windowController then
		return
	end

	-- Update tab appearance
	self:UpdateTabAppearance(tabIndex)

	-- Update window state
	self.windowController.currentTab = tabIndex
	self.windowController.currentPage = 1

	-- Refresh content
	if self.windowController.RefreshContent then
		self.windowController:RefreshContent()
	end
end

-- Update tab appearance
function EventHandler:UpdateTabAppearance(selectedIndex)
	if not self.windowController or not self.windowController.tabs then
		return
	end

	for i, tab in ipairs(self.windowController.tabs) do
		if i == selectedIndex then
			PanelTemplates_SelectTab(tab)
		else
			PanelTemplates_DeselectTab(tab)
		end
	end
end

-- Pagination events
function EventHandler:OnPreviousPage()
	if not self.windowController then
		return
	end

	if self.windowController.currentPage > 1 then
		self.windowController.currentPage = self.windowController.currentPage - 1
		if self.windowController.RefreshContent then
			self.windowController:RefreshContent()
		end
	end
end

function EventHandler:OnNextPage()
	if not self.windowController then
		return
	end

	if self.windowController.currentPage < (self.windowController.maxPages or 1) then
		self.windowController.currentPage = self.windowController.currentPage + 1
		if self.windowController.RefreshContent then
			self.windowController:RefreshContent()
		end
	end
end

-- Item button population
function EventHandler:PopulateItemButton(button, item)
	if not button or not item then
		return
	end

	-- Get display data
	local displayData = self.dataManager:GetItemDisplayData(item)
	if not displayData then
		return
	end

	-- Store item data
	button.itemData = item

	-- Set icon
	if displayData.itemTexture then
		button.icon:SetTexture(displayData.itemTexture)
	else
		button.icon:SetTexture(Constants.TEXTURES.UNKNOWN_ICON)
	end

	-- Set icon border
	if displayData.qualityColor then
		button.iconBorder:SetVertexColor(
			displayData.qualityColor.r,
			displayData.qualityColor.g,
			displayData.qualityColor.b,
			1
		)
		button.iconBorder:Show()
	else
		button.iconBorder:Hide()
	end

	-- Set display name
	button.name:SetText(displayData.displayName)

	-- Set attempts
	button.attempts:SetText(tostring(displayData.attempts))

	-- Set likelihood
	button.likelihood:SetText(string.format("%.1f%%", displayData.likelihood))

	-- Set progress bar
	button.progressBar:SetWidth(displayData.progressWidth)
	button.progressBar:SetColorTexture(unpack(displayData.progressBarColor))

	-- Set zone
	button.zone:SetText(displayData.zoneText)

	-- Set status
	button.status:SetText(displayData.statusText)
	button.statusBg:SetColorTexture(unpack(displayData.statusColor))

	-- Set source
	button.source:SetText(displayData.methodName)
end

-- Cleanup function
function EventHandler:Cleanup()
	if self.activeTooltip then
		self.activeTooltip:Hide()
		if R and R.Tooltips then
			R.Tooltips:ReleaseTooltip(self.activeTooltip)
		end
		self.activeTooltip = nil
	end
end

-- Error handling wrapper
function EventHandler:SafeExecute(func, ...)
	local success, result = pcall(func, ...)
	if not success then
		print("ERROR: EventHandler execution failed - " .. tostring(result))
		return false
	end
	return true
end

-- Validation functions
function EventHandler:ValidateButton(button)
	return button and button.itemData and type(button.itemData) == "table"
end

function EventHandler:ValidateItem(item)
	return item and type(item) == "table"
end

-- Store in addon table
if not addonTable.TabbedWindowModules then
	addonTable.TabbedWindowModules = {}
end

addonTable.TabbedWindowModules.EventHandler = EventHandler
