local DebugMenuFrame = {
	-- numMessagesToDisplay = 30,
	backdropSettings = {
		bgFile = "Interface/BUTTONS/WHITE8X8",
		edgeFile = "Interface/GLUES/Common/Glue-Tooltip-Border",
		tile = true,
		edgeSize = 8,
		tileSize = 8,
		insets = {
			left = 5,
			right = 5,
			top = 5,
			bottom = 5,
		},
	},
}

-- local CopyPastePopup = Rarity.CopyPastePopup
-- local DebugCache = Rarity.Utils.DebugCache

function DebugMenuFrame:OnLoad()
	-- 	local numSavedLines = DebugCache.cacheSize

	local MinPanelWidth = 715
	local MinPanelHeight = 210
	local DefaultPanelWidth = MinPanelWidth
	local DefaultPanelHeight = 400

	local frame =
		CreateFrame("Frame", "RarityDebugMenuFrame", UIParent, BackdropTemplateMixin and "ButtonFrameTemplate")
	ButtonFrameTemplate_HidePortrait(frame)
	frame:SetSize(DefaultPanelWidth, DefaultPanelHeight)
	frame:SetPoint("CENTER")
	frame:SetToplevel(true)
	frame:SetMovable(true)
	frame:SetResizable(true)
	frame:EnableMouse(true)
	frame:SetClampedToScreen(true)
	frame:SetTitle("Rarity: Debug Menu")
	frame:SetFrameStrata("DIALOG")
	-- frame:SetBackdrop(self.backdropSettings)
	-- frame:SetBackdropColor(0, 0, 0)

	frame.Title = CreateFrame("Frame", "$parentTitle", frame, "PanelDragBarTemplate")
	frame.Title:SetHeight(32)
	frame.Title:SetPoint("TOPLEFT")
	frame.Title:SetPoint("TOPRIGHT")
	frame.Title:Init(frame)

	frame.ResizeButton = CreateFrame("Button", "$parentResizeButton", frame, "PanelResizeButtonTemplate")
	frame.ResizeButton:SetPoint("BOTTOMRIGHT")
	frame.ResizeButton:Init(frame, MinPanelWidth, MinPanelHeight)

	frame.Close = CreateFrame("Button", "$parentClose", frame, BackdropTemplateMixin and "UIPanelCloseButtonNoScripts")

	local function OnEvent(event, ...)
		Rarity:Debug("DebugMenuFrame.OnEvent: " .. tostring(event))
		print(event, GetSubZoneText())
		DebugMenuFrame:ZONE_CHANGED(event, ...)
	end

	frame:RegisterEvent("ZONE_CHANGED")
	frame:RegisterEvent("ZONE_CHANGED_INDOORS")
	frame:RegisterEvent("ZONE_CHANGED_NEW_AREA")
	frame:RegisterEvent("PLAYER_ENTERING_WORLD")
	frame:SetScript("OnEvent", OnEvent)

	self.header = frame:CreateFontString(nil, "OVERLAY", "GameFontHighlight")
	self.header:SetJustifyH("LEFT")
	self.header:SetJustifyV("TOP")
	self.header:SetPoint("TOPLEFT", 16, -32 - 32)
	self.header:SetText("")
	self.frame = frame
end
function DebugMenuFrame.OnEvent(event, ...)
	-- Rarity:Debug("DebugMenuFrame.OnEvent: " .. tostring(event))
	-- 	print(event, GetSubZoneText())
	-- 	DebugMenuFrame:ZONE_CHANGED(event, ...)
end

-- TODO unregister if debug mode is turned off
function DebugMenuFrame:ZONE_CHANGED(event, ...)
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

	self.header:SetText(
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

Rarity.DebugMenuFrame = DebugMenuFrame

DebugMenuFrame:OnLoad()
