local _, addonTable = ...

-- Upvalues
--- WOW API
local IsAddOnLoaded = C_AddOns.IsAddOnLoaded
local LoadAddOn = C_AddOns.LoadAddOn
--- Lua API
local table_wipe = table.wipe
local pairs = pairs

local Profiling = { DEFAULT_TIMER_LABEL = "Default", isTimerRunning = false, activeTimers = {}, accumulatedTimes = {} }

function Profiling:StartTimer(label)
	if not self:IsProfilingEnabled() then
		return
	end

	label = label or self.DEFAULT_TIMER_LABEL

	if self.activeTimers[label] then
		Rarity:Debug("Failed to start timer %s (already running)", label) -- Should be a NOTICE or similar
		return
	end

	local startTime = self:GetCurrentTimeInMilliseconds()
	self.activeTimers[label] = startTime

	-- If it's is the first time this label was used, we'll initialize the total implicitly here
	if not self:HasAccumulatedTime(label) then
		self:ResetAccumulatedTime(label)
	end
end

function Profiling:HasAccumulatedTime(label)
	return self.accumulatedTimes[label] ~= nil
end

function Profiling:InspectAccumulatedTimes()
	-- TODO: If clicked multiple times, it will open a new instance. But I guess we don't really care to fix this?
	local isLoading, isLoaded = IsAddOnLoaded("Blizzard_DebugTools")
	if not isLoaded then
		Rarity:Debug("Loading Blizzard_DebugTools (required to use the Table Inspector)")
		local success, reason = LoadAddOn("Blizzard_DebugTools")
		if not success then
			Rarity:Debug("Failed to open Table Inspector (Blizzard_DebugTools could not be loaded)")
			return
		end
	end
	-- This can't be cached as the addon isn't loaded automatically, and the global DisplayTableInspectorWindow won't be available
	local tableInspectorInstance = _G["DisplayTableInspectorWindow"](self.accumulatedTimes, "Rarity Profiling Data")
	tableInspectorInstance:SetDynamicUpdates(true)
end

function Profiling:ResetAccumulatedTime(label)
	if not label then
		return
	end

	Rarity:Debug("Reset accumulated profiling data for label %s", label)
	self.accumulatedTimes[label] = 0
end

function Profiling:ResetAccumulatedTimes()
	Rarity:Debug("Reset ALL accumulated profiling data")

	for label, time in pairs(self.accumulatedTimes) do
		-- If we just re-assign the table, the Table Inspector's dynamic updates will stop working and we have to re-open it (I think)
		self:ResetAccumulatedTime(label)
	end
end

function Profiling:GetAccumulatedTime(label)
	return self.accumulatedTimes[label]
end

function Profiling:AccumulateTime(label, timeInMilliseconds)
	if not self:HasAccumulatedTime(label) then
		self:ResetAccumulatedTime(label)
	end

	self.accumulatedTimes[label] = self.accumulatedTimes[label] + timeInMilliseconds
end

local GetTimePreciseSec = _G.GetTimePreciseSec
local MS_PER_SECOND = 1000

function Profiling:GetCurrentTimeInMilliseconds()
	return GetTimePreciseSec() * MS_PER_SECOND
	-- Relying on debugprofilestop() is risky, as it could be reset globally via debugprofilestart()
	-- return debugprofilestop()
end

function Profiling:EndTimer(label)
	if not self:IsProfilingEnabled() then
		return
	end

	label = label or self.DEFAULT_TIMER_LABEL

	local startTime = self.activeTimers[label]

	if not startTime then
		Rarity:Debug("Failed to end timer %s (no such timer is active)", label)
		return
	end

	local endTime = self:GetCurrentTimeInMilliseconds()
	local elapsedTimeInMilliseconds = endTime - startTime

	self:AccumulateTime(label, elapsedTimeInMilliseconds)

	self.activeTimers[label] = nil

	Rarity:ProfileDebug(format("%s: %.2f ms", label, elapsedTimeInMilliseconds))
end

function Profiling:GetTimer(label)
	if not self:IsProfilingEnabled() then
		return
	end

	label = label or self.DEFAULT_TIMER_LABEL

	return self.activeTimers[label]
end

function Profiling:IsProfilingEnabled()
	return Rarity.db.profile.enableProfiling
end

Rarity.Profiling = Profiling
return Profiling
