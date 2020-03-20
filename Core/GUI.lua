local _, addonTable = ...

--- GUI.lua
-- A random assortment of UI functionality... still needs to be cleaned up further (later)
local GUI = {}

-- Locals
local tooltip, tooltip2
local frame, frame2
local headers = {}
local scanTip = CreateFrame("GameTooltip", "__Rarity_ScanTip", nil, "GameTooltipTemplate")
scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
GUI.scanTip = scanTip
local numHolidayReminders = 0
local showedHolidayReminderOverflow = false

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local media = LibStub("LibSharedMedia-3.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dataobj =
	ldb:NewDataObject(
	"Rarity",
	{
		type = "data source",
		text = L["Loading"],
		label = "Rarity",
		tocname = "Rarity",
		icon = [[Interface\Icons\spell_nature_forceofnature]]
	}
)
local dbicon = LibStub("LibDBIcon-1.0")
local qtip = LibStub("LibQTip-1.0")
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
local lbct = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()

-- Upvalues
local R = Rarity
local UIParent = UIParent
local CONSTANTS = addonTable.constants

-- LUA APIs
local format = format
local Round = Round
local debugprofilestop = debugprofilestop
local date = date
local time = time

-- WOW APIs
local GetItemInfo = GetItemInfo
local IsShiftKeyDown = IsShiftKeyDown
local IsControlKeyDown = IsControlKeyDown
local LoadAddOn = LoadAddOn
local UnitClass = UnitClass
local GetBestMapForUnit = C_Map.GetBestMapForUnit
local GetMapInfo = C_Map.GetMapInfo
local GetTime = GetTime
local IsQuestFlaggedCompleted = IsQuestFlaggedCompleted
local InCombatLockdown = InCombatLockdown
local UnitCreatureType = UnitCreatureType
local UnitGUID = UnitGUID
local UnitCanAttack = UnitCanAttack
local UnitIsPlayer = UnitIsPlayer
local UnitIsPVP = UnitIsPVP
local GetAchievementLink = GetAchievementLink
local GetRealZoneText = GetRealZoneText
local GetSubZoneText = GetSubZoneText
local GetContainerItemID = GetContainerItemID
local RequestRaidInfo = RequestRaidInfo
local RequestLFDPlayerLockInfo = RequestLFDPlayerLockInfo

-- Addon APIs
local FormatTime = Rarity.Utils.PrettyPrint.FormatTime
local sort = Rarity.Utils.Sorting.sort
local sort2 = Rarity.Utils.Sorting.sort2
local sort_difficulty = Rarity.Utils.Sorting.sort_difficulty
local sort_category = Rarity.Utils.Sorting.sort_category
local sort_zone = Rarity.Utils.Sorting.sort_zone
local sort_progress = Rarity.Utils.Sorting.sort_progress
local GetDate = Rarity.Utils.Time.GetDate
local TSM_Interface = Rarity.Utils.TSM_Interface

-- Constants
-- Sort parameters
local SORT_NAME = "SORT_NAME"
local SORT_DIFFICULTY = "SORT_DIFFICULTY"
local SORT_PROGRESS = "SORT_PROGRESS"
local SORT_CATEGORY = "SORT_CATEGORY"
local SORT_ZONE = "SORT_ZONE"
local STATUS_TOOLTIP_MAX_WIDTH = 200
-- Tooltip formatting
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"
-- Categories of origin
local HOLIDAY = "HOLIDAY"
-- Color codes
local red = {r = 1.0, g = 0.2, b = 0.2}
local blue = {r = 0.4, g = 0.4, b = 1.0}
local green = {r = 0.2, g = 1.0, b = 0.2}
local yellow = {r = 1.0, g = 1.0, b = 0.2}
local gray = {r = 0.5, g = 0.5, b = 0.5}
local white = {r = 1.0, g = 1.0, b = 1.0}

-- Helper function (to look up map names more easily)
-- TODO: DRY (not sure where this fits best, move after refactoring the rest and delete any duplicates)
-- Returns the localized map name, or nil if the uiMapID is invalid
local function GetMapNameByID(uiMapID)
	local UiMapDetails = GetMapInfo(uiMapID)
	return UiMapDetails and UiMapDetails.name or nil
end

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

function GUI:UpdateText()
	self = Rarity

	if not Rarity.Caching:IsReady() then
		dataobj.text =
			L["Loading"] ..
			" (" .. format("%d%%", Rarity.Caching:GetPrimedItems() / Rarity.Caching:GetItemsToPrime() * 100) .. ")"
		return
	end

	self:ProfileStart()
	local attempts, dropChance, chance

	local trackedItem = Rarity.Tracking:GetTrackedItem(1)
	if not trackedItem or (trackedItem and not trackedItem.itemId) then
		dataobj.text = L["None"]
		return
	end

	-- Feed text
	local itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(trackedItem.itemId)
	if not itemTexture then
		dataobj.icon = [[Interface\Icons\spell_nature_forceofnature]]
	else
		dataobj.icon = itemTexture
	end
	attempts = 0
	if trackedItem.attempts then
		attempts = trackedItem.attempts
	end
	if trackedItem.lastAttempts then
		attempts = attempts - trackedItem.lastAttempts
	end
	if trackedItem.realAttempts and trackedItem.found and not trackedItem.repeatable then
		attempts = trackedItem.realAttempts
	end

	attempts = min(attempts, 2 ^ 31 - 1) -- Workaround to stop invalid attempt counts from breaking the addon; the correct count can be obtained by updating manually. It should also be restored automatically (at some point...) if the addon loads without errors. See issue: https://github.com/SacredDuckwhale/Rarity/issues/43) - This is mostly relevant for the two Archaeology mounts that may have invalid entries after the API was changed and not updated in the addon for quite some time

	if trackedItem.found and not trackedItem.repeatable then
		if trackedItem.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			dataobj.text = L["Collection complete!"]
		else
			if attempts == 1 then
				dataobj.text = format(L["Found on your first attempt!"], attempts)
			else
				dataobj.text = format(L["Found after %d attempts!"], attempts)
			end
		end
		chance = 100.0
	else
		if trackedItem.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			chance = (trackedItem.attempts or 0) / (trackedItem.chance or 100)
			if chance < 0 then
				chance = 0
			end
			if chance > 1 then
				chance = 1
			end
			chance = chance * 100
			dataobj.text = format(L["%d collected - %.2f%%"], attempts, chance)
		else
			dropChance = Rarity.Statistics.GetRealDropPercentage(trackedItem)
			chance = 100 * (1 - math.pow(1 - dropChance, attempts))
			if self.db.profile.feedText == CONSTANTS.LDB_TEXT_STYLES.FEED_MINIMAL then
				if attempts == 1 then
					dataobj.text = format(L["%d attempt"], attempts)
				else
					dataobj.text = format(L["%d attempts"], attempts)
				end
			elseif self.db.profile.feedText == CONSTANTS.LDB_TEXT_STYLES.FEED_VERBOSE then
				if attempts == 1 then
					dataobj.text = format(L["%s: %d attempt - %.2f%%"], itemLink or trackedItem.name, attempts, chance)
				else
					dataobj.text = format(L["%s: %d attempts - %.2f%%"], itemLink or trackedItem.name, attempts, chance)
				end
			else
				if attempts == 1 then
					dataobj.text = format(L["%d attempt - %.2f%%"], attempts, chance)
				else
					dataobj.text = format(L["%d attempts - %.2f%%"], attempts, chance)
				end
			end
		end
	end

	-- Bar 1
	if not chance then
		chance = 0
	end
	if chance > 100 then
		chance = 100
	end
	if chance < 0 then
		chance = 0
	end
	local text = format("%s: %d (%.2f%%)", itemName or trackedItem.name, attempts, chance)
	if not self.bar then
		self.bar =
			self.barGroup:NewCounterBar(
			"Track",
			text,
			chance,
			100,
			itemTexture or [[Interface\Icons\spell_nature_forceofnature]]
		)
	else
		self.bar:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
		self.bar:SetLabel(text)
		self.bar:SetValue(chance, 100)
	end
	if self.hadBarTwo then -- If we've transitioning from 2 bars to 1, hiding/showing the bars collapses them
		self.barGroup:Hide()
		if self.db.profile.bar.visible then
			self.barGroup:Show()
		end
	end

	-- Bar 2
	local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)
	if trackedItem2 == nil or trackedItem2.itemId == nil then
		self.barGroup:RemoveBar("Track2")
		self.bar2 = nil
	else
		self.hadBarTwo = true
		_, -- itemName,
			_, -- itemLink,
			itemRarity,
			itemLevel,
			itemMinLevel,
			itemType,
			itemSubType,
			itemStackCount,
			itemEquipLoc,
			itemTexture,
			itemSellPrice = GetItemInfo(trackedItem2.itemId)
		attempts = 0
		if trackedItem2.attempts then
			attempts = trackedItem2.attempts
		end
		if trackedItem2.lastAttempts then
			attempts = attempts - trackedItem2.lastAttempts
		end
		if trackedItem2.realAttempts and trackedItem2.found and not trackedItem2.repeatable then
			attempts = trackedItem2.realAttempts
		end
		if trackedItem2.found and not trackedItem2.repeatable then
			chance = 1.0
		else
			if trackedItem2.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
				chance = (trackedItem2.attempts or 0) / (trackedItem2.chance or 100)
				if chance < 0 then
					chance = 0
				end
				if chance > 1 then
					chance = 1
				end
				chance = chance * 100
			else
				dropChance = Rarity.Statistics.GetRealDropPercentage(trackedItem2)
				chance = 100 * (1 - math.pow(1 - dropChance, attempts))
			end
		end
		if not chance then
			chance = 0
		end
		if chance > 100 then
			chance = 100
		end
		if chance < 0 then
			chance = 0
		end
		text = format("%s: %d (%.2f%%)", trackedItem2.name or "", attempts, chance)
		if not self.bar2 then
			self.bar2 =
				self.barGroup:NewCounterBar(
				"Track2",
				text,
				chance,
				100,
				itemTexture or [[Interface\Icons\spell_nature_forceofnature]]
			)
		else
			self.bar2:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
			self.bar2:SetLabel(text)
			self.bar2:SetValue(chance, 100)
		end
	end
	self:ProfileStop("UpdateText: %fms")
end

function dataobj.OnEnter(self)
	frame = self
	Rarity:ShowTooltip()
end

function dataobj.OnLeave(self)
end

function dataobj:OnClick(button)
	if IsShiftKeyDown() then
		-- Show options
		Rarity:Debug("Loading Rarity_Options addon")
		LoadAddOn("Rarity_Options")
		if R.optionsFrame then
			InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
		else
			R:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		end
	elseif IsControlKeyDown() then
		-- Change sort order
		if R.db.profile.sortMode == SORT_NAME then
			R.db.profile.sortMode = SORT_CATEGORY
		elseif R.db.profile.sortMode == SORT_CATEGORY then
			R.db.profile.sortMode = SORT_DIFFICULTY
		elseif R.db.profile.sortMode == SORT_DIFFICULTY then
			R.db.profile.sortMode = SORT_PROGRESS
		elseif R.db.profile.sortMode == SORT_PROGRESS then
			R.db.profile.sortMode = SORT_ZONE
		else
			R.db.profile.sortMode = SORT_NAME
		end
		if tooltip then
			tooltip:Hide()
		end
		if qtip:IsAcquired("RarityTooltip") then
			qtip:Release("RarityTooltip")
		end
		Rarity:ShowTooltip()
	else
		-- Toggle progress bar visibility
		R.db.profile.bar.visible = not R.db.profile.bar.visible
		Rarity.GUI:UpdateBar()
		Rarity.GUI:UpdateText()
	end
end

function GUI:RegisterDataBroker()
	dbicon:Register("Rarity", dataobj, Rarity.db.profile.minimap)
end

function R:InTooltip()
	return qtip:IsAcquired("RarityTooltip")
end

local function tooltip2AddLine(value)
	local lineIndex = tooltip2:AddLine()
	tooltip2:SetCell(lineIndex, 1, value, nil, nil, 2, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
end

local function tooltip2AddDoubleLine(value1, value2)
	local lineIndex = tooltip2:AddLine()
	tooltip2:SetCell(lineIndex, 1, value1, nil, nil, 1, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
	tooltip2:SetCell(lineIndex, 2, value2)
end

local function colorize(s, color)
	if color and s then
		return format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
	else
		return s
	end
end

local function colorizeV(s, r, g, b)
	if r and g and b and s then
		return format("|cff%02x%02x%02x%s|r", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255, s)
	else
		return s
	end
end

local function showSubTooltip(cell, item)
	if not item or not item.itemId then
		return
	end

	if qtip:IsAcquired("RaritySubTooltip") and tooltip2 then
		qtip:Release(tooltip2)
		tooltip2 = nil
	end
	tooltip2 = qtip:Acquire("RaritySubTooltip", 3, "LEFT", "RIGHT")
	tooltip2:ClearAllPoints()
	tooltip2:SetClampedToScreen(true)

	if R.db.profile.statusTip == TIP_RIGHT then
		tooltip2:SetPoint("LEFT", cell, "RIGHT", 30, 0)
	elseif R.db.profile.statusTip == TIP_LEFT then
		tooltip2:SetPoint("RIGHT", cell, "LEFT", -30, 0)
	end

	local itemName,
	itemLink,
	itemRarity,
	itemLevel,
	itemMinLevel,
	itemType,
	itemSubType,
	itemStackCount,
	itemEquipLoc,
	itemTexture,
	itemSellPrice

	_, -- itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(item.itemId)

	-- Rarity extended information tooltip
	if R.db.profile.statusTip == TIP_HIDDEN then
		return
	end

	if itemTexture ~= nil then
		tooltip2:AddHeader(itemLink or item.name, "|T" .. itemTexture .. ":22|t")
	else
		tooltip2:AddHeader(itemLink or item.name)
	end
	scanTip:ClearLines()
	if item.isToy then
		scanTip:SetToyByItemID(item.itemId)
	else
		scanTip:SetItemByID(item.itemId)
	end
	for i = 2, scanTip:NumLines() do
		local myLeft = _G["__Rarity_ScanTipTextLeft" .. i]
		local txtLeft = myLeft:GetText()
		local leftR, leftG, leftB, leftAlpha = myLeft:GetTextColor()
		local myRight = _G["__Rarity_ScanTipTextRight" .. i]
		local txtRight = myRight:GetText()
		local rightR, rightG, rightB, rightAlpha = myRight:GetTextColor()
		if txtRight then
			tooltip2AddDoubleLine(colorizeV(txtLeft, leftR, leftG, leftB), colorizeV(txtRight, rightR, rightG, rightB))
		else
			tooltip2AddLine(colorizeV(txtLeft, leftR, leftG, leftB))
		end
	end
	tooltip2:AddSeparator(1, 1, 1, 1, 1)

	local catIcon = ""
	if item.cat and Rarity.catIcons[item.cat] then
		catIcon = [[ |TInterface\AddOns\Rarity\Icons\]] .. Rarity.catIcons[item.cat] .. ".blp:0:4|t"
	end
	if R.string_types[item.type] ~= nil then
		tooltip2AddLine(colorize((R.string_types[item.type] or "UNKNOWN") .. catIcon, yellow))
	end
	if item.groupSize and item.groupSize > 1 then
		tooltip2AddLine(colorize(format(L["Usually requires a group of around %d players"], item.groupSize), red))
	end
	if item.method == CONSTANTS.DETECTION_METHODS.SPECIAL and item.obtain then
		tooltip2AddLine(colorize(item.obtain, blue))
	else
		local actualMethod = item.method
		if item.method == CONSTANTS.DETECTION_METHODS.BOSS and item.groupSize and item.groupSize > 1 then
			actualMethod = CONSTANTS.DETECTION_METHODS.BOSS
		else
			if item.method == CONSTANTS.DETECTION_METHODS.BOSS then
				actualMethod = CONSTANTS.DETECTION_METHODS.NPC
			end
		end
		tooltip2AddLine(colorize(R.string_methods[actualMethod], blue))
	end
	if item.pickpocket then
		local class, classFileName = UnitClass("player")
		local pickcolor
		if classFileName == "ROGUE" then
			pickcolor = green
		else
			pickcolor = red
		end
		tooltip2AddLine(colorize(L["Requires Pickpocketing"], pickcolor))
	end
	if item.method == CONSTANTS.DETECTION_METHODS.ZONE or item.method == CONSTANTS.DETECTION_METHODS.FISHING then
		if item.zones and type(item.zones) == "table" then
			for k, v in pairs(item.zones) do
				local zone = lbz[v]
				if not zone then
					zone = lbsz[v]
				end
				if not zone then
					-- zone = v -- Why?
				end
				if not tonumber(v) then
					tooltip2AddLine(colorize("    " .. v, gray))
				end
			end
		end
	elseif item.method == CONSTANTS.DETECTION_METHODS.ARCH then
		if item.raceId then
			tooltip2AddLine(colorize("    " .. R.string_archraces[item.raceId], gray))
		end
	elseif item.method == CONSTANTS.DETECTION_METHODS.USE then
		if item.items and type(item.items) == "table" then
			for k, v in pairs(item.items) do
				_, -- itemName,
					itemLink,
					itemRarity,
					itemLevel,
					itemMinLevel,
					itemType,
					itemSubType,
					itemStackCount,
					itemEquipLoc,
					_, -- itemTexture,
					itemSellPrice = GetItemInfo(v)
				if itemLink then
					tooltip2AddLine("    " .. itemLink)
				end
			end
		end
	end

	-- Source text, bonus satchel, black market, etc.
	local hadSource = false
	if item.type == CONSTANTS.ITEM_TYPES.MOUNT and item.spellId ~= nil and Rarity.mount_sources[item.spellId] ~= nil then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		tooltip2AddLine(Rarity.mount_sources[item.spellId])
		hadSource = true
	end
	if item.type == CONSTANTS.ITEM_TYPES.PET and item.creatureId ~= nil and Rarity.pet_sources[item.creatureId] ~= nil then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		tooltip2AddLine(Rarity.pet_sources[item.creatureId])
		hadSource = true
	end
	if item.sourceText ~= nil and item.sourceText ~= "" then
		tooltip2AddLine(item.sourceText)
		hadSource = true
	end
	if item.worldBossFactionless then
		tooltip2AddLine(
			colorize(L["All players can participate in killing this world boss once per week, regardless of faction"], blue)
		)
	end
	if item.wasGuaranteed then
		tooltip2AddLine(
			colorize(L["This was a guaranteed drop for players who defeated the encounter when it was current"], blue)
		)
	end
	if item.bonusSatchel then
		tooltip2AddLine(colorize(L["Contained in bonus satchels"], yellow))
	end
	if item.blackMarket then
		tooltip2AddLine(colorize(L["Appears in the Black Market"], yellow))
	end
	if item.enableCoin then
		tooltip2AddLine(colorize(L["Can be obtained with a bonus roll"], yellow))
	end
	if item.requiresAlliance then
		tooltip2AddLine(colorize(L["This mount is only obtainable by Alliance players"], red))
	end
	if item.requiresHorde then
		tooltip2AddLine(colorize(L["This mount is only obtainable by Horde players"], red))
	end
	if
		hadSource or item.bonusSatchel or item.blackMarket or item.wasGuaranteed or item.worldBossFactionless or
			item.requiresAlliance or
			item.requiresHorde
	 then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
	end

	-- Zone(s)
	local zoneText = ""
	local currentZone = GetBestMapForUnit("player")
	if item.coords ~= nil and type(item.coords) == "table" then
		local zoneList = {}
		for _, zoneValue in pairs(item.coords) do
			if type(zoneValue) == "table" and zoneValue.m ~= nil then
				local doThisZone = false
				if zoneList[zoneValue.m] == nil then
					zoneList[zoneValue.m] = true
					doThisZone = true
				end
				if doThisZone then
					if zoneText ~= "" then
						zoneText = zoneText .. ", "
					end
					if currentZone == zoneValue.m then
						zoneText = zoneText .. colorize(GetMapNameByID(zoneValue.m) or "", green)
					else
						zoneText = zoneText .. colorize(GetMapNameByID(zoneValue.m) or "", gray)
					end
				end
			end
		end
		if zoneText ~= "" then
			tooltip2AddLine(L["Found in: "] .. zoneText)
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
		end
	end

	-- Collection info
	if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		local collectText = ""
		if type(item.collectedItemId) ~= "table" then
			itemName,
				itemLink,
				itemRarity,
				itemLevel,
				itemMinLevel,
				itemType,
				itemSubType,
				itemStackCount,
				itemEquipLoc,
				_, -- itemTexture,
				itemSellPrice = GetItemInfo(item.collectedItemId)
			collectText = itemLink or itemName or ""
		else
			for k, v in pairs(item.collectedItemId) do
				itemName,
					itemLink,
					itemRarity,
					itemLevel,
					itemMinLevel,
					itemType,
					itemSubType,
					itemStackCount,
					itemEquipLoc,
					_, -- itemTexture,
					itemSellPrice = GetItemInfo(v)
				if collectText ~= "" then
					collectText = collectText .. ", "
				end
				collectText = collectText .. (itemLink or itemName or "")
			end
		end
		tooltip2AddLine(colorize(format(L["Collect %d %s"], item.chance or 100, collectText), white))
		if item.obtain then
			tooltip2AddLine(colorize(item.obtain, white))
		end
	else
		tooltip2AddLine(colorize(format(L["1 in %d chance"], item.chance or 100), white))
	end
	local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
	local medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
	if item.method ~= CONSTANTS.DETECTION_METHODS.COLLECTION then
		tooltip2AddLine(colorize(format(L["Lucky if you obtain in %d or less"], medianLoots), gray))
	end

	-- Time and progress
	tooltip2:AddSeparator(1, 1, 1, 1, 1)
	local len = (Rarity.Session:GetLastTime() or 0) - (Rarity.Session:GetStartTime() or 0)
	local tracked = Rarity.Tracking:FindTrackedItem()
	if not Rarity.Session:IsActive() or not len or tracked ~= item then
		len = 0
	end

	if item.totalFinds and item.method ~= CONSTANTS.DETECTION_METHODS.COLLECTION then
		tooltip2AddLine(colorize(L["Since last drop"], yellow))
	end
	local attempts = (item.attempts or 0) - (item.lastAttempts or 0)
	if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		tooltip2AddDoubleLine(L["Collected"], attempts)
	else
		tooltip2AddDoubleLine(L["Attempts"], attempts)
	end
	if
		item.method == CONSTANTS.DETECTION_METHODS.NPC or item.method == CONSTANTS.DETECTION_METHODS.ZONE or
			item.method == CONSTANTS.DETECTION_METHODS.FISHING or
			item.method == CONSTANTS.DETECTION_METHODS.USE
	 then
		tooltip2AddDoubleLine(L["Time spent farming"], FormatTime((item.time or 0) - (item.lastTime or 0) + len))
	end
	if attempts > 0 then
		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			local chance = 100 * (attempts / (item.chance or 100))
			if chance > 100 then
				chance = 100
			end
			if chance < 0 then
				chance = 0
			end
			tooltip2AddDoubleLine(L["Progress"], format("%.2f%%", chance))
		else
			local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
			tooltip2AddDoubleLine(L["Chance so far"], format("%.2f%%", chance))
		end
	end

	if item.totalFinds and item.method ~= CONSTANTS.DETECTION_METHODS.COLLECTION then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		tooltip2AddLine(colorize(L["Total"], yellow))
		attempts = (item.attempts or 0)
		tooltip2AddDoubleLine(L["Attempts"], attempts)
		if
			item.method == CONSTANTS.DETECTION_METHODS.NPC or item.method == CONSTANTS.DETECTION_METHODS.ZONE or
				item.method == CONSTANTS.DETECTION_METHODS.FISHING or
				item.method == CONSTANTS.DETECTION_METHODS.USE
		 then
			tooltip2AddDoubleLine(L["Time spent farming"], FormatTime((item.time or 0) + len))
		end
		tooltip2AddDoubleLine(L["Total found"], item.totalFinds)
		if item.finds then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
			local f = sort2(item.finds)
			for k, v in pairs(f) do
				dropChance = Rarity.Statistics.GetRealDropPercentage(v)
				local chance = 100 * (1 - math.pow(1 - dropChance, v.attempts))
				if v.attempts == 1 then
					tooltip2AddDoubleLine(
						format(L["#%d: %d attempt (%.2f%%)"], v.num, v.attempts, chance),
						FormatTime((v.time or 0) + len)
					)
				else
					tooltip2AddDoubleLine(
						format(L["#%d: %d attempts (%.2f%%)"], v.num, v.attempts, chance),
						FormatTime((v.time or 0) + len)
					)
				end
			end
		end
	end

	-- Session/time period breakdown
	if item.dates and item.method ~= CONSTANTS.DETECTION_METHODS.COLLECTION then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)

		if item.session then
			local sessionAttempts = item.session.attempts or 0
			local sessionTime = item.session.time or 0
			tooltip2AddDoubleLine(L["Session"], format("%d (%s)", sessionAttempts, FormatTime(sessionTime + len)))
		end

		local todayDate = GetDate()
		local yesterDate = GetDate(86400)
		local todayAttempts = item.dates[todayDate] and item.dates[todayDate].attempts or 0
		local todayTime = item.dates[todayDate] and item.dates[todayDate].time or 0
		if tracked == item and Rarity.Session:IsActive() then
			todayTime = todayTime + len
		end
		local yesterAttempts = item.dates[yesterDate] and item.dates[yesterDate].attempts or 0
		local yesterTime = item.dates[yesterDate] and item.dates[yesterDate].time or 0
		local weekAttempts = (todayAttempts or 0) + (yesterAttempts or 0)
		local weekTime = (todayTime or 0) + (yesterTime or 0)
		for day = 2, 6 do
			local dt = GetDate(day * 86400)
			local dayAttempts = item.dates[dt] and item.dates[dt].attempts or 0
			local dayTime = item.dates[dt] and item.dates[dt].time or 0
			weekAttempts = weekAttempts + dayAttempts
			weekTime = weekTime + dayTime
		end
		local monthAttempts = weekAttempts
		local monthTime = weekTime
		for day = 7, 29 do
			local dt = GetDate(day * 86400)
			local dayAttempts = item.dates[dt] and item.dates[dt].attempts or 0
			local dayTime = item.dates[dt] and item.dates[dt].time or 0
			monthAttempts = monthAttempts + dayAttempts
			monthTime = monthTime + dayTime
		end

		tooltip2AddDoubleLine(L["Today"], format("%d (%s)", todayAttempts or 0, FormatTime((todayTime or 0) + len)))
		tooltip2AddDoubleLine(L["Yesterday"], format("%d (%s)", yesterAttempts or 0, FormatTime(yesterTime or 0)))
		tooltip2AddDoubleLine(L["Last Week"], format("%d (%s)", weekAttempts or 0, FormatTime(weekTime or 0)))
		tooltip2AddDoubleLine(L["Last Month"], format("%d (%s)", monthAttempts or 0, FormatTime(monthTime or 0)))
	end

	-- Multi-step defeat detection
	if item.defeatSteps ~= nil and type(item.defeatSteps) == "table" then
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		for defeatStepQuest, defeatStepText in pairs(item.defeatSteps) do
			local defeated = colorize(L["Undefeated"], green)
			if IsQuestFlaggedCompleted(defeatStepQuest) then
				defeated = colorize(L["Defeated"], red)
			end
			tooltip2AddDoubleLine(defeatStepText, defeated)
		end
	end

	tooltip2:AddSeparator(1, 1, 1, 1, 1)

	-- Add TSM pricing information to the tooltip
	if TSM_Interface:IsLoaded() and Rarity.db.profile.showTSMColumn then
		local tooltipLines = {
			{priceSource = "DBMinBuyout", isMonetaryValue = true, localisedDisplayText = L["Min Buyout"]},
			{priceSource = "DBMarket", isMonetaryValue = true, localisedDisplayText = L["Market Price"]},
			{priceSource = "DBRegionMarketAvg", isMonetaryValue = true, localisedDisplayText = L["Region Market Avg"]},
			{priceSource = "DBRegionSaleAvg", isMonetaryValue = true, localisedDisplayText = L["Region Sale Avg"]},
			{priceSource = "DBRegionSaleRate", isMonetaryValue = false, localisedDisplayText = L["Region Sale Rate"]},
			{priceSource = "DBRegionSoldPerDay", isMonetaryValue = false, localisedDisplayText = L["Region Avg Daily Sold"]}
		}

		local hasPrice = false
		for _, lineInfo in pairs(tooltipLines) do -- Add text to tooltip if TSM4 has pricing data for this source
			if not TSM_Interface:IsValidPriceSource(lineInfo.priceSource) then
				Rarity:Print(
					format(
						"Attempting to use invalid price source %s to retrieve a price for item %d via TSM_API." ..
							" Please report this error so it can be fixed :)",
						lineInfo.priceSource,
						item.itemId
					)
				)
				break
			end

			local formattedPrice = TSM_Interface:GetMarketPrice(item.itemId, lineInfo.priceSource, true)
			if (formattedPrice ~= nil) then
				hasPrice = true
				tooltip2AddDoubleLine(
					colorize(lineInfo.localisedDisplayText, blue),
					lineInfo.isMonetaryValue and formattedPrice,
					nil,
					nil
				)
			end
		end

		if hasPrice then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
		end
	end

	-- Click instructions
	tooltip2AddLine(colorize(L["Click to switch to this item"], gray))
	tooltip2AddLine(colorize(L["Shift-Click to link your progress to chat"], gray))

	-- Waypoint instructions
	if item.coords ~= nil and type(item.coords) == "table" then
		local numCoords = 0
		local totalCoords = 0
		for _, coord in pairs(item.coords) do
			if type(coord) == "table" and coord.x ~= nil and coord.y ~= nil and coord.m ~= nil then
				totalCoords = totalCoords + 1
				if coord.q ~= nil then
					if IsQuestFlaggedCompleted(coord.q) == false then
						numCoords = numCoords + 1
					end
				else
					numCoords = numCoords + 1
				end
			end
		end
		if totalCoords > 0 then
			local s = format(L["Rarity has %d |4coordinate:coordinates; for this item."], totalCoords) .. " "
			if totalCoords > numCoords then
				if numCoords <= 0 then
					s = s .. L["You already defeated all of them."]
				else
					s = s .. format(L["You already defeated %d of them."], totalCoords - numCoords) .. " "
				end
			end
			if TomTom ~= nil and TomTom.AddWaypoint ~= nil then
				if numCoords > 0 then
					if totalCoords > numCoords then
						s = s .. L["Ctrl-Click to create the remaining TomTom waypoint(s)."]
					else
						s = s .. L["Ctrl-Click to create TomTom waypoint(s)."]
					end
				end
			else
				s = s .. L["Install TomTom to enable waypoint creation."]
			end
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
			tooltip2AddLine(colorize(s, green))
		end
	end

	--tooltip2:UpdateScrolling()
	tooltip2:Show()
end

local function showSubTooltipMe(cell, group)
	showSubTooltip(cell, group, "")
end

local function showSubTooltipPet(cell, group)
	showSubTooltip(cell, group, "_pet")
end

local function hideSubTooltip()
	if tooltip2 then
		qtip:Release(tooltip2)
		tooltip2 = nil
	end
	GameTooltip:Hide()
end

local function onClickGroup(cell, group)
	if type(group) == "table" then
		if group.collapsed == true then
			group.collapsed = false
		else
			group.collapsed = true
		end
		if tooltip then
			tooltip:Hide()
		end
		if qtip:IsAcquired("RarityTooltip") then
			qtip:Release("RarityTooltip")
		end
		Rarity:ShowTooltip()
	end
end

local function onClickGroup2(cell, group)
	if type(group) == "table" then
		if group.collapsedGroup == true then
			group.collapsedGroup = false
		else
			group.collapsedGroup = true
		end
		if tooltip then
			tooltip:Hide()
		end
		if qtip:IsAcquired("RarityTooltip") then
			qtip:Release("RarityTooltip")
		end
		Rarity:ShowTooltip()
	end
end

local function onClickItem(cell, item)
	local trackedItem = Rarity.Tracking:GetTrackedItem()

	if IsShiftKeyDown() then
		if not item or type(item) ~= "table" or not item.itemId then
			return
		end
		local v = item
		local itemName,
			itemLink,
			itemRarity,
			itemLevel,
			itemMinLevel,
			itemType,
			itemSubType,
			itemStackCount,
			itemEquipLoc,
			itemTexture,
			itemSellPrice = GetItemInfo(v.itemId)
		local attempts = v.attempts or 0
		if v.lastAttempts then
			attempts = attempts - v.lastAttempts
		end
		local dropChance = Rarity.Statistics.GetRealDropPercentage(v)
		local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
		local medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
		local lucky = L["lucky"]
		if medianLoots < attempts then
			lucky = L["unlucky"]
		end
		local s = format(L["%s: 0/%d attempts so far (%.2f%% - %s)"], itemLink or item.name, attempts, chance, lucky)
		if attempts == 1 then
			s = format(L["%s: 0/%d attempt so far (%.2f%% - %s)"], itemLink or item.name, attempts, chance, lucky)
		end
		if attempts <= 0 then
			s = format("%s", itemLink or item.name)
		end
		ChatEdit_InsertLink(s)
	elseif IsControlKeyDown() then
		if not item or type(item) ~= "table" or not item.itemId then
			return
		end
		if item.coords ~= nil and type(item.coords) == "table" then
			local added = 0
			local instance = 0
			for _, coord in pairs(item.coords) do
				local good = false
				if coord.q ~= nil then
					if IsQuestFlaggedCompleted(coord.q) == false then
						good = true
					end
				else
					good = true
				end
				if good and TomTom ~= nil and TomTom.AddWaypoint ~= nil and coord.m ~= nil and coord.x ~= nil and coord.y ~= nil then
					local extraName = ""
					if coord.n ~= nil then
						extraName = " (" .. coord.n .. ")"
					end
					if coord.i ~= true then
						TomTom:AddWaypoint(
							coord.m,
							coord.x / 100.0,
							coord.y / 100.0,
							{title = "Rarity" .. ": " .. item.name .. extraName}
						)
						added = added + 1
					end
					if coord.i == true then
						instance = instance + 1
					end
					if TomTom.SetClosestWaypoint ~= nil then
						TomTom:SetClosestWaypoint()
					end
				end
			end
			if added > 0 then
				Rarity:Print(format(L["Added %d |4waypoint:waypoints; to TomTom"], added))
			end
			if instance > 0 then
				Rarity:Print(
					format(
						L["%d |4waypoint:waypoints; |4is:are; located inside |4an instance:instances; and |4was:were; not added"],
						instance
					)
				)
			end
		end
	else
		if trackedItem ~= item and Rarity.Session:IsActive() then
			Rarity.Session:End()
		end
		Rarity.Tracking:SetTrackedItem(nil, 2)
		Rarity.Tracking:Update(item)
	end
end

local function addGroup(group, requiresGroup)
	local trackedItem = Rarity.Tracking:GetTrackedItem()

	R:ProfileStart2()

	local addGroupStart = debugprofilestop()

	if type(group) ~= "table" then
		return
	end
	if group.name == nil then
		return
	end

	local dt = date("*t", time())
	local line
	local added = false
	local headerAdded = false
	local itemsExistInThisGroup = false
	local g

	local addGroupSortStart = debugprofilestop()

	if R.db.profile.sortMode == SORT_NAME then
		g = sort(group)
	elseif R.db.profile.sortMode == SORT_DIFFICULTY then
		g = sort_difficulty(group)
	elseif R.db.profile.sortMode == SORT_CATEGORY then
		g = sort_category(group)
	elseif R.db.profile.sortMode == SORT_ZONE then
		g = sort_zone(group)
	else
		g = sort_progress(group)
	end

	local addGroupSortEnd = debugprofilestop()

	for k, v in pairs(g) do
		if
			type(v) == "table" and v.enabled ~= false and
				((requiresGroup and v.groupSize ~= nil and v.groupSize > 1) or
					(not requiresGroup and (v.groupSize == nil or v.groupSize <= 1)))
		 then
			local classGood = true
			if not Rarity.Caching:GetPlayerClass() then
				Rarity.Caching:SetPlayerClass(select(2, UnitClass("player")))
			end
			if
				v.disableForClass and type(v.disableForClass == "table") and
					v.disableForClass[Rarity.Caching:GetPlayerClass()] == true
			 then
				classGood = false
			end

			-- Item
			if
				(v.requiresHorde and R.Caching:IsHorde()) or (v.requiresAlliance and not R.Caching:IsHorde()) or
					(not v.requiresHorde and not v.requiresAlliance)
			 then
				if (R.db.profile.cats[v.cat]) or v.cat == nil then
					if (not (R.db.profile.hideHighChance and (v.chance or 0) < 50)) and classGood then
						local itemName,
							itemLink,
							itemRarity,
							itemLevel,
							itemMinLevel,
							itemType,
							itemSubType,
							itemStackCount,
							itemEquipLoc,
							itemTexture,
							itemSellPrice = GetItemInfo(v.itemId)
						local attempts = tonumber(v.attempts or 0) or 0
						if type(attempts) ~= "number" then
							attempts = 0
						end
						if v.lastAttempts then
							attempts = attempts - v.lastAttempts
						end

						local lucky, chance, dropChance

						if v.method ~= CONSTANTS.DETECTION_METHODS.COLLECTION then
							dropChance = Rarity.Statistics.GetRealDropPercentage(v)
							chance = 100 * (1 - math.pow(1 - dropChance, attempts))
							local medianLoots = Round(math.log(1 - 0.5) / math.log(1 - dropChance))
							lucky = colorize(L["Lucky"], green)
							if (tonumber(medianLoots) or 0) < (tonumber(attempts) or 0) then
								lucky = colorize(L["Unlucky"], red)
							end
						else
							chance = 100 * (attempts / (v.chance or 100))
							if chance < 0 then
								chance = 0
							end
							if chance > 100 then
								chance = 100
							end
							lucky = colorize(L["Lucky"], green)
						end

						local icon = ""
						if trackedItem == v then
							icon = [[|TInterface\Buttons\UI-CheckBox-Check:0|t]]
						end
						local duration = 0
						if v.time then
							duration = v.time
						end
						if v.lastTime then
							duration = v.time - v.lastTime
						end
						if Rarity.Session:IsActive() and trackedItem == v then
							local len = Rarity.Session:GetLastTime() - Rarity.Session:GetStartTime()
							duration = duration + len
						end
						duration = FormatTime(duration)
						local likelihood = format("%.2f%%", chance)
						if attempts == 0 then
							attempts = ""
							lucky = ""
							duration = ""
							likelihood = ""
						end
						if duration == "0:00" then
							duration = ""
						end
						if
							v.method ~= CONSTANTS.DETECTION_METHODS.NPC and v.method ~= CONSTANTS.DETECTION_METHODS.ZONE and
								v.method ~= CONSTANTS.DETECTION_METHODS.FISHING and
								v.method ~= CONSTANTS.DETECTION_METHODS.USE
						 then
							duration = ""
						end
						local status = ""
						if v.questId and not v.holidayTexture then
							if type(v.questId) == "table" then
								status = colorize(L["Undefeated"], green)
								for key, questId in pairs(v.questId) do
									if IsQuestFlaggedCompleted(questId) then
										status = colorize(L["Defeated"], red)
									end
								end
							else
								if IsQuestFlaggedCompleted(v.questId) then
									status = colorize(L["Defeated"], red)
								else
									status = colorize(L["Undefeated"], green)
								end
							end
						elseif v.questId and v.holidayTexture then
							if Rarity.holiday_textures[v.holidayTexture] == nil then
								status = colorize(L["Unavailable"], gray)
							elseif v.christmasOnly and dt.month == 12 and dt.day < 25 then
								status = colorize(L["Unavailable"], gray)
							else
								if type(v.questId) == "table" then
									status = colorize(L["Undefeated"], green)
									for key, questId in pairs(v.questId) do
										if IsQuestFlaggedCompleted(questId) then
											status = colorize(L["Defeated"], red)
										end
									end
								else
									if IsQuestFlaggedCompleted(v.questId) then
										status = colorize(L["Defeated"], red)
									else
										status = colorize(L["Undefeated"], green)
									end
								end
							end
						elseif v.lockBossName or v.lockoutDetails then
							-- Lockout-based defeat detection requires special treatment due to the underlying complexity
							if not lbb["Theralion and Valiona"] and lbb["Valiona and Theralion"] then
								-- LibBabble-Boss is still outdated -> Add correct encounter name
								lbb["Theralion and Valiona"] = lbb["Valiona and Theralion"] -- Workaround for issue:
							-- https://github.com/SacredDuckwhale/Rarity/issues/22 - can be removed once the library was updated
							end

							local isDefeated
							local mode = CONSTANTS.DEFEAT_DETECTION.MODE_OR
							-- OR: At least one encounter must be defeated
							-- AND: All encounters must be defeated
							-- (before the item will be displayed as defeated)
							local usesNewDefeatDetection = v.lockoutDetails and type(v.lockoutDetails) == "table" and #v.lockoutDetails > 0

							if usesNewDefeatDetection then -- Resolve the defeat detection using the item's parameters
								isDefeated = false
								local continue = true

								mode = v.lockoutDetails.mode or mode

								for index, sharedDifficultyGroup in ipairs(v.lockoutDetails) do
									-- Check all stored lockouts and resolve the defeat detection
									-- (if there are none there isn't anything left to do)
									local isValidEntry =
										sharedDifficultyGroup.encounterName and type(sharedDifficultyGroup.encounterName) == "string" and
										sharedDifficultyGroup.instanceDifficulties and
										type(sharedDifficultyGroup.instanceDifficulties) == "table"

									if not isValidEntry then
										Rarity:Debug(
											"Invalid lockout details for item " .. tostring(v.name) .. " - defeat detection will not be resolved"
										)
										continue = false
									end

									local storedLockouts = Rarity.lockouts_detailed[sharedDifficultyGroup.encounterName] or {}

									local isGroupCompleted = false
									for instanceDifficulty, membershipFlag in pairs(sharedDifficultyGroup.instanceDifficulties) do
										-- Check if a lockout is stored for any of the group's members (difficulties)
										if storedLockouts[instanceDifficulty] then -- Flag the entire group as locked out
											isGroupCompleted = true -- isGroupCompleted = storedLockouts[instanceDifficulty]
										end
									end

									if mode == CONSTANTS.DEFEAT_DETECTION.MODE_AND and not isGroupCompleted and continue then
										-- Since at least one step isn't complete, the item shouldn't be marked as defeated
										isDefeated = false
										continue = false
									elseif continue then -- Overwrite default value
										isDefeated = true
									end

									-- Otherwise, at least one version was defeated, so the item should be marked as defeated
									if mode == CONSTANTS.DEFEAT_DETECTION.MODE_OR and isGroupCompleted and continue then
										isDefeated = true
										continue = false
									end
								end
							end

							-- Currently, only one of the two detection routines should be used
							if
								(v.lockBossName and lbb[v.lockBossName] and
									(Rarity.lockouts[lbb[v.lockBossName]] == true or Rarity.lockouts[v.lockBossName] == true)) or -- Legacy detection (I'll leave it be, for now)
									isDefeated
							 then
								status = colorize(L["Defeated"], red)
							else
								status = colorize(L["Undefeated"], green)
							end
						elseif v.lockDungeonId then
							if Rarity.lockouts_holiday[v.lockDungeonId] == true then
								status = colorize(L["Defeated"], red)
							else
								if Rarity.lockouts_holiday[v.lockDungeonId] == false then
									status = colorize(L["Undefeated"], green)
								else
									status = colorize(L["Unavailable"], gray)
								end
							end
						elseif v.holidayTexture and Rarity.holiday_textures[v.holidayTexture] == nil then
							status = colorize(L["Unavailable"], gray)
						end
						if v.pickpocket then
							local class, classFileName = UnitClass("player")
							if classFileName ~= "ROGUE" then
								status = colorize(L["Unavailable"], gray)
							end
						end

						-- Support for Defeated items with multiple steps of defeat (supports quests only)
						if
							status == colorize(L["Defeated"], red) and v.defeatAllQuests and v.questId ~= nil and type(v.questId) == "table"
						 then
							local totalQuests = 0
							local numCompletedQuests = 0
							for _, quest in pairs(v.questId) do
								totalQuests = totalQuests + 1
								if IsQuestFlaggedCompleted(quest) then
									numCompletedQuests = numCompletedQuests + 1
								end
							end
							if totalQuests > numCompletedQuests then
								status = colorize(format(L["Defeated"] .. " (%d of %d)", numCompletedQuests, totalQuests), yellow)
							end
						end

						if Rarity.db.profile.hideUnavailable == false or status ~= colorize(L["Unavailable"], gray) then
							if Rarity.db.profile.hideDefeated == false or status ~= colorize(L["Defeated"], red) then
								-- Holiday reminder
								if
									Rarity.db.profile.holidayReminder and Rarity.allRemindersDone == nil and v.holidayReminder ~= false and
										v.cat == HOLIDAY and
										status == colorize(L["Undefeated"], green)
								 then
									Rarity.anyReminderDone = true
									numHolidayReminders = numHolidayReminders + 1
									if numHolidayReminders <= 2 then
										local text =
											format(L["A holiday event is available today for %s! Go get it!"], itemLink or itemName or v.name)
										Rarity:Print(text)
										if tostring(SHOW_COMBAT_TEXT) ~= "0" then
											if type(CombatText_AddMessage) == "nil" then
												UIParentLoadAddOn("Blizzard_CombatText")
											end
											CombatText_AddMessage(text, CombatText_StandardScroll, 1, 1, 1, true, false)
										else
											UIErrorsFrame:AddMessage(text, 1, 1, 1, 1.0)
										end
									else
										if showedHolidayReminderOverflow == false then
											Rarity:Print(
												colorize(
													L["There are more holiday items available, but Rarity only reminds you about the first two."],
													gray
												)
											)
										end
										showedHolidayReminderOverflow = true
									end
								end

								if
									not Rarity.db.profile.onlyShowItemsWithAttempts or
										(Rarity.db.profile.onlyShowItemsWithAttempts and (tonumber(v.attempts or 0) or 0) > 0)
								 then
									if
										not Rarity.db.profile.hideOutsideZone or
											(Rarity.db.profile.hideOutsideZone and select(2, R:GetZone(v)) and R:IsAttemptAllowed(v))
									 then
										itemsExistInThisGroup = true
										if
											((not requiresGroup and group.collapsed ~= true) or (requiresGroup and group.collapsedGroup ~= true)) and
												v.itemId ~= nil
										 then
											-- Header
											if not added then
												headerAdded = true
												local groupName = group.name
												if requiresGroup then
													groupName = groupName .. L[" (Group)"]
												end
												if not headers[groupName] and v.itemId ~= nil then
													headers[groupName] = true
													local collapsed = group.collapsed or false
													if ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
														line = tooltip:AddLine("|TInterface\\Buttons\\UI-PlusButton-Up:16|t", colorize(groupName, yellow))
													else
														line =
															tooltip:AddLine(
															"|TInterface\\Buttons\\UI-MinusButton-Up:16|t",
															colorize(groupName, yellow),
															colorize(L["Attempts"], yellow),
															colorize(L["Likelihood"], yellow),
															Rarity.db.profile.showTimeColumn and colorize(L["Time"], yellow) or nil,
															Rarity.db.profile.showLuckinessColumn and colorize(L["Luckiness"], yellow) or nil,
															Rarity.db.profile.showZoneColumn and colorize(L["Zone"], yellow) or nil,
															colorize(L["Defeated"], yellow),
															TSM_API ~= nil and Rarity.db.profile.showTSMColumn and colorize(L["Market Price"], yellow) or nil
														)
													end
													tooltip:SetLineScript(line, "OnMouseUp", requiresGroup and onClickGroup2 or onClickGroup, group)
												end
											end

											-- Zone
											local zoneText, inMyZone, zoneColor, numZones = R:GetZone(v)

											-- Retrieve the DBMarket price provided by the TSM_API (if loaded)
											local marketPrice =
												Rarity.db.profile.showTSMColumn and TSM_Interface:GetMarketPrice(v.itemId, "DBMarket", true)

											-- Add the item to the tooltip
											local catIcon = ""
											if Rarity.db.profile.showCategoryIcons and v.cat and Rarity.catIcons[v.cat] then
												catIcon = [[|TInterface\AddOns\Rarity\Icons\]] .. Rarity.catIcons[v.cat] .. ".blp:0:4|t "
											end
											line =
												tooltip:AddLine(
												icon,
												catIcon .. (itemTexture and "|T" .. itemTexture .. ":0|t " or "") .. (itemLink or v.name or L["Unknown"]),
												attempts,
												likelihood,
												Rarity.db.profile.showTimeColumn and duration or nil,
												Rarity.db.profile.showLuckinessColumn and lucky or nil,
												Rarity.db.profile.showZoneColumn and colorize(zoneText, zoneColor) or nil,
												status,
												Rarity.db.profile.showTSMColumn and marketPrice or nil
											)
											tooltip:SetLineScript(line, "OnMouseUp", onClickItem, v)
											tooltip:SetLineScript(line, "OnEnter", showSubTooltip, v)
											tooltip:SetLineScript(line, "OnLeave", hideSubTooltip)
											added = true

										-- "Should display the item" endif section:
										end
									end
								end
							end
						end
					-- End "should display the item" endif section
					end
				end
			end
		end
	end

	local addGroupIterationEnd = debugprofilestop()

	-- Collapsed Header
	if
		(not headerAdded) and itemsExistInThisGroup and
			((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true))
	 then
		-- headerAdded = true -- Why?
		local groupName = group.name
		if requiresGroup then
			groupName = groupName .. L[" (Group)"]
		end
		if not headers[groupName] then
			headers[groupName] = true
			local collapsed = group.collapsed or false
			if ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
				line = tooltip:AddLine("|TInterface\\Buttons\\UI-PlusButton-Up:16|t", colorize(groupName, yellow))
			else
				line =
					tooltip:AddLine(
					"|TInterface\\Buttons\\UI-MinusButton-Up:16|t",
					colorize(groupName, yellow),
					colorize(L["Attempts"], yellow),
					colorize(L["Likelihood"], yellow),
					Rarity.db.profile.showTimeColumn and colorize(L["Time"], yellow) or nil,
					Rarity.db.profile.showLuckinessColumn and colorize(L["Luckiness"], yellow) or nil,
					Rarity.db.profile.showZoneColumn and colorize(L["Zone"], yellow) or nil,
					colorize(L["Defeated"], yellow)
				)
			end
			tooltip:SetLineScript(line, "OnMouseUp", requiresGroup and onClickGroup2 or onClickGroup, group)
		end
	end

	local addGroupEnd = debugprofilestop()

	R:ProfileStop2(
		"addGroup(" ..
			group.name ..
				", " ..
					tostring(requiresGroup) ..
						") took %fms" ..
							format(
								" (Total: %f, Sort: %f, Iteration: %f, Tooltip: %f",
								(addGroupEnd - addGroupStart),
								(addGroupSortEnd - addGroupSortStart),
								(addGroupIterationEnd - addGroupSortEnd),
								(addGroupEnd - addGroupIterationEnd)
							)
	)

	return added, itemsExistInThisGroup
end

local renderingTip = false

function R:ShowTooltip(hidden)
	-- This function needs to be non-reentrant
	if renderingTip then
		return
	end
	renderingTip = true

	if qtip:IsAcquired("RarityTooltip") and tooltip then
		-- Don't show the tooltip if it's already showing
		if tooltip:IsVisible() then
			renderingTip = false
			return
		end
		tooltip:Clear()
	else
		tooltip = qtip:Acquire("RarityTooltip", 9, "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT", "CENTER", "CENTER", "CENTER")
		-- intentionally one column more than we need to avoid text clipping
		tooltip:SetScale(self.db.profile.tooltipScale or 1)
	end

	table.wipe(headers)
	local addedLast
	local itemsExistInThisGroup
	numHolidayReminders = 0
	showedHolidayReminderOverflow = false
	local delay
	if self.db.profile.tooltipHideDelay <= 0 then
		delay = 0.01
	else
		delay = self.db.profile.tooltipHideDelay or 0.6
	end
	tooltip:SetAutoHideDelay(
		delay,
		frame,
		function()
			tooltip = nil
			qtip:Release("RarityTooltip")
		end
	)

	-- The tooltip can't be built in combat; it takes too long and the script will receive a "script ran too long" error
	if InCombatLockdown() then
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Tooltip can't be shown in combat"], gray), nil, nil, 3)
		if hidden == true or frame == nil then
			renderingTip = false
			return
		end
		tooltip:SmartAnchorTo(frame)
		tooltip:UpdateScrolling()
		tooltip:Show()
		renderingTip = false
		return
	end

	-- No tooltip until we're done initializing
	if not Rarity.Caching:IsReady() then
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Rarity is loading..."], gray), nil, nil, 3)
		if hidden == true or frame == nil then
			renderingTip = false
			return
		end
		tooltip:SmartAnchorTo(frame)
		tooltip:UpdateScrolling()
		tooltip:Show()
		renderingTip = false
		return
	end

	-- Sort header
	local sortDesc = L["Sorting by name"]
	if self.db.profile.sortMode == SORT_DIFFICULTY then
		sortDesc = L["Sorting by difficulty"]
	elseif self.db.profile.sortMode == SORT_PROGRESS then
		sortDesc = L["Sorting by percent complete"]
	elseif self.db.profile.sortMode == SORT_CATEGORY then
		sortDesc = L["Sorting by category, then name"]
	elseif self.db.profile.sortMode == SORT_ZONE then
		sortDesc = L["Sorting by zone"]
	end
	sortDesc = sortDesc .. colorize(" (" .. L["Ctrl-Click to change sort order"] .. ")", gray)
	local line = tooltip:AddLine()
	tooltip:SetCell(line, 1, colorize(sortDesc, green), nil, nil, 3)

	-- Item groups
	R:ProfileStart()

	local somethingAdded = false

	local group1start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.mounts)
	local group1end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group2start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.pets)
	local group2end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group3start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.items)
	local group3end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group4start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.user)
	local group4end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group5start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.mounts, true)
	local group5end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group6start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.pets, true)
	local group6end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group7start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.items, true)
	local group7end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	local group8start = debugprofilestop()
	addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.user, true)
	local group8end = debugprofilestop()
	if addedLast then
		tooltip:AddSeparator(1, 1, 1, 1, 1.0)
	end
	if itemsExistInThisGroup then
		somethingAdded = true
	end

	if not somethingAdded then
		line = tooltip:AddLine()
		tooltip:SetCell(
			line,
			1,
			colorize(
				L[
					"No items to display! Either you've obtained every item, or you have\n" ..
						"one or more options turned on which hide things from the tooltip."
				],
				red
			),
			nil,
			nil,
			3
		)
	end

	R:ProfileStop(
		"Tooltip rendering took %fms" ..
			format(
				" (%f, %f, %f, %f, %f, %f, %f, %f)",
				(group1end - group1start),
				(group2end - group2start),
				(group3end - group3start),
				(group4end - group4start),
				(group5end - group5start),
				(group6end - group6start),
				(group7end - group7start),
				(group8end - group8start)
			)
	)

	-- Footer
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, colorize(L["Click to toggle the progress bar"], gray), nil, nil, 3)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, colorize(L["Shift-Click to open options"], gray), nil, nil, 3)
	line = tooltip:AddLine()
	tooltip:SetCell(line, 1, colorize(L["Ctrl-Click to change sort order"], gray), nil, nil, 3)

	if Rarity.anyReminderDone and not Rarity.allRemindersDone then
		Rarity.allRemindersDone = true
		if Rarity.db.profile.holidayReminder then
			Rarity:Print(
				colorize(
					L[
						"You can turn off holiday reminders as a whole or on an item-by-item basis by visiting the Rarity Options screen."
					],
					gray
				)
			)
		end
	end
	if hidden == true or frame == nil then
		renderingTip = false
		return
	end

	tooltip:SmartAnchorTo(frame)
	tooltip:UpdateScrolling()
	tooltip:Show()

	renderingTip = false
end

--[[
      GAME TOOLTIPS ------------------------------------------------------------------------------------------------------------
  ]]
-- TOOLTIP: NPCS

_G.GameTooltip:HookScript(
	"OnTooltipSetUnit",
	function(self)
		if not R.db or R.db.profile.enableTooltipAdditions == false then
			return
		end

		local name, unit = self:GetUnit()
		if not unit then
			return
		end
		local creatureType = UnitCreatureType(unit)
		--Rarity:Debug("Creature type: "..(creatureType or "nil").." (translation: "..(lbct[creatureType] or "nil")..")")
		if
			creatureType == "Critter" or lbct[creatureType] == "Critter" or creatureType == "Non-combat Pet" or
				lbct[creatureType] == "Non-combat Pet" or
				creatureType == "Wild Pet" or
				lbct[creatureType] == "Wild Pet"
		 then
			return
		end

		local guid = UnitGUID(unit)
		if not unit or not guid then
			return
		end
		local npcid = R:GetNPCIDFromGUID(guid)
		if not UnitCanAttack("player", unit) and not Rarity.db.profile.oneTimeItems[npcid] then
			return
		end -- Something you can't attack (but allow this for one-time items)
		if UnitIsPlayer(unit) then
			return
		end -- A player
		if UnitIsPVP(unit) then
			return
		end -- A PVP flagged unit

		local blankAdded = false
		local rarityAdded = false

		-- This NPC is known to be used for obtaining something
		if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
			for k, v in pairs(Rarity.npcs_to_items[npcid]) do
				if R:IsAttemptAllowed(v) then
					if
						(v.requiresHorde and R.Caching:IsHorde()) or (v.requiresAlliance and not R.Caching:IsHorde()) or
							(not v.requiresHorde and not v.requiresAlliance)
					 then
						local itemName,
							itemLink,
							itemRarity,
							itemLevel,
							itemMinLevel,
							itemType,
							itemSubType,
							itemStackCount,
							itemEquipLoc,
							itemTexture,
							itemSellPrice = GetItemInfo(v.itemId)
						if itemLink or itemName or v.name then
							if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
								blankAdded = true
								GameTooltip:AddLine(" ")
							end
							local chance = select(2, Rarity.Statistics.GetRealDropPercentage(v))
							local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], v.attempts or 0, chance or 0), white)
							if v.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
								attemptText = " " .. colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white)
							end
							if v.known or Rarity.db.profile.tooltipAttempts == false then
								attemptText = ""
							end
							GameTooltip:AddLine(
								colorize(
									(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
										(itemLink or itemName or v.name) .. attemptText,
									yellow
								)
							)
							rarityAdded = true
							if v.pickpocket then
								local class, classFileName = UnitClass("player")
								local pickcolor
								if classFileName == "ROGUE" then
									pickcolor = green
								else
									pickcolor = red
								end
								GameTooltip:AddLine(colorize(L["Requires Pickpocketing"], pickcolor))
							end
							if v.known then
								GameTooltip:AddLine(colorize(L["Already known"], red))
								blankAdded = false
							end
							GameTooltip:Show()
						end
					end
				end
			end
		end

		blankAdded = false

		-- One-time items
		if Rarity.db.profile.oneTimeItems[npcid] and type(Rarity.db.profile.oneTimeItems[npcid]) == "table" then
			if Rarity.db.profile.oneTimeItems[npcid].itemId ~= 99999 then
				local itemName,
					itemLink,
					itemRarity,
					itemLevel,
					itemMinLevel,
					itemType,
					itemSubType,
					itemStackCount,
					itemEquipLoc,
					itemTexture,
					itemSellPrice = GetItemInfo(Rarity.db.profile.oneTimeItems[npcid].itemId)
				if itemLink or itemName then
					if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
						blankAdded = true
						GameTooltip:AddLine(" ")
					end
					if
						Rarity.db.profile.oneTimeItems[npcid].questId ~= nil and
							IsQuestFlaggedCompleted(Rarity.db.profile.oneTimeItems[npcid].questId)
					 then
						GameTooltip:AddLine(
							colorize(
								(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
									(itemLink or itemName),
								yellow
							)
						)
						GameTooltip:AddLine(colorize(L["Already defeated"], red))
						blankAdded = false
						rarityAdded = true
					else
						scanTip:ClearLines()
						scanTip:SetItemByID(Rarity.db.profile.oneTimeItems[npcid].itemId)

						GameTooltip:AddDoubleLine(
							colorize(
								(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
									(itemLink or itemName),
								yellow
							),
							"|T" .. itemTexture .. ":22|t"
						)
						rarityAdded = true

						for i = 2, scanTip:NumLines() do
							local myLeft = _G["__Rarity_ScanTipTextLeft" .. i]
							local txtLeft = myLeft:GetText()
							local leftR, leftG, leftB, leftAlpha = myLeft:GetTextColor()
							local myRight = _G["__Rarity_ScanTipTextRight" .. i]
							local txtRight = myRight:GetText()
							local rightR, rightG, rightB, rightAlpha = myRight:GetTextColor()
							if txtRight then
								GameTooltip:AddDoubleLine(txtLeft, txtRight, leftR, leftG, leftB, rightR, rightB, rightG)
							else
								GameTooltip:AddLine(txtLeft, leftR, leftG, leftB, true)
							end
						end
					end -- showing item tooltip
				end
			end
		end

		-- blankAdded = false -- Why?

		-- NPC is required for an achievement
		if Rarity.ach_npcs_achId[name] then
			local link = GetAchievementLink(Rarity.ach_npcs_achId[name])
			if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
				blankAdded = true
				GameTooltip:AddLine(" ")
			end
			if not Rarity.ach_npcs_isKilled[name] then
				GameTooltip:AddLine(
					colorize((not rarityAdded and L["Rarity: "] or ""), yellow) .. colorize(format(L["Required for %s"], link), green)
				)
			else
				GameTooltip:AddLine(
					colorize((not rarityAdded and L["Rarity: "] or ""), yellow) ..
						colorize(format(L["Already defeated for %s"], link), red)
				)
			end
			rarityAdded = true
		end

		-- This whole zone is used for obtaining something
		if not UnitCanAttack("player", unit) then
			return
		end -- Something you can't attack
		if UnitIsPlayer(unit) then
			return
		end -- A player
		local unitType = tonumber(guid:sub(5, 5), 16) or 0
		if unitType ~= 3 and unitType ~= 5 then
			return
		end

		local zone = GetRealZoneText()
		local subzone = GetSubZoneText()
		local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
		local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]
		if
			Rarity.zones[tostring(GetBestMapForUnit("player"))] or Rarity.zones[zone] or Rarity.zones[lbz[zone] or "."] or
				Rarity.zones[lbsz[subzone] or "."] or
				Rarity.zones[zone_t] or
				Rarity.zones[subzone_t] or
				Rarity.zones[lbz[zone_t] or "."] or
				Rarity.zones[lbsz[subzone_t] or "."]
		 then
			for k, v in pairs(R.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							local found = false
							if vv.method == CONSTANTS.DETECTION_METHODS.ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
								for kkk, vvv in pairs(vv.zones) do
									if tonumber(vvv) ~= nil and tonumber(vvv) == GetBestMapForUnit("player") then
										found = true
									end
									if
										vvv == zone or vvv == lbz[zone] or vvv == subzone or vvv == lbsz[subzone] or vvv == zone_t or vvv == subzone_t or
											vvv == lbz[zone_t] or
											vvv == subzone or
											vvv == lbsz[subzone_t]
									 then
										found = true
									end
								end
							end
							if found then
								if R:IsAttemptAllowed(vv) then
									local itemName,
										itemLink,
										itemRarity,
										itemLevel,
										itemMinLevel,
										itemType,
										itemSubType,
										itemStackCount,
										itemEquipLoc,
										itemTexture,
										itemSellPrice = GetItemInfo(vv.itemId)
									if itemLink or itemName or vv.name then
										if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
											blankAdded = true
											GameTooltip:AddLine(" ")
										end
										local chance = select(2, Rarity.Statistics.GetRealDropPercentage(vv))
										local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
										if vv.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
											attemptText = " " .. colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white)
										end
										if vv.known or Rarity.db.profile.tooltipAttempts == false then
											attemptText = ""
										end
										GameTooltip:AddLine(
											colorize(
												(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
													(itemLink or itemName or vv.name) .. attemptText,
												yellow
											)
										)
										rarityAdded = true
										if vv.known then
											GameTooltip:AddLine(colorize(L["Already known"], red))
											blankAdded = false
										end
										GameTooltip:Show()
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

-- TOOLTIP: ITEMS IN INVENTORY

hooksecurefunc(
	GameTooltip,
	"SetBagItem",
	function(self, bag, slot)
		local blankAdded = false
		local id = GetContainerItemID(bag, slot)
		if id then
			local item
			local rarityAdded = false

			-- This item is used to obtain another item
			if Rarity.items_to_items[id] then
				for k, v in pairs(Rarity.items_to_items[id]) do
					if v.itemId then
						local itemName,
							itemLink,
							itemRarity,
							itemLevel,
							itemMinLevel,
							itemType,
							itemSubType,
							itemStackCount,
							itemEquipLoc,
							itemTexture,
							itemSellPrice = GetItemInfo(v.itemId)
						if itemLink or itemName or v.name then
							if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
								blankAdded = true
								GameTooltip:AddLine(" ")
							end
							local chance = select(2, Rarity.Statistics.GetRealDropPercentage(v))
							local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], v.attempts or 0, chance or 0), white)
							if v.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
								attemptText = " " .. colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white)
							end
							if v.known or Rarity.db.profile.tooltipAttempts == false then
								attemptText = ""
							end
							GameTooltip:AddLine(
								colorize(
									(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
										(itemLink or itemName or v.name) .. attemptText,
									yellow
								)
							)
							rarityAdded = true
							if v.known then
								GameTooltip:AddLine(colorize(L["Already known"], red))
								blankAdded = false
							end
							GameTooltip:Show()
						end
					end
				end
			end

			blankAdded = false

			-- Extra item tooltips
			if R.db.profile.extraTooltips.inventoryItems[id] then
				for x, y in pairs(R.db.profile.extraTooltips.inventoryItems[id]) do
					local itemName,
						itemLink,
						itemRarity,
						itemLevel,
						itemMinLevel,
						itemType,
						itemSubType,
						itemStackCount,
						itemEquipLoc,
						itemTexture,
						itemSellPrice = GetItemInfo(y)
					if itemLink or itemName then
						if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
							blankAdded = true
							GameTooltip:AddLine(" ")
						end
						for k, v in pairs(R.db.profile.groups) do
							if type(v) == "table" then
								for kk, vv in pairs(v) do
									if type(vv) == "table" then
										if vv.itemId == y then
											if R:IsAttemptAllowed(vv) then
												itemName,
													itemLink,
													itemRarity,
													itemLevel,
													itemMinLevel,
													itemType,
													itemSubType,
													itemStackCount,
													itemEquipLoc,
													itemTexture,
													itemSellPrice = GetItemInfo(vv.itemId)
												if itemLink or itemName or vv.name then
													if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
														blankAdded = true
														GameTooltip:AddLine(" ")
													end
													local chance = select(2, Rarity.Statistics.GetRealDropPercentage(vv))
													local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
													if vv.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
														attemptText = " " .. colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white)
													end
													if vv.known or Rarity.db.profile.tooltipAttempts == false then
														attemptText = ""
													end
													GameTooltip:AddLine(
														colorize(
															(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
																(itemLink or itemName or vv.name) .. attemptText,
															yellow
														)
													)
													rarityAdded = true
													if vv.known then
														GameTooltip:AddLine(colorize(L["Already known"], red))
														blankAdded = false
													end
													GameTooltip:Show()
												end
											end
										end
									end
								end
							end
						end
					end
				end
			end
		end
	end
)

function R:GetZone(v)
	local zoneText = ""
	local inMyZone = false
	local zoneColor = gray
	local numZones = 0
	local currentZone = GetBestMapForUnit("player")
	if v.coords ~= nil and type(v.coords) == "table" then
		local zoneList = {}
		for _, zoneValue in pairs(v.coords) do
			if type(zoneValue) == "table" and zoneValue.m ~= nil then
				if zoneList[zoneValue.m] == nil then
					numZones = numZones + 1
					zoneList[zoneValue.m] = true
				end
				zoneText = GetMapNameByID(zoneValue.m)
				if currentZone == zoneValue.m then
					inMyZone = true
				end
			end
		end
		if numZones > 1 then
			zoneText = format(L["%d |4zone:zones;"], numZones)
		end
		if v.coords.zoneOverride ~= nil then
			zoneText = v.coords.zoneOverride
		end
		if inMyZone then
			zoneColor = green
			if numZones > 1 then
				zoneText = GetMapNameByID(currentZone) .. " " .. colorize(format("+%d", numZones - 1), gray)
			end
		end
	end
	return zoneText, inMyZone, zoneColor, numZones
end

function R:OutputAttempts(item, skipTimeUpdate)
	local trackedItem = Rarity.Tracking:GetTrackedItem()
	local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)

	-- TODO: Check if item entry is valid (reuse DB helper), just to be safe
	if type(item) ~= "table" then
		self:Error("Usage: OutputAttempts(item[, skipTimeUpdate]")
		return
	end

	if not item.itemId or not item.name or item.attempts == nil then
		self:Debug("Failed to OutputAttempts (item entry has invalid format")
		return
	end

	self:Debug("New attempt found for %s", item.name)

	if item.enabled == false then
		self:Debug("Skipped OutputAttempts (item is disabled)")
		return
	end

	if item.found and not item.repeatable then
		self:Debug("Skipped OutputAttempts (non-repeatable item was already found)")
		return
	end

	local isHordePlayer = R.Caching:IsHorde()
	if (item.requiresHorde and not isHordePlayer) or (item.requiresAlliance and isHordePlayer) then
		self:Debug("Ignoring attempt for this item (faction does not match)")
		return
	end

	if not skipTimeUpdate then
		-- Increment attempt counter for today
		local dt = GetDate()
		if not item.dates then
			item.dates = {}
		end
		if not item.dates[dt] then
			item.dates[dt] = {}
		end
		if not item.dates[dt].attempts then
			item.dates[dt].attempts = 0
		end
		item.dates[dt].attempts = item.dates[dt].attempts + 1
		if not item.session then
			item.session = {}
		end
		if not item.session.attempts then
			item.session.attempts = 0
		end
		item.session.attempts = item.session.attempts + 1

		-- Handle time tracking
		local lastAttemptItem = Rarity.Tracking:GetLastAttemptItem()
		-- TODO: Clean this up once I know what it's actually used for
		local DUAL_TRACK_THRESHOLD = Rarity.Tracking.DUAL_TRACK_THRESHOLD
		if
			lastAttemptItem and lastAttemptItem ~= item and
				GetTime() - (Rarity.Tracking:GetLastAttemptTime() or 0) <= DUAL_TRACK_THRESHOLD
		 then -- Beginning to track two things at once
			Rarity.Session:Update()
		else
			if trackedItem == item or trackedItem2 == item then
				Rarity.Session:Update()
			else
				Rarity.Session:End()
				Rarity.Session:Start()
			end
		end
	end

	-- Update LDB text
	Rarity.GUI:UpdateText()

	-- Switch to track this item
	Rarity.Tracking:Update(item)

	-- Save what we last tracked and when it happened
	Rarity.Tracking:SetLastAttemptTime(GetTime())
	Rarity.Tracking:SetLastAttemptItem(item)
	-- If this item supports lockout detection, request updated instance info from the server now and in 10 seconds
	if item.lockBossName or item.lockDungeonId then
		RequestRaidInfo()
		RequestLFDPlayerLockInfo()

		self:ScheduleTimer(
			function()
				RequestRaidInfo()
				RequestLFDPlayerLockInfo()
			end,
			10
		)
		self:ScheduleTimer(
			function()
				Rarity:ScanInstanceLocks("ATTEMPT DETECTED")
			end,
			5
		)
	end

	-- Save this item for coin tracking, but only for 90 seconds
	if item.enableCoin then
		self:Debug("Allowing this item to be counted again if a coin is used in the next 90 seconds")
		self.lastCoinItem = item

		self:ScheduleTimer(
			function()
				self.lastCoinItem = nil
			end,
			90
		)
	else
		self.lastCoinItem = nil
	end

	-- Don't go any further if we don't want to announce this
	if self.db.profile.enableAnnouncements == false then
		return
	end
	if item.announce == false then
		return
	end
	if self.db.profile.onlyAnnounceFound == true then
		return
	end

	-- Output the attempt count
	local itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(item.itemId)
	if itemName or item.name then
		local s
		local attempts = item.attempts or 1
		local total = item.attempts or 1

		if item.lastAttempts then
			attempts = attempts - item.lastAttempts
		end

		if total <= attempts then
			if attempts == 1 then
				s = format(L["%s: %d attempt"], itemName or item.name, attempts)
			else
				s = format(L["%s: %d attempts"], itemName or item.name, attempts)
			end
		else
			if attempts == 1 then
				s = format(L["%s: %d attempt (%d total)"], itemName or item.name, attempts, total)
			else
				s = format(L["%s: %d attempts (%d total)"], itemName or item.name, attempts, total)
			end
		end

		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			s = format(L["%s: %d collected"], itemName or item.name, attempts)
		end
		self:Pour(s, nil, nil, nil, nil, nil, nil, nil, nil, itemTexture)
	end
end

local function RarityAchievementAlertFrame_SetUp(frame, itemId, attempts)
	local itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(itemId)
	if itemName == nil then
		return
	end
	if itemTexture == nil then
		itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]]
	end

	-- The following code is adapted from Blizzard's AchievementAlertFrame_SetUp function found in FrameXML\AlertFrameSystems.lua [introduced in 7.0]

	local displayName = frame.Name
	local shieldPoints = frame.Shield.Points
	local shieldIcon = frame.Shield.Icon
	local unlocked = frame.Unlocked
	local oldCheevo = frame.OldAchievement

	displayName:SetText(itemName)

	AchievementShield_SetPoints(0, shieldPoints, GameFontNormal, GameFontNormalSmall)

	if (frame.guildDisplay or frame.oldCheevo) then
		frame.oldCheevo = nil
		shieldPoints:Show()
		shieldIcon:Show()
		oldCheevo:Hide()
		frame.guildDisplay = nil
		frame:SetHeight(88)
		local background = frame.Background
		background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background")
		background:SetTexCoord(0, 0.605, 0, 0.703)
		background:SetPoint("TOPLEFT", 0, 0)
		background:SetPoint("BOTTOMRIGHT", 0, 0)
		local iconBorder = frame.Icon.Overlay
		iconBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame")
		iconBorder:SetTexCoord(0, 0.5625, 0, 0.5625)
		iconBorder:SetPoint("CENTER", -1, 2)
		frame.Icon:SetPoint("TOPLEFT", -26, 16)
		displayName:SetPoint("BOTTOMLEFT", 72, 36)
		displayName:SetPoint("BOTTOMRIGHT", -60, 36)
		frame.Shield:SetPoint("TOPRIGHT", -10, -13)
		shieldPoints:SetPoint("CENTER", 7, 2)
		shieldPoints:SetVertexColor(1, 1, 1)
		shieldIcon:SetTexCoord(0, 0.5, 0, 0.45)
		unlocked:SetPoint("TOP", 7, -23)
		frame.GuildName:Hide()
		frame.GuildBorder:Hide()
		frame.GuildBanner:Hide()
		frame.glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
		frame.glow:SetTexCoord(0, 0.78125, 0, 0.66796875)
		frame.shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
		frame.shine:SetTexCoord(0.78125, 0.912109375, 0, 0.28125)
		frame.shine:SetPoint("BOTTOMLEFT", 0, 8)
	end

	shieldIcon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]])

	frame.Icon.Texture:SetTexture(itemTexture)

	if attempts == nil or attempts <= 0 then
		attempts = 1
	end
	if item and item.method and item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		unlocked:SetText(L["Collection Complete"])
	else
		if attempts == 1 then
			unlocked:SetText(L["Obtained On Your First Attempt"])
		else
			unlocked:SetText(format(L["Obtained After %d Attempts"], attempts))
		end
	end
	Rarity:ScheduleTimer(
		function()
			-- Put the achievement frame back to normal when we're done
			unlocked:SetText(ACHIEVEMENT_UNLOCKED)
		end,
		10
	)

	frame.id = itemId
	return true
end

local RarityAchievementAlertSystem =
	AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", RarityAchievementAlertFrame_SetUp, 2, 6)
RarityAchievementAlertSystem:SetCanShowMoreConditionFunc(
	function()
		return not C_PetBattles.IsInBattle()
	end
)

-- test with: /run Rarity:ShowFoundAlert(32458, 5)
function R:ShowFoundAlert(itemId, attempts, item)
	local trackedItem = Rarity.Tracking:GetTrackedItem()
	if item == nil then
		item = trackedItem
	end

	local itemName,
		itemLink,
		itemRarity,
		itemLevel,
		itemMinLevel,
		itemType,
		itemSubType,
		itemStackCount,
		itemEquipLoc,
		itemTexture,
		itemSellPrice = GetItemInfo(itemId)
	if itemName == nil then
		return
	end -- Server doesn't know this item, we can't award it
	if itemTexture == nil then
		itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]]
	end

	-- Output to the sink
	if self.db.profile.enableAnnouncements ~= false and item.announce ~= false then
		local s
		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			s = format(L["%s: collection completed!"], itemName)
		else
			if attempts <= 1 then
				s = format(L["%s: Found on the first attempt!"], itemName)
			else
				s = format(L["%s: Found after %d attempts!"], itemName, attempts)
			end
		end
		self:Pour(s, nil, nil, nil, nil, nil, nil, nil, nil, itemTexture)
	end

	-- The following code is adapted from Blizzard's AlertFrameMixin:OnEvent function found in FrameXML\AlertFrames.lua [heavily updated in 7.0]

	if (IsKioskModeEnabled()) then
		return
	end

	if (not AchievementFrame) then
		AchievementFrame_LoadUI()
	end

	RarityAchievementAlertSystem:AddAlert(itemId, attempts)

	self:ScheduleTimer(
		function()
			-- Take a screenshot
			if Rarity.db.profile.takeScreenshot then
				if (ActionStatus:IsShown()) then
					ActionStatus:Hide()
				end
				Screenshot()
			end
		end,
		2
	)

	PlaySound(12891) -- UI_Alert_AchievementGained
end

Rarity.GUI = GUI
return GUI
