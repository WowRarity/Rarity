local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)

local CopyPastePopup = { editBoxText = "", instructionText = "" }

function CopyPastePopup:OnLoad()
	self:ConfigureStaticPopUp()

	local instructionText = L["Use CTRL+C to copy and CTRL+V to paste"]
	if IsMacClient() then
		instructionText = L["Use CMD+C to copy and CMD+V to paste"]
	end
	self:SetInstructionText(instructionText)
end

function CopyPastePopup:ConfigureStaticPopUp()
	local popup = StaticPopupDialogs["RarityCopyPastePopup"]
	function self.ShowPopupDialogWithEditBox(msg, text, callback, timeout)
		if not popup then
			popup = {
				button1 = L["Close Window"],
				timeout = timeout,
				showAlert = false,
				whileDead = true,
				hideOnEscape = true,
				enterClicksFirstButton = true,
				hasEditBox = true,
				OnAccept = function(frame)
					if popup.callback then
						local editBox = frame.GetEditBox and frame:GetEditBox() or frame.editBox
						popup.callback(editBox:GetText())
					end
				end,
			}
			StaticPopupDialogs["RarityCopyPastePopup"] = popup
		end
		popup.OnShow = function(frame, data)
			local editBox = frame.GetEditBox and frame:GetEditBox() or frame.editBox
			editBox:SetText(text)
			editBox:SetJustifyH("CENTER")
			editBox:SetWidth(240)
			editBox:HighlightText()
		end
		popup.text = msg or L["Use CTRL+C to copy and CTRL+V to paste"]
		popup.callback = callback
		StaticPopup_Hide("RarityCopyPastePopup")
		StaticPopup_Show("RarityCopyPastePopup")
	end
end

function CopyPastePopup:SetEditBoxText(text)
	text = text or ""
	self.editBoxText = text
end

function CopyPastePopup:SetInstructionText(text)
	text = text or ""
	self.instructionText = text
end

function CopyPastePopup:Show()
	self.name = "RarityCopyPastePopup"
	self.ShowPopupDialogWithEditBox(
		self.instructionText,
		self.editBoxText,
		function(frame)
			-- OnCloseCallback? (or at least it's triggered when you click OK)
		end,
		nil -- autoCloseTimeoutInMilliseconds
	)
	local popup = StaticPopupDialogs[self.name] or self.popup
	self.popup = popup
	StaticPopup_Show(self.name)
end

CopyPastePopup:OnLoad()

Rarity.CopyPastePopup = CopyPastePopup
