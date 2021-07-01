
-- Upvalues
local GUI = Rarity.GUI

-- Externals
local media = LibStub("LibSharedMedia-3.0")

-- Tracking bar (anchored?)

function GUI:OnBarAnchorClicked(cbk, group, button)
	self = Rarity

	local point, relativeTo, relativePoint, x, y = self.barGroup:GetPoint()
	self:Debug("Clicked anchor", point, relativePoint, x, y) -- This doesn't seem to be working?
	self.db.profile.bar.x = x
	self.db.profile.bar.y = y
	self.db.profile.bar.point = point
	self.db.profile.bar.relativePoint = relativePoint
end

function GUI:InitialiseBar()
	self = Rarity

	self.barGroup = self:NewBarGroup("Rarity", nil, self.db.profile.bar.width, self.db.profile.bar.height)
	self.barGroup.RegisterCallback(Rarity.GUI, "AnchorClicked", "OnBarAnchorClicked")
	Rarity.GUI:UpdateBar()
	self.bar = nil
end

function GUI:UpdateBar()
	self = Rarity

	if not self.barGroup:GetBars() then
		return
	end
	if not self.db.profile.bar.font then
		self.barGroup:SetFont(self.db.profile.bar.font, self.db.profile.bar.fontSize or 8)
	else
		self.barGroup:SetFont(media:Fetch("font", self.db.profile.bar.font), self.db.profile.bar.fontSize or 8)
	end
	if self.db.profile.bar.texture then
		self.barGroup:SetTexture(media:Fetch("statusbar", self.db.profile.bar.texture))
	end
	if self.db.profile.bar.rightAligned then
		self.barGroup:SetOrientation(3)
	else
		self.barGroup:SetOrientation(1)
	end
	if self.db.profile.bar.growUp then
		self.barGroup:ReverseGrowth(true)
	else
		self.barGroup:ReverseGrowth(false)
	end
	if self.db.profile.bar.showIcon then
		self.barGroup:ShowIcon()
	else
		self.barGroup:HideIcon()
	end
	if self.db.profile.bar.showText then
		self.barGroup:ShowLabel()
	else
		self.barGroup:HideLabel()
	end
	self.barGroup:SetColorAt(1.00, 1, 0, 0, 1) -- These SetColorAt calls appear to take longer and longer to execute every time they are called.
	self.barGroup:SetColorAt(0.66, 1, 1, 0, 1) -- Only do this when absolutely necessary.
	self.barGroup:SetColorAt(0.33, 0, 1, 1, 1)
	self.barGroup:SetColorAt(0.00, 0, 0, 1, 1)
	self.barGroup:ClearAllPoints()
	self.barGroup:SetPoint(
		self.db.profile.bar.point,
		UIParent,
		self.db.profile.bar.relativePoint,
		self.db.profile.bar.x,
		self.db.profile.bar.y
	)
	self.barGroup:SetScale(self.db.profile.bar.scale)
	self.barGroup:SetWidth(self.db.profile.bar.width)
	self.barGroup:SetHeight(self.db.profile.bar.height)
	if not self.db.profile.bar.visible then
		self.barGroup:Hide()
	else
		self.barGroup:Show()
	end
	if not self.db.profile.bar.anchor then
		self.barGroup:HideAnchor()
	else
		self.barGroup:ShowAnchor()
	end
	if not self.db.profile.bar.locked then
		self.barGroup:Unlock()
	else
		self.barGroup:Lock()
	end
end