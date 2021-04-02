local _, addonTable = ...

-- Upvalues
local R = Rarity
local GUI = Rarity.GUI
local CONSTANTS = addonTable.constants

local GetBestMapForUnit = C_Map.GetBestMapForUnit
local IsWorldQuestActive = C_TaskQuest.IsActive
local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted

local FormatTime = Rarity.Utils.PrettyPrint.FormatTime
local sort2 = Rarity.Utils.Sorting.sort2
local GetDate = Rarity.Utils.Time.GetDate
local AuctionDB = Rarity.AuctionDB
local scanTip = Rarity.GUI.scanTip
local GetMapNameByID = Rarity.GetMapNameByID

-- Main window
-- LibQTip stuff

-- Externals
local qtip = LibStub("LibQTip-1.0")
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()

-- Settings
local STATUS_TOOLTIP_MAX_WIDTH = 200

-- Locals
local tooltip, tooltip2, quicktip
local renderingQuicktip = false
local numHolidayReminders = 0
local showedHolidayReminderOverflow = false
local renderingTip = false
local headers = {}

-- Constants
-- Sort parameters
local SORT_NAME = CONSTANTS.SORT_METHODS.SORT_NAME
local SORT_DIFFICULTY = CONSTANTS.SORT_METHODS.SORT_DIFFICULTY
local SORT_PROGRESS = CONSTANTS.SORT_METHODS.SORT_PROGRESS
local SORT_CATEGORY = CONSTANTS.SORT_METHODS.SORT_CATEGORY
local SORT_ZONE = CONSTANTS.SORT_METHODS.SORT_ZONE
-- Tooltip formatting
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"
-- Categories of origin
local HOLIDAY = "HOLIDAY"
-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"
-- Color codes
-- TODO DRY
local red = {r = 1.0, g = 0.2, b = 0.2}
local blue = {r = 0.4, g = 0.4, b = 1.0}
local green = {r = 0.2, g = 1.0, b = 0.2}
local yellow = {r = 1.0, g = 1.0, b = 0.2}
local gray = {r = 0.5, g = 0.5, b = 0.5}
local white = {r = 1.0, g = 1.0, b = 1.0}
-- GUI.COLOR_WHITE = white
-- GUI.COLOR_YELLOW = yellow
-- GUI.COLOR_GREEN = green
-- GUI.COLOR_RED = red
-- GUI.COLOR_GRAY = gray

-- Addon-scoped functions
function R:InTooltip()
	return qtip:IsAcquired("RarityTooltip")
end

function R:HideQuicktip()
	if quicktip and quicktip:IsVisible() then
		quicktip:Release()
	end
end

function R:ShowQuicktip(hidden)
	if renderingQuicktip then
		return
	end
	renderingQuicktip = true

	if qtip:IsAcquired("RarityQuicktip") and quicktip then
		-- Don't show the tooltip if it's already showing
		if quicktip:IsVisible() then
			renderingQuicktip = false
			return
		end
		quicktip:Clear()
	else
		quicktip = qtip:Acquire("RarityQuicktip", 3, "LEFT", "LEFT")
		-- intentionally one column more than we need to avoid text clipping
		quicktip:SetScale(self.db.profile.tooltipScale or 1)
	end

	quicktip:AddHeader(L["Rarity"])
	quicktip:AddSeparator(1, 1, 1, 1, 1)
	quicktip:AddLine(L["Left click"], L["Open Rarity window"])
	quicktip:AddLine(L["Right click"], L["Toggle tracker"])
	quicktip:AddLine(L["Shift + Left click"], L["Open settings"])
	quicktip:AddLine(L["Ctrl + Left click"], L["Change sorting"])

	quicktip:SetAutoHideDelay(
		0.1,
		Rarity.frame,
		function()
			quicktip = nil
			qtip:Release("RarityQuicktip")
		end
	)

	quicktip:SmartAnchorTo(Rarity.frame)
	quicktip:UpdateScrolling()
	quicktip:Show()

	renderingQuicktip = false
end

function R:HideTooltip()
	if tooltip:IsVisible() then
		tooltip:Release()
	end
end

-- Local functions

local function colorizeV(s, r, g, b)
	if r and g and b and s then
		return format("|cff%02x%02x%02x%s|r", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255, s)
	else
		return s
	end
end

local function tooltip2AddDoubleLine(value1, value2)
	local lineIndex = tooltip2:AddLine()
	tooltip2:SetCell(lineIndex, 1, value1, nil, nil, 1, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
	tooltip2:SetCell(lineIndex, 2, value2)
end

local colorize = GUI.colorize

-- Local functions

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

local function tooltip2AddLine(value)
	local lineIndex = tooltip2:AddLine()
	tooltip2:SetCell(lineIndex, 1, value, nil, nil, 2, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
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
		tooltip2AddLine(
			colorize(L["This item is only obtainable by Alliance players"], R.Caching:IsAlliance() and green or red)
		)
	end
	if item.requiresHorde then
		tooltip2AddLine(colorize(L["This item is only obtainable by Horde players"], R.Caching:IsHorde() and green or red))
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
	if AuctionDB:IsLoaded() and Rarity.db.profile.showTSMColumn then
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
			if not AuctionDB:IsValidPriceSource(lineInfo.priceSource) then
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

			local formattedPrice = AuctionDB:GetMarketPrice(item.itemId, lineInfo.priceSource, true)
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

local function hideSubTooltip()
	if tooltip2 then
		qtip:Release(tooltip2)
		tooltip2 = nil
	end
	GameTooltip:Hide()
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

	local addGroupSortStart = debugprofilestop()

	local sortedGroup = Rarity.Utils.Sorting:SortGroup(group, R.db.profile.sortMode)

	local addGroupSortEnd = debugprofilestop()

	-- Inlining this because it has WAY too many interdependencies and I don't have time to unwrangle it now, but using early exit is easier this way (and more readable). It doesn't change the functionality and the small overhead shouldn't matter here
	local function AddItem(k, v)
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

			if not v.itemId then
				Rarity:Error(
					format(
						"Failed to add tooltip line for item %s (%s) in group %s (invalid ID or the server didn't return any data)",
						k,
						v.name or "nil",
						group.name
					)
				)
				return
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
							-- If item is linked to a World Quest, flag as unavailable if WQ isn't up.
							if v.worldQuestId then
								if IsWorldQuestActive(v.worldQuestId) == false then
									status = colorize(L["Unavailable"], gray)
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
										(v.cat == HOLIDAY or v.worldQuestId) and
										status == colorize(L["Undefeated"], green)
								 then
									Rarity.anyReminderDone = true
									numHolidayReminders = numHolidayReminders + 1
									if numHolidayReminders <= 2 then
										local text
										if v.worldQuestId then
											if IsWorldQuestActive(v.worldQuestId) then
												text = format(L["A world event is currently available for %s! Go get it!"], itemLink or itemName or v.name)
											end
										else
											text = format(L["A holiday event is available today for %s! Go get it!"], itemLink or itemName or v.name)
										end
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
											local marketPrice = Rarity.db.profile.showTSMColumn and AuctionDB:GetMarketPrice(v.itemId, "DBMarket", true)

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

	for k, v in ipairs(sortedGroup) do
		AddItem(k, v)
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

-- Module-level functions
-- Change sort order based on the current one (awkward, but alas... this should probably be improved later)
function GUI:SelectNextSortOrder()
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
end

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
		Rarity.frame,
		function()
			tooltip = nil
			qtip:Release("RarityTooltip")
		end
	)

	-- The tooltip can't be built in combat; it takes too long and the script will receive a "script ran too long" error
	if InCombatLockdown() then
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Tooltip can't be shown in combat"], gray), nil, nil, 3)
		if hidden == true or Rarity.frame == nil then
			renderingTip = false
			return
		end
		tooltip:SmartAnchorTo(Rarity.frame)
		tooltip:UpdateScrolling()
		tooltip:Show()
		renderingTip = false
		return
	end

	-- No tooltip until we're done initializing
	if not Rarity.Caching:IsReady() then
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Rarity is loading..."], gray), nil, nil, 3)
		if hidden == true or Rarity.frame == nil then
			renderingTip = false
			return
		end
		tooltip:SmartAnchorTo(Rarity.frame)
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

	local function OnHeaderClicked()
		if not IsControlKeyDown() then
			return
		end -- Unlike the LDB icon, this also works with right-click...
		-- I have no idea how to get the button from LDB. The tooltip says "click" and not "left-click", so both should be fine
		Rarity.GUI:SelectNextSortOrder()
	end
	tooltip:SetLineScript(line, "OnMouseUp", OnHeaderClicked)

	-- Item groups
	R:ProfileStart()

	local somethingAdded = false

	local group1start = debugprofilestop()
	if (R.db.profile.collectionType[MOUNT]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.mounts)

		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group1end = debugprofilestop()

	local group2start = debugprofilestop()
	if (R.db.profile.collectionType[PET]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.pets)
		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group2end = debugprofilestop()

	local group3start = debugprofilestop()
	if (R.db.profile.collectionType[ITEM]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.items)
		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group3end = debugprofilestop()

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
	if (R.db.profile.collectionType[MOUNT]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.mounts, true)
		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group5end = debugprofilestop()

	local group6start = debugprofilestop()
	if (R.db.profile.collectionType[PET]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.pets, true)
		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group6end = debugprofilestop()

	local group7start = debugprofilestop()
	if (R.db.profile.collectionType[ITEM]) then
		addedLast, itemsExistInThisGroup = addGroup(self.db.profile.groups.items, true)
		if addedLast then
			tooltip:AddSeparator(1, 1, 1, 1, 1.0)
		end
		if itemsExistInThisGroup then
			somethingAdded = true
		end
	end
	local group7end = debugprofilestop()

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
	if hidden == true or Rarity.frame == nil then
		renderingTip = false
		return
	end

	tooltip:SmartAnchorTo(Rarity.frame)
	tooltip:UpdateScrolling()
	tooltip:Show()

	renderingTip = false
end

-- Groups, sort order etc
