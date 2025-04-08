local DebugMenuFrame = {
	minPanelWidth = 640,
	minPanelHeight = 240,
	defaultPanelWidth = 640,
	defaultPanelHeight = 240,
}
function DebugMenuFrame:OnLoad()
	local frame = CreateFrame("Frame", "RarityDebugMenuFramec", UIParent, "ButtonFrameTemplate")
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

	frame:SetScript("OnEvent", DebugMenuFrame.OnEvent)

	frame.Title = CreateFrame("Frame", "$parentTitle", frame, "PanelDragBarTemplate")
	frame.Title:SetHeight(32)
	frame.Title:SetPoint("TOPLEFT")
	frame.Title:SetPoint("TOPRIGHT")
	frame.Title:Init(frame)

	frame.ResizeButton = CreateFrame("Button", "$parentResizeButton", frame, "PanelResizeButtonTemplate")
	frame.ResizeButton:SetPoint("BOTTOMRIGHT")
	frame.ResizeButton:Init(frame, self.minPanelWidth, self.minPanelHeight)

	frame.Close = CreateFrame("Button", "$parentClose", frame, BackdropTemplateMixin and "UIPanelCloseButtonNoScripts")

	self.innerText = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight") -- TBD content, not header?
	self.innerText:SetJustifyH("LEFT")
	self.innerText:SetJustifyV("MIDDLE")
	self.innerText:SetPoint("TOPLEFT", 16, -32 - 2 - 32)
	self.frame = frame

	for tabIndex, tabInfo in ipairs(self.tabs) do
		self:CreateTabPanel(tabIndex, tabInfo)
	end

	PanelTemplates_SetNumTabs(frame, #self.tabs)
	PanelTemplates_SetTab(frame, 1)

	-- Once saved vars are loaded synchronously, show based on debug mode setting
	frame:Hide()
end

function DebugMenuFrame:CreateTabPanel(tabIndex, tabInfo)
	local parent = self.frame
	local name = "$parentTabButton" .. tabIndex
	local tabButton = CreateFrame("Button", name, parent, "CharacterFrameTabTemplate")

	tabButton:SetPoint("TOPLEFT", parent, "BOTTOMLEFT", 11, 2)
	tabButton:SetText(tabInfo.displayText)
	tabButton:SetScript("OnClick", function(_, button)
		PanelTemplates_Tab_OnClick(tabButton, parent)
		PanelTemplates_SetTab(parent, tabIndex)
		PlaySound(SOUNDKIT.IG_CHARACTER_INFO_TAB)

		local clickHandler = tabInfo.action or self.ShowPlaceholderText
		clickHandler(self, tabIndex, tabInfo)
	end)

	if tabInfo.disabled then
		PanelTemplates_DisableTab(parent, tabIndex)
	end
end

function DebugMenuFrame:ShowPlaceholderText(_, tabInfo)
	local fallback = format("Not yet implemented: %s", tabInfo.displayText)
	self.innerText:SetText(fallback)
end

function DebugMenuFrame:Update()
	if Rarity.db.profile.debugMode then
		self.frame:RegisterEvent("ZONE_CHANGED")
		self.frame:RegisterEvent("ZONE_CHANGED_INDOORS")
		self.frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
		self.frame:RegisterEvent("PLAYER_ENTERING_WORLD")

		self.frame:Show()

		-- Force-update in case debug mode was disabled on login
		self:UpdateMapInfo()
		return
	end

	self.frame:UnregisterEvent("ZONE_CHANGED")
	self.frame:UnregisterEvent("ZONE_CHANGED_INDOORS")
	self.frame:UnregisterEvent("ZONE_CHANGED_NEW_AREA")
	self.frame:UnregisterEvent("PLAYER_ENTERING_WORLD")

	self.frame:Hide()
end

function DebugMenuFrame.OnEvent(event, ...)
	DebugMenuFrame:UpdateMapInfo()
end

function DebugMenuFrame:UpdateMapInfo()
	local colorize = Rarity.Utils.String.Colorize
	local green = Rarity.Enum.Colors.Green
	local red = Rarity.Enum.Colors.Red
	local blue = Rarity.Enum.Colors.Blue
	Rarity:Debug("ZONE_CHANGED")

	local mapID = C_Map.GetBestMapForUnit("player")
	local mapInfo = mapID and C_Map.GetMapInfo(mapID) or nil
	mapID = mapID and colorize(mapID, blue) or colorize("N/A", red)

	-- mapID == nil -> check instance info?
	local mapName = mapInfo and colorize(mapInfo.name, green) or colorize("Unknown", red)
	-- local mapID = colorize(GetSubZoneText() or "NO SUBZONE TEXT (N/A)", green)
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
		"UI Map: "
			.. mapID
			.. " ("
			.. mapName
			.. ")"
			.. "|nSubzone: "
			.. subzoneText
			.. "|nInstance: "
			.. name
			.. " (Type: "
			.. instanceType
			.. ")"
			.. "|nDifficulty: "
			.. difficultyID
			.. " ("
			.. difficultyName
			.. ")"
			.. "|nLFG Dungeon ID: "
			.. LfgDungeonID
			.. "|nInstance ID: "
			.. instanceID
	)
end

DebugMenuFrame.tabs = {
	{
		displayText = "Map Info",
		action = DebugMenuFrame.UpdateMapInfo,
	},
	{
		displayText = "Spell Tracking",
		disabled = true,
	},
	{
		displayText = "Defeat Detection",
		disabled = true,
	},
	{
		displayText = "Attempts",
		disabled = true,
	},
	{
		displayText = "Caching",
		disabled = true,
	},
}

Rarity.GUI.DebugMenuFrame = DebugMenuFrame

DebugMenuFrame:OnLoad()
