-- Upvalues
local GUI = Rarity.GUI

-- Externals
local media = LibStub("LibSharedMedia-3.0")

-- Custom StatusBar Container to replace LibBars functionality
local RarityBarContainer = {}
RarityBarContainer.__index = RarityBarContainer

function RarityBarContainer:New(name, parent, width, height)
	local container = setmetatable({}, RarityBarContainer)

	-- Create main container frame
	container.frame = CreateFrame("Frame", name, parent or UIParent)
	container.frame:SetSize(width or 200, height or 20)
	container.frame:SetMovable(true)
	container.frame:EnableMouse(false) -- Initially disabled

	-- Properties
	container.bars = {}
	container.callbacks = {}
	container.locked = true
	container.anchorVisible = false
	container.colorStops = {}
	container.orientation = 1 -- 1 = left to right, 3 = right to left
	container.reverseGrowth = false
	container.showIcon = true
	container.showText = true

	-- Create anchor frame for dragging (more polished appearance)
	container.anchor = CreateFrame("Frame", name .. "Anchor", container.frame, "BackdropTemplate")
	container.anchor:SetSize(16, 16) -- Smaller, less intrusive
	container.anchor:SetPoint("TOP", container.frame, "TOP", 0, 20) -- Position above the center of the bar
	container.anchor:SetMovable(true)
	container.anchor:EnableMouse(true)
	container.anchor:RegisterForDrag("LeftButton")
	container.anchor:Hide() -- Hidden by default

	-- Anchor backdrop (more subtle appearance)
	container.anchor:SetBackdrop({
		bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		tile = true,
		tileSize = 4,
		edgeSize = 4,
		insets = { left = 1, right = 1, top = 1, bottom = 1 },
	})
	container.anchor:SetBackdropColor(0.2, 0.2, 0.3, 0.9) -- Slightly more visible
	container.anchor:SetBackdropBorderColor(0.6, 0.6, 0.7, 1) -- Lighter border

	-- Anchor text (smaller and more subtle)
	container.anchor.text = container.anchor:CreateFontString(nil, "OVERLAY")
	container.anchor.text:SetPoint("CENTER")
	container.anchor.text:SetFont("Fonts\\FRIZQT__.TTF", 7, "OUTLINE")
	container.anchor.text:SetText(":::") -- Use a more universal "drag handle" symbol
	container.anchor.text:SetTextColor(0.9, 0.9, 1, 1)

	-- Anchor drag functionality
	container.anchor:SetScript("OnDragStart", function(self)
		container.frame:StartMoving()
	end)

	container.anchor:SetScript("OnDragStop", function(self)
		container.frame:StopMovingOrSizing()
		container:FireCallback("AnchorClicked")
	end)

	-- Store reference for cleanup
	container.frame.rarityContainer = container

	return container
end

function RarityBarContainer:RegisterCallback(obj, event, method)
	if not self.callbacks[event] then
		self.callbacks[event] = {}
	end
	table.insert(self.callbacks[event], { obj = obj, method = method })
end

function RarityBarContainer:FireCallback(event, ...)
	if self.callbacks[event] then
		for _, callback in ipairs(self.callbacks[event]) do
			if callback.obj and callback.obj[callback.method] then
				callback.obj[callback.method](callback.obj, ...)
			end
		end
	end
end

function RarityBarContainer:CreateBar(name, icon, maxValue, value)
	local bar = CreateFrame("StatusBar", name, self.frame)

	-- Set up AnimatedStatusBarTemplate properties
	bar.tileTemplate = "AnimatedStatusBarGlowLinesTemplate"
	bar.tileTemplateWidth = 37
	bar.tileTemplateOverlap = 0
	bar.tileTemplateDelay = 0.3

	-- Apply AnimatedStatusBarMixin if available
	if AnimatedStatusBarMixin then
		Mixin(bar, AnimatedStatusBarMixin)
	end

	-- Create ColorableTextures array (for animation color changes)
	bar.ColorableTextures = {}
	bar.AnimatedTextures = {}

	-- Create the animated texture layers following Blizzard's template
	-- BORDER Layer - BarGain
	bar.BarGain = bar:CreateTexture(nil, "BORDER")
	bar.BarGain:SetSize(50, 20)
	bar.BarGain:SetPoint("TOPLEFT")
	bar.BarGain:SetPoint("BOTTOMLEFT")
	bar.BarGain:SetAlpha(0)
	bar.BarGain:SetBlendMode("BLEND")
	bar.BarGain:SetTexture("Interface\\TargetingFrame\\UI-StatusBar") -- Fallback texture
	table.insert(bar.ColorableTextures, bar.BarGain)

	-- ARTWORK Layer - BarTrailGlow
	bar.BarTrailGlow = bar:CreateTexture(nil, "ARTWORK")
	bar.BarTrailGlow:SetSize(50, 20)
	bar.BarTrailGlow:SetPoint("TOPRIGHT", bar, "TOPLEFT")
	bar.BarTrailGlow:SetPoint("BOTTOMRIGHT", bar, "BOTTOMLEFT")
	bar.BarTrailGlow:SetAlpha(0)
	bar.BarTrailGlow:SetBlendMode("ADD")
	bar.BarTrailGlow:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	table.insert(bar.ColorableTextures, bar.BarTrailGlow)

	-- OVERLAY Layer - BarGlow
	bar.BarGlow = bar:CreateTexture(nil, "OVERLAY")
	bar.BarGlow:SetSize(50, 8)
	bar.BarGlow:SetPoint("LEFT", 0, 8)
	bar.BarGlow:SetAlpha(0)
	bar.BarGlow:SetBlendMode("ADD")
	bar.BarGlow:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	table.insert(bar.ColorableTextures, bar.BarGlow)

	-- OVERLAY Layer - SparkBurstMove
	bar.SparkBurstMove = bar:CreateTexture(nil, "OVERLAY")
	bar.SparkBurstMove:SetSize(16, 16)
	bar.SparkBurstMove:SetPoint("CENTER", bar, "LEFT")
	bar.SparkBurstMove:SetAlpha(0)
	bar.SparkBurstMove:SetBlendMode("ADD")
	bar.SparkBurstMove:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark")
	table.insert(bar.AnimatedTextures, bar.SparkBurstMove)

	-- Create the main animation group
	bar.Anim = bar:CreateAnimationGroup()
	bar.Anim:SetToFinalAlpha(true)

	-- Set up the StatusBar texture to BORDER layer (per Blizzard template)
	bar:SetStatusBarTexture("Interface\\TargetingFrame\\UI-StatusBar")
	if bar:GetStatusBarTexture() then
		bar:GetStatusBarTexture():SetDrawLayer("BORDER")
	end

	-- Basic setup
	bar:SetMinMaxValues(0, maxValue or 100)
	bar:SetValue(value or 0)
	bar:SetStatusBarColor(0, 0.5, 1, 1) -- Default blue

	-- Create background
	bar.bg = bar:CreateTexture(nil, "BACKGROUND")
	bar.bg:SetAllPoints(bar)
	bar.bg:SetTexture("Interface\\TargetingFrame\\UI-StatusBar")
	bar.bg:SetVertexColor(0, 0, 0, 0.4) -- Slightly more visible background

	-- Create border for more polished look
	bar.border = CreateFrame("Frame", nil, bar, "BackdropTemplate")
	bar.border:SetAllPoints(bar)
	bar.border:SetBackdrop({
		edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
		edgeSize = 1,
		insets = { left = 0, right = 0, top = 0, bottom = 0 },
	})
	bar.border:SetBackdropBorderColor(0.3, 0.3, 0.3, 0.8) -- Subtle dark border

	-- Create text label (positioned considering the icon is to the left)
	bar.text = bar:CreateFontString(nil, "OVERLAY")
	bar.text:SetPoint("CENTER", bar, "CENTER", 0, 0) -- Centered on the bar itself
	bar.text:SetFont("Fonts\\FRIZQT__.TTF", 10, "OUTLINE")
	bar.text:SetTextColor(1, 1, 1, 1)
	bar.text:SetJustifyH("CENTER")

	-- Create icon (positioned to the left of the bar)
	bar.icon = bar:CreateTexture(nil, "ARTWORK")
	bar.icon:SetSize(18, 18) -- Slightly larger for better visibility
	bar.icon:SetPoint("RIGHT", bar, "LEFT", -3, 0) -- Position to the left of the bar with small gap
	bar.icon:SetTexCoord(0.08, 0.92, 0.08, 0.92) -- Crop edges for cleaner look

	if icon then
		bar.icon:SetTexture(icon)
	end

	-- Initialize AnimatedStatusBarMixin if available
	if bar.OnLoad then
		bar:OnLoad()
	end

	-- Set up OnUpdate script for animation handling
	bar:SetScript("OnUpdate", function(self, elapsed)
		if self.OnUpdate then
			self:OnUpdate(elapsed)
		end
	end)

	-- Apply current settings
	if not self.showIcon then
		bar.icon:Hide()
	end
	if not self.showText then
		bar.text:Hide()
	end

	-- Set orientation
	if self.orientation == 3 then
		bar:SetReverseFill(true)
	end

	table.insert(self.bars, bar)
	self:UpdateLayout()

	return bar
end

function RarityBarContainer:UpdateLayout()
	local numBars = #self.bars
	if numBars == 0 then
		return
	end

	local containerHeight = self.frame:GetHeight()
	local barHeight = math.max(1, containerHeight / numBars)

	for i, bar in ipairs(self.bars) do
		bar:SetSize(self.frame:GetWidth(), barHeight)

		if self.reverseGrowth then
			-- Grow upward
			bar:SetPoint("BOTTOMLEFT", self.frame, "BOTTOMLEFT", 0, (i - 1) * barHeight)
		else
			-- Grow downward (default)
			bar:SetPoint("TOPLEFT", self.frame, "TOPLEFT", 0, -(i - 1) * barHeight)
		end

		bar:Show()
	end
end

function RarityBarContainer:GetBars()
	return self.bars
end

function RarityBarContainer:SetFont(font, size)
	for _, bar in ipairs(self.bars) do
		if bar.text then
			bar.text:SetFont(font, size or 10, "OUTLINE")
		end
	end
end

function RarityBarContainer:SetTexture(texture)
	for _, bar in ipairs(self.bars) do
		bar:SetStatusBarTexture(texture)
		if bar.bg then
			bar.bg:SetTexture(texture)
		end
	end
end

function RarityBarContainer:SetOrientation(orientation)
	self.orientation = orientation
	for _, bar in ipairs(self.bars) do
		if orientation == 3 then
			bar:SetReverseFill(true)
		else
			bar:SetReverseFill(false)
		end
	end
end

function RarityBarContainer:ReverseGrowth(reverse)
	self.reverseGrowth = reverse
	self:UpdateLayout()
end

function RarityBarContainer:ShowIcon()
	self.showIcon = true
	for _, bar in ipairs(self.bars) do
		if bar.icon then
			bar.icon:Show()
		end
	end
end

function RarityBarContainer:HideIcon()
	self.showIcon = false
	for _, bar in ipairs(self.bars) do
		if bar.icon then
			bar.icon:Hide()
		end
	end
end

function RarityBarContainer:ShowLabel()
	self.showText = true
	for _, bar in ipairs(self.bars) do
		if bar.text then
			bar.text:Show()
		end
	end
end

function RarityBarContainer:HideLabel()
	self.showText = false
	for _, bar in ipairs(self.bars) do
		if bar.text then
			bar.text:Hide()
		end
	end
end

function RarityBarContainer:SetColorAt(percent, r, g, b, a)
	-- Store color stops for gradient calculation
	self.colorStops[percent] = { r, g, b, a }

	-- Apply color to all bars based on their current value
	for _, bar in ipairs(self.bars) do
		self:UpdateBarColor(bar)
		-- Update animated texture colors if available
		if bar.SetAnimatedTextureColors then
			bar:SetAnimatedTextureColors(r, g, b)
		end
	end
end

function RarityBarContainer:UpdateBarColor(bar)
	if not bar then
		return
	end

	local currentPercent = 0
	local min, max = bar:GetMinMaxValues()
	if max > min then
		currentPercent = (bar:GetValue() - min) / (max - min)
	end

	-- Find the appropriate color based on current percentage
	local r, g, b, a = self:GetColorAtPercent(currentPercent)
	bar:SetStatusBarColor(r, g, b, a)
end

function RarityBarContainer:GetColorAtPercent(percent)
	if not next(self.colorStops) then
		return 0, 0.5, 1, 1 -- Default blue
	end

	-- Find the two color stops that bracket this percentage
	local lowerStop, upperStop = nil, nil
	local lowerPercent, upperPercent = 0, 1

	for stopPercent, color in pairs(self.colorStops) do
		if stopPercent <= percent then
			if not lowerStop or stopPercent > lowerPercent then
				lowerStop = color
				lowerPercent = stopPercent
			end
		end
		if stopPercent >= percent then
			if not upperStop or stopPercent < upperPercent then
				upperStop = color
				upperPercent = stopPercent
			end
		end
	end

	-- If we have exact match, return it
	if lowerPercent == upperPercent then
		return unpack(lowerStop or { 0, 0.5, 1, 1 })
	end

	-- Interpolate between the two colors
	if lowerStop and upperStop then
		local t = (percent - lowerPercent) / (upperPercent - lowerPercent)
		local r = lowerStop[1] + (upperStop[1] - lowerStop[1]) * t
		local g = lowerStop[2] + (upperStop[2] - lowerStop[2]) * t
		local b = lowerStop[3] + (upperStop[3] - lowerStop[3]) * t
		local a = lowerStop[4] + (upperStop[4] - lowerStop[4]) * t
		return r, g, b, a
	end

	-- Fallback
	return unpack(lowerStop or upperStop or { 0, 0.5, 1, 1 })
end

-- Frame positioning and management
function RarityBarContainer:ClearAllPoints()
	self.frame:ClearAllPoints()
end

function RarityBarContainer:SetPoint(...)
	self.frame:SetPoint(...)
end

function RarityBarContainer:GetPoint()
	return self.frame:GetPoint()
end

function RarityBarContainer:SetScale(scale)
	self.frame:SetScale(scale or 1)
end

function RarityBarContainer:SetWidth(width)
	self.frame:SetWidth(width or 200)
	self:UpdateLayout()
end

function RarityBarContainer:SetHeight(height)
	self.frame:SetHeight(height or 20)
	self:UpdateLayout()
end

function RarityBarContainer:Hide()
	self.frame:Hide()
end

function RarityBarContainer:Show()
	self.frame:Show()
end

function RarityBarContainer:ShowAnchor()
	self.anchor:Show()
	self.anchorVisible = true
end

function RarityBarContainer:HideAnchor()
	self.anchor:Hide()
	self.anchorVisible = false
end

function RarityBarContainer:Lock()
	self.locked = true
	self.frame:EnableMouse(false)
	self.anchor:EnableMouse(false)
end

function RarityBarContainer:Unlock()
	self.locked = false
	self.frame:EnableMouse(true)
	self.anchor:EnableMouse(true)
end

-- Enhanced bar value methods for animations
function RarityBarContainer:SetBarValue(barIndex, value, min, max, level, animate)
	local bar = self.bars[barIndex]
	if not bar then
		return
	end

	-- Use AnimatedStatusBarMixin methods if available
	if bar.SetAnimatedValues and animate ~= false then
		bar:SetAnimatedValues(value, min or 0, max or 100, level)
	else
		-- Fallback to standard methods
		if min and max then
			bar:SetMinMaxValues(min, max)
		end
		bar:SetValue(value)
		self:UpdateBarColor(bar)
	end

	-- Update text display
	if bar.text and self.showText then
		local percentage = 0
		local barMin, barMax = bar:GetMinMaxValues()
		if barMax > barMin then
			percentage = math.floor((value - barMin) / (barMax - barMin) * 100)
		end
		bar.text:SetText(string.format("%d%%", percentage))
	end
end

function RarityBarContainer:GetBarValue(barIndex)
	local bar = self.bars[barIndex]
	if not bar then
		return 0
	end

	-- Use animated value if available, otherwise standard value
	if bar.GetAnimatedValue then
		return bar:GetAnimatedValue()
	else
		return bar:GetValue()
	end
end

function RarityBarContainer:IsBarAnimating(barIndex)
	local bar = self.bars[barIndex]
	if not bar then
		return false
	end

	if bar.IsAnimating then
		return bar:IsAnimating()
	end

	return bar.Anim and bar.Anim:IsPlaying()
end

function RarityBarContainer:StopBarAnimation(barIndex)
	local bar = self.bars[barIndex]
	if not bar then
		return
	end

	if bar.Anim and bar.Anim:IsPlaying() then
		bar.Anim:Stop()
	end

	-- Reset animated textures
	if bar.BarGain then
		bar.BarGain:SetAlpha(0)
	end
	if bar.BarTrailGlow then
		bar.BarTrailGlow:SetAlpha(0)
	end
	if bar.BarGlow then
		bar.BarGlow:SetAlpha(0)
	end
	if bar.SparkBurstMove then
		bar.SparkBurstMove:SetAlpha(0)
	end
end

function RarityBarContainer:SetAnimationEnabled(enabled)
	self.animationEnabled = enabled
	for _, bar in ipairs(self.bars) do
		if not enabled and bar.Anim and bar.Anim:IsPlaying() then
			bar.Anim:Stop()
		end
	end
end

-- Cleanup function
function RarityBarContainer:Destroy()
	for _, bar in ipairs(self.bars) do
		if bar.Anim and bar.Anim:IsPlaying() then
			bar.Anim:Stop()
		end
		-- Clean up animated textures and UI elements
		if bar.BarGain then
			bar.BarGain = nil
		end
		if bar.BarTrailGlow then
			bar.BarTrailGlow = nil
		end
		if bar.BarGlow then
			bar.BarGlow = nil
		end
		if bar.SparkBurstMove then
			bar.SparkBurstMove = nil
		end
		if bar.ColorableTextures then
			bar.ColorableTextures = nil
		end
		if bar.AnimatedTextures then
			bar.AnimatedTextures = nil
		end
		if bar.border then
			bar.border:Hide()
			bar.border:SetParent(nil)
			bar.border = nil
		end

		bar:Hide()
		bar:SetParent(nil)
	end
	self.bars = {}

	if self.anchor then
		self.anchor:Hide()
		self.anchor:SetParent(nil)
	end

	if self.frame then
		self.frame:Hide()
		self.frame:SetParent(nil)
	end
end

-- Create AnimatedStatusBarGlowLinesTemplate equivalent
local function CreateGlowLinesTemplate(parent)
	local frame = CreateFrame("Frame", nil, parent)
	frame:SetSize(37, 26)

	-- Create glow lines texture
	frame.GlowLines = frame:CreateTexture(nil, "ARTWORK", nil, 3)
	frame.GlowLines:SetAllPoints()
	frame.GlowLines:SetAlpha(0)
	frame.GlowLines:SetBlendMode("ADD")
	frame.GlowLines:SetTexture("Interface\\CastingBar\\UI-CastingBar-Spark") -- Fallback texture

	-- Create animation group
	frame.Anim = frame:CreateAnimationGroup()
	frame.Anim:SetToFinalAlpha(true)

	-- Alpha animation 1
	local alpha1 = frame.Anim:CreateAnimation("Alpha")
	alpha1:SetChildKey("GlowLines")
	alpha1:SetDuration(0.2)
	alpha1:SetOrder(1)
	alpha1:SetFromAlpha(0)
	alpha1:SetToAlpha(1)

	-- Scale animation
	local scale1 = frame.Anim:CreateAnimation("Scale")
	scale1:SetChildKey("GlowLines")
	scale1:SetDuration(0.4)
	scale1:SetOrder(1)
	scale1:SetScale(1, 2)

	-- Translation animation
	local translate1 = frame.Anim:CreateAnimation("Translation")
	translate1:SetChildKey("GlowLines")
	translate1:SetDuration(0.3)
	translate1:SetOrder(1)
	translate1:SetOffset(0, 8)

	-- Alpha animation 2
	local alpha2 = frame.Anim:CreateAnimation("Alpha")
	alpha2:SetChildKey("GlowLines")
	alpha2:SetDuration(0.4)
	alpha2:SetOrder(2)
	alpha2:SetFromAlpha(1)
	alpha2:SetToAlpha(0)

	return frame
end

-- Enhanced container creation with proper template support
function RarityBarContainer:CreateAnimatedStatusBar(name, icon, maxValue, value)
	local bar = self:CreateBar(name, icon, maxValue, value)

	-- Initialize tile template system
	bar.tileTemplates = {}
	bar.numUsedTileTemplates = 0

	-- Override AcquireTileTemplate for custom implementation
	bar.AcquireTileTemplate = function(self)
		self.numUsedTileTemplates = (self.numUsedTileTemplates or 0) + 1
		if not self.tileTemplates then
			self.tileTemplates = {}
		end
		if not self.tileTemplates[self.numUsedTileTemplates] then
			self.tileTemplates[self.numUsedTileTemplates] = CreateGlowLinesTemplate(self:GetParent())
		end
		return self.numUsedTileTemplates, self.tileTemplates[self.numUsedTileTemplates]
	end

	-- Override ReleaseAllTileTemplate
	bar.ReleaseAllTileTemplate = function(self)
		if self.tileTemplates then
			for i, tileTemplate in ipairs(self.tileTemplates) do
				if tileTemplate.Anim and tileTemplate.Anim:IsPlaying() then
					tileTemplate.Anim:Stop()
				end
				tileTemplate:ClearAllPoints()
				tileTemplate:Hide()
			end
			self.numUsedTileTemplates = 0
		end
	end

	return bar
end

-- Replace the old LibBars NewBarGroup function in the Rarity namespace
function Rarity:NewBarGroup(name, parent, width, height)
	return RarityBarContainer:New(name, parent, width, height)
end

-- Enhanced callback system for the new container
function GUI:OnBarAnchorClicked(cbk, group, button)
	self = Rarity

	local point, relativeTo, relativePoint, x, y = self.barGroup:GetPoint()
	self:Debug("Clicked anchor", point, relativePoint, x, y)

	-- Store the new position
	self.db.profile.bar.x = x
	self.db.profile.bar.y = y
	self.db.profile.bar.point = point
	self.db.profile.bar.relativePoint = relativePoint
end

function GUI:InitialiseBar()
	self = Rarity

	-- Clean up existing bar group if it exists
	if self.barGroup and self.barGroup.Destroy then
		self.barGroup:Destroy()
	end

	-- Create new bar group using our custom container
	self.barGroup = self:NewBarGroup("RarityBarGroup", UIParent, self.db.profile.bar.width, self.db.profile.bar.height)
	self.barGroup:RegisterCallback(Rarity.GUI, "AnchorClicked", "OnBarAnchorClicked")

	-- Initialize and update
	Rarity.GUI:UpdateBar()
	self.bar = nil
end

function GUI:UpdateBar()
	self = Rarity

	if not self.barGroup or not self.barGroup.GetBars then
		return
	end

	-- Font configuration
	local fontPath = "Fonts\\FRIZQT__.TTF"
	if self.db.profile.bar.font and media then
		local mediaFont = media:Fetch("font", self.db.profile.bar.font)
		if mediaFont then
			fontPath = mediaFont
		end
	end
	self.barGroup:SetFont(fontPath, self.db.profile.bar.fontSize or 8)

	-- Texture configuration
	if self.db.profile.bar.texture and media then
		local mediaTexture = media:Fetch("statusbar", self.db.profile.bar.texture)
		if mediaTexture then
			self.barGroup:SetTexture(mediaTexture)
		end
	end

	-- Orientation (alignment)
	if self.db.profile.bar.rightAligned then
		self.barGroup:SetOrientation(3) -- Right to left
	else
		self.barGroup:SetOrientation(1) -- Left to right
	end

	-- Growth direction
	if self.db.profile.bar.growUp then
		self.barGroup:ReverseGrowth(true)
	else
		self.barGroup:ReverseGrowth(false)
	end

	-- Icon visibility
	if self.db.profile.bar.showIcon then
		self.barGroup:ShowIcon()
	else
		self.barGroup:HideIcon()
	end

	-- Text visibility
	if self.db.profile.bar.showText then
		self.barGroup:ShowLabel()
	else
		self.barGroup:HideLabel()
	end

	-- Color gradient setup (optimized to avoid performance issues)
	-- Only set colors if they haven't been set or if we're forced to update
	if not self.barGroup.colorsInitialized or self.forceColorUpdate then
		self.barGroup:SetColorAt(1.00, 1, 0, 0, 1) -- Red at 100%
		self.barGroup:SetColorAt(0.66, 1, 1, 0, 1) -- Yellow at 66%
		self.barGroup:SetColorAt(0.33, 0, 1, 1, 1) -- Cyan at 33%
		self.barGroup:SetColorAt(0.00, 0, 0, 1, 1) -- Blue at 0%
		self.barGroup.colorsInitialized = true
		self.forceColorUpdate = false
	end

	-- Positioning
	self.barGroup:ClearAllPoints()
	self.barGroup:SetPoint(
		self.db.profile.bar.point or "CENTER",
		UIParent,
		self.db.profile.bar.relativePoint or "CENTER",
		self.db.profile.bar.x or 0,
		self.db.profile.bar.y or 0
	)

	-- Scale and dimensions
	self.barGroup:SetScale(self.db.profile.bar.scale or 1)
	self.barGroup:SetWidth(self.db.profile.bar.width or 200)
	self.barGroup:SetHeight(self.db.profile.bar.height or 20)

	-- Visibility
	if self.db.profile.bar.visible then
		self.barGroup:Show()
	else
		self.barGroup:Hide()
	end

	-- Anchor visibility (only show when explicitly enabled)
	if self.db.profile.bar.anchor then
		self.barGroup:ShowAnchor()
	else
		self.barGroup:HideAnchor()
	end

	-- Lock state
	if self.db.profile.bar.locked then
		self.barGroup:Lock()
	else
		self.barGroup:Unlock()
	end
end

function GUI:ToggleProgressBar()
	Rarity.db.profile.bar.visible = not Rarity.db.profile.bar.visible
	Rarity.GUI:UpdateBar()
	if Rarity.GUI.UpdateText then
		Rarity.GUI:UpdateText()
	end
end

-- Additional utility functions for the new system
function GUI:ForceColorUpdate()
	self = Rarity
	if self.barGroup then
		self.forceColorUpdate = true
		self:UpdateBar()
	end
end

function GUI:GetBarContainer()
	self = Rarity
	return self.barGroup
end

-- Enhanced methods for better Rarity integration
function GUI:CreateProgressBar(name, icon, maxValue, value, animate)
	self = Rarity
	if not self.barGroup then
		self:InitialiseBar()
	end

	local bar
	if animate ~= false and self.barGroup.CreateAnimatedStatusBar then
		bar = self.barGroup:CreateAnimatedStatusBar(name, icon, maxValue, value)
	else
		bar = self.barGroup:CreateBar(name, icon, maxValue, value)
	end

	return bar
end

function GUI:UpdateProgressBar(barIndex, value, min, max, level, animate)
	self = Rarity
	if self.barGroup and self.barGroup.SetBarValue then
		self.barGroup:SetBarValue(barIndex, value, min, max, level, animate)
	end
end

function GUI:GetProgressBarValue(barIndex)
	self = Rarity
	if self.barGroup and self.barGroup.GetBarValue then
		return self.barGroup:GetBarValue(barIndex)
	end
	return 0
end

function GUI:IsProgressBarAnimating(barIndex)
	self = Rarity
	if self.barGroup and self.barGroup.IsBarAnimating then
		return self.barGroup:IsBarAnimating(barIndex)
	end
	return false
end

function GUI:SetProgressBarAnimationEnabled(enabled)
	self = Rarity
	if self.barGroup and self.barGroup.SetAnimationEnabled then
		self.barGroup:SetAnimationEnabled(enabled)
	end
end

function GUI:StopAllBarAnimations()
	self = Rarity
	if self.barGroup and self.barGroup.bars then
		for i = 1, #self.barGroup.bars do
			if self.barGroup.StopBarAnimation then
				self.barGroup:StopBarAnimation(i)
			end
		end
	end
end

-- Legacy compatibility method
function GUI:SetIcon(icon)
	self = Rarity
	if self.barGroup and self.barGroup.bars and #self.barGroup.bars > 0 then
		local bar = self.barGroup.bars[1]
		if bar and bar.icon then
			bar.icon:SetTexture(icon)
			if icon then
				bar.icon:Show()
			else
				bar.icon:Hide()
			end
		end
	end
end

-- Convenience methods for anchor management
function GUI:ShowBarAnchor()
	self = Rarity
	if self.barGroup then
		self.barGroup:ShowAnchor()
	end
end

function GUI:HideBarAnchor()
	self = Rarity
	if self.barGroup then
		self.barGroup:HideAnchor()
	end
end

function GUI:ToggleBarAnchor()
	self = Rarity
	if self.barGroup then
		if self.barGroup.anchorVisible then
			self.barGroup:HideAnchor()
		else
			self.barGroup:ShowAnchor()
		end
	end
end
