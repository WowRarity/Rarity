local _, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Get Constants from addon table (will be available since loaded first)
local Constants = addonTable.TabbedWindowModules and addonTable.TabbedWindowModules.Constants

local UIFactory = {}

-- Helper function to set color on texture
local function SetTextureColor(texture, colorTable)
	if texture and colorTable then
		texture:SetColorTexture(unpack(colorTable))
	end
end

-- Helper function to set backdrop with validation
local function SetBackdropSafe(frame, backdrop, bgColor, borderColor)
	if frame and backdrop then
		frame:SetBackdrop(backdrop)
		if bgColor then
			frame:SetBackdropColor(unpack(bgColor))
		end
		if borderColor then
			frame:SetBackdropBorderColor(unpack(borderColor))
		end
	end
end

-- Main window factory
function UIFactory:CreateMainWindow(parent, windowController)
	local config = Constants.WINDOW
	local colors = Constants.COLORS

	local frame = CreateFrame("Frame", "RarityMainWindow", parent, Constants.TEMPLATES.BACKDROP)
	frame:SetSize(config.WIDTH, config.HEIGHT)
	frame:SetPoint("CENTER", parent, "CENTER", 0, 0)
	frame:SetFrameStrata(config.FRAME_STRATA)
	frame:SetFrameLevel(config.FRAME_LEVEL)

	-- Backdrop styling
	SetBackdropSafe(frame, Constants.BACKDROP.MAIN_WINDOW, colors.WINDOW_BG, colors.WINDOW_BORDER)

	-- Make draggable
	frame:SetMovable(true)
	frame:EnableMouse(true)
	frame:RegisterForDrag("LeftButton")
	frame:SetScript("OnDragStart", function(self)
		self:StartMoving()
	end)
	frame:SetScript("OnDragStop", function(self)
		self:StopMovingOrSizing()
	end)

	-- Title bar
	local titleBg = frame:CreateTexture(nil, "ARTWORK")
	titleBg:SetPoint("TOPLEFT", frame, "TOPLEFT", 8, -8)
	titleBg:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -8)
	titleBg:SetHeight(28)
	SetTextureColor(titleBg, colors.TITLE_BG)

	-- Title text
	local title = frame:CreateFontString(nil, "OVERLAY", "GameFontNormalLarge")
	title:SetPoint("TOP", frame, "TOP", 0, -16)
	title:SetText(config.TITLE)
	title:SetTextColor(unpack(colors.TITLE_TEXT))
	frame.title = title

	-- Close button
	local closeButton = CreateFrame("Button", "$parentCloseButton", frame, Constants.TEMPLATES.CLOSE_BUTTON)
	closeButton:SetPoint("TOPRIGHT", frame, "TOPRIGHT", -8, -6)
	closeButton:SetScript("OnClick", function()
		if windowController and windowController.Hide then
			windowController:Hide()
		end
	end)
	frame.closeButton = closeButton

	return frame
end

-- Tab factory
function UIFactory:CreateTabs(parent, tabController)
	local config = Constants.TABS
	local tabs = {}

	for i, tabInfo in ipairs(Constants.TAB_DATA) do
		local tab = CreateFrame("Button", "$parentTab" .. i, parent, Constants.TEMPLATES.TAB_BUTTON)
		tab:SetID(i)
		tab:SetText(tabInfo.name)
		tab:SetWidth(config.WIDTH)
		tab:SetHeight(config.HEIGHT)
		tab:SetScript("OnClick", function()
			if tabController and tabController.SelectTab then
				tabController:SelectTab(i)
			end
		end)

		-- Position tabs
		if i == 1 then
			tab:SetPoint("BOTTOMLEFT", parent, "BOTTOMLEFT", Constants.CONTENT.INSET_LEFT, config.BOTTOM_OFFSET)
		else
			tab:SetPoint("LEFT", tabs[i - 1], "RIGHT", config.SPACING, 0)
		end

		PanelTemplates_TabResize(tab, config.RESIZE_PADDING)
		tabs[i] = tab
	end

	return tabs
end

-- Content area factory
function UIFactory:CreateContentArea(parent)
	local config = Constants.CONTENT

	local contentFrame = CreateFrame("ScrollFrame", "$parentContent", parent, Constants.TEMPLATES.SCROLL_FRAME)
	contentFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", config.INSET_LEFT, config.TOP_OFFSET)
	contentFrame:SetPoint("BOTTOMRIGHT", parent, "BOTTOMRIGHT", config.SCROLL_BAR_OFFSET, config.BOTTOM_OFFSET)

	local scrollChild = CreateFrame("Frame", "$parentScrollChild", contentFrame)
	scrollChild:SetSize(1, 1)
	contentFrame:SetScrollChild(scrollChild)

	return contentFrame, scrollChild
end

-- Column headers factory
function UIFactory:CreateColumnHeaders(parent)
	local config = Constants.CONTENT
	local colors = Constants.COLORS

	local headerFrame = CreateFrame("Frame", "$parentHeaders", parent)
	headerFrame:SetPoint("TOPLEFT", parent, "TOPLEFT", config.INSET_LEFT, config.HEADER_TOP_OFFSET)
	headerFrame:SetPoint("TOPRIGHT", parent, "TOPRIGHT", config.SCROLL_BAR_OFFSET, config.HEADER_TOP_OFFSET)
	headerFrame:SetHeight(config.HEADER_HEIGHT)

	-- Header background
	local headerBg = headerFrame:CreateTexture(nil, "BACKGROUND")
	headerBg:SetAllPoints(headerFrame)
	SetTextureColor(headerBg, colors.HEADER_BG)

	-- Create column headers
	local columnHeaders = {}
	for i, col in ipairs(Constants.COLUMN_DEFINITIONS) do
		local header = headerFrame:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
		header:SetHeight(20)
		header:SetWidth(col.width)
		header:SetText(L[col.name])
		header:SetTextColor(unpack(colors.HEADER_TEXT))
		header:SetJustifyH(col.anchor)

		if i == 1 then
			header:SetPoint("LEFT", headerFrame, "LEFT", 10, 0)
		else
			header:SetPoint("LEFT", columnHeaders[i - 1], "RIGHT", 5, 0)
		end

		columnHeaders[i] = header
	end

	return headerFrame, columnHeaders
end

-- Search box factory
function UIFactory:CreateSearchBox(parent, searchController)
	local config = Constants.SEARCH
	local colors = Constants.COLORS

	local searchContainer = CreateFrame("Frame", "$parentSearchContainer", parent)
	searchContainer:SetPoint("TOPRIGHT", parent, "TOPRIGHT", config.RIGHT_OFFSET, config.TOP_OFFSET)
	searchContainer:SetSize(config.CONTAINER_WIDTH, config.CONTAINER_HEIGHT)

	-- -- Background
	-- local searchBg = searchContainer:CreateTexture(nil, "BACKGROUND")
	-- searchBg:SetAllPoints(searchContainer)
	-- SetTextureColor(searchBg, colors.SEARCH_BG)

	-- Border
	-- local searchBorder = searchContainer:CreateTexture(nil, "BORDER")
	-- searchBorder:SetAllPoints(searchContainer)
	-- searchBorder:SetDrawLayer("BORDER", -1)
	-- SetTextureColor(searchBorder, colors.SEARCH_BORDER)

	-- Search box
	local searchBox = CreateFrame("EditBox", "$parentSearchBox", searchContainer, Constants.TEMPLATES.INPUT_BOX)
	searchBox:SetPoint("RIGHT", searchContainer, "RIGHT", -config.BUTTON_WIDTH - config.BUTTON_SPACING, 0)
	searchBox:SetSize(config.BOX_WIDTH, config.BOX_HEIGHT)
	searchBox:SetAutoFocus(false)
	searchBox:SetScript("OnTextChanged", function(self, userInput)
		if userInput and searchController and searchController.OnSearchTextChanged then
			searchController:OnSearchTextChanged(self:GetText())
		end
	end)
	searchBox:SetScript("OnEscapePressed", function(self)
		self:ClearFocus()
		self:SetText("")
		if searchController and searchController.OnSearchTextChanged then
			searchController:OnSearchTextChanged("")
		end
	end)

	-- Clear button
	local clearButton = CreateFrame("Button", "$parentClearButton", searchContainer, Constants.TEMPLATES.PANEL_BUTTON)
	clearButton:SetPoint("LEFT", searchBox, "RIGHT", config.BUTTON_SPACING, 0)
	clearButton:SetSize(config.BUTTON_WIDTH, config.BUTTON_HEIGHT)
	clearButton:SetText(L["Clear"])
	clearButton:SetScript("OnClick", function()
		searchBox:SetText("")
		if searchController and searchController.OnSearchTextChanged then
			searchController:OnSearchTextChanged("")
		end
	end)

	-- Label
	local searchLabel = searchContainer:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	searchLabel:SetPoint("RIGHT", searchBox, "LEFT", config.LABEL_SPACING, 0)
	searchLabel:SetText(L["Search"] .. ":")
	searchLabel:SetTextColor(unpack(colors.SEARCH_LABEL_TEXT))

	return searchContainer, searchBox, clearButton
end

-- Item container factory
function UIFactory:CreateItemContainer(parent)
	local itemContainer = CreateFrame("Frame", "$parentItemContainer", parent)
	itemContainer:SetPoint("TOPLEFT", parent, "TOPLEFT", 0, 0)
	itemContainer:SetSize(850, 500)

	return itemContainer
end

-- Item button factory
function UIFactory:CreateItemButton(parent, index, eventHandler)
	local config = Constants.ITEM_BUTTON
	local colors = Constants.COLORS

	local button = CreateFrame("Button", "$parentItem" .. index, parent)
	button:SetSize(config.WIDTH, config.HEIGHT)

	-- Background textures
	local normalTexture = button:CreateTexture(nil, "BACKGROUND")
	normalTexture:SetAllPoints(button)
	SetTextureColor(normalTexture, index % 2 == 0 and colors.BUTTON_NORMAL_ODD or colors.BUTTON_NORMAL_EVEN)
	button:SetNormalTexture(normalTexture)

	local highlightTexture = button:CreateTexture(nil, "HIGHLIGHT")
	highlightTexture:SetAllPoints(button)
	SetTextureColor(highlightTexture, colors.BUTTON_HIGHLIGHT)
	button:SetHighlightTexture(highlightTexture)

	-- Create all button elements
	local elements = self:CreateItemButtonElements(button, config, colors)

	-- Assign elements to button
	for key, element in pairs(elements) do
		button[key] = element
	end

	-- Event handling
	if eventHandler then
		button:SetScript("OnEnter", function(self)
			eventHandler:OnItemButtonEnter(self)
		end)
		button:SetScript("OnLeave", function(self)
			eventHandler:OnItemButtonLeave(self)
		end)
		button:SetScript("OnClick", function(self, mouseButton)
			eventHandler:OnItemButtonClick(self, mouseButton)
		end)
	end

	return button
end

-- Item button elements factory
function UIFactory:CreateItemButtonElements(button, config, colors)
	local elements = {}

	-- Icon
	elements.icon = button:CreateTexture(nil, "ARTWORK")
	elements.icon:SetSize(config.ICON_SIZE, config.ICON_SIZE)
	elements.icon:SetPoint("LEFT", button, "LEFT", config.ICON_LEFT_OFFSET, 0)

	-- Icon border
	elements.iconBorder = button:CreateTexture(nil, "OVERLAY")
	elements.iconBorder:SetSize(config.ICON_BORDER_SIZE, config.ICON_BORDER_SIZE)
	elements.iconBorder:SetPoint("CENTER", elements.icon, "CENTER", 0, 0)
	elements.iconBorder:SetTexture(Constants.TEXTURES.ICON_BORDER)

	-- Name
	elements.name = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	elements.name:SetPoint("LEFT", elements.icon, "RIGHT", 8, 0)
	elements.name:SetSize(config.NAME_WIDTH, 20)
	elements.name:SetJustifyH("LEFT")
	elements.name:SetTextColor(unpack(colors.BUTTON_TEXT))

	-- Attempts
	elements.attempts = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	elements.attempts:SetPoint("LEFT", elements.name, "RIGHT", config.COLUMN_SPACING, 0)
	elements.attempts:SetSize(config.ATTEMPTS_WIDTH, 20)
	elements.attempts:SetJustifyH("CENTER")
	elements.attempts:SetTextColor(unpack(colors.BUTTON_TEXT))

	-- Likelihood
	elements.likelihood = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	elements.likelihood:SetPoint("LEFT", elements.attempts, "RIGHT", config.COLUMN_SPACING, 0)
	elements.likelihood:SetSize(config.LIKELIHOOD_WIDTH, 20)
	elements.likelihood:SetJustifyH("CENTER")
	elements.likelihood:SetTextColor(unpack(colors.BUTTON_TEXT))

	-- Progress bar background
	elements.progressBg = button:CreateTexture(nil, "BACKGROUND")
	elements.progressBg:SetPoint("CENTER", elements.likelihood, "CENTER", 0, config.PROGRESS_BAR_OFFSET)
	elements.progressBg:SetSize(config.PROGRESS_BAR_WIDTH, config.PROGRESS_BAR_HEIGHT)
	SetTextureColor(elements.progressBg, colors.PROGRESS_BG)

	-- Progress bar
	elements.progressBar = button:CreateTexture(nil, "ARTWORK")
	elements.progressBar:SetPoint("LEFT", elements.progressBg, "LEFT", 0, 0)
	elements.progressBar:SetHeight(config.PROGRESS_BAR_HEIGHT)
	SetTextureColor(elements.progressBar, colors.PROGRESS_LOW)

	-- Zone
	elements.zone = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	elements.zone:SetPoint("LEFT", elements.likelihood, "RIGHT", config.COLUMN_SPACING, 0)
	elements.zone:SetSize(config.ZONE_WIDTH, 20)
	elements.zone:SetJustifyH("CENTER")
	elements.zone:SetTextColor(unpack(colors.ZONE_TEXT))

	-- Status background
	elements.statusBg = button:CreateTexture(nil, "ARTWORK")
	elements.statusBg:SetPoint("LEFT", elements.zone, "RIGHT", config.COLUMN_SPACING, 0)
	elements.statusBg:SetSize(config.STATUS_WIDTH, config.STATUS_BG_HEIGHT)
	SetTextureColor(elements.statusBg, colors.STATUS_DEFAULT)

	-- Status text
	elements.status = button:CreateFontString(nil, "OVERLAY", "GameFontNormalSmall")
	elements.status:SetPoint("CENTER", elements.statusBg, "CENTER", 0, 0)
	elements.status:SetSize(config.STATUS_WIDTH - 5, config.STATUS_BG_HEIGHT)
	elements.status:SetJustifyH("CENTER")
	elements.status:SetTextColor(unpack(colors.BUTTON_TEXT))

	-- Source
	elements.source = button:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	elements.source:SetPoint("LEFT", elements.statusBg, "RIGHT", config.COLUMN_SPACING, 0)
	elements.source:SetSize(config.SOURCE_WIDTH, 20)
	elements.source:SetJustifyH("CENTER")
	elements.source:SetTextColor(unpack(colors.SOURCE_TEXT))

	return elements
end

-- Pagination factory
function UIFactory:CreatePagination(parent, paginationController)
	local config = Constants.PAGINATION
	local colors = Constants.COLORS

	local pagination = CreateFrame("Frame", "$parentPagination", parent)
	pagination:SetPoint("BOTTOM", parent, "BOTTOM", 0, config.BOTTOM_OFFSET)
	pagination:SetSize(config.CONTAINER_WIDTH, config.CONTAINER_HEIGHT)

	-- Previous button
	local prevButton = CreateFrame("Button", "$parentPrevButton", pagination, Constants.TEMPLATES.PANEL_BUTTON)
	prevButton:SetPoint("LEFT", pagination, "LEFT", config.BUTTON_SPACING, 0)
	prevButton:SetSize(config.BUTTON_WIDTH, config.BUTTON_HEIGHT)
	prevButton:SetText(L["Previous"])
	prevButton:SetScript("OnClick", function()
		if paginationController and paginationController.PreviousPage then
			paginationController:PreviousPage()
		end
	end)

	-- Page info
	local pageInfo = pagination:CreateFontString(nil, "OVERLAY", "GameFontNormal")
	pageInfo:SetPoint("CENTER", pagination, "CENTER", 0, 0)
	pageInfo:SetTextColor(unpack(colors.PAGE_INFO_TEXT))

	-- Next button
	local nextButton = CreateFrame("Button", "$parentNextButton", pagination, Constants.TEMPLATES.PANEL_BUTTON)
	nextButton:SetPoint("RIGHT", pagination, "RIGHT", -config.BUTTON_SPACING, 0)
	nextButton:SetSize(config.BUTTON_WIDTH, config.BUTTON_HEIGHT)
	nextButton:SetText(L["Next"])
	nextButton:SetScript("OnClick", function()
		if paginationController and paginationController.NextPage then
			paginationController:NextPage()
		end
	end)

	return pagination, prevButton, nextButton, pageInfo
end

-- Validation helper
function UIFactory:ValidateComponent(component, name)
	if not component then
		error(string.format("Failed to create %s component", name or "unknown"))
	end
	return component
end

-- Store in addon table
if not addonTable.TabbedWindowModules then
	addonTable.TabbedWindowModules = {}
end

addonTable.TabbedWindowModules.UIFactory = UIFactory
