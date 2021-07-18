local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)

local CopyPastePopup = {
	editBoxText = "",
	instructionText = ""
}

function CopyPastePopup:OnLoad()
	self:ConfigureStaticPopUp()
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
				OnAccept = function(self)
					if popup.callback then
						popup.callback(self.editBox:GetText())
					end
				end
			}
			StaticPopupDialogs["RarityCopyPastePopup"] = popup
		end
		popup.OnShow = function(self, data)
			self.editBox:SetText(text)
			self.editBox:SetJustifyH("CENTER")
			self.editBox:SetWidth(240)
			self.editBox:HighlightText()
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
	self.ShowPopupDialogWithEditBox(
		self.instructionText,
		self.editBoxText,
		function(self)
			-- OnCloseCallback? (or at least it's triggered when you click OK)
		end,
		nil -- autoCloseTimeoutInMilliseconds
	)
	local popup = StaticPopupDialogs["RarityCopyPastePopup"] or self.popup
	self.popup = popup
	-- self:Hide()
	StaticPopup_Show(self.name)
end

CopyPastePopup:OnLoad()

Rarity.CopyPastePopup = CopyPastePopup
