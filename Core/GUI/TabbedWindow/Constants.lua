local _, addonTable = ...
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- TabbedWindow Constants Module
local Constants = {
	-- Window configuration
	WINDOW = {
		WIDTH = 950,
		HEIGHT = 750,
		TITLE = "Rarity - Collection Tracking",
		FRAME_STRATA = "DIALOG",
		FRAME_LEVEL = 100,
	},

	-- Backdrop styling
	BACKDROP = {
		MAIN_WINDOW = {
			bgFile = "Interface/DialogFrame/UI-DialogBox-Background",
			edgeFile = "Interface/DialogFrame/UI-DialogBox-Border",
			tile = true,
			edgeSize = 32,
			tileSize = 32,
			insets = { left = 8, right = 8, top = 8, bottom = 8 },
		},
	},

	-- Tab configuration
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

	-- Tab layout
	TAB_LAYOUT = {
		WIDTH = 120,
		HEIGHT = 32,
		SPACING = 0,
		START_Y = -32,
		SELECTED_OFFSET = 2,
		FONT = "GameFontNormalSmall",
		SELECTED_FONT = "GameFontHighlightSmall",
	},

	-- Search configuration
	SEARCH = {
		CONTAINER_WIDTH = 400,
		CONTAINER_HEIGHT = 35,
		BOX_WIDTH = 180,
		BOX_HEIGHT = 25,
		BUTTON_WIDTH = 70,
		BUTTON_HEIGHT = 25,
		TOP_OFFSET = -40,
		RIGHT_OFFSET = -15,
		BUTTON_SPACING = 10,
		LABEL_SPACING = -15,
		WIDTH = 200,
		HEIGHT = 32,
		INSTRUCTIONS = "Search items...",
		POSITION = { x = -20, y = -8 },
		CLEAR_BUTTON_SIZE = 24,
	},

	-- Content area
	CONTENT = {
		TOP_OFFSET = -55,
		BOTTOM_OFFSET = 110,
		HEADER_HEIGHT = 25,
		HEADER_TOP_OFFSET = -65,
		CONTENT_TOP_OFFSET = -90,
		SCROLL_BAR_OFFSET = -35,
		INSET_LEFT = 15,
		INSET_RIGHT = -15,
		INSET_TOP = -70,
		INSET_BOTTOM = 50,
		SCROLL_STEP = 25,
	},

	-- Column definitions
	COLUMN_DEFINITIONS = {
		{ name = "Name", width = 220, anchor = "LEFT", key = "name" },
		{ name = "Attempts", width = 80, anchor = "CENTER", key = "attempts" },
		{ name = "Likelihood", width = 100, anchor = "CENTER", key = "likelihood" },
		{ name = "Zone", width = 150, anchor = "CENTER", key = "zone" },
		{ name = "Status", width = 100, anchor = "CENTER", key = "status" },
		{ name = "Source", width = 120, anchor = "CENTER", key = "source" },
	},

	-- Item button configuration
	ITEM_BUTTON = {
		WIDTH = 870,
		HEIGHT = 28,
		SPACING = 30,
		ICON_SIZE = 20,
		ICON_BORDER_SIZE = 22,
		ICON_LEFT_OFFSET = 8,
		NAME_WIDTH = 180,
		ATTEMPTS_WIDTH = 80,
		LIKELIHOOD_WIDTH = 100,
		ZONE_WIDTH = 150,
		STATUS_WIDTH = 80,
		SOURCE_WIDTH = 120,
		PROGRESS_BAR_WIDTH = 90,
		PROGRESS_BAR_HEIGHT = 3,
		PROGRESS_BAR_OFFSET = -8,
		COLUMN_SPACING = 10,
		STATUS_BG_HEIGHT = 16,
		ZONE_TEXT_MAX_LENGTH = 18,
		ZONE_TEXT_TRUNCATE_LENGTH = 15,
	},

	-- Pagination
	PAGINATION = {
		CONTAINER_WIDTH = 500,
		CONTAINER_HEIGHT = 35,
		BUTTON_WIDTH = 90,
		BUTTON_HEIGHT = 28,
		BOTTOM_OFFSET = 20,
		BUTTON_SPACING = 10,
		ITEMS_PER_PAGE = 20,
	},

	-- Colors
	COLORS = {
		WINDOW_BG = { 0.05, 0.05, 0.1, 0.95 },
		WINDOW_BORDER = { 0.3, 0.3, 0.4, 1 },
		TITLE_BG = { 0.1, 0.1, 0.15, 0.8 },
		TITLE_TEXT = { 0.9, 0.9, 1, 1 },
		SEARCH_BG = { 0.05, 0.05, 0.1, 0.8 },
		SEARCH_BORDER = { 0.3, 0.3, 0.4, 0.5 },
		HEADER_BG = { 0.15, 0.15, 0.2, 0.9 },
		HEADER_TEXT = { 1, 1, 1, 1 },
		PAGE_INFO_TEXT = { 0.9, 0.9, 1, 1 },
		SEARCH_LABEL_TEXT = { 0.9, 0.9, 1, 1 },

		-- Item button colors
		BUTTON_NORMAL_EVEN = { 0.05, 0.05, 0.05, 0.3 },
		BUTTON_NORMAL_ODD = { 0.1, 0.1, 0.1, 0.2 },
		BUTTON_HIGHLIGHT = { 0.2, 0.4, 0.8, 0.3 },
		BUTTON_TEXT = { 1, 1, 1, 1 },
		ZONE_TEXT = { 0.8, 0.8, 0.8, 1 },
		SOURCE_TEXT = { 0.7, 0.7, 0.9, 1 },

		-- Status colors
		STATUS_FOUND = { 0.2, 0.8, 0.2, 0.8 },
		STATUS_DISABLED = { 0.8, 0.2, 0.2, 0.8 },
		STATUS_TRACKING = { 0.2, 0.4, 0.8, 0.8 },
		STATUS_DEFAULT = { 0.2, 0.2, 0.2, 0.6 },

		-- Progress bar colors
		PROGRESS_BG = { 0.2, 0.2, 0.2, 0.8 },
		PROGRESS_VERY_LIKELY = { 0.8, 0.2, 0.2, 0.8 }, -- Red (>=75%)
		PROGRESS_LIKELY = { 1, 0.6, 0, 0.8 }, -- Orange (>=50%)
		PROGRESS_MODERATE = { 1, 1, 0, 0.8 }, -- Yellow (>=25%)
		PROGRESS_LOW = { 0.2, 0.8, 0.2, 0.8 }, -- Green (<25%)
	},

	-- Progress thresholds
	PROGRESS_THRESHOLDS = {
		VERY_LIKELY = 75,
		LIKELY = 50,
		MODERATE = 25,
	},

	-- Method name mappings for different item types
	ITEM_TYPE_METHODS = {
		MOUNT = "GetMountInfo",
		PET = "GetPetInfo",
		ITEM = "GetItemInfo",
		TOY = "GetToyInfo",
	},

	-- UI Templates
	TEMPLATES = {
		BACKDROP = BackdropTemplateMixin and "BackdropTemplate" or nil,
		CLOSE_BUTTON = "UIPanelCloseButton",
		TAB_BUTTON = "PanelTabButtonTemplate",
		SCROLL_FRAME = "UIPanelScrollFrameTemplate",
		INPUT_BOX = "InputBoxTemplate",
		PANEL_BUTTON = "UIPanelButtonTemplate",
		SEARCH_BOX = "SearchBoxTemplate",
	},

	-- Textures
	TEXTURES = {
		UNKNOWN_ICON = "Interface\\Icons\\INV_Misc_QuestionMark",
		ICON_BORDER = "Interface\\Tooltips\\UI-Tooltip-Border",
		TAB_INACTIVE = "Interface\\ChatFrame\\ChatFrameTab-BGLeft",
		TAB_ACTIVE = "Interface\\ChatFrame\\ChatFrameTab-BGMid",
	},

	-- Tooltip configuration
	TOOLTIP = {
		OFFSET_X = 10,
		OFFSET_Y = 0,
		MIN_WIDTH = 200,
	},

	-- Tab layout constants (additional)
	TABS = {
		WIDTH = 140,
		HEIGHT = 36,
		BOTTOM_OFFSET = 65,
		SPACING = 5,
		RESIZE_PADDING = 0,
	},

	-- Localization keys
	LOCALIZATION = {
		SEARCH_PLACEHOLDER = "Search items...",
		NO_ITEMS_FOUND = "No items found matching your search.",
		LOADING = "Loading...",
		PAGE_INFO = "Page %d of %d (%d items)",
		TRACK_BUTTON = "Track",
		UNTRACK_BUTTON = "Untrack",
		WAYPOINT_BUTTON = "Waypoint",
		CHAT_LINK_BUTTON = "Link",
		TOOLTIP_ATTEMPTS = "Attempts: %d",
		TOOLTIP_PROGRESS = "Progress: %.1f%%",
		TOOLTIP_LAST_ATTEMPT = "Last attempt: %s",
		TOOLTIP_ESTIMATED_ATTEMPTS = "Estimated attempts: %d",
	},
}

-- Store in addon table
if not addonTable.TabbedWindowModules then
	addonTable.TabbedWindowModules = {}
end

addonTable.TabbedWindowModules.Constants = Constants
