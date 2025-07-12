local addonTable = select(2, ...)
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Access modules from addon table
local TabbedWindowModules = addonTable.TabbedWindowModules or {}
local Constants = TabbedWindowModules.Constants
local UIFactory = TabbedWindowModules.UIFactory
local DataManager = TabbedWindowModules.DataManager
local EventHandler = TabbedWindowModules.EventHandler

-- Fallback constants if modules not loaded
local DEFAULT_CONSTANTS = {
	TAB_DATA = {
		{
			name = L["Mounts"],
			icon = "Interface\\Icons\\Ability_Mount_RidingHorse",
			dataSource = "mounts",
			itemType = "MOUNT",
		},
		{
			name = L["Battle Pets"],
			icon = "Interface\\Icons\\INV_Pet_BattlePetTraining",
			dataSource = "pets",
			itemType = "PET",
		},
		{
			name = L["Toys & Items"],
			icon = "Interface\\Icons\\INV_Misc_Toy_10",
			dataSource = "items",
			itemType = "ITEM",
		},
		{
			name = L["Custom"],
			icon = "Interface\\Icons\\INV_Misc_Note_01",
			dataSource = "user",
			itemType = nil,
		},
	},
	PAGINATION = { ITEMS_PER_PAGE = 20 },
	CONTENT = { INSET_LEFT = 15, CONTENT_TOP_OFFSET = -90 },
	ITEM_BUTTON = { SPACING = 30 },
}

-- Use Constants or fallback
if not Constants then
	Constants = DEFAULT_CONSTANTS
end

-- Upvalues
local R = Rarity

-- Main tabbed window controller
local RarityTabbedWindow = {
	-- UI Components
	frame = nil,
	tabs = {},
	itemButtons = {},
	contentFrame = nil,
	scrollChild = nil,
	searchBox = nil,
	clearButton = nil,
	pageInfo = nil,
	prevButton = nil,
	nextButton = nil,
	itemContainer = nil,

	-- State
	currentTab = 1,
	currentPage = 1,
	maxPages = 1,
	filterText = "",

	-- Configuration
	itemsPerPage = (Constants.PAGINATION and Constants.PAGINATION.ITEMS_PER_PAGE) or 20,

	-- Module instances
	uiFactory = nil,
	dataManager = nil,
	eventHandler = nil,
}

function RarityTabbedWindow:OnLoad()
	-- Initialize module instances
	self.uiFactory = UIFactory
	self.dataManager = DataManager
	self.eventHandler = EventHandler

	-- If modules not available, use simple fallback
	if not self.uiFactory or not self.dataManager or not self.eventHandler then
		return self:CreateSimpleWindow()
	end

	-- Initialize event handler with reference to this controller
	if self.eventHandler.Initialize then
		self.eventHandler:Initialize(self)
	end

	-- Create UI components with error handling
	local success, err = pcall(function()
		self:CreateUI()
		self:ValidateComponents()
		self:InitializeState()
	end)

	if not success then
		print("ERROR: Rarity TabbedWindow initialization failed - " .. tostring(err))
		return false
	end

	return true
end

-- Simple fallback window creation
function RarityTabbedWindow:CreateSimpleWindow()
	local frame = CreateFrame("Frame", "RarityMainWindow", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	frame:SetSize(950, 750)
	frame:SetPoint("CENTER", UIParent, "CENTER", 0, 0)
	frame:SetFrameStrata("DIALOG")
	frame:SetFrameLevel(100)

	-- Simple backdrop
	if frame.SetBackdrop then
		frame:SetBackdrop({
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
			tile = true,
			edgeSize = 32,
			tileSize = 32,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		})
		frame:SetBackdropColor(0.05, 0.05, 0.1, 0.95)
		frame:SetBackdropBorderColor(0.3, 0.3, 0.4, 1)
	end

	-- Title
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", frame, "TOP", 0, -16)
	title:SetText("Rarity - " .. L["Collection Tracking"])
	title:SetTextColor(0.9, 0.9, 1, 1)

	-- Close button
	local closeButton = CreateFrame("Button", "$parentCloseButton", frame, "UIPanelCloseButton")
	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -6)
	closeButton:SetScript("OnClick", function()
		self:Hide()
	end)

	-- Simple message
	local message = frame:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	message:SetPoint("CENTER", frame, "CENTER", 0, 0)
	message:SetText("TabbedWindow modules not loaded - using simple fallback")
	message:SetTextColor(1, 1, 1, 1)

	self.frame = frame
	frame:Hide()

	return true
end

-- Create all UI components (only if modules available)
function RarityTabbedWindow:CreateUI()
	if not self.uiFactory then
		return
	end

	-- Create main window
	self.frame = self.uiFactory:CreateMainWindow(UIParent, self)
	self.uiFactory:ValidateComponent(self.frame, "main window")

	-- Create tabs
	self.tabs = self.uiFactory:CreateTabs(self.frame, self)
	self.uiFactory:ValidateComponent(self.tabs, "tabs")

	-- Create content area
	self.contentFrame, self.scrollChild = self.uiFactory:CreateContentArea(self.frame)
	self.uiFactory:ValidateComponent(self.contentFrame, "content area")
	self.uiFactory:ValidateComponent(self.scrollChild, "scroll child")

	-- Create column headers
	self.headerFrame, self.columnHeaders = self.uiFactory:CreateColumnHeaders(self.frame)
	self.uiFactory:ValidateComponent(self.headerFrame, "column headers")

	-- Create search box
	self.searchContainer, self.searchBox, self.clearButton = self.uiFactory:CreateSearchBox(self.frame, self)
	self.uiFactory:ValidateComponent(self.searchBox, "search box")

	-- Create item container
	self.itemContainer = self.uiFactory:CreateItemContainer(self.scrollChild)
	self.uiFactory:ValidateComponent(self.itemContainer, "item container")

	-- Create item buttons
	self:CreateItemButtons()

	-- Create pagination
	self.paginationFrame, self.prevButton, self.nextButton, self.pageInfo =
		self.uiFactory:CreatePagination(self.frame, self)
	self.uiFactory:ValidateComponent(self.pageInfo, "pagination")

	-- Adjust content positioning after headers
	if Constants.CONTENT then
		self.contentFrame:SetPoint(
			"TOPLEFT",
			self.frame,
			"TOPLEFT",
			Constants.CONTENT.INSET_LEFT,
			Constants.CONTENT.CONTENT_TOP_OFFSET
		)
	end
end

-- Create item buttons using the factory
function RarityTabbedWindow:CreateItemButtons()
	if not self.uiFactory then
		return
	end

	self.itemButtons = {}

	for i = 1, self.itemsPerPage do
		local button = self.uiFactory:CreateItemButton(self.itemContainer, i, self.eventHandler)
		if button then
			local spacing = (Constants.ITEM_BUTTON and Constants.ITEM_BUTTON.SPACING) or 30
			button:SetPoint("TOPLEFT", self.itemContainer, "TOPLEFT", 0, -(i - 1) * spacing)
			button:Hide()
			self.itemButtons[i] = button
		end
	end
end

-- Validate all critical components
function RarityTabbedWindow:ValidateComponents()
	local required = {
		{ self.frame, "main frame" },
		{ self.tabs, "tabs" },
		{ self.contentFrame, "content frame" },
		{ self.searchBox, "search box" },
		{ self.itemContainer, "item container" },
		{ self.pageInfo, "page info" },
		{ self.prevButton, "previous button" },
		{ self.nextButton, "next button" },
		{ self.itemButtons, "item buttons" },
	}

	for _, component in ipairs(required) do
		if not component[1] then
			error("Missing required component: " .. component[2])
		end
	end
end

-- Initialize state
function RarityTabbedWindow:InitializeState()
	-- Hide initially
	if self.frame then
		self.frame:Hide()
	end

	-- Set initial tab
	self:SelectTab(1)
end

-- Tab selection
function RarityTabbedWindow:SelectTab(tabIndex)
	print("SelectTab called with index:", tabIndex) -- Debug

	local tabCount = Constants.TAB_DATA and #Constants.TAB_DATA or 4
	if not tabIndex or tabIndex < 1 or tabIndex > tabCount then
		print("Invalid tab index:", tabIndex, "max:", tabCount) -- Debug
		return
	end

	-- Update tab appearance using event handler if available
	if self.eventHandler and self.eventHandler.UpdateTabAppearance then
		self.eventHandler:UpdateTabAppearance(tabIndex)
	end

	-- Update window state
	self.currentTab = tabIndex
	self.currentPage = 1

	-- Refresh content
	self:RefreshContent()
end

-- Content refresh
function RarityTabbedWindow:RefreshContent()
	if not self:ValidateState() then
		return
	end

	-- Get current tab info
	local tabData = Constants.TAB_DATA or DEFAULT_CONSTANTS.TAB_DATA
	local tabInfo = tabData[self.currentTab]
	if not tabInfo then
		return
	end

	-- Get filtered items
	local allItems = {}
	if self.dataManager then
		allItems = self.dataManager:GetFilteredItems(tabInfo, self.filterText)
	end

	-- Get paginated items
	local pageItems, currentPage, maxPages = {}, 1, 1
	if self.dataManager then
		pageItems, currentPage, maxPages =
			self.dataManager:GetPaginatedItems(allItems, self.currentPage, self.itemsPerPage)
	end

	-- Update state
	self.currentPage = currentPage
	self.maxPages = maxPages

	-- Update pagination info
	self:UpdatePagination(#allItems)

	-- Update item buttons
	self:UpdateItemButtons(pageItems)
end

-- Validate current state
function RarityTabbedWindow:ValidateState()
	if not self.pageInfo or not self.prevButton or not self.nextButton then
		print("ERROR: TabbedWindow components not properly initialized")
		return false
	end
	return true
end

-- Update pagination display
function RarityTabbedWindow:UpdatePagination(totalItems)
	if self.pageInfo then
		self.pageInfo:SetText(string.format(L["Page %d of %d (%d items)"], self.currentPage, self.maxPages, totalItems))
	end

	-- Update button states
	if self.prevButton then
		self.prevButton:SetEnabled(self.currentPage > 1)
	end
	if self.nextButton then
		self.nextButton:SetEnabled(self.currentPage < self.maxPages)
	end
end

-- Update item buttons with new data
function RarityTabbedWindow:UpdateItemButtons(items)
	-- Hide all buttons first
	for i = 1, self.itemsPerPage do
		if self.itemButtons[i] then
			self.itemButtons[i]:Hide()
		end
	end

	-- Show and populate visible buttons
	for i, item in ipairs(items) do
		if i <= self.itemsPerPage and self.itemButtons[i] then
			local button = self.itemButtons[i]
			if self.eventHandler then
				self.eventHandler:PopulateItemButton(button, item)
			end
			button:Show()
		end
	end
end

-- Navigation methods
function RarityTabbedWindow:PreviousPage()
	print("PreviousPage called") -- Debug

	if self.eventHandler and self.eventHandler.OnPreviousPage then
		self.eventHandler:OnPreviousPage()
	else
		if self.currentPage > 1 then
			self.currentPage = self.currentPage - 1
			self:RefreshContent()
		end
	end
end

function RarityTabbedWindow:NextPage()
	print("NextPage called") -- Debug

	if self.eventHandler and self.eventHandler.OnNextPage then
		self.eventHandler:OnNextPage()
	else
		if self.currentPage < self.maxPages then
			self.currentPage = self.currentPage + 1
			self:RefreshContent()
		end
	end
end

-- Search text change handler
function RarityTabbedWindow:OnSearchTextChanged(text)
	print("OnSearchTextChanged called with text:", text) -- Debug

	if self.eventHandler and self.eventHandler.OnSearchTextChanged then
		self.eventHandler:OnSearchTextChanged(text)
	else
		self.filterText = text or ""
		self.currentPage = 1
		self:RefreshContent()
	end
end

-- Public API methods
function RarityTabbedWindow:Show()
	if not self.frame then
		local success = self:OnLoad()
		if not success then
			print("ERROR: Failed to initialize TabbedWindow")
			return
		end
	end

	if self.frame then
		self.frame:Show()
		self:RefreshContent()
	end
end

function RarityTabbedWindow:Hide()
	if self.frame then
		self.frame:Hide()
	end

	-- Cleanup event handler
	if self.eventHandler then
		self.eventHandler:Cleanup()
	end
end

function RarityTabbedWindow:Toggle()
	if self.frame and self.frame:IsVisible() then
		self:Hide()
	else
		self:Show()
	end
end

function RarityTabbedWindow:IsVisible()
	return self.frame and self.frame:IsVisible()
end

-- Initialize and assign to global
Rarity.TabbedWindow = RarityTabbedWindow

return RarityTabbedWindow
