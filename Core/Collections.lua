local _, addonTable = ...

local Collections = {}

-- Locals
local archfragments = {}

-- Upvalues
local R = Rarity
local CONSTANTS = addonTable.constants

-- Lua APIs
local pairs = pairs
local type = type
local select = select
local tonumber = tonumber

-- WOW APIs
local PlayerHasToy = PlayerHasToy
local InCombatLockdown = InCombatLockdown
local C_TransmogCollection = C_TransmogCollection
local C_MountJournal = C_MountJournal
local C_PetJournal = C_PetJournal
local GetNumCompanions = GetNumCompanions
local GetCompanionInfo = GetCompanionInfo
local GetAchievementInfo = GetAchievementInfo
local GetNumArchaeologyRaces = GetNumArchaeologyRaces
local GetNumArtifactsByRace = GetNumArtifactsByRace
local GetArtifactInfoByRace = GetArtifactInfoByRace
local IsQuestComplete = IsQuestComplete
local GetArchaeologyRaceInfo = GetArchaeologyRaceInfo
local GetActiveArtifactByRace = GetActiveArtifactByRace

function Collections:ScanTransmog(reason)
	self = Rarity
	self:Debug("Scanning transmog (" .. (reason or "") .. ")")

	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.itemId and not vv.repeatable and select(2, C_TransmogCollection.GetItemInfo(vv.itemId)) then -- Don't scan for items that aren't gear that have a transmog collection appearance
						if C_TransmogCollection.PlayerHasTransmog(vv.itemId) then -- You have the appearance of the item you're tracking
							vv.known = true
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end
end

function Collections:ScanToys(reason)
	self = Rarity
	self:Debug("Scanning toys (" .. (reason or "") .. ")")

	-- Load the Collections add-on if needed
	if not Rarity.toysScanned then
		if not ToyBox_OnLoad then
			self:Debug("Loading Blizzard_Collections addon so the ToyBox can be scanned")
			UIParentLoadAddOn("Blizzard_Collections")
		end
	end

	-- Scan all Rarity items to see if we already have a toy
	Rarity.toysScanned = true
	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.itemId and not vv.repeatable then
						if PlayerHasToy(vv.itemId) then
							vv.known = true
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end
end

function Collections:ScanExistingItems(reason)
	self = Rarity
	-- Don't allow this scan in combat; it takes too long and the script will receive a "script ran too long" error
	-- Under normal conditions this shouldn't be called during combat, except during the 5-minute final init, or
	-- if the user is messing around with Options in combat.
	if InCombatLockdown() then
		return
	end

	self:Debug("Scanning for existing items (" .. reason .. ")")
	self:ProfileStart()

	-- Scans need to index by spellId, creatureId, achievementId, raceId, itemId (for toys), statisticId (which is a table; for stats)

	-- Mounts (pre-7.0)
	if (C_MountJournal.GetMountInfo ~= nil) then
		-- Mounts (7.0+)
		for id = 1, C_MountJournal.GetNumMounts() do
			local creatureName,
				spellId,
				icon,
				active,
				isUsable,
				sourceType,
				isFavorite,
				isFactionSpecific,
				faction,
				hideOnChar,
				isCollected = C_MountJournal.GetMountInfo(id)
			local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountType = C_MountJournal.GetMountInfoExtra(id)

			Rarity.mount_sources[spellId] = sourceText

			if isCollected then
				for k, v in pairs(R.db.profile.groups) do
					if type(v) == "table" then
						for kk, vv in pairs(v) do
							if type(vv) == "table" then
								if vv.spellId and vv.spellId == spellId then
									vv.known = true
								end
								if vv.spellId and vv.spellId == spellId and not vv.repeatable then
									vv.enabled = false
									vv.found = true
								end
							end
						end
					end
				end
			end
		end
	else
		for i, id in pairs(C_MountJournal.GetMountIDs()) do
			local _, spellId, _, _, _, _, _, _, _, _, isCollected = C_MountJournal.GetMountInfoByID(id)
			local _, _, sourceText = C_MountJournal.GetMountInfoExtraByID(id)

			Rarity.mount_sources[spellId] = sourceText

			if isCollected then
				for k, v in pairs(R.db.profile.groups) do
					if type(v) == "table" then
						for kk, vv in pairs(v) do
							if type(vv) == "table" then
								if vv.spellId and vv.spellId == spellId then
									vv.known = true
								end
								if vv.spellId and vv.spellId == spellId and not vv.repeatable then
									vv.enabled = false
									vv.found = true
								end
							end
						end
					end
				end
			end
		end
	end

	-- Companions that this character learned
	for id = 1, GetNumCompanions("CRITTER") do
		local spellId = select(3, GetCompanionInfo("CRITTER", id))
		for k, v in pairs(R.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						if vv.spellId and vv.spellId == spellId and not vv.repeatable then
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end

	-- Battle pets across your account
	if (C_PetJournal.SetFlagFilter ~= nil) then -- Pre-7.0
		C_PetJournal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_COLLECTED, true)
		C_PetJournal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_FAVORITES, false)
		C_PetJournal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)
		C_PetJournal.AddAllPetTypesFilter()
		C_PetJournal.AddAllPetSourcesFilter()
	else -- 7.0+
		C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_COLLECTED, true)
		C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_FAVORITES, false)
		C_PetJournal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)
		C_PetJournal.SetAllPetTypesChecked(true)
		C_PetJournal.SetAllPetSourcesChecked(true)
	end
	local total, numOwnedPets = C_PetJournal.GetNumPets()
	for i = 1, total do
		local petID,
			speciesID,
			owned,
			customName,
			level,
			favorite,
			isRevoked,
			speciesName,
			icon,
			petType,
			companionID,
			tooltip,
			description,
			isWild,
			canBattle,
			isTradeable,
			isUnique,
			obtainable = C_PetJournal.GetPetInfoByIndex(i)
		Rarity.pet_sources[companionID] = tooltip
		if owned then
			for k, v in pairs(R.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							if vv.creatureId and vv.creatureId == companionID then
								vv.known = true
							end
							if vv.creatureId and vv.creatureId == companionID and not vv.repeatable then
								vv.enabled = false
								vv.found = true
							end
						end
					end
				end
			end
		end
	end

	-- Achievements
	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.achievementId and tonumber(vv.achievementId) then
						local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch =
							GetAchievementInfo(vv.achievementId)
						if Completed and not vv.repeatable then
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end

	-- Scan all archaeology races and set any item attempts to the number of solves for that race
	-- (if we've never seen attempts for the race before)
	local s = 0
	for x = 1, GetNumArchaeologyRaces() do
		local c = GetNumArtifactsByRace(x)
		local a = 0
		for y = 1, c do
			local t = select(10, GetArtifactInfoByRace(x, y))
			a = a + t
			s = s + t
		end

		for k, v in pairs(self.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						if vv.enabled ~= false then
							if vv.method == CONSTANTS.DETECTION_METHODS.ARCH and vv.raceId ~= nil then
								if vv.raceId == x then
									-- We've never seen any attempts for this race yet, so set our attempts to this character's current amount
									if a > (vv.attempts or 0) then
										vv.attempts = a
									end
								end
							end
						end
					end
				end
			end
		end
	end

	-- Scan all items for Obtained Quest IDs and mark completed if the quest is completed
	for k, v in pairs(R.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.obtainedQuestId and tonumber(vv.obtainedQuestId) then
						if IsQuestComplete(tonumber(vv.obtainedQuestId)) then
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end

	self:ProfileStop("ScanExistingItems: Mounts/Pets/Achievements/Archaeology took %fms")

	-- Other scans
	self:ScanStatistics(reason)
	self:ProfileStart2() -- Statistics does its own profiling

	Rarity.Collections:ScanToys(reason)
	self:ProfileStop2("Toys took %fms")
	self:ProfileStart2()

	Rarity.Collections:ScanTransmog(reason)
	self:ProfileStop2("Transmog took %fms")
	self:ProfileStart2()

	self:ScanCalendar(reason)
	self:ProfileStop2("Calendar took %fms")
	self:ProfileStart2()

	self:ScanInstanceLocks(reason)
	self:ProfileStop2("Instances took %fms")

	self:ProfileStop("ScanExistingItems: Total time %fms")
end

-------------------------------------------------------------------------------------
-- Archaeology detection. Basically we look to see if you spent any fragments, and rescan your projects if so.
-------------------------------------------------------------------------------------

function R:ScanAllArch(event)
	self:UnregisterEvent("RESEARCH_ARTIFACT_HISTORY_READY")
	self:ScanArchFragments(event)
	self:ScanArchProjects(event)
end

function R:ScanArchFragments(event)
	local scan = false
	if GetNumArchaeologyRaces() == 0 then
		return
	end
	for race_id = 1, GetNumArchaeologyRaces() do
		local _, _, _, currencyAmount = GetArchaeologyRaceInfo(race_id)
		local diff = currencyAmount - (archfragments[race_id] or 0)
		archfragments[race_id] = currencyAmount
		if diff < 0 then
			-- We solved an artifact. If any of our items depend on this race ID, increment their attempt count.
			for k, v in pairs(self.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							if vv.enabled ~= false then
								local found = false
								if vv.method == CONSTANTS.DETECTION_METHODS.ARCH and vv.raceId ~= nil then
									if vv.raceId == race_id then
										found = true
									end
								end
								if found then
									if vv.attempts == nil then
										vv.attempts = 1
									else
										vv.attempts = vv.attempts + 1
									end
									self:OutputAttempts(vv)
								end
							end
						end
					end
				end
			end
			scan = true
		end
	end

	-- We solved an artifact; scan projects
	if scan then
		-- Scan now, and later. The server takes a while to decide on the next project. The time it takes varies considerably.
		self:ScanArchProjects(event)
		self:ScheduleTimer(
			function()
				R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 1")
			end,
			2
		)
		self:ScheduleTimer(
			function()
				R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 2")
			end,
			5
		)
		self:ScheduleTimer(
			function()
				R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 3")
			end,
			10
		)
		self:ScheduleTimer(
			function()
				R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 4")
			end,
			20
		)
	end
end

function R:ScanArchProjects(reason)
	self:Debug("Scanning archaeology projects (%s)", reason)
	if GetNumArchaeologyRaces() == 0 then
		return
	end
	for race_id = 1, GetNumArchaeologyRaces() do
		local name = GetActiveArtifactByRace(race_id)
		if Rarity.architems[name] then
			-- We started a project we were looking for!
			local id = Rarity.architems[name].itemId
			if id then
				self:OnItemFound(id, Rarity.items[id])
			end
		end
	end
end

Rarity.Collections = Collections
return Collections
