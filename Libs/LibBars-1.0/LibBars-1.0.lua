local MAJOR = "LibBars-1.0"
local MINOR = tonumber(("$Revision: 77792 $"):match("%d+"))

local lib, oldminor = LibStub:NewLibrary(MAJOR, MINOR)
if not lib then return end -- No Upgrade needed.

local CallbackHandler = LibStub:GetLibrary("CallbackHandler-1.0")

local GetTime = _G.GetTime
local sin, cos, rad = _G.math.sin, _G.math.cos, _G.math.rad
local abs, min, max, floor = _G.math.abs, _G.math.min, _G.math.max, _G.math.floor
local table_sort, tinsert, tremove = _G.table.sort, tinsert, tremove
local next, pairs, assert, error = next, pairs, assert, error

local dummyFrame, barFrameMT, barPrototype, barPrototype_mt, barListPrototype
local barListPrototype_mt

lib.LEFT_TO_RIGHT = 1
lib.BOTTOM_TO_TOP = 2
lib.RIGHT_TO_LEFT = 3
lib.TOP_TO_BOTTOM = 4

local function sizeChanged(f)
	f:SetValue(f.value)
end

lib.dummyFrame = lib.dummyFrame or CreateFrame("Frame")
lib.barFrameMT = lib.barFrameMT or {__index = lib.dummyFrame}
lib.barPrototype = lib.barPrototype or setmetatable({}, lib.barFrameMT)
lib.barPrototype_mt = lib.barPrototype_mt or {__index = lib.barPrototype}
lib.barListPrototype = lib.barListPrototype or setmetatable({}, lib.barFrameMT)
lib.barListPrototype_mt = lib.barListPrototype_mt or {__index = lib.barListPrototype}

dummyFrame = lib.dummyFrame
barFrameMT = lib.barFrameMT
barPrototype = lib.barPrototype
barPrototype_mt = lib.barPrototype_mt
barListPrototype = lib.barListPrototype
barListPrototype_mt = lib.barListPrototype_mt

lib.bars = lib.bars or {}
lib.barLists = lib.barLists or {}
lib.recycledBars = lib.recycledBars or {}
lib.embeds = lib.embeds or {}
local bars = lib.bars
local barLists = lib.barLists
local recycledBars = lib.recycledBars

local frame_defaults = {
	bgFile = "Interface\\Tooltips\\UI-Tooltip-Background",
	edgeFile = "Interface\\Tooltips\\UI-Tooltip-Border",
	inset = 4,
	edgeSize = 8,
	tile = true,
	insets = {left = 2, right = 2, top = 2, bottom = 2}
}


do
	local mixins = { "NewCounterBar", "NewTimerBar", "GetBar", "NewBarGroup", "ReleaseBar" }
	function lib:Embed(target)
		for k, v in pairs( mixins ) do
			target[v] = self[v]
		end
		lib.embeds[target] = true
		return target
	end
end

local ComputeGradient
do
	local new, del
	do
		local list = lib.garbageList or setmetatable({}, {__mode='k'})
		lib.garbageList = list
		-- new is always called with the exact same arguments, no need to
		-- iterate over a vararg
		function new(a1, a2, a3, a4, a5)
			local t = next(list)
			if t then
				list[t] = nil
				t[1] = a1
				t[2] = a2
				t[3] = a3
				t[4] = a4
				t[5] = a5
			else
				t = {a1, a2, a3, a4, a5}
			end
			return t
		end

		-- del is called over the same tables produced from new, no need for
		-- fancy stuff
		function del(t)
			t[1] = nil
			t[2] = nil
			t[3] = nil
			t[4] = nil
			t[5] = nil
			t[''] = true
			t[''] = nil
			list[t] = true
			return nil
		end
	end

	local function sort_colors(a, b)
		return a[1] < b[1]
	end

	local colors = {}
	local function getColor(point)
		local lowerBound = colors[1]
		local upperBound = colors[#colors]
		local lowerBoundIndex, upperBoundIndex = 0, 1
		for i = 1, #colors do
			if colors[i][1] >= point then
				if i > 1 then
					lowerBound = colors[i-1]
					lowerBoundIndex = colors[i-1][1]
				end
				upperBound = colors[i]
				upperBoundIndex = colors[i][1]
				break
			end
		end
		local pct = (point - lowerBoundIndex) / (upperBoundIndex - lowerBoundIndex)
		local r = lowerBound[2] + ((upperBound[2] - lowerBound[2]) * pct)
		local g = lowerBound[3] + ((upperBound[3] - lowerBound[3]) * pct)
		local b = lowerBound[4] + ((upperBound[4] - lowerBound[4]) * pct)
		local a = lowerBound[5] + ((upperBound[5] - lowerBound[5]) * pct)
		return r, g, b, a
	end

	function ComputeGradient(self)
		self.gradMap = self.gradMap or {}
		if not self.colors then return end

		for i = 1, #colors do
			del(tremove(colors))
		end
		for i = 1, #self.colors, 5 do
			tinsert(colors, new(self.colors[i], self.colors[i+1], self.colors[i+2], self.colors[i+3], self.colors[i+4]))
		end
		table_sort(colors, sort_colors)

		for i = 0, 200 do
			local r, g, b, a = getColor(i / 200)
			self.gradMap[(i*4)] = r
			self.gradMap[(i*4)+1] = g
			self.gradMap[(i*4)+2] = b
			self.gradMap[(i*4)+3] = a
		end
	end
end

function lib:GetBar(name)
	return bars[self] and bars[self][name]
end

function lib:GetBars(name)
	return bars[self]
end

function lib:NewCounterBar(name, text, value, maxVal, icon, orientation, width, height, isTimer)
	if self == lib then
		error("You may only call :NewBar as an embedded function")
	end
	bars[self] = bars[self] or {}
	local bar = bars[self][name]
	local isNew = false
	if not bar then
		isNew = true
		bar = tremove(recycledBars)
		if not bar then
			bar = setmetatable(CreateFrame("Frame"), barPrototype_mt)
		else
			bar:Show()
		end
	end
	bar:Create(text, value, maxVal, icon, orientation, width, height, isTimer)
	bar:SetFont(self.font, self.fontSize, self.fontFlags)

	bars[self][name] = bar
	bar.name = name
	bar.isTimer = isTimer
	
	return bar, isNew
end

--[[ Individual bars ]]--

function lib:NewTimerBar(name, text, time, maxTime, icon, orientation, width, height)
	local bar, isNew = self:NewCounterBar(name, text, time, maxTime, icon, orientation, width, height, true)
	return bar, isNew
end

function lib:ReleaseBar(name)
	local bar

	if not bars[self] then return end

	if type(name) == "string" then
		bar = bars[self][name]
	elseif type(name) == "table" then
		for k, v in pairs(bars[self]) do
			if v == name then
				bar = v
				break
			end
		end
	end
	
	if bar then
		tinsert(recycledBars, bar)
		bar.flashing = false
		bar:SetScript("OnUpdate", nil)
		bar.ownerGroup = nil
		bar:SetParent(UIParent)
		bar:ClearAllPoints()
		bar:Hide()
		if bar.timeLeftTriggers then
			for k, v in pairs(bar.timeLeftTriggers) do
				bar.timeLeftTriggers[k] = nil
			end
		end

		bar.fill = false
		if bar.colors then
			for k, v in pairs(bar.colors) do
				bar.colors[k] = nil
			end
		end
		if bar.gradMap then
			for k, v in pairs(bar.gradMap) do
				bar.gradMap[k] = nil
			end
		end
		local f, s, m = ChatFontNormal:GetFont()
		bar.label:SetFont(f, s or 10, m)
		bar.timerLabel:SetFont(f, s or 10, m)
		
		-- Cancel all registered callbacks. CBH doesn't seem to provide a method to do this.
		if bar.callbacks.insertQueue then
			for eventname, callbacks in pairs(bar.callbacks.insertQueue) do
				for k, v in pairs(callbacks) do
					callbacks[k] = nil
				end
			end
		end
		for eventname, callbacks in pairs(bar.callbacks.events) do
			for k, v in pairs(callbacks) do
				callbacks[k] = nil
			end
			if bar.callbacks.OnUnused then
				bar.callbacks.OnUnused(bar.callbacks, target, eventname)
			end
		end
				
		bars[self][bar.name] = nil
	end	
end

---[[ Bar Groups ]]---
do
	local function move(self)
		if not self:GetParent().locked then
			self.startX = self:GetParent():GetLeft()
			self.startY = self:GetParent():GetTop()
			self:GetParent():StartMoving()
		end
	end
	local function stopMove(self)
		if not self:GetParent().locked then
			self:GetParent():StopMovingOrSizing()		
			local endX = self:GetParent():GetLeft()
			local endY = self:GetParent():GetTop()
			if self.startX ~= endX or self.startY ~= endY then
				self:GetParent().callbacks:Fire("AnchorMoved", self:GetParent(), endX, endY)
			end
		end
	end
	local function buttonClick(self, button)
		self:GetParent().callbacks:Fire("AnchorClicked", self:GetParent(), button)
	end

	function lib:NewBarGroup(name, orientation, width, height, frameName)
		if self == lib then
			error("You may only call :NewBarList as an embedded function")
		end

		barLists[self] = barLists[self] or {}
		if barLists[self][name] then
			error("A bar list named " .. name .. " already exists.")
		end

		orientation = orientation or lib.LEFT_TO_RIGHT
		orientation = orientation == "LEFT" and lib.LEFT_TO_RIGHT or orientation
		orientation = orientation == "RIGHT" and lib.RIGHT_TO_LEFT or orientation

		local list = setmetatable(CreateFrame("Frame", frameName, UIParent), barListPrototype_mt)
		list:SetMovable(true)
		list:SetClampedToScreen(true)

		list.callbacks = list.callbacks or CallbackHandler:New(list)
		barLists[self][name] = list
		list.name = name
		list.orientation = orientation

		list.button = CreateFrame("Button", nil, list)
		list.button:SetBackdrop(frame_defaults)
		list.button:SetTextFontObject(ChatFontSmall)

		if orientation % 2 == 0 then
			list.button:SetText("")
			list.button:SetWidth(15)
			local _width = width
			width = height or 13
			height = _width or 200
		else
			list.button:SetText(name)
			list.button:SetHeight(15)
			width = width or 200
			height = height or 13
		end
		list:SetWidth(width)
		list:SetHeight(height)

		list.button:SetScript("OnMouseDown", move)
		list.button:SetScript("OnMouseUp", stopMove)
		list.button:SetBackdropColor(0,0,0,1)
		list.button:RegisterForClicks("LeftButtonUp", "RightButtonUp", "MiddleButtonUp", "Button4Up", "Button5Up")
		list.button:SetScript("OnClick", buttonClick)

		list:SetPoint("CENTER", UIParent, "CENTER")
		list:ReverseGrowth(false)
		
		list.locked = false

		return list
	end
end

function lib:GetBarGroup(name)
	return barLists[self] and barLists[self][name]
end

--[[ BarList prototype ]]--

function barListPrototype:NewCounterBar(name, text, value, maxVal, icon, isTimer)
	local bar, isNew = lib.NewCounterBar(self, name, text, value, maxVal, icon, self.orientation, nil, self.height, isTimer)
	bar:SetTexture(self.texture)
	self:SortBars()
	bar.ownerGroup = self
	bar.RegisterCallback(self, "FadeFinished")
	bar.RegisterCallback(self, "TimerFinished")
	bar:SetParent(self)
	return bar, isNew
end

function barListPrototype:Lock()
	self.locked = true
end

function barListPrototype:Unlock()
	self.locked = false
end

function barListPrototype:IsLocked()
	return self.locked 
end

local function startFlashing(bar, time)
	if not bar.flashing then
		bar:Flash(bar.ownerGroup.flashPeriod)
	end
end

function barListPrototype:NewTimerBar(name, text, time, maxTime, icon, flashTrigger)
	local bar, isNew = self:NewCounterBar(name, text, time, maxTime, icon, true)
	bar:RegisterTimeLeftTrigger(flashTrigger or bar.ownerGroup.flashTrigger or 5, startFlashing)
	return bar, isNew
end

-- Max number of bars to display. nil to display all.
function barListPrototype:SetMaxBars(num)
	self.maxBars = num
end

function barListPrototype:SetFlashTrigger(t)
	self.flashTrigger = t
end

function barListPrototype:SetFlashPeriod(p)
	self.flashPeriod = p
end

function barListPrototype:SetTexture(tex)
	self.texture = tex
	if bars[self] then
		for k, v in pairs(bars[self]) do
			v:SetTexture(tex)
		end
	end
end

function barListPrototype:SetFont(f, s, m)
	self.font, self.fontSize, self.fontFlags = f, s, m
	if bars[self] then
		for k, v in pairs(bars[self]) do
			v:SetFont(f, s, m)
		end
	end
end

function barListPrototype:SetFill(fill)
	self.fill = fill
	if bars[self] then
		for k, v in pairs(bars[self]) do
			v:SetFill(fill)
		end
	end
end

barListPrototype.GetBar = lib.GetBar
barListPrototype.GetBars = lib.GetBars

function barListPrototype:MoveBarToGroup(bar, group)
	if type(bar) ~= "table" then
		bar = bars[self][bar]
	end
	if not bar then
		error("Cannot find bar passed to MoveBarToGroup")
	end
	bars[group] = bars[group] or {}
	if bars[group][bar.name] then
		error("Cannot move " .. bar.name .. " to this group; a bar with that name already exists.")
	end
	for k, v in pairs(bars[self]) do
		if v == bar then
			bars[self][k] = nil
			bar = v
			break
		end
	end
	bar:SetParent(group)
	bar.ownerGroup = group
	bars[group][bar.name] = bar
end

function barListPrototype:RemoveBar(bar)
	lib.ReleaseBar(self, bar)
end

function barListPrototype:SetDisplayMax(val)
	self.displayMax = val
end

function barListPrototype:UpdateColors()
	-- Force a color update on all the bars, particularly the counter bars
	if bars[self] then
		for k, v in pairs(bars[self]) do
			v:UpdateColor()
--             if not v.isTimer then
--                 v:UpdateColor()
--             end
		end
	end
end

function barListPrototype:SetColorAt(at, r, g, b, a)
	self.colors = self.colors or {}
	tinsert(self.colors, at)
	tinsert(self.colors, r)
	tinsert(self.colors, g)
	tinsert(self.colors, b)
	tinsert(self.colors, a)
	ComputeGradient(self)
	self:UpdateColors()
end

function barListPrototype:UnsetColorAt(at)
	if not self.colors then return end
	for i = 1, #self.colors, 5 do
		if self.colors[i] == at then
			for j = 1, 5 do
				tremove(self.colors, i)
			end
			ComputeGradient(self)
			self:UpdateColors()
			return
		end
	end
end

function barListPrototype:UnsetAllColors()
	if not self.colors then return end
	for i = 1, #self.colors do
		tremove(self.colors)
	end
	return
end

function barListPrototype:TimerFinished(evt, bar, name)
	bar.ownerGroup.callbacks:Fire("TimerFinished", bar.ownerGroup, bar, name)
	bar:Fade()
end

function barListPrototype:FadeFinished(evt, bar, name)
	local group = bar.ownerGroup
	lib.ReleaseBar(group, bar)
	group:SortBars()
end

function barListPrototype:ShowAnchor()
	self.button:Show()
	self:SortBars()
end

function barListPrototype:HideAnchor()
	self.button:Hide()
	self:SortBars()
end

function barListPrototype:IsAnchorVisible()
	return self.button:IsVisible()
end

function barListPrototype:ToggleAnchor()
	if self.button:IsVisible() then
		self.button:Hide()
	else
		self.button:Show()
	end
	self:SortBars()
end

function barListPrototype:GetBarTop()
	return self.growup and (self.lastBar:GetTop() - self.lastBar:GetHeight()) or (self.lastBar:GetBottom() - self.lastBar:GetHeight())
end

function barListPrototype:ReverseGrowth(flag)
	self.growup = flag
	self.button:ClearAllPoints()
	if self.orientation % 2 == 0 then
		if flag then
			self.button:SetPoint("TOPLEFT", self, "TOPLEFT")
			self.button:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
		else
			self.button:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			self.button:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		end
	else
		if flag then
			self.button:SetPoint("TOPLEFT", self, "TOPLEFT")
			self.button:SetPoint("TOPRIGHT", self, "TOPRIGHT")
		else
			self.button:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
			self.button:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
		end
	end
	self:SortBars()
end

function barListPrototype:SetOrientation(orientation)
	local oldorientation = self.orientation
	self.orientation = orientation
	if bars[self] then
		for k, v in pairs(bars[self]) do
			v:SetOrientation(orientation)
		end
	end
	if orientation % 2 ~= oldorientation % 2 then
		local height = self:GetHeight()
		self:SetHeight(self:GetWidth())
		self:SetWidth(height)
	end
	if orientation % 2 == 0 then
		self.button:SetText("")
		self.button:SetWidth(15)
	else
		self.button:SetText(self.name)
		self.button:SetHeight(15)
	end
	self:SortBars()
end

function barListPrototype:SetSortFunction(func)
	assert(type(func) == "function")
	self.sortFunc = func
end

-- group:SetSortFunction(group.NOOP) to disable sorting
function barListPrototype.NOOP() end

do
	local values = {}
	local function sortFunc(a, b)
		if a.isTimer ~= b.isTimer then
			return a.isTimer
		end

		local apct, bpct = a.value / a.maxValue, b.value / b.maxValue
		if apct == bpct then
			if a.maxValue == b.maxValue then
				return a.name > b.name
			else
				return a.maxValue > b.maxValue
			end
		else
			return apct > bpct
		end
	end
	function barListPrototype:SortBars()
		local lastBar = self
		local ct = 0
		if not bars[self] then return end
		for k, v in pairs(bars[self]) do
			if not v.isAnimating then
				ct = ct + 1
				values[ct] = v
			end
		end
		for i = ct + 1, #values do
			values[i] = nil
		end
		table_sort(values, self.sortFunc or sortFunc)

		local vertical = self.orientation % 2 == 0
		local growup = self.growup

		local xoff, yoff = 0, 0
		local from, to
		if vertical then
			local thickness = self:GetWidth()
			if growup then
				from = "RIGHT"
				to = "LEFT"
				xoff = 15 - thickness
			else
				from = "LEFT"
				to = "RIGHT"
				xoff = thickness - 15
			end
		else
			local thickness = self:GetHeight()
			if growup then
				from = "BOTTOM"
				to = "TOP"
				yoff = thickness - 15
			else
				from = "TOP"
				to = "BOTTOM"
				yoff = 15 - thickness
			end
		end
		local collapse = not self.button:IsVisible()
		for i = 1, #values do
			local realx, realy = 0, 0
			local realto = to
			if collapse then
				realto = from
				realx = xoff
				realy = yoff
				collapse = false
			end

			local v = values[i]
			v:ClearAllPoints()
			if self.maxBars and i > self.maxBars then
				v:Hide()
			else
				v:Show()
				if vertical then
					v:SetPoint("TOP"..from, lastBar, "TOP"..realto, realx, realy)
					v:SetPoint("BOTTOM"..from, lastBar, "BOTTOM"..realto, realx, realy)
				else
					v:SetPoint(from.."LEFT", lastBar, realto.."LEFT", realx, realy)
					v:SetPoint(from.."RIGHT", lastBar, realto.."RIGHT", realx, realy)
				end
				lastBar = v
			end
		end
		self.lastBar = lastBar
	end
end

--[[
****************************************************************
***	Bar methods
****************************************************************
]]--

--[[ Bar Prototype ]]--

function barPrototype:Create(text, value, maxVal, icon, orientation, width, height, isTimer)

	self.callbacks = self.callbacks or CallbackHandler:New(self)

	orientation = orientation or 1
	width = width or 200
	height = height or 15

	if orientation % 2 == 0 then
		width, height = height, width
	end

	self:SetScript("OnSizeChanged", sizeChanged)

	self:SetWidth(width)
	self:SetHeight(height)

	self.texture = self.texture or self:CreateTexture(nil, "ARTWORK")
	
	if self.timeLeftTriggers then
		for k, v in pairs(self.timeLeftTriggers) do
			self.timeLeftTriggers[k] = false
		end
	end

	if not self.spark then
		self.spark = self:CreateTexture(nil, "OVERLAY")
		self.spark:SetTexture([[Interface\CastingBar\UI-CastingBar-Spark]])
		self.spark:SetWidth(5)
		self.spark:SetHeight(5)
		self.spark:SetBlendMode("ADD")
	end

	self.bgtexture = self.bgtexture or self:CreateTexture(nil, "BACKGROUND")
	self.bgtexture:SetAllPoints()
	self.bgtexture:SetVertexColor(0.3, 0.3, 0.3, 0.6)

	self.icon = self.icon or self:CreateTexture(nil, "OVERLAY")
	local ih = min(width, height)
	self.icon:SetHeight(ih)
	self.icon:SetWidth(ih)
	self.icon:SetPoint("LEFT", self, "LEFT", 0, 0)
	self:SetIcon(icon)

	self.label = self.label or self:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
	self.label:SetText(text)
	self.label:ClearAllPoints()
	self.label:SetPoint("LEFT", self, "LEFT", 3, 0)

	local f, s, m = self.label:GetFont()
	self.label:SetFont(f, s or 10, m)

	self.timerLabel = self.timerLabel or self:CreateFontString(nil, "OVERLAY", "ChatFontNormal")
	self.timerLabel:SetText("")
	self.timerLabel:ClearAllPoints()
	self.timerLabel:SetPoint("RIGHT", self, "RIGHT", -3, 0)

	local f, s, m = self.timerLabel:GetFont()
	self.timerLabel:SetFont(f, s or 10, m)

	self.SetLabel = self.SetLabel or function(self, l) self.label:SetText(l) end

	self.timerFuncs = self.timerFuncs or {}
	for i = 1, #self.timerFuncs do
		tremove(self.timerFuncs)
	end

	self:SetScale(1)
	self:SetAlpha(1)
	--[[
	self.texture:SetAlpha(1)
	self.bgtexture:SetAlpha(0.6)
	self.icon:SetAlpha(1)
	]]--
	
	self.flashing = false

	self:SetOrientation(orientation)

	value = value or 1
	maxVal = maxVal or value
	self.value = value
	self.maxValue = maxVal

	if not isTimer then
		self:SetMaxValue(maxVal)
	else
		self.updateDelay = min(max(maxVal, 1) / width, 0.05)
		self:SetTimer(value, maxVal)
	end
end

function barPrototype:GetGroup()
	return self.ownerGroup
end

function barPrototype:SetFont(ff, ss, mm)
	local f, s, m = self.label:GetFont()
	self.label:SetFont(ff or f, ss or s, mm or m)

	f, s, m = self.timerLabel:GetFont()
	self.timerLabel:SetFont(ff or f, ss or s, mm or m)
end

function barPrototype:AddOnUpdate(f)
	tinsert(self.timerFuncs, f)
	self:SetScript("OnUpdate", self.OnUpdate)
end

function barPrototype:RemoveOnUpdate(f)
	local timerFuncs = self.timerFuncs
	for i = 1, #timerFuncs do
		if f == timerFuncs[i] then
			tremove(timerFuncs, i)
			if #timerFuncs == 0 then
				self:SetScript("OnUpdate", nil)
			end
			return
		end
	end
end

function barPrototype.OnUpdate(f, t)
	local timerFuncs = f.timerFuncs
	for i = 1, #timerFuncs do
		local func = timerFuncs[i]
		if func then
			func(f, t)
		end
	end
end

function barPrototype:SetIcon(icon)
	if icon then
		self.icon:Show()
		if type(icon) == "number" then
			icon = select(3, GetSpellInfo(icon))
		end
		self.icon:SetTexture(icon)
	else
		self.icon:Hide()
	end
end

local function animate(self, elapsed)
	self.aniST = self.aniST + elapsed
	local amt = min(1, self.aniST / self.aniT)
	local x = self.aniSX + ((self.aniX - self.aniSX) * amt)
	local y = self.aniSY + ((self.aniY - self.aniSY) * amt)
	local s = self.aniSS + ((self.aniS - self.aniSS) * amt)
	self:ClearAllPoints()
	self:SetPoint("BOTTOMLEFT", UIParent, "BOTTOMLEFT", x, y)
	self:SetScale(s)

	if amt == 1 then
		self.isAnimating = false
		self:RemoveOnUpdate(animate)
		self.callbacks:Fire("AnimateFinished", self, self.name)
		if self.ownerGroup then
			self:ClearAllPoints()
			self:SetPoint("TOPLEFT", self.ownerGroup.lastBar, "BOTTOMLEFT")
			-- self.ownerGroup:SortBars()
			-- self:UpdateColor()
			self:SetParent(self.ownerGroup)
			self:SetScale(1)
		end
	end
end

function barPrototype:AnimateTo(x, y, scale, t)
	self.isAnimating = true
	self.aniSX, self.aniSY, self.aniSS, self.aniST = self:GetLeft(), self:GetTop(), self:GetScale(), 0
	self.aniX, self.aniY, self.aniS, self.aniT = x, y, scale, t
	self:AddOnUpdate(animate)
end

function barPrototype:AnimateToGroup(group)
	self.isAnimating = true
	self.ownerGroup:SortBars()
	self.ownerGroup:MoveBarToGroup(self, group)
	self:SetParent(UIParent)

	local x, y = group:GetLeft() / UIParent:GetScale(), group:GetBarTop() / UIParent:GetScale()
	self:AnimateTo(x, y, group:GetScale(), 0.75)
end

function barPrototype:SetTexture(texture)
	self.texture:SetTexture(texture)
	self.bgtexture:SetTexture(texture)
end

function barPrototype:SetColorAt(at, r, g, b, a)
	self.colors = self.colors or {}
	tinsert(self.colors, at)
	tinsert(self.colors, r)
	tinsert(self.colors, g)
	tinsert(self.colors, b)
	tinsert(self.colors, a)
	ComputeGradient(self)
	self:UpdateColor()
end

function barPrototype:UnsetColorAt(at)
	if not self.colors then return end
	for i = 1, #self.colors, 5 do
		if self.colors[i] == at then
			for j = 1, 5 do
				tremove(self.colors, i)
			end
			ComputeGradient(self)
			self:UpdateColor()
			return
		end
	end
end

function barPrototype:UnsetAllColors()
	if not self.colors then return end
	for i = 1, #self.colors do
		tremove(self.colors)
	end
end

do
	local function RotateTexture(tex, degrees)
		local angle = rad(degrees)
		local cosv, sinv = cos(angle), sin(angle)
		tex:SetTexCoord((sinv - cosv), -(cosv + sinv), -cosv, -sinv, sinv, -cosv, 0, 0)
	end

	function barPrototype:SetOrientation(o)
		assert(o >= 1 and o <= 4, "orientation must be 1-4")

		local t
		if o == lib.LEFT_TO_RIGHT then
			self.icon:ClearAllPoints()
			self.icon:SetPoint("RIGHT", self, "LEFT", 0, 0)

			t = self.spark
			t:ClearAllPoints()
			t:SetPoint("TOP", self.texture, "TOPRIGHT", 0, 7)
			t:SetPoint("BOTTOM", self.texture, "BOTTOMRIGHT", 0, -7)
			t:SetTexCoord(0, 1, 0, 1)

			t = self.texture
			t.SetValue = t.SetWidth
			t:ClearAllPoints()
			t:SetPoint("TOPLEFT", self, "TOPLEFT")
			t:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
			t:SetTexCoord(0, 1, 0, 1)

			self.bgtexture:SetTexCoord(0, 1, 0, 1)
		elseif o == lib.BOTTOM_TO_TOP then
			self.icon:ClearAllPoints()
			self.icon:SetPoint("TOP", self, "BOTTOM", 0, 0)

			t = self.spark
			t:ClearAllPoints()
			t:SetPoint("LEFT", self.texture, "TOPLEFT", -7, 0)
			t:SetPoint("RIGHT", self.texture, "TOPRIGHT", 7, 0)
			t:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)

			t = self.texture
			t.SetValue = t.SetHeight
			t:ClearAllPoints()
			t:SetPoint("BOTTOMLEFT", self, "BOTTOMLEFT")
			t:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
			t:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)

			self.bgtexture:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)
		elseif o == lib.RIGHT_TO_LEFT then
			self.icon:ClearAllPoints()
			self.icon:SetPoint("LEFT", self, "RIGHT", 0, 0)

			t = self.spark
			t:ClearAllPoints()
			t:SetPoint("TOP", self.texture, "TOPLEFT", 0, 7)
			t:SetPoint("BOTTOM", self.texture, "BOTTOMLEFT", 0, -7)
			t:SetTexCoord(0, 1, 0, 1)

			t = self.texture
			t.SetValue = t.SetWidth
			t:ClearAllPoints()
			t:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			t:SetPoint("BOTTOMRIGHT", self, "BOTTOMRIGHT")
			t:SetTexCoord(0, 1, 0, 1)

			self.bgtexture:SetTexCoord(0, 1, 0, 1)
		elseif o == lib.TOP_TO_BOTTOM then
			self.icon:ClearAllPoints()
			self.icon:SetPoint("BOTTOM", self, "TOP", 0, 0)

			t = self.spark
			t:ClearAllPoints()
			t:SetPoint("LEFT", self.texture, "BOTTOMLEFT", -7, 0)
			t:SetPoint("RIGHT", self.texture, "BOTTOMRIGHT", 7, 0)
			t:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)

			t = self.texture
			t.SetValue = t.SetHeight
			t:ClearAllPoints()
			t:SetPoint("TOPLEFT", self, "TOPLEFT")
			t:SetPoint("TOPRIGHT", self, "TOPRIGHT")
			t:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)

			self.bgtexture:SetTexCoord(0, 1, 1, 1, 0, 0, 1, 0)
		end
		self.orientation = o
	end
end

function barPrototype:SetValue(val)
	assert(val ~= nil, "Value cannot be nil!")
	self.value = val
	if not self.maxValue or val > self.maxValue then
		self.maxValue = val
	end
	local ownerGroup = self.ownerGroup
	local displayMax = ownerGroup and ownerGroup.displayMax or self.displayMax
	if displayMax then
		displayMax = min(displayMax, self.maxValue)
	else
		displayMax = self.maxValue
	end
	local amt = min(1, val / displayMax)
	if amt == 1 then
		self.spark:Hide()
	else
		self.spark:Show()
	end
	local dist
	if self.orientation % 2 == 0 then
		dist = (ownerGroup and ownerGroup:GetHeight()) or (self:GetTop() and self:GetTop() - self:GetBottom()) or self:GetHeight()
	else
		dist = (ownerGroup and ownerGroup:GetWidth()) or (self:GetRight() and self:GetRight() - self:GetLeft()) or self:GetWidth()
	end
	self.texture:SetValue(amt * dist)
	self:UpdateColor()
end

function barPrototype:SetDisplayMax(val)
	self.displayMax = val
end

function barPrototype:SetMaxValue(val)
	self.maxValue = val
	self:SetValue(self.value)
end

function barPrototype:RegisterTimeLeftTrigger(time, func)
	if time > 0 then
		self.timeLeftTriggers = self.timeLeftTriggers or {}
		self.timeLeftTriggerFuncs = self.timeLeftTriggerFuncs or {}
		self.timeLeftTriggers[time] = false
		self.timeLeftTriggerFuncs[time] = func
	end
end

function barPrototype:SetTimer(remaining, maxVal)
	self:StopFade()
	self.maxValue = maxVal or self.maxValue
	self:SetValue(self.fill and self.maxValue - remaining or remaining)

	self.timerLabel:Show()
	self.startTime = GetTime() - (self.maxValue - remaining)
	self.lastElapsed = 0
	self:UpdateTimer()
	if remaining > 0 then
		self:RemoveOnUpdate(self.UpdateTimer)
		self:AddOnUpdate(self.UpdateTimer)
	end
end

function barPrototype:SetFill(fill)
	self.fill = fill
end

function barPrototype:UpdateColor()
	local amt = floor(self.value / self.maxValue * 200) * 4
	local map
	if self.gradMap and #self.gradMap > 0 then
		map = self.gradMap
	elseif self.ownerGroup and self.ownerGroup.gradMap and #self.ownerGroup.gradMap > 0 then
		map = self.ownerGroup.gradMap
	end
	if map then
		self.texture:SetVertexColor(map[amt], map[amt+1], map[amt+2], map[amt+3])
	end
end

function barPrototype:UpdateTimer(t)
	local t = GetTime()
	local elapsed, elapsedClamped = t - self.startTime, floor(t) - floor(self.startTime)
	self.lastElapsed = self.lastElapsed or 0
	if elapsed - self.lastElapsed <= self.updateDelay then
		return
	end
	self.lastElapsed = elapsed

	local maxvalue = self.maxValue
	local value, valueClamped, remaining
	if not self.fill then
		value = maxvalue - elapsed
		remaining = value
		valueClamped = maxvalue - elapsedClamped
		texcoord = 1 - (elapsed / maxvalue)
	else
		value = elapsed
		remaining = maxvalue - value
		valueClamped = elapsedClamped
		texcoord = elapsed / maxvalue
	end
	if self.timeLeftTriggers then
		for k, v in pairs(self.timeLeftTriggers) do
			if not v and remaining < k then
				self.timeLeftTriggers[k] = true
				self.timeLeftTriggerFuncs[k](self, k, remaining)
			end
		end
	end
	if remaining <= 0 then
		self:RemoveOnUpdate(self.UpdateTimer)
		self.callbacks:Fire("TimerFinished", self, self.name)
	end
	if valueClamped >= 3600 then
		local h, m, s
		h = floor(valueClamped / 3600)
		m = floor((valueClamped - (h * 3600)) / 60)
		s = floor(valueClamped - (h * 3600) - (m * 36))
		self.timerLabel:SetText(("%02.0f:%02.0f:%02.0f"):format(h, m, s))
	elseif valueClamped >= 60 then
		local m, s
		m = floor(valueClamped / 60)
		s = floor(valueClamped - (m * 60))
		self.timerLabel:SetText(("%02.0f:%02.0f"):format(m, s))
	elseif valueClamped > 10 then
		self.timerLabel:SetText(("%02.0f"):format(valueClamped))
	else
		self.timerLabel:SetText(("%02.1f"):format(abs(value)))
	end
	self:SetValue(value)

	local o = self.orientation
	if o == lib.LEFT_TO_RIGHT then
		self.texture:SetTexCoord(0, value/maxvalue, 0, 1)
	elseif o == lib.RIGHT_TO_LEFT then
		self.texture:SetTexCoord(1-(value/maxvalue), 1, 0, 1)
	elseif o == lib.BOTTOM_TO_TOP then
		self.texture:SetTexCoord(1-(value/maxvalue), 1, 1, 1, 1-value/maxvalue, 0, 1, 0)
	elseif o == lib.TOP_TO_BOTTOM then
		self.texture:SetTexCoord(0, 1, value/maxvalue, 1, 0, 0, value/maxvalue, 0)
	end
end

do
	local function fade(self, elapsed)
		self.fadeElapsed = (self.fadeElapsed or 0) + elapsed
		self:SetAlpha(1 - min(1, max(0, self.fadeElapsed / self.fadeTotal)))
		if self.fadeElapsed > self.fadeTotal then
			self:RemoveOnUpdate(fade)
			self.fadeElapsed, self.fadeTotal = nil, nil
			self.callbacks:Fire("FadeFinished", self, self.name)
		end
	end

	function barPrototype:Fade(t)
		t = t or 0.5
		self.fadeTotal = t
		self.fadeElapsed = 0
		self:AddOnUpdate(fade)
		fade(self, 0)
		self.fading = true
	end

	function barPrototype:StopFade()
		if self.fading then
			self.fading = false
			self:RemoveOnUpdate(fade)
			self.fadeElapsed, self.fadeTotal = nil, nil
			self:SetAlpha(1)
		end
	end
end

do
	local TWOPI = _G.math.pi * 2
	local function flash(self, t)
		self.flashTime = self.flashTime + t
		if self.flashTime > TWOPI then
			self.flashTime = self.flashTime - TWOPI
			if self.flashTimes then
				self.flashedTimes = self.flashedTimes + 1
				if self.flashedTimes >= self.flashTimes then
					self:StopFlash()
				end
			end
		end
		local amt = (cos(self.flashTime / self.flashPeriod) + 1) / 2
		--[[
		self.texture:SetAlpha(amt)
		self.bgtexture:SetAlpha(amt * 0.6)
		self.icon:SetAlpha(amt)
		]]--
		self:SetAlpha(amt)
	end

	function barPrototype:Flash(period, times)
		self.flashTimes = times
		self.flashedTimes = 0
		self.flashPeriod = (period or 1 / 5) or 0.1
		self:SetAlpha(1)
		self.flashTime = 0
		self.flashing = true
		self:AddOnUpdate(flash)
	end

	function barPrototype:StopFlash()
		self.flashing = false
		self:RemoveOnUpdate(flash)
		self:SetAlpha(1)
	end
end

--- Finally: upgrade our old embeds
for target, v in pairs(lib.embeds) do
	lib:Embed(target)
end
