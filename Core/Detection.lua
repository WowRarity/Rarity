-- Upvalues
local R = Rarity

-- Lua API
local table = table

-- WOW API
local C_Calendar = C_Calendar
local GetContainerNumSlots = GetContainerNumSlots
local GetContainerItemID = GetContainerItemID
local GetContainerItemInfo = GetContainerItemInfo
local GetNumSavedInstances = GetNumSavedInstances
local GetSavedInstanceInfo = GetSavedInstanceInfo
local GetNumRandomDungeons = GetNumRandomDungeons
local GetLFGRandomDungeonInfo = GetLFGRandomDungeonInfo
local GetLFGDungeonInfo = GetLFGDungeonInfo
local GetLFGDungeonRewards = GetLFGDungeonRewards
local GetStatistic = GetStatistic
local UnitName = UnitName
local UnitGUID = UnitGUID
local InCombatLockdown = InCombatLockdown
local GetAchievementNumCriteria = GetAchievementNumCriteria

-- Constants
local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local BOSS_DEAD = _G.BOSS_DEAD

-- Why is this so inconsistently named? Does it have a special meaning?
local rarity_stats = {}

-------------------------------------------------------------------------------------
-- Scan your bags to see if you are in possession of any of the items we want. This is used for BOSS and FISHING methods,
-- and also works as a second line of defense in case other methods fail to notice the item.
-------------------------------------------------------------------------------------
function R:ScanBags()
	table.wipe(Rarity.bagitems)
	for i = 0, NUM_BAG_SLOTS do
		local numSlots = GetContainerNumSlots(i)
		if numSlots then
			for ii = 1, numSlots do
				local id = GetContainerItemID(i, ii)
				if id then
					local qty = select(2, GetContainerItemInfo(i, ii))
					if qty and qty > 0 then
						if not Rarity.bagitems[id] then
							Rarity.bagitems[id] = 0
						end
						Rarity.bagitems[id] = Rarity.bagitems[id] + qty
					end
				end
			end
		end
	end
end

function R:ScanCalendar(reason)
	self:Debug("Scanning calendar (" .. reason .. ")")

	table.wipe(Rarity.holiday_textures)
	local dateInfo = C_Calendar.GetDate() -- This is the CURRENT date (always "today")
	local month, day, year = dateInfo.month, dateInfo.monthDay, dateInfo.year
	local monthInfo = C_Calendar.GetMonthInfo() -- This is the CALENDAR date (as selected)
	local curMonth, curYear = monthInfo.month, monthInfo.year -- It should be noted that this is the calendar's "current" month... the name may be misleading, but I'll keep it as it was
	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = C_Calendar.GetNumDayEvents(monthOffset, day)
	local numLoaded = 0

	for i = 1, numEvents, 1 do
		local CalendarDayEvent = C_Calendar.GetDayEvent(monthOffset, day, i)
		local calendarType, texture = CalendarDayEvent.calendarType, CalendarDayEvent.iconTexture

		if calendarType == "HOLIDAY" and texture ~= nil then
			Rarity.holiday_textures[texture] = true
		end
	end
end

function R:ScanInstanceLocks(reason)
	self:Debug("Scanning instance locks (" .. reason .. ")")

	local scanTip = Rarity.GUI.scanTip

	table.wipe(Rarity.lockouts)
	local savedInstances = GetNumSavedInstances()
	for i = 1, savedInstances do
		local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig =
			GetSavedInstanceInfo(i)

		-- Legacy code (deprecated)
		if instanceReset > 0 then
			scanTip:ClearLines()
			scanTip:SetInstanceLockEncountersComplete(i)
			for line = 2, scanTip:NumLines() do
				local txtRight = _G["__Rarity_ScanTipTextRight" .. line]:GetText()
				if txtRight then
					if txtRight == BOSS_DEAD then
						self.lockouts[_G["__Rarity_ScanTipTextLeft" .. line]:GetText()] = true
					end
				end
			end
		end

		-- Detailed lockouts saving (stub - I'm leaving the legacy code above untouched, even if it's partly identical)
		if instanceReset > 0 then -- Lockout isn't expired -> Scan it and store the defeated encounter names
			scanTip:ClearLines()
			scanTip:SetInstanceLockEncountersComplete(i)
			for line = 2, scanTip:NumLines() do
				local txtRight = _G["__Rarity_ScanTipTextRight" .. line]:GetText()
				if txtRight then
					if txtRight == BOSS_DEAD then
						local encounterName = _G["__Rarity_ScanTipTextLeft" .. line]:GetText()
						self.lockouts[encounterName] = true
						-- Create containers if this is the first lockout for a given instance
						self.lockouts_detailed[encounterName] = self.lockouts_detailed[encounterName] or {}
						self.lockouts_detailed[encounterName][instanceDifficulty] =
							self.lockouts_detailed[encounterName][instanceDifficulty] or {}
						-- Add this lockout to the container
						self.lockouts_detailed[encounterName][instanceDifficulty] = true
					end
				end
			end
		end
	end

	table.wipe(Rarity.lockouts_holiday)
	local num = GetNumRandomDungeons()
	for i = 1, num do
		local dungeonID, name = GetLFGRandomDungeonInfo(i)
		local _, _, _, _, _, _, _, _, _, _, _, _, _, desc, isHoliday = GetLFGDungeonInfo(dungeonID)
		if isHoliday and dungeonID ~= 828 then -- 828 = ??
			local doneToday = GetLFGDungeonRewards(dungeonID)
			self.lockouts_holiday[dungeonID] = doneToday
		end
	end

	-- This code lists every LFG dungeon ID in the game (up through 1000)
	--for instanceID = 0, 1000 do
	--	local dungeonName, typeId, subtypeId, minLvl, maxLvl, recLvl, minRecLvl, maxRecLvl, expansionId, groupId, textureName, difficulty, maxPlayers, dungeonDesc, isHoliday = GetLFGDungeonInfo(instanceID)
	--		if dungeonName then
	--			self:Print("instanceID = " .. instanceID .. " Name = " .. dungeonName .. " typeID = " .. tostring(typeId) .. " minLvl = " .. minLvl .. " maxLvl = " .. maxLvl .. " recLvl = " .. recLvl .. " groupId = " .. tostring(groupId) .." maxPlayers = " .. tostring(maxPlayers))
	--		end
	--end
end

-- TODO: Does this really belong here? I don't think so...
function R:BuildStatistics(reason)
	self:ProfileStart2()
	--self:Debug("Building statistics table ("..reason..")")

	local tbl = {}
	Rarity.lastStatCount = 0

	for k, v in pairs(R.stats_to_scan) do
		local s = GetStatistic(k)
		tbl[k] = (tonumber(s or "0") or 0)
		if not Rarity.db.profile.accountWideStatistics then
			Rarity.db.profile.accountWideStatistics = {}
		end
		local charName = UnitName("player")
		local charGuid = UnitGUID("player")
		if charName and charGuid then
			if not Rarity.db.profile.accountWideStatistics[charGuid] then
				Rarity.db.profile.accountWideStatistics[charGuid] = {}
			end
			Rarity.db.profile.accountWideStatistics[charGuid].playerName = charName
			Rarity.db.profile.accountWideStatistics[charGuid].server = GetRealmName() or ""
			if not Rarity.db.profile.accountWideStatistics[charGuid].statistics then
				Rarity.db.profile.accountWideStatistics[charGuid].statistics = {}
			end
			Rarity.db.profile.accountWideStatistics[charGuid].statistics[k] = (tonumber(s or "0") or 0)
		end
		Rarity.lastStatCount = Rarity.lastStatCount + 1
	end

	self:ProfileStop2("BuildStatistics: %fms")
	return tbl
end

function R:ScanStatistics(reason)
	if InCombatLockdown() then
		return
	end -- Don't do this during combat as it has a tendency to run too long

	self:ProfileStart2()
	--self:Debug("Scanning statistics ("..reason..")")

	if rarity_stats == nil or (Rarity.lastStatCount or 0) <= 0 then
		self:Debug("Building initial statistics table")
		rarity_stats = self:BuildStatistics(reason)
	end

	local newStats = self:BuildStatistics(reason)

	for kk, vv in pairs(Rarity.items_with_stats) do
		if type(vv) == "table" then
			if
				(vv.requiresHorde and R.Caching:IsHorde()) or (vv.requiresAlliance and not R.Caching:IsHorde()) or
					(not vv.requiresHorde and not vv.requiresAlliance)
			 then
				if vv.statisticId and type(vv.statisticId) == "table" then
					local count = 0
					local totalCrossAccount = 0

					for kkk, vvv in pairs(vv.statisticId) do
						local newAmount = newStats[vvv] or 0
						local oldAmount = rarity_stats[vvv] or 0
						count = count + newAmount

						-- Count up the total for this statistic across the entire account
						if Rarity.db.profile.accountWideStatistics then
							for playerGuid, playerData in pairs(Rarity.db.profile.accountWideStatistics) do
								if playerData.statistics then
									totalCrossAccount =
										totalCrossAccount + (Rarity.db.profile.accountWideStatistics[playerGuid].statistics[vvv] or 0)
								end
							end
						end

						-- One of the statistics has gone up; add one attempt for this item
						if newAmount > oldAmount then
							R:Debug("Statistics indicate a new attempt for " .. vv.name)
							vv.attempts = (vv.attempts or 0) + 1
							self:OutputAttempts(vv, true)
						end
					end

					-- We've never seen any attempts for this yet; update to this player's statistic total
					if count > 0 and (vv.attempts or 0) <= 0 then
						-- We seem to have gathered more attempts on this character than accounted for yet; update to new total
						vv.attempts = count
						self:OutputAttempts(vv, true)
					elseif count > 0 and count > (vv.attempts or 0) and vv.doNotUpdateToHighestStat ~= true then -- Some items don't want us doing this (generally when Blizzard has a statistic overcounting bug)
						R:Debug("Statistics for " .. vv.name .. " are higher than current amount. Updating to " .. count)
						vv.attempts = count
						self:OutputAttempts(vv, true)
					end

					-- Cross-account statistic total is higher than the one we have; update to new total
					if totalCrossAccount > (vv.attempts or 0) and vv.doNotUpdateToHighestStat ~= true then
						R:Debug(
							"Account-wide statistics for " .. vv.name .. " are higher than current amount. Updating to " .. totalCrossAccount
						)
						vv.attempts = totalCrossAccount
						self:OutputAttempts(vv, true)
					end
				end
			end
		end
	end

	-- Done with scan; update our saved table to the current scan
	rarity_stats = newStats

	if self.db.profile.debugMode then
		R.stats = rarity_stats
	end

	-- Scan rare NPC achievements
	table.wipe(Rarity.ach_npcs_isKilled)
	table.wipe(Rarity.ach_npcs_achId)
	for k, v in pairs(self.db.profile.achNpcs) do
		local count = GetAchievementNumCriteria(v)
		for i = 1, count do
			local description, type, completed = GetAchievementCriteriaInfo(v, i)
			Rarity.ach_npcs_achId[description] = v
			if completed then
				Rarity.ach_npcs_isKilled[description] = true
			end
		end
	end

	self:ProfileStop2("ScanStatistics: %fms")
end
