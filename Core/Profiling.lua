local _, addonTable = ...

local Profiling = {
	DEFAULT_TIMER_LABEL = "Default",
	activeTimers = {},
	accumulatedTimes = {}
}

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
