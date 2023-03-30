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

--[[
      GAME TOOLTIPS ------------------------------------------------------------------------------------------------------------
  ]]
-- TOOLTIP: NPCS

local Announcements = Rarity.Announcements

function R:OutputAttempts(item, isForcedUpdate)
	-- TODO: Check if item entry is valid (reuse DB helper), just to be safe
	if type(item) ~= "table" then
		self:Error("Usage: OutputAttempts(item[, isForcedUpdate]")
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

	if not isForcedUpdate then
		self:AddDailyAttempt(item)
		self:AddSessionAttempt(item)
		self:UpdateSessionAttempts(item)
	end

	-- Update LDB text
	Rarity.GUI:UpdateText()

	-- Switch to track this item
	Rarity.Tracking:Update(item)

	-- Save what we last tracked and when it happened
	Rarity.Tracking:SetLastAttemptTime(GetTime())
	Rarity.Tracking:SetLastAttemptItem(item)
	-- If this item supports lockout detection, request updated instance info from the server now and in 10 seconds
	self:ProcessLockoutDetection(item)

	-- Save this item for coin tracking, but only for 90 seconds
	self:StartBonusRollTrackingTimer(item)

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
	Announcements:AnnounceAttemptForItem(item)
end

-- Increment attempt counter for today
function Rarity:AddDailyAttempt(item)
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
end

function Rarity:AddSessionAttempt(item)
	if not item.session then
		item.session = {}
	end
	if not item.session.attempts then
		item.session.attempts = 0
	end
	item.session.attempts = item.session.attempts + 1
end

-- Handle time tracking (No idea what this does TBH)
function Rarity:UpdateSessionAttempts(item)
	local lastAttemptItem = Rarity.Tracking:GetLastAttemptItem()
	-- TODO: Clean this up once I know what it's actually used for
	local DUAL_TRACK_THRESHOLD = Rarity.Tracking.DUAL_TRACK_THRESHOLD

	local trackedItem = Rarity.Tracking:GetTrackedItem()
	local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)

	if
		lastAttemptItem
		and lastAttemptItem ~= item
		and GetTime() - (Rarity.Tracking:GetLastAttemptTime() or 0) <= DUAL_TRACK_THRESHOLD
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

function Rarity:ProcessLockoutDetection(item)
	if item.lockBossName or item.lockDungeonId then
		RequestRaidInfo()
		RequestLFDPlayerLockInfo()

		self:ScheduleTimer(function()
			RequestRaidInfo()
			RequestLFDPlayerLockInfo()
		end, 10)
		self:ScheduleTimer(function()
			Rarity:ScanInstanceLocks("ATTEMPT DETECTED")
		end, 5)
	end
end

function Rarity:StartBonusRollTrackingTimer(item)
	if item.enableCoin then
		self:Debug("Allowing this item to be counted again if a coin is used in the next 90 seconds")
		self.lastCoinItem = item

		self:ScheduleTimer(function()
			self.lastCoinItem = nil
		end, 90)
	else
		self.lastCoinItem = nil
	end
end

Rarity.GUI = GUI
return GUI
