local _, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local R = Rarity
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
local hbd = LibStub("HereBeDragons-2.0")

---

--[[
      VARIABLES ----------------------------------------------------------------------------------------------------------------
  ]]
R.modulesEnabled = {}

local npcs = {}

Rarity.fishzones = {}
Rarity.mount_sources = {}
Rarity.pet_sources = {}
Rarity.lockouts = {}
Rarity.lockouts_detailed = {}
Rarity.lockouts_holiday = {}
Rarity.holiday_textures = {}
Rarity.ach_npcs_isKilled = {}
Rarity.ach_npcs_achId = {}
Rarity.stats_to_scan = {}
Rarity.items_with_stats = {}
Rarity.collection_items = {}
Rarity.itemInfoCache = {}

Rarity.isBankOpen = false
Rarity.isGuildBankOpen = false
Rarity.isAuctionHouseOpen = false
Rarity.isTradeWindowOpen = false
Rarity.isTradeskillOpen = false
Rarity.isMailboxOpen = false

Rarity.isFishing = false
Rarity.isOpening = false

Rarity.isPool = false

local itemCacheDebug = false

Rarity.itemsToPrime = {}
Rarity.itemsMasterList = {}
local initTimer
local numPrimeAttempts = 0

--[[
      CONSTANTS ----------------------------------------------------------------------------------------------------------------
  ]]
local CONSTANTS = addonTable.constants

-- Methods of obtaining
local NPC = "NPC"
local BOSS = "BOSS"
local ZONE = "ZONE"
local USE = "USE"
local FISHING = "FISHING"
local ARCH = "ARCH"
local SPECIAL = "SPECIAL"
local COLLECTION = "COLLECTION"

-- Sort modes
local SORT_NAME = "SORT_NAME"
local SORT_DIFFICULTY = "SORT_DIFFICULTY"
local SORT_PROGRESS = "SORT_PROGRESS"
local SORT_CATEGORY = "SORT_CATEGORY"
local SORT_ZONE = "SORT_ZONE"

Rarity.CONSTANTS = addonTable.constants

--[[
      UPVALUES -----------------------------------------------------------------------------------------------------------------
  ]]
-- Lua APIs
local _G = getfenv(0)
local pairs = _G.pairs
local strlower = _G.strlower
local format = _G.format
local min = min
local tostring = tostring

-- WOW APIs
local UnitGUID = _G.UnitGUID
local UnitName = _G.UnitName
local UnitCanAttack = _G.UnitCanAttack
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsDead = _G.UnitIsDead
local GetNumLootItems = _G.GetNumLootItems
local GetLootSlotInfo = _G.GetLootSlotInfo
local GetLootSlotLink = _G.GetLootSlotLink
local GetItemInfo_Blizzard = _G.GetItemInfo
local GetItemInfo = function(id)
	return R:GetItemInfo(id)
end
local GetRealZoneText = _G.GetRealZoneText
local GetContainerNumSlots = _G.C_Container.GetContainerNumSlots
local GetContainerItemID = _G.C_Container.GetContainerItemID
local GetContainerItemInfo = _G.C_Container.GetContainerItemInfo
local GetNumArchaeologyRaces = _G.GetNumArchaeologyRaces
local GetArchaeologyRaceInfo = _G.GetArchaeologyRaceInfo
local GetStatistic = _G.GetStatistic
local GetLootSourceInfo = _G.GetLootSourceInfo
local GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local GetMapInfo = _G.C_Map.GetMapInfo
local C_Timer = _G.C_Timer
local IsSpellKnown = _G.IsSpellKnown
local CombatLogGetCurrentEventInfo = _G.CombatLogGetCurrentEventInfo
local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted
local C_Covenants = _G.C_Covenants

local COMBATLOG_OBJECT_AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = _G.COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = _G.COMBATLOG_OBJECT_AFFILIATION_RAID

-- Addon APIs
local DebugCache = Rarity.Utils.DebugCache
local GetRealDropPercentage = Rarity.Statistics.GetRealDropPercentage
local FormatTime = Rarity.Utils.PrettyPrint.FormatTime
local GetDate = Rarity.Utils.Time.GetDate

do
	-- Set up the debug cache (TODO: Move to initialisation routine after the refactoring is complete)
	Rarity.Utils.DebugCache:SetOutputHandler(Rarity.Utils.PrettyPrint.DebugMsg)
	function Rarity:Error(message, ...)
		if R.db.profile.disableCustomErrors then
			return
		end
		Rarity.Utils.PrettyPrint.Error(message, ...)
	end
end

local GetMapNameByID = Rarity.MapInfo.GetMapNameByID

--[[
      LIFECYCLE ----------------------------------------------------------------------------------------------------------------
  ]]
function R:OnInitialize() end

local Output = Rarity.Output

do
	local isInitialized = false

	function R:OnEnable()
		self:DoEnable()
	end

	function R:DoEnable()
		if isInitialized then
			return
		end
		isInitialized = true

		self:PrepareDefaults() -- Loads in any new items

		self.db = LibStub("AceDB-3.0"):New("RarityDB", self.defaults, true)
		Output:Setup()

		self:RegisterChatCommand("rarity", "OnChatCommand")
		self:RegisterChatCommand("rare", "OnChatCommand")

		-- Register keybind(s): These must match the info from Bindings.xml (and use localized descriptions)
		_G.BINDING_HEADER_Rarity = "Rarity"
		_G.BINDING_NAME_RARITY_DEBUGWINDOWTOGGLE = L["Toggle Debug Window"]

		Rarity.GUI:RegisterDataBroker()

		-- Expose private objects
		R.npcs = npcs

		Rarity.GUI:InitialiseBar()

		Rarity.Collections:ScanExistingItems("INITIALIZING") -- Checks for items you already have
		self:ScanBags() -- Initialize our inventory list, as well as checking if you've obtained an item
		self:OnBagUpdate() -- This will update counters for collection items
		self:OnCurrencyUpdate("INITIALIZING") -- Prepare our currency list
		self:UpdateInterestingThings()
		Rarity.Tracking:FindTrackedItem()
		Rarity.Caching:SetReadyState(false)
		Rarity.GUI:UpdateText()
		Rarity.Caching:SetReadyState(true)
		Rarity.GUI:UpdateText()
		Rarity.GUI:UpdateBar()

		Rarity.Serialization:ImportFromBunnyHunter()

		Rarity.EventHandlers:Register()

		if R.Options_DoEnable then
			R:Options_DoEnable()
		end
		self.db.profile.lastRevision = R.MINOR_VERSION

		self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")

		self:ScanAllArch("DoEnable")
		RequestRaidInfo() -- Request raid lock info from the server
		RequestLFDPlayerLockInfo() -- Request LFD data from the server; this is used for holiday boss detection
		C_Calendar.OpenCalendar() -- Request calendar info from the server

		-- Prepare a master list of all the items Rarity may need info for
		table.wipe(R.itemsMasterList)
		Rarity.Caching:SetPrimedItems(0)
		Rarity.Caching:SetItemsToPrime(0)
		for k, v in pairs(self.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						if vv.itemId then
							R.itemsMasterList[vv.itemId] = true
						end
						if vv.collectedItemId then
							if type(vv.collectedItemId) == "table" then
								for kkk, vvv in pairs(vv.collectedItemId) do
									R.itemsMasterList[vvv] = true
								end
							else
								R.itemsMasterList[vv.collectedItemId] = true
							end
						end
						if vv.items and type(vv.items) == "table" then
							for kkk, vvv in pairs(vv.items) do
								R.itemsMasterList[vvv] = true
							end
						end
					end
				end
			end
		end
		for k, v in pairs(self.db.profile.oneTimeItems) do
			if type(v) == "table" and v.itemId then
				R.itemsMasterList[v.itemId] = true
			end
		end
		for k, v in pairs(self.db.profile.extraTooltips.inventoryItems) do
			for kk, vv in pairs(v) do
				R.itemsMasterList[vv] = true
			end
		end
		local temp = {}
		for k, v in pairs(R.itemsMasterList) do
			Rarity.Caching:SetItemsToPrime(Rarity.Caching:GetItemsToPrime() + 1)
			temp[Rarity.Caching:GetItemsToPrime()] = k
		end
		R.itemsMasterList = temp

		-- Progressively prime our item cache over time instead of hitting Blizzard's API all at once
		Rarity.Caching:SetItemsToPrime(100) -- Just setting this temporarily to avoid a divide by zero
		self:ScheduleTimer(function()
			self:PrimeItemCache()
		end, 2)

		-- Scan instance locks 5 seconds after init
		self:ScheduleTimer(function()
			R:ScanInstanceLocks("DELAYED INIT")
		end, 5)

		-- Scan bags, currency, and instance locks 10 seconds after init
		self:ScheduleTimer(function()
			R:ScanBags()
			R:OnCurrencyUpdate("DELAYED INIT")
			R:OnBagUpdate()
			R:ScanInstanceLocks("DELAYED INIT 2")
		end, 10)

		-- Clean up session info
		for k, v in pairs(self.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						vv.session = nil
					end
				end
			end
		end

		-- Delayed calendar init a few times
		self:ScheduleTimer(function()
			if type(CalendarFrame) ~= "table" or not CalendarFrame:IsShown() then
				local CalendarTime = C_DateAndTime.GetCurrentCalendarTime()
				local month, year = CalendarTime.month, CalendarTime.year
				C_Calendar.SetAbsMonth(month, year)
			end
		end, 7)
		self:ScheduleTimer(function()
			if type(CalendarFrame) ~= "table" or not CalendarFrame:IsShown() then
				local CalendarTime = C_DateAndTime.GetCurrentCalendarTime()
				local month, year = CalendarTime.month, CalendarTime.year
				C_Calendar.SetAbsMonth(month, year)
			end
		end, 20)

		-- Update text again several times later - this helps get the icon right after login
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 10)
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 20)
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 30)
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 60)
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 120)
		self:ScheduleTimer(function()
			R:DelayedInit()
		end, 180)
		self:ScheduleTimer(function()
			self:ScanCalendar("FINAL INIT")
			Rarity.Collections:ScanExistingItems("FINAL INIT")
			Rarity.GUI:UpdateText()
		end, 240)

		self:Debug(L["Loaded (running in debug mode)"])

		if self.db.profile.verifyDatabaseOnLogin then
			self.Validation:ValidateItemDB()
		end
	end
end

function R:DelayedInit()
	self:ScanStatistics("DELAYED INIT")
	self:ScanCalendar("DELAYED INIT")
	Rarity.Collections:ScanToys("DELAYED INIT")
	Rarity.Collections:ScanTransmog("DELAYED INIT")
	Rarity.GUI:UpdateText()
	Rarity.GUI:UpdateBar()
end

function R:PrimeItemCache()
	numPrimeAttempts = numPrimeAttempts + 1
	if numPrimeAttempts >= 20 then
		self:Debug("Maximum number of cache prime attempts reached")
		return
	end

	-- This doesn't always fully work, so first build a list of which items we still need to obtain
	Rarity.Caching:SetItemsToPrime(1)
	Rarity.Caching:SetPrimedItems(0)
	table.wipe(R.itemsToPrime)
	for k, v in pairs(R.itemsMasterList) do
		if R.itemInfoCache[v] == nil then
			R.itemsToPrime[Rarity.Caching:GetItemsToPrime()] = v
			Rarity.Caching:SetItemsToPrime(Rarity.Caching:GetItemsToPrime() + 1)
		end
	end
	Rarity.Caching:SetItemsToPrime(Rarity.Caching:GetItemsToPrime() - 1)
	if Rarity.Caching:GetItemsToPrime() <= 0 then
		return
	end

	-- Prime the items
	self:Debug("Loading " .. Rarity.Caching:GetItemsToPrime() .. " item(s) from server...")
	initTimer = self:ScheduleRepeatingTimer(function()
		if Rarity.Caching:GetPrimedItems() <= 0 then
			Rarity.Caching:SetPrimedItems(1)
		end
		for i = 1, 10 do
			GetItemInfo(R.itemsToPrime[Rarity.Caching:GetPrimedItems()])
			Rarity.Caching:SetPrimedItems(Rarity.Caching:GetPrimedItems() + 1)
			if Rarity.Caching:GetPrimedItems() > Rarity.Caching:GetItemsToPrime() then
				break
			end
		end
		if Rarity.Caching:GetPrimedItems() >= Rarity.Caching:GetItemsToPrime() then
			self:CancelTimer(initTimer)
			-- First-time initialization finished
			if not Rarity.Caching:IsReady() then
				Rarity.Caching:SetReadyState(false)
				-- Trigger holiday reminders
				self:ScheduleTimer(function()
					Rarity:ShowTooltip(true)
				end, 5)
			end
			-- Check how many items were not processed, rescanning if necessary
			local got = 0
			local totalNeeded = 0
			for k, v in pairs(R.itemInfoCache) do
				got = got + 1
			end
			for k, v in pairs(R.itemsMasterList) do
				totalNeeded = totalNeeded + 1
			end
			if got < totalNeeded then
				self:Debug("Initialization failed to retrieve " .. (totalNeeded - got) .. " item(s)")
				self:ScheduleTimer(function()
					self:PrimeItemCache()
				end, 5)
			else
				self:Debug("Finished loading " .. Rarity.Caching:GetItemsToPrime() .. " item(s) from server")
			end
		end
		Rarity.GUI:UpdateText()
	end, 0.1)
end

--[[
      UTILITIES ----------------------------------------------------------------------------------------------------------------
  ]]
-- Item cache
function R:GetItemInfo(id)
	if id == nil then
		return
	end
	if R.itemInfoCache[id] ~= nil then
		return unpack(R.itemInfoCache[id])
	end
	if itemCacheDebug and Rarity.Caching:IsReady() == false then
		R:Debug("ItemInfo not cached for " .. id)
	end
	local info = { GetItemInfo_Blizzard(id) }
	if #info > 0 then
		R.itemInfoCache[id] = info
	end
	if R.itemInfoCache[id] == nil then
		return nil
	end
	return unpack(R.itemInfoCache[id])
end

-- Miscellaneous
function R:tcopy(to, from)
	for k, v in pairs(from) do
		if type(v) == "table" then
			to[k] = {}
			R:tcopy(to[k], v)
		else
			to[k] = v
		end
	end
end

-- Location/Distance/Zone
function R:GetDistanceToItem(item)
	local distance = 999999999
	if item and type(item) == "table" and item.coords and type(item.coords) == "table" then
		local playerWorldX, playerWorldY, instance = hbd:GetPlayerWorldPosition()
		for k, v in pairs(item.coords) do
			if v and type(v) == "table" and v.m and v.i ~= true then
				local map = v.m
				local x = (v.x or 50) / 100
				local y = (v.y or 50) / 100
				local itemWorldX, itemWorldY = hbd:GetWorldCoordinatesFromZone(x, y, map, v.f or 1)
				if itemWorldX ~= nil then -- Library returns nil for instances
					local thisDistance =
						hbd:GetWorldDistance(instance, itemWorldX, itemWorldY, playerWorldX, playerWorldY)
					-- R:Print("map: "..map..", x: "..x..", y: "..y..", itemWorldX: "..itemWorldX..", itemWorldY: "..itemWorldY..", playerWorldX: "..playerWorldX..", playerWorldY: "..playerWorldY..", thisDistance: "..thisDistance)
					if thisDistance < distance then
						distance = thisDistance
					end
				end
			end
		end
	end
	if distance ~= 999999999 then
		return distance
	end
	return nil
end

-- Prepares a set of lookup tables to let us quickly determine if we're interested in various things.
-- Many of the events we handle fire quite frequently, so speed is of the essence.
-- Any item that is not enabled for tracking won't show up in these lists.
function R:UpdateInterestingThings()
	self:Debug("Updating interesting things tables")

	-- Store an internal table listing every MapID
	if self.db.profile.mapIds == nil then
		self.db.profile.mapIds = {}
	else
		table.wipe(self.db.profile.mapIds)
	end
	for map_id = 1, 5000 do -- 5000 seems arbitrarily high; right now (8.0.1) there are barely 100 uiMapIDs... but it shouldn't matter if the misses are skipped
		if GetMapNameByID(map_id) ~= nil then
			self.db.profile.mapIds[map_id] = GetMapNameByID(map_id)
		end
	end

	table.wipe(npcs)
	table.wipe(Rarity.bosses)
	table.wipe(Rarity.zones)
	table.wipe(Rarity.items)
	table.wipe(Rarity.guids)
	table.wipe(Rarity.npcs_to_items)
	table.wipe(Rarity.items_to_items)
	table.wipe(Rarity.used)
	table.wipe(Rarity.fishzones)
	table.wipe(Rarity.architems)
	table.wipe(Rarity.stats_to_scan)
	table.wipe(Rarity.items_with_stats)
	table.wipe(Rarity.collection_items)

	for k, v in pairs(self.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.enabled ~= false and vv.statisticId and type(vv.statisticId) == "table" then
						local numStats = 0
						for kkk, vvv in pairs(vv.statisticId) do
							Rarity.stats_to_scan[vvv] = vv
							numStats = numStats + 1
						end
						if numStats > 0 then
							Rarity.items_with_stats[kk] = vv
						end
					end
					if vv.method == NPC and vv.npcs ~= nil and type(vv.npcs) == "table" then
						for kkk, vvv in pairs(vv.npcs) do
							npcs[vvv] = vv
							if Rarity.npcs_to_items[vvv] == nil then
								Rarity.npcs_to_items[vvv] = {}
							end
							table.insert(Rarity.npcs_to_items[vvv], vv)
						end
					elseif vv.method == BOSS and vv.npcs ~= nil and type(vv.npcs) == "table" then
						for kkk, vvv in pairs(vv.npcs) do
							Rarity.bosses[vvv] = vv
							if Rarity.npcs_to_items[vvv] == nil then
								Rarity.npcs_to_items[vvv] = {}
							end
							table.insert(Rarity.npcs_to_items[vvv], vv)
						end
					elseif vv.method == ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
						for kkk, vvv in pairs(vv.zones) do
							if lbz[vvv] then
								Rarity.zones[lbz[vvv]] = vv
							end
							if lbsz[vvv] then
								Rarity.zones[lbsz[vvv]] = vv
							end
							Rarity.zones[vvv] = vv
						end
					elseif vv.method == USE and vv.items ~= nil and type(vv.items) == "table" then
						for kkk, vvv in pairs(vv.items) do
							Rarity.used[vvv] = vv
							if Rarity.items_to_items[vvv] == nil then
								Rarity.items_to_items[vvv] = {}
							end
							table.insert(Rarity.items_to_items[vvv], vv)
						end
					elseif vv.method == FISHING and vv.zones ~= nil and type(vv.zones) == "table" then
						for kkk, vvv in pairs(vv.zones) do
							if lbz[vvv] then
								Rarity.fishzones[lbz[vvv]] = vv
							end
							if lbsz[vvv] then
								Rarity.fishzones[lbsz[vvv]] = vv
							end
							Rarity.fishzones[vvv] = vv
						end
					elseif vv.method == ARCH and vv.itemId ~= nil then
						local itemName = GetItemInfo(vv.itemId)
						if itemName then
							Rarity.architems[itemName] = vv
						end
					end
					if vv.itemId ~= nil and vv.method ~= COLLECTION then
						Rarity.items[vv.itemId] = vv
					end
					if vv.itemId2 ~= nil and vv.method ~= COLLECTION then
						Rarity.items[vv.itemId2] = vv
					end
					if vv.method == COLLECTION and vv.collectedItemId ~= nil then
						if type(vv.collectedItemId) == "table" then
							for kkk, vvv in pairs(vv.collectedItemId) do
								local itemID = tonumber(vvv) -- It's stored as a list of strings, but we use numbers for indices
								Rarity.items[itemID] = vv
							end
						else
							Rarity.items[vv.collectedItemId] = vv
						end
						table.insert(Rarity.collection_items, vv)
					end

					if vv.tooltipNpcs and type(vv.tooltipNpcs) == "table" then -- Item has tooltipNpcs -> Check if they should be displayed
						local showTooltipNpcs = true -- If no filters exist, always show the tooltip for relevant NPCs

						if
							vv.showTooltipCondition
							and type(vv.showTooltipCondition) == "table" -- This item has filter conditions to help decide when the tooltipNpcs should be added
							and vv.showTooltipCondition.filter
							and type(vv.showTooltipCondition.filter) == "function"
							and vv.showTooltipCondition.value
						then -- Filter has the correct format and can be applied -- Check filter conditions to see if tooltipNpcs should be added
							showTooltipNpcs = false -- Hide the additional tooltip info by default (filters will overwrite this if they can find a match, below)

							-- Each filter requires separate handling here
							if vv.showTooltipCondition.filter == IsSpellKnown then -- Filter if a (relevant) spell with the given name is not known
								for spellID, spellName in pairs(Rarity.relevantSpells) do -- Try to find any match for the given spell (a single one will do)
									if spellName == vv.showTooltipCondition.value then -- The value is a relevant spell -> Check if filter condition is true
										--	Player hasn't learned the required spell -> Stop trying to find other matches and turn off the filter
										showTooltipNpcs = IsSpellKnown(spellID)
										if showTooltipNpcs then
											break
										end -- No point in checking the other spells; A single match is enough to decide to not filter them
									end
								end
							end

							-- There aren't any other Filter types at the moment... but there could be!
						end

						-- Check for post-processing via tooltip modifiers (additional logic contained in a database entry that requires special handling)
						-- This has to run last, as it is intended to update things on the fly where a filter isn't sufficient
						local tooltipModifier = vv.tooltipModifier

						if
							tooltipModifier ~= nil
							and type(tooltipModifier) == "table"
							and tooltipModifier.condition ~= nil
							and tooltipModifier.value ~= nil
						then -- Apply modifications where necessary
							local shouldApplyModification = type(tooltipModifier.condition) == "function"
								and tooltipModifier.condition()
							if
								shouldApplyModification
								and tooltipModifier.action
								and type(tooltipModifier.action) == "function"
							then -- Apply this action to the entry
								vv = tooltipModifier.action(vv, tooltipModifier.value) -- A tooltip modifier always returns the (modified) database entry to keep processing separate
							end
						end

						-- Add entries to the list of relevant NPCs for this item
						if showTooltipNpcs then
							for kkk, vvv in pairs(vv.tooltipNpcs) do
								if Rarity.npcs_to_items[vvv] == nil then
									Rarity.npcs_to_items[vvv] = {}
								end
								table.insert(Rarity.npcs_to_items[vvv], vv)
							end
						end
					end
				end
			end
		end
	end
end

function R:GetNPCIDFromGUID(guid)
	if guid then
		local unit_type, _, _, _, _, mob_id = strsplit("-", guid)
		if unit_type == "Pet" or unit_type == "Player" then
			return 0
		end
		return (guid and mob_id and tonumber(mob_id)) or 0
	end
	return 0
end

function R:IsAttemptAllowed(item)
	-- No item supplied; assume it's okay
	if item == nil then
		return true
	end

	-- Check disabled classes
	local playerClass = select(2, UnitClass("player"))
	if item.disableForClass and item.disableForClass[playerClass] then
		Rarity:Debug(format("Attempts for item %s are disallowed (disabled for class %s)", item.name, playerClass))
		return false
	end

	local dungeonID = select(10, GetInstanceInfo())
	if dungeonID and item.requiredDungeons and not item.requiredDungeons[dungeonID] then
		Rarity:Debug(format("Attempts for item %s are disallowed (not a required dungeon: %d)", item.name, dungeonID))
		return false
	end

	local activeCovenantID = C_Covenants.GetActiveCovenantID()
	if item.requiresCovenant and item.requiredCovenantID and activeCovenantID ~= item.requiredCovenantID then
		local activeCovenantData = C_Covenants.GetCovenantData(activeCovenantID)
		local requiredCovenantData = C_Covenants.GetCovenantData(item.requiredCovenantID)

		if not activeCovenantData then
			Rarity:Debug(
				format(
					"Attempts for item %s are disallowed (Covenant %d/%s is required, but none is currently active)",
					item.name,
					item.requiredCovenantID,
					requiredCovenantData.name
				)
			)
			return false
		end

		Rarity:Debug(
			format(
				"Attempts for item %s are disallowed (Covenant %d/%s is required, but active covenant is %d/%s)",
				item.name,
				item.requiredCovenantID,
				requiredCovenantData.name,
				activeCovenantID,
				activeCovenantData.name
			)
		)
		return false
	end

	-- If any prerequisite quests exist, check if they are all completed
	if item.requiresCompletedQuestId and type(item.requiresCompletedQuestId) == "table" then
		for key, questId in pairs(item.requiresCompletedQuestId) do
			if not IsQuestFlaggedCompleted(questId) then
				return false
			end
		end
	end

	if item.requiredAreaPOIs and not Rarity.AreaPOIs.HasActiveAreaPOIs(item.requiredAreaPOIs) then
		Rarity:Debug(format("Attempts for item %s are disallowed (requires active area POIs)", item.name))
		return false
	end

	-- No valid instance difficulty configuration; allow (this needs to be the second-to-last check)
	if
		item.instanceDifficulties == nil
		or type(item.instanceDifficulties) ~= "table"
		or next(item.instanceDifficulties) == nil
	then
		return true
	end

	-- Check instance difficulty (this needs to be the last check)
	local foundTrue = false
	for k, v in pairs(item.instanceDifficulties) do
		if v == true then
			foundTrue = true
		end
	end
	if foundTrue == false then
		return true
	end
	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize =
		GetInstanceInfo()
	if item.instanceDifficulties[difficulty] and item.instanceDifficulties[difficulty] == true then
		return true
	end
	return false
end

function R:CheckNpcInterest(guid, zone, subzone, zone_t, subzone_t, curSpell, requiresPickpocket)
	if guid == nil then
		return
	end
	if type(guid) ~= "string" then
		return
	end
	if Rarity.guids[guid] ~= nil then
		return
	end -- Already seen this NPC

	local npcid = self:GetNPCIDFromGUID(guid)
	if npcs[npcid] == nil then -- Not an NPC we need, abort
		self:Debug("NPC ID not on the list of needed NPCs: " .. (npcid or "nil"))

		if
			Rarity.zones[tostring(GetBestMapForUnit("player"))] == nil
			and Rarity.zones[zone] == nil
			and Rarity.zones[lbz[zone] or "."] == nil
			and Rarity.zones[lbsz[subzone] or "."] == nil
			and Rarity.zones[zone_t] == nil
			and Rarity.zones[subzone_t] == nil
			and Rarity.zones[lbz[zone_t] or "."] == nil
			and Rarity.zones[lbsz[subzone_t] or "."] == nil
		then -- Not a zone we need, abort
			self:Debug("Map ID not on the list of needed zones: " .. tostring(GetBestMapForUnit("player")))
			return
		end
	else
		self:Debug("NPC ID is one we need: " .. (npcid or "nil"))
	end

	-- If the loot is the result of certain spell casts (mining, herbing, opening, pick lock, archaeology, disenchanting, etc), stop here -> This is to avoid multiple attempts, since those methods are handled separately!
	if Rarity.relevantSpells[curSpell] then
		self:Debug("Aborting because we were casting a disallowed spell: " .. curSpell)
		return
	end

	-- If the loot is not from an NPC (could be from yourself or a world object), we don't want to process this
	local unitType, _, _, _, _, mob_id = strsplit("-", guid)
	if unitType ~= "Creature" and unitType ~= "Vehicle" then
		self:Debug(
			"This loot isn't from an NPC; disregarding. Loot source identified as unit type: " .. (unitType or "nil")
		)
		return
	end

	Rarity.guids[guid] = true

	-- Increment attempt counter(s). One NPC might drop multiple things we want, so scan for them all.
	if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
		for k, v in pairs(Rarity.npcs_to_items[npcid]) do
			if v.enabled ~= false and (v.method == NPC or v.method == ZONE) then
				if self:IsAttemptAllowed(v) then
					-- Don't increment attempts if this NPC also has a statistic defined. This would result in two attempts counting instead of one.
					if not v.statisticId or type(v.statisticId) ~= "table" or #v.statisticId <= 0 then
						-- Don't increment attempts for unique items if you already have the item in your bags
						if not (v.unique == true and (Rarity.bagitems[v.itemId] or 0) > 0) then
							-- Don't increment attempts for non-pickpocketed items if this item isn't being pickpocketed
							if
								(requiresPickpocket and v.pickpocket)
								or (requiresPickpocket == false and not v.pickpocket)
							then
								if v.attempts == nil then
									v.attempts = 1
								else
									v.attempts = v.attempts + 1
								end
								self:OutputAttempts(v)
							end
						end
					end
				end
			end
		end
	end

	-- Check for zone-wide items and increment them if needed
	for k, v in pairs(self.db.profile.groups) do
		if type(v) == "table" then
			for kk, vv in pairs(v) do
				if type(vv) == "table" then
					if vv.enabled ~= false then
						local found = false
						if vv.method == ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
							for kkk, vvv in pairs(vv.zones) do
								if tonumber(vvv) ~= nil and tonumber(vvv) == GetBestMapForUnit("player") then
									found = true
								end
								if
									vvv == zone
									or vvv == lbz[zone]
									or vvv == subzone
									or vvv == lbsz[subzone]
									or vvv == zone_t
									or vvv == subzone_t
									or vvv == lbz[zone_t]
									or vvv == subzone
									or vvv == lbsz[subzone_t]
								then
									found = true
								end
							end
						end
						if found then
							if self:IsAttemptAllowed(vv) then
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
	end
end

--[[
      CORE FUNCTIONALITY -------------------------------------------------------------------------------------------------------
  ]]
function R:Update(reason)
	Rarity.Collections:ScanExistingItems(reason)
	self:UpdateInterestingThings(reason)
	Rarity.Tracking:FindTrackedItem()
	Rarity.GUI:UpdateText()
	-- if self:InTooltip() then self:ShowTooltip() end
end
