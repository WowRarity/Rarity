local _, addonTable = ...

--- Session.lua
-- TODO: LuaDoc
local Session = {}

-- Globals
local R = Rarity
-- Addon APIs
local FormatTime = Rarity.Utils.PrettyPrint.FormatTime -- Utils are loaded before Core modules, so this should be fine
local GetDate = Rarity.Utils.Time.GetDate
-- WOW APIs
local GetItemInfo = GetItemInfo
local GetTime = GetTime
local C_Timer = C_Timer

-- Locals
local inSession = false
local sessionStarted = 0
local sessionLast = 0
local isSessionLocked = false
local sessionTimer

-- Constants
local SESSION_LENGTH = 60 * 10 -- 10 minutes

-- Temporary access to locals for external modules (TODO: Remove after refactoring is complete
function Session:GetTimer()
	return sessionTimer
end

function Session:SetTimer(newTimer)
	sessionTimer = newTimer
end

function Session:IsActive()
	return inSession
end

function Session:GetStartTime()
	return sessionStarted
end

function Session:GetLastTime()
	return sessionLast
end

-- Used on profile changes only. Why doesn't it end the session normally?
function Session:Cancel()
	inSession = false
end

local function timeoutSession()
	R:Debug("Nothing happened in 5 minutes. Ending your session.")
	sessionTimer = nil
	Rarity.Session:End()
end

function Session:End()
	self = Rarity

	if inSession then
		local trackedItem = Rarity.Tracking:GetTrackedItem(1)
		local trackedItem2 = Rarity.Tracking:GetTrackedItem(2)

		if trackedItem and trackedItem.itemId then
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
			local len = sessionLast - sessionStarted
			local i = Rarity.Tracking:FindTrackedItem()
			if i then
				i.time = (i.time or 0) + len
				local dt = GetDate()
				if not i.dates then
					i.dates = {}
				end
				if not i.dates[dt] then
					i.dates[dt] = {}
				end
				i.dates[dt].time = (i.dates[dt].time or 0) + len
				if not i.session then
					i.session = {}
				end
				i.session.time = (i.session.time or 0) + len
			end
			self:Debug("Ending session for %s (%s)", itemLink or "ITEM_LINK_UNAVAILABLE", FormatTime(trackedItem.time or 0))
		end
		if trackedItem2 and trackedItem2.itemId then
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
				itemSellPrice = GetItemInfo(trackedItem2.itemId)
			local len = sessionLast - sessionStarted
			local i = trackedItem2
			if i then
				i.time = (i.time or 0) + len
				local dt = GetDate()
				if not i.dates then
					i.dates = {}
				end
				if not i.dates[dt] then
					i.dates[dt] = {}
				end
				i.dates[dt].time = (i.dates[dt].time or 0) + len
				if not i.session then
					i.session = {}
				end
				i.session.time = (i.session.time or 0) + len
			end
			self:Debug("Also ending session for %s (%s)", itemLink, FormatTime(trackedItem2.time or 0))
		end
	end
	inSession = false
end

function Session:Start()
	self = Rarity

	self:Debug("Starting a session")
	inSession = true
	sessionStarted = GetTime()
	sessionLast = sessionStarted
	sessionStarted = sessionStarted - 1
	if sessionTimer then
		self:CancelTimer(sessionTimer, true)
	end
	sessionTimer = self:ScheduleTimer(timeoutSession, SESSION_LENGTH)
end

function Session:Update()
	self = Rarity
	if inSession then
		sessionLast = GetTime()
		--self:Debug("Extending current session")
		if sessionTimer then
			self:CancelTimer(sessionTimer, true)
		end
		sessionTimer = self:ScheduleTimer(timeoutSession, SESSION_LENGTH)
	else
		Rarity.Session:Start()
	end
end

function Session:IsLocked()
	return isSessionLocked
end

function Session.Unlock()
	Rarity:Debug("Unlocking session to continue scanning for new LOOT_READY events")
	isSessionLocked = false
end

function Session:Lock(delay)
	delay = delay or 1 -- 1 second seems to be a suitable default value (as both events fire within 0.5-0.8s of each other)

	-- Lock the current session (and set the timer to unlock it again)
	Rarity:Debug(
		"Locking session for " .. tostring(delay) .. " second(s) to prevent duplicate attempts from being counted"
	)
	isSessionLocked = true
	C_Timer.After(delay, self.Unlock) -- Unlock via timer
end

Rarity.Session = Session
return Session
