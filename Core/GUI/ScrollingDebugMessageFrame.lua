local ScrollingDebugMessageFrame = {
	numMessagesToDisplay = 30,
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

local CopyPastePopup = Rarity.CopyPastePopup
local DebugCache = Rarity.Utils.DebugCache

function ScrollingDebugMessageFrame:OnLoad()
	local numSavedLines = DebugCache.cacheSize

	local frame =
		CreateFrame("Frame", "RarityScrollingDebugMessageFrame", UIParent, BackdropTemplateMixin and "BackdropTemplate")
	frame:SetSize(1024, 640)
	frame:SetPoint("CENTER")
	frame:SetAlpha(0.5)
	frame:SetFrameStrata("BACKGROUND")
	frame:SetBackdrop(self.backdropSettings)
	frame:SetBackdropColor(0, 0, 0)

	frame.Close = CreateFrame("Button", "$parentClose", frame)
	frame.Close:SetSize(24, 24)
	frame.Close:SetPoint("TOPRIGHT")
	frame.Close:SetNormalTexture("Interface/Buttons/UI-Panel-MinimizeButton-Up")
	frame.Close:SetPushedTexture("Interface/Buttons/UI-Panel-MinimizeButton-Down")
	frame.Close:SetHighlightTexture("Interface/Buttons/UI-Panel-MinimizeButton-Highlight", "ADD")
	frame.Close:SetScript("OnClick", function(widget)
		widget:GetParent():Hide()
	end)

	frame.Messages = CreateFrame("ScrollingMessageFrame", "$parentMessages", frame)
	frame.Messages:SetPoint("TOPLEFT", 15, -25)
	frame.Messages:SetPoint("BOTTOMRIGHT", -30, 15)
	frame.Messages:SetTextCopyable(true)
	frame.Messages:EnableMouse(true)
	frame.Messages:SetInsertMode(SCROLLING_MESSAGE_FRAME_INSERT_MODE_TOP)
	frame.Messages:SetMaxLines(numSavedLines)
	frame.Messages:SetFading(false)
	frame.Messages:SetIndentedWordWrap(true)
	frame.Messages:SetFontObject(ChatFontNormal)
	frame.Messages:SetJustifyH("LEFT")

	frame.Scroll = CreateFrame("ScrollFrame", "$parentScroll", frame, "FauxScrollFrameTemplate")
	frame.Scroll:SetPoint("TOPLEFT", 15, -25)
	frame.Scroll:SetPoint("BOTTOMRIGHT", -30, 15)
	local function ScrollList(widget)
		local offset = FauxScrollFrame_GetOffset(widget)
		widget:GetParent().Messages:SetScrollOffset(offset)
		FauxScrollFrame_Update(widget, numSavedLines, 25, 12)
	end
	frame.Scroll:SetScript("OnVerticalScroll", function(widget, offset)
		FauxScrollFrame_OnVerticalScroll(widget, offset, 6, ScrollList)
	end)

	frame.Select = CreateFrame("Button", "$parentSelect", frame, "UIPanelButtonTemplate")
	frame.Select:SetSize(180, 25)
	frame.Select:SetPoint("RIGHT", frame.Close, "LEFT")
	frame.Select:SetText("Copy ALL the things")
	frame.Select:SetScale(0.85)
	frame.Select:SetScript("OnClick", function()
		local concatenatedMessages = DebugCache:GetCopyableMessageString()
		CopyPastePopup:SetEditBoxText(concatenatedMessages)
		CopyPastePopup:Show()
	end)

	frame.Clear = CreateFrame("Button", "$parentClear", frame, "UIPanelButtonTemplate")
	frame.Clear:SetSize(180, 25)
	frame.Clear:SetPoint("RIGHT", frame.Select, "LEFT")
	frame.Clear:SetText("Clear ALL the things")
	frame.Clear:SetScale(0.85)
	frame.Clear:SetScript("OnClick", function()
		DebugCache:Clear()
		frame.Messages:Clear()
	end)

	frame:Hide()

	self.frame = frame
end

function ScrollingDebugMessageFrame:AddMessage(message)
	self.frame.Messages:AddMessage(message)

	if not self.frame:IsShown() then
		return -- No need to waste time updating an invisible frame
	end

	self:UpdateDisplayedMessages()
end

function ScrollingDebugMessageFrame:Toggle()
	self.frame:SetShown(not self.frame:IsShown())
end

function ScrollingDebugMessageFrame:UpdateDisplayedMessages()
	local numMessagesAvailable = self.frame.Messages:GetNumMessages()
	FauxScrollFrame_Update(self.frame.Scroll, numMessagesAvailable, self.numMessagesToDisplay, 12)
end

Rarity.ScrollingDebugMessageFrame = ScrollingDebugMessageFrame

ScrollingDebugMessageFrame:OnLoad()
