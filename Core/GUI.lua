local _, addonTable = ...

--- GUI.lua
-- A random assortment of UI functionality... still needs to be cleaned up further (later)
local GUI = {}

-- Locals
local scanTip = CreateFrame("GameTooltip", "__Rarity_ScanTip", nil, "GameTooltipTemplate")
scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")
GUI.scanTip = scanTip

Rarity.tooltipOpenDelay = false

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()

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
local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted
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
local sort_difficulty = Rarity.Utils.Sorting.sort_difficulty
local sort_category = Rarity.Utils.Sorting.sort_category
local sort_zone = Rarity.Utils.Sorting.sort_zone
local sort_progress = Rarity.Utils.Sorting.sort_progress
local GetDate = Rarity.Utils.Time.GetDate
local AuctionDB = Rarity.AuctionDB

-- Helper function (to look up map names more easily)
-- TODO: DRY (not sure where this fits best, move after refactoring the rest and delete any duplicates)
-- Returns the localized map name, or nil if the uiMapID is invalid
function Rarity.GetMapNameByID(uiMapID) -- TODO doesn't really belong here
	local UiMapDetails = GetMapInfo(uiMapID)
	return UiMapDetails and UiMapDetails.name or nil
end

local GetMapNameByID = Rarity.GetMapNameByID

-- Helper function to open the Tooltip GUI unless the delayed opening has been aborted meanwhile.
function R:ShowDelayedTooltip()
	if Rarity.tooltipOpenDelay == true then
		Rarity:ShowTooltip()
	end
end

--[[
      GAME TOOLTIPS ------------------------------------------------------------------------------------------------------------
  ]]
-- TOOLTIP: NPCS

function GUI.colorize(s, color)
	if color and s then
		return format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
	else
		return s
	end
end
local colorize = GUI.colorize
local red = {r = 1.0, g = 0.2, b = 0.2}
local blue = {r = 0.4, g = 0.4, b = 1.0}
local green = {r = 0.2, g = 1.0, b = 0.2}
local yellow = {r = 1.0, g = 1.0, b = 0.2}
local gray = {r = 0.5, g = 0.5, b = 0.5}
local white = {r = 1.0, g = 1.0, b = 1.0}
-- TODO DRY
-- local white = Rarity.GUI.COLOR_WHITE
-- local yellow = Rarity.GUI.COLOR_YELLOW
-- local green = Rarity.GUI.COLOR_GREEN
-- local red = Rarity.GUI.COLOR_RED
-- local gray = Rarity.GUI.COLOR_GRAY

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
	frame:EnableMouse(false)	-- Make achievement toast unclickable

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
			frame:EnableMouse(true)
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
	-- Presumably, this is now outdated (as of 9.0) so maybe copy/pasting it wasn't the best idea? :P

	if (not AchievementFrame) then
		AchievementFrame_LoadUI()
	end

	-- If option to generate achievement toast on item found is enabled, then generate the toast.
	if Rarity.db.profile.showAchievementToast then
		RarityAchievementAlertSystem:AddAlert(itemId, attempts)
		PlaySound(12891) -- UI_Alert_AchievementGained
	end

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
end

Rarity.GUI = GUI
return GUI
