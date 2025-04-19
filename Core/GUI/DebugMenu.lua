local colorize = Rarity.Utils.String.Colorize
local green = Rarity.Enum.Colors.Green
local red = Rarity.Enum.Colors.Red
local blue = Rarity.Enum.Colors.Blue

local DebugMenu = {
	minPanelWidth = 500,
	minPanelHeight = 200,
	defaultPanelWidth = 500,
	defaultPanelHeight = 200,
	tabs = {
		"Map Info",
		"Spell Tracking",
	},
	selectedTab = "Map Info",
	tabButtons = {},
	events = {
		"PLAYER_ENTERING_WORLD",
		"UPDATE_MOUSEOVER_UNIT",
		"UNIT_SPELLCAST_FAILED",
		"UNIT_SPELLCAST_SENT",
		"UNIT_SPELLCAST_STOP",
		"UNIT_SPELLCAST_SUCCEEDED",
		"WORLD_CURSOR_TOOLTIP_UPDATE",
		"ZONE_CHANGED",
		"ZONE_CHANGED_INDOORS",
		"ZONE_CHANGED_NEW_AREA",
	},
}

function DebugMenu:OnLoad()
	if self.frame then
		return
	end

	local frame = CreateFrame("Frame", "RarityDebugMenuFrame", UIParent, "ButtonFrameTemplate")
	ButtonFrameTemplate_HidePortrait(frame)
	frame:SetSize(self.defaultPanelWidth, self.defaultPanelHeight)
	frame:SetPoint("CENTER")
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetTitle("Rarity: Debug Menu")
	frame:SetFrameStrata("DIALOG")
	self.frame = frame

	local titleBar = CreateFrame("Frame", "$parentTitleBar", frame, "PanelDragBarTemplate")
	titleBar:SetHeight(32)
	titleBar:SetPoint("TOPLEFT")
	titleBar:SetPoint("TOPRIGHT")
	titleBar:Init(frame)
	self.titleBar = titleBar

	local reloadButton = CreateFrame("Button", "$parentReloadButton", frame, "UIPanelButtonTemplate")
	reloadButton:SetPoint("TOPLEFT", 16 - 6, -32 + 6)
	reloadButton:SetSize(80, 32)
	reloadButton:RegisterForClicks("AnyDown", "AnyUp")
	reloadButton:SetText("Reload UI")
	reloadButton:SetScript("OnClick", function()
		ReloadUI()
	end)
	self.reloadButton = reloadButton

	local alertButton = CreateFrame("Button", "$parentAlertButton", frame, "UIPanelButtonTemplate")
	alertButton:SetPoint("LEFT", reloadButton, "RIGHT", 2, 0)
	alertButton:SetSize(80, 32)
	alertButton:RegisterForClicks("AnyUp")
	alertButton:SetText("Test Alert")
	alertButton:SetScript("OnClick", function()
		Rarity:ShowFoundAlert(32458, 5)
	end)
	self.alertButton = alertButton

	local resizeButton = CreateFrame("Button", "$parentResizeButton", frame, "PanelResizeButtonTemplate")
	resizeButton:SetPoint("BOTTOMRIGHT")
	resizeButton:Init(frame, self.minPanelWidth, self.minPanelHeight)
	self.resizeButton = resizeButton

	local closeButton = CreateFrame("Button", "$parentCloseButton", frame, "UIPanelCloseButtonNoScripts")
	self.closeButton = closeButton

	local innerText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	innerText:SetJustifyH("LEFT")
	innerText:SetPoint("TOPLEFT", frame.Inset, "TOPLEFT", 11, -11)
	self.innerText = innerText

	for tabIndex, tabInfo in ipairs(self.tabs) do
		self:CreateTabPanel(tabIndex, tabInfo)
	end
	PanelTemplates_SetNumTabs(frame, #self.tabs)
	PanelTemplates_SetTab(frame, 1)

	self.frame:SetScript("OnEvent", function(...)
		self:UpdateSelectedTabContent()
	end)

	self.frame:Hide() -- Tab panels aren't updated unless the frame is explicitly shown (?)
end

function DebugMenu:CreateTabPanel(tabIndex, tabInfo)
	local parent = self.frame
	local name = "$parentTab" .. tabIndex
	local template = C_EditMode and "CharacterFrameTabTemplate" or "CharacterFrameTabButtonTemplate"
	local tabButton = CreateFrame("Button", name, parent, template)

	local previousTabPanel = self.tabButtons[#self.tabButtons]
	if previousTabPanel then
		tabButton:SetPoint("LEFT", previousTabPanel, "RIGHT", -15, 0)
	else
		tabButton:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 11, 2)
	end
	tabButton:SetText(tabInfo)
	tabButton:SetScript("OnClick", function(_, button)
		PanelTemplates_Tab_OnClick(tabButton, parent)
		PanelTemplates_SetTab(parent, tabIndex)
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)
		self.selectedTab = tabInfo
		self:UpdateSelectedTabContent()
	end)

	self.tabButtons[#self.tabButtons + 1] = tabButton
end

function DebugMenu:UpdateSelectedTabContent()
	if self.selectedTab == "Map Info" then
		self:UpdateMapInfo()
	elseif self.selectedTab == "Spell Tracking" then
		self:UpdateSpellTracker()
	else
		self:ShowPlaceholderText()
	end
end

function DebugMenu:ShowPlaceholderText()
	local fallback = format("Not yet implemented: %s", self.selectedTab)
	self.innerText:SetText(fallback)
end

function DebugMenu:UpdateMapInfo()
	local mapID = C_Map.GetBestMapForUnit("player")
	local mapInfo = mapID and C_Map.GetMapInfo(mapID) or nil
	mapID = mapID and colorize(mapID, blue) or colorize("N/A", red)

	local mapName = mapInfo and colorize(mapInfo.name, green) or colorize("Unknown", red)
	local subzoneText = GetSubZoneText()
	subzoneText = (subzoneText == "") and colorize("N/A", red) or colorize(subzoneText, green)

	local name, instanceType, difficultyID, difficultyName, maxPlayers, dynamicDifficulty, isDynamic, instanceID, instanceGroupSize, LfgDungeonID =
		GetInstanceInfo()

	name = name and colorize(name, green) or colorize("Unknown", red)
	instanceType = instanceType and colorize(instanceType, blue) or colorize("N/A", red)
	difficultyID = difficultyID and colorize(difficultyID, blue) or colorize("N/A", red)
	difficultyName = (difficultyName ~= "") and colorize(difficultyName, green) or colorize("Unknown", red)
	instanceID = instanceID and colorize(instanceID, blue) or colorize("N/A", red)
	LfgDungeonID = instanceID and colorize(LfgDungeonID, blue) or colorize("N/A", red)

	self.innerText:SetText(
		format(
			"UI Map: %s (%s)|n"
				.. "Subzone: %s|n"
				.. "Instance: %s (Type: %s)|n"
				.. "Difficulty: %s (%s)|n"
				.. "LFG Dungeon ID: %s|n"
				.. "Instance ID: %s",
			mapID,
			mapName,
			subzoneText,
			name,
			instanceType,
			difficultyID,
			difficultyName,
			LfgDungeonID,
			instanceID
		)
	)
end

local function colorizeBoolean(value)
	if value == true then
		return colorize("TRUE", green)
	elseif value == false then
		return colorize("FALSE", red)
	else
		return colorize("N/A", blue)
	end
end

function DebugMenu:UpdateSpellTracker()
	local spellID = colorize(Rarity.previousSpell or "N/A", blue)
	local name = colorize(Rarity.relevantSpells[Rarity.previousSpell] or "untracked", blue)
	local target = colorize(Rarity.lastNode or "N/A", blue)
	local mouseoverGUID = colorize(UnitGUID("mouseover") or "N/A", blue)
	local mouseoverNPC = colorize(Rarity:GetNPCIDFromGUID(mouseoverGUID), blue)
	self.innerText:SetText(
		format("Spell ID: %s (%s)", spellID, name)
			.. "|n"
			.. "|n"
			.. format("Hovering: %s (%s)", mouseoverGUID, mouseoverNPC)
			.. "|n"
			.. format("Targeting: %s (%s)", colorizeBoolean(Rarity.foundTarget), target)
			.. "|n"
			.. "|n"
			.. format("Opening: %s", colorizeBoolean(Rarity.isOpening))
			.. "|n"
			.. format("Fishing: %s", colorizeBoolean(Rarity.isFishing))
			.. "|n"
			.. format("Pool: %s", colorizeBoolean(Rarity.isPool))
			.. "|n"
	)
end

function DebugMenu:Show()
	if not self.frame then
		-- Load on demand since most players won't find this particularly useful
		self:OnLoad()
	end

	self:UpdateSelectedTabContent()

	for _, event in ipairs(self.events) do
		self.frame:RegisterEvent(event)
	end

	self.frame:Show()
end

function DebugMenu:Hide()
	if not self.frame then
		return
	end

	for _, event in ipairs(self.events) do
		self.frame:UnregisterEvent(event)
	end

	self.frame:Hide()
end

Rarity.GUI.DebugMenu = DebugMenu
