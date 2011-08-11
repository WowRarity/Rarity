Rarity = LibStub("AceAddon-3.0"):NewAddon("Rarity", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0")
Rarity.MINOR_VERSION = tonumber(("$Revision$"):match("%d+"))
local FORCE_PROFILE_RESET_BEFORE_REVISION = 1 -- Set this to one higher than the Revision on the line above this
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local R = Rarity
local qtip = LibStub("LibQTip-1.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dbicon = LibStub("LibDBIcon-1.0")
local dataobj = ldb:NewDataObject("Rarity", {
 type = "data source",
 text = L["Loading"],
 label = "Rarity",
 tocname = "Rarity",
 icon = [[Interface\Icons\spell_nature_forceofnature]]
})
local lbz = LibStub("LibBabble-Zone-3.0"):GetLookupTable()
---


--[[
      VARIABLES ----------------------------------------------------------------------------------------------------------------
  ]]

local npcs = {}
local bosses = {}
local zones = {}
local guids = {}
local items = {}
local npcs_to_items = {}
local bagitems = {}
local tempbagitems = {}
local used = {}
local fishzones = {}
local archfragments = {}
local architems = {}

local bankOpen = false
local guildBankOpen = false
local prevSpell, curSpell, foundTarget, gatherEvents, ga
local fishSpell = (GetSpellInfo(33095))
local spells = {
	[fishSpell] = "Fishing",
}
local tooltipLeftText1 = _G["GameTooltipTextLeft1"]
local fishing = false
local fishingTimer
local FISHING_DELAY = 19

local red = { r = 1.0, g = 0.2, b = 0.2 }
local blue = { r = 0.4, g = 0.4, b = 1.0 }
local green = { r = 0.2, g = 1.0, b = 0.2 }
local yellow = { r = 1.0, g = 1.0, b = 0.2 }
local gray = { r = 0.5, g = 0.5, b = 0.5 }
local black = { r = 0.0, g = 0.0, b = 0.0 }
local white = { r = 1.0, g = 1.0, b = 1.0 }



--[[
      CONSTANTS ----------------------------------------------------------------------------------------------------------------
  ]]

-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"

-- Methods of obtaining
local NPC = "NPC"
local BOSS = "BOSS"
local ZONE = "ZONE"
local USE = "USE"
local FISHING = "FISHING"
local ARCH = "ARCH"
  


--[[
      UPVALUES -----------------------------------------------------------------------------------------------------------------
  ]]
  
local _G = getfenv(0)
local pairs = _G.pairs
local strlower = _G.strlower
local strupper = _G.strupper
local format = _G.format
local strsub = _G.strsub
local strlen = _G.strlen
local bit_band = _G.bit.band

local UnitGUID = _G.UnitGUID
local UnitName = _G.UnitName
local UnitCanAttack = _G.UnitCanAttack
local UnitIsPlayer = _G.UnitIsPlayer
local UnitIsDead = _G.UnitIsDead
local GetNumLootItems = _G.GetNumLootItems
local GetLootSlotInfo = _G.GetLootSlotInfo
local GetLootSlotLink = _G.GetLootSlotLink
local GetInstanceDifficulty = _G.GetInstanceDifficulty
local GetItemInfo = _G.GetItemInfo
local GetRealZoneText = _G.GetRealZoneText
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemID = _G.GetContainerItemID
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetNumArchaeologyRaces = _G.GetNumArchaeologyRaces
local GetArchaeologyRaceInfo = _G.GetArchaeologyRaceInfo
local SetSelectedArtifact = _G.SetSelectedArtifact
local GetSelectedArtifactInfo = _G.GetSelectedArtifactInfo

local NUM_BAG_SLOTS = _G.NUM_BAG_SLOTS
local COMBATLOG_OBJECT_AFFILIATION_MINE = _G.COMBATLOG_OBJECT_AFFILIATION_MINE
local COMBATLOG_OBJECT_AFFILIATION_PARTY = _G.COMBATLOG_OBJECT_AFFILIATION_PARTY
local COMBATLOG_OBJECT_AFFILIATION_RAID = _G.COMBATLOG_OBJECT_AFFILIATION_RAID



--[[
      LIFECYCLE ----------------------------------------------------------------------------------------------------------------
  ]]

function R:OnInitialize()
end


do
	local isInitialized = false
	
	function R:OnEnable()
		self:DoEnable()
	end
	
	function R:DoEnable()
		if isInitialized then return end

  -- If not ready to initialize, bail here

		isInitialized = true
	
		self:PrepareDefaults() -- Loads in any new items
		
		self.db = LibStub("AceDB-3.0"):New("RarityDB", self.defaults, false) -- This add-on uses character-specific profiles by default
  self:SetSinkStorage(self.db.profile)

		self:RegisterChatCommand("rarity", "ChatCommand")
		self:RegisterChatCommand("rare", "ChatCommand")
		
		dbicon:Register("Rarity", dataobj, self.db.profile.minimap)

		self:ScanExistingItems("INITIALIZING") -- Checks for items you already have
  self:ScanBags() -- Initialize our inventory list, as well as checking if you've obtained an item
		
		if self.db.profile.debugMode then
   -- Expose normally private objects publically
   R.npcs = npcs
   R.bosses = bosses
   R.zones = zones
   R.guids = guids
   R.items = items
   R.npcs_to_items = npcs_to_items
   R.used = used
   R.tempbagitems = tempbagitems
   R.bagitems = bagitems
   R.fishzones = fishzones
   R.archfragments = archfragments
   R.architems = architems
		end

  self:UpdateInterestingThings()
		
		self:UnregisterAllEvents()
  self:RegisterEvent("BAG_UPDATE", "OnEvent")
  self:RegisterEvent("LOOT_OPENED", "OnEvent")
  self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "ScanArchFragments") -- The high tech method by which we detect archaeology solves
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombat") -- Used to detect boss kills that we didn't solo
  self:RegisterEvent("BANKFRAME_OPENED", "OnEvent")
  self:RegisterEvent("BANKFRAME_CLOSED", "OnEvent")
  self:RegisterEvent("GUILDBANKFRAME_OPENED", "OnEvent")
  self:RegisterEvent("GUILDBANKFRAME_CLOSED", "OnEvent")
  self:RegisterEvent("CURSOR_UPDATE", "CursorChange") -- Fishing detection
  self:RegisterEvent("UNIT_SPELLCAST_SENT", "SpellStarted") -- Fishing detection
	 self:RegisterEvent("UNIT_SPELLCAST_STOP", "SpellStopped") -- Fishing detection
	 self:RegisterEvent("UNIT_SPELLCAST_FAILED", "SpellFailed") -- Fishing detection
	 self:RegisterEvent("UNIT_SPELLCAST_INTERRUPTED", "SpellFailed") -- Fishing detection
  self:RegisterEvent("LOOT_CLOSED", "GatherCompleted") -- Fishing detection
  self:RegisterEvent("ARTIFACT_HISTORY_READY", "ScanAllArch")

		if R.Options_DoEnable then R:Options_DoEnable() end
		self.db.profile.lastRevision = R.MINOR_VERSION

		self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")

  RequestArtifactCompletionHistory() -- Request archaeology info from the server
  self:ScheduleTimer(function() R:ScanBags() end, 10) -- Also scan bags 10 seconds after init
		
		self:Debug(L["Loaded (running in debug mode)"])
	end
end


function R:ChatCommand(input)
	if strlower(input) == "debug" then
		if self.db.profile.debugMode then
			self.db.profile.debugMode = false
			self:Print(L["Debug mode OFF"])
		else
			self.db.profile.debugMode = true
			self:Print(L["Debug mode ON"])
		end
	else
		LoadAddOn("Rarity_Options")
		if R.optionsFrame then
			InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
		else
			self:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		end
	end
end


function R:CheckForceReset(report)
	-- Require a profile reset after a hardcoded revision
	if (self.db.profile.lastRevision or 0) < FORCE_PROFILE_RESET_BEFORE_REVISION then
		self.db:RegisterDefaults(self.defaults)
		
		-- Save as many settings as we can
		local minimap = self.db.profile.minimap.hide
		
		-- Reset the profile
		self.db:ResetProfile(false, true)
		self.db.profile.lastRevision = R.MINOR_VERSION

		-- Migrate settings across
		self.db.profile.minimap.hide = minimap
		
		self:ScanExistingItems("FORCED PROFILE RESET")	
		if report or report == nil then
			self:Print(format(L["Welcome to Rarity r%d. Your settings have been reset."], R.MINOR_VERSION))
		end
	end
end


function R:OnProfileChanged(event, database, newProfileKey)
	self:Debug("Profile changed. Reinitializing.")
	self.db:RegisterDefaults(self.defaults)
	self:ScanExistingItems("PROFILE CHANGED")
	self.db.profile.lastRevision = R.MINOR_VERSION
end



--[[
      UTILITIES ----------------------------------------------------------------------------------------------------------------
  ]]

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


function round(num)
 return math.floor(num + 0.5)
end


local function colorize(s, color)
	if color and s then
		return format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
	else
		return s
	end
end


function R:Debug(s, ...)
	if self.db.profile.debugMode then self:Print(format(s, ...)) end
end


-- Prepares a set of lookup tables to let us quickly determine if we're interested in various things.
-- Many of the events we handle fire quite frequently, so speed is of the essence.
-- Any item that is not enabled for tracking won't show up in these lists.
function R:UpdateInterestingThings()
 self:Debug("Updating interesting things tables")

 table.wipe(npcs)
 table.wipe(bosses)
 table.wipe(zones)
 table.wipe(items)
 table.wipe(guids)
 table.wipe(npcs_to_items)
 table.wipe(used)
 table.wipe(fishzones)
 table.wipe(architems)

 for k, v in pairs(self.db.profile.groups) do
  if type(v) == "table" then
   for kk, vv in pairs(v) do
    if type(vv) == "table" then
     if vv.enabled ~= false then
      if vv.method == NPC and vv.npcs ~= nil and type(vv.npcs) == "table" then
       for kkk, vvv in pairs(vv.npcs) do
        npcs[vvv] = vv
        if npcs_to_items[vvv] == nil then npcs_to_items[vvv] = {} end
        table.insert(npcs_to_items[vvv], vv)
       end
      elseif vv.method == BOSS and vv.npcs ~= nil and type(vv.npcs) == "table" then
       for kkk, vvv in pairs(vv.npcs) do
        bosses[vvv] = vv
        if npcs_to_items[vvv] == nil then npcs_to_items[vvv] = {} end
        table.insert(npcs_to_items[vvv], vv)
       end
      elseif vv.method == ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
       for kkk, vvv in pairs(vv.zones) do
        zones[lbz[vvv]] = vv
        zones[vvv] = vv
       end
      elseif vv.method == USE and vv.items ~= nil and type(vv.items) == "table" then
       for kkk, vvv in pairs(vv.items) do
        used[vvv] = vv
       end
      elseif vv.method == FISHING and vv.zones ~= nil and type(vv.zones) == "table" then
       for kkk, vvv in pairs(vv.zones) do
        fishzones[lbz[vvv]] = vv
        fishzones[vvv] = vv
       end
      elseif vv.method == ARCH and vv.itemId ~= nil then
       local itemName = GetItemInfo(vv.itemId)
       if itemName then architems[itemName] = vv end
      end
      if vv.itemId ~= nil then items[vv.itemId] = vv end
      if vv.itemId2 ~= nil then items[vv.itemId2] = vv end
     end
    end
   end
  end
 end
end


function R:GetNPCIDFromGUID(guid)
	if guid then
		return (guid and tonumber(guid:sub(7, 10), 16)) or 0
	end
end


function R:IsHeroic()
	local diff = GetInstanceDifficulty()
	local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
	if isDynamic then
		if dynamicDifficulty == 1 then return true else return false end
	end
	if maxPlayers > 5 and (diff == 3 or diff == 4) then return true end
 if maxPlayers == 5 and diff == 2 then return true end
 return false
end



--[[
      OBTAIN DETECTION ---------------------------------------------------------------------------------------------------------
      -- Some easy, some fairly arcane methods to detect when we've obtained something we're looking for
  ]]

function R:OnEvent(event, ...)

 -- You opened the bank or guild bank. This turns off item use detection.
 if event == "BANKFRAME_OPENED" then
  bankOpen = true
 elseif event == "GUILDBANKFRAME_OPENED" then
  guildBankOpen = true
 elseif event == "BANKFRAME_CLOSED" then
  bankOpen = false
 elseif event == "GUILDBANKFRAME_CLOSED" then
  guildBankOpen = false


 -------------------------------------------------------------------------------------
 -- You opened a loot window on a corpse or fishing node.
 -------------------------------------------------------------------------------------
	elseif event == "LOOT_OPENED" then
  local zone = GetRealZoneText()

  -- Handle fishing
  if fishing then
   self:Debug("Successfully fished from a pool")
   if fishzones[zone] then
    -- We're interested in the fishing here, let's find the item(s) involved
    for k, v in pairs(self.db.profile.groups) do
     if type(v) == "table" then
      for kk, vv in pairs(v) do
       if type(vv) == "table" then
        if vv.enabled ~= false then
         local found = false
         if vv.method == FISHING and vv.zones ~= nil and type(vv.zones) == "table" then
          for kkk, vvv in pairs(vv.zones) do if vvv == zone or vvv == lbz[zone] then found = true end end
         end
         if found then
          if (vv.heroic == true and self:IsHeroic()) or (vv.heroic == false and not self:IsHeroic()) or vv.heroic == nil then
           if vv.attempts == nil then vv.attempts = 1 else vv.attempts = vv.attempts + 1 end
           self:OutputAttempts(vv)
          end
         end
        end
       end
      end
     end
    end
   end
  end
  if fishingTimer then self:CancelTimer(fishingTimer, true) end
  fishingTimer = nil
  fishing = false

  -- Handle normal NPC looting
		local guid = UnitGUID("target")
		local name = UnitName("target")

		if not name or not guid then return end -- No target when looting
		if not UnitCanAttack("player", "target") then return end -- You targeted something you can't attack
		if UnitIsPlayer("target") then return end -- You targetted a player
		if not UnitIsDead("target") then return end -- You're looting something that's alive. It's a little strange
  if guids[guid] then return end -- Already saw this corpse

  local npcid = self:GetNPCIDFromGUID(guid)
  if npcs[npcid] == nil then -- Not an NPC we need
   if zones[zone] == nil and zones[lbz[zone]] == nil then return end -- Not a zone we need either
  end

	 -- We're interested in this loot, process further
  guids[guid] = true
  
  -- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
  if npcs_to_items[npcid] and type(npcs_to_items[npcid]) == "table" then
   for k, v in pairs(npcs_to_items[npcid]) do
    if v.enabled ~= false and (v.method == NPC or v.method == ZONE) then
     if (v.heroic == true and self:IsHeroic()) or (v.heroic == false and not self:IsHeroic()) or v.heroic == nil then
      if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
      self:OutputAttempts(v)
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
        for kkk, vvv in pairs(vv.zones) do if vvv == zone or vvv == lbz[zone] then found = true end end
       end
       if found then
        if (vv.heroic == true and self:IsHeroic()) or (vv.heroic == false and not self:IsHeroic()) or vv.heroic == nil then
         if vv.attempts == nil then vv.attempts = 1 else vv.attempts = vv.attempts + 1 end
         self:OutputAttempts(vv)
        end
       end
      end
     end
    end
   end
  end
  
  -- Scan the loot to see if we found something we're looking for
		local numItems = GetNumLootItems()
  local slotID
		for slotID = 1, numItems, 1 do
			local _, _, qty = GetLootSlotInfo(slotID)
			if qty > 0 then -- Coins have quantity of 0, so skip those
				local itemLink = GetLootSlotLink(slotID)
				local _, itemId = strsplit(":", itemLink)
    itemId = tonumber(itemId)
    if items[itemId] ~= nil then
     self:FoundItem(itemId, items[itemId])
    end
			end
		end

  -- Update the tooltip if we're in it
  if self:InTooltip() then self:ShowTooltip() end


 -------------------------------------------------------------------------------------
 -- Something in your bags changed.
 -- This is used for a couple things. First, for boss drops that require a group, you may not have obtained the item even if it dropped from the boss.
 -- Therefore, we only say you obtained it when it appears in your inventory. Secondly, this is useful as a second line of defense in case
 -- you somehow obtain an item without us noticing it. This even fires a lot, so we need to be fast.
 --
 -- We also store how many of every item you have on you at the moment. If we notice an item decreasing in quantity, and it's something we care
 -- about, you just used an item or opened a container.
 -------------------------------------------------------------------------------------
 elseif event == "BAG_UPDATE" then
  local numSlots, id, qty, i

  -- Save a copy of your bags before this event
  table.wipe(tempbagitems)
  for k, v in pairs(bagitems) do
   tempbagitems[k] = v
  end

  -- Get a list of the items you have now, alerting if we find anything we're looking for
  self:ScanBags()

  -- Check for a decrease in quantity of any items we're watching for
  if not bankOpen and not guildBankOpen then
   for k, v in pairs(tempbagitems) do
    if (bagitems[k] and bagitems[k] < tempbagitems[k]) or not bagitems[k] then -- An inventory item went down in count or disappeared
     if used[k] then -- It's an item we care about
      local i = used[k]
      if i.attempts == nil then i.attempts = 1 else i.attempts = i.attempts + 1 end
      self:OutputAttempts(i)
     end
    end
   end
  end


 end
end


-------------------------------------------------------------------------------------
-- Scan your bags to see if you are in possession of any of the items we want. This is used for BOSS and FISHING methods,
-- and also works as a second line of defense in case other methods fail to notice the item.
-------------------------------------------------------------------------------------
function R:ScanBags()
	table.wipe(bagitems)
	for i = 0, NUM_BAG_SLOTS do
		numSlots = GetContainerNumSlots(i)
		if numSlots then
			for ii = 1, numSlots do
				id = GetContainerItemID(i, ii)
				if id then
					qty = select(2, GetContainerItemInfo(i, ii))
					if not bagitems[id] then bagitems[id] = 0 end
					bagitems[id] = bagitems[id] + qty
					if items[id] then
      -- We came into possession of an item we were looking for!
      if items[id].method ~= FISHING then -- FISHING properly increments attempts before you get the item. BOSS does not (because you don't necessarily see a loot window before you obtain the item), so we increment here.
       if items[id].attempts == nil then items[id].attempts = 0 end
       items[id].attempts = items[id].attempts + 1
      end
      self:FoundItem(id, items[id])
     end
				end
			end
		end
	end
end


-------------------------------------------------------------------------------------
-- Handle boss kills. You may not ever open a loot window on a boss, so we need to watch the combat log for it's death.
-------------------------------------------------------------------------------------
function R:OnCombat(event, timestamp, eventType, hideCaster, srcGuid, srcName, srcFlags, srcRaidFlags, dstGuid, dstName, dstFlags, dstRaidFlags, ...)
 -- This event fires tens of thousands of times per minute at peak, so we must be extremely efficient
 if eventType == "UNIT_DIED" then -- A unit died near you
  local npcid = self:GetNPCIDFromGUID(dstGuid)
  if bosses[npcid] then -- It's a boss we're interested in
   if bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) then -- You, a party member, or a raid member killed it
    if not guids[dstGuid] then
     guids[dstGuid] = true

     -- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
     if npcs_to_items[npcid] and type(npcs_to_items[npcid]) == "table" then
      for k, v in pairs(npcs_to_items[npcid]) do
       if v.enabled ~= false and v.method == BOSS then
        if (v.heroic == true and self:IsHeroic()) or (v.heroic == false and not self:IsHeroic()) or v.heroic == nil then
         if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
         self:OutputAttempts(v)
        end
       end
      end
     end

    end
   end
  end
 end

end


-------------------------------------------------------------------------------------
-- Fishing detection. It's not easy. Thanks to GatherMate2 for this code.
-------------------------------------------------------------------------------------

function R:GatherCompleted(event)
	prevSpell, curSpell = nil, nil
	foundTarget = false
end

function R:CursorChange(event)
	if foundTarget then return end
	if (MinimapCluster:IsMouseOver()) then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
end

function R:SpellStopped(event, unit)
	if unit ~= "player" then return end
	if spells[prevSpell] then
		self:GetWorldTarget()
	end
	prevSpell, curSpell = curSpell, curSpell
end

function R:SpellFailed(event, unit)
	if unit ~= "player" then return end
	prevSpell, curSpell = nil, nil
end

function R:SpellStarted(event, unit, spellcast, rank, target)
	if unit ~= "player" then return end
	foundTarget = false
	ga ="No"
	if spells[spellcast] then
		curSpell = spellcast
		prevSpell = spellcast
		self:GetWorldTarget()
	else
		prevSpell, curSpell = nil, nil
	end
end

function R:GetWorldTarget()
	if foundTarget or not spells[curSpell] then return end
	if (MinimapCluster:IsMouseOver()) then return end
	local what = tooltipLeftText1:GetText()
	if what and prevSpell and what ~= prevSpell then
  self:Debug("------YOU HAVE STARTED FISHING FROM A NODE------")
		fishing = true
  if fishingTimer then self:CancelTimer(fishingTimer, true) end
  fishingTimer = self:ScheduleTimer(function()
   R:Debug("You didn't loot anything from that fishing node. Giving up.")
   fishingTimer = nil
   fishing = false
  end, FISHING_DELAY)
		foundTarget = true
	end
end


-------------------------------------------------------------------------------------
-- Archaeology detection. Basically we look to see if you spent any fragments, and rescan your projects if so.
-------------------------------------------------------------------------------------

function R:ScanAllArch(event)
 self:UnregisterEvent("ARTIFACT_HISTORY_READY")
 self:ScanArchFragments()
 self:ScanArchProjects(event)
end

function R:ScanArchFragments()
 self:Debug("Scanning archaeology fragments")
 local scan = false
 if GetNumArchaeologyRaces() == 0 then return end
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
        if vv.method == ARCH and vv.raceId ~= nil then
         if vv.raceId == race_id then found = true end
        end
        if found then
         if vv.attempts == nil then vv.attempts = 1 else vv.attempts = vv.attempts + 1 end
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
 if scan then self:ScanArchProjects("SOLVED AN ARTIFACT") end
end

function R:ScanArchProjects(reason)
 self:Debug("Scanning archaeology projects (%s)", reason)
 if GetNumArchaeologyRaces() == 0 then return end
	for race_id = 1, GetNumArchaeologyRaces() do
	 SetSelectedArtifact(race_id)
	 local name, _, rarity, icon, spellDescription, numSockets = GetSelectedArtifactInfo()
  if architems[name] then
   -- We started a project we were looking for!
   local id = architems[name].itemId
   if id then self:FoundItem(id, items[id]) end
  end
 end
end



--[[
      DATA BROKER OBJECT AND TOOLTIP -------------------------------------------------------------------------------------------
  ]]

do
	local tooltip, tooltip2
	local frame, frame2
	local headers = {}

 function R:UpdateText()
  
 end

	function dataobj.OnEnter(self)
		frame = self
		R:ShowTooltip()
	end


	function dataobj.OnLeave(self)
	end
	
	
	function R:InTooltip()
		return qtip:IsAcquired("RarityTooltip")
	end


	function dataobj:OnClick(button)
		LoadAddOn("Rarity_Options")
		if R.optionsFrame then
			InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
		else
			R:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		end
	end
	
	
	local function showSubTooltip(cell, group, suffix)
		local self = E
		if qtip:IsAcquired("RaritySubTooltip") and tooltip2 then
			qtip:Release(tooltip2)
			tooltip2 = nil
		end
		tooltip2 = qtip:Acquire("RaritySubTooltip", 4, "LEFT")
		tooltip2:ClearAllPoints()
		tooltip2:SetClampedToScreen(true)
		if self.db.profile.subtipAnchor == 2 then
			tooltip2:SetPoint("LEFT", cell, "RIGHT", 10, 0)
		else
			tooltip2:SetPoint("RIGHT", cell, "LEFT", -10, 0)
		end
		tooltip2:AddHeader(group.name)
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		local lastCastByHeader = ""
		if self.db.profile.recentCaster ~= 1 then lastCastByHeader = colorize(L["Last Seen From"], blue) end
		tooltip2:AddLine(colorize(L["Buff/Consumable"], blue), colorize(L["Providers"], blue), lastCastByHeader)
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
		
  
  
  
  		
		if onlyItems then
			qtip:Release(tooltip2)
			tooltip2 = nil
			return
		end
		
		tooltip2:UpdateScrolling()
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
	end


 function onClickGroup(cell, group)
  if type(group) == "table" then
   if group.collapsed == true then group.collapsed = false else group.collapsed = true end
   R:ShowTooltip()
  end
 end


 function onClickGroup2(cell, group)
  if type(group) == "table" then
   if group.collapsedGroup == true then group.collapsedGroup = false else group.collapsedGroup = true end
   R:ShowTooltip()
  end
 end


 function addGroup(group, requiresGroup)
  if type(group) ~= "table" then return end
  if group.name == nil then return end

  local line
  local added = false
  for k, v in pairs(group) do
   if type(v) == "table" and v.enabled ~= false and ((requiresGroup and v.groupSize ~= nil and v.groupSize > 1) or (not requiresGroup and (v.groupSize == nil or v.groupSize <= 1))) then

    -- Header
    local groupName = group.name
    if requiresGroup then groupName = groupName..L[" (Group)"] end
		  if not headers[groupName] then
			  headers[groupName] = true
     local collapsed = group.collapsed or false
     if ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
			   line = tooltip:AddLine("|TInterface\\Buttons\\UI-PlusButton-Up:16|t", colorize(groupName, yellow))
     else
			   line = tooltip:AddLine("|TInterface\\Buttons\\UI-MinusButton-Up:16|t", colorize(groupName, yellow), colorize(L["Attempts"], yellow), colorize(L["Likelihood"], yellow), colorize(L["Time"], yellow), colorize(L["Luckiness"], yellow))
     end
     tooltip:SetLineScript(line, "OnMouseUp", requiresGroup and onClickGroup2 or onClickGroup, group)
		  end

    -- Item
    if ((not requiresGroup and group.collapsed ~= true) or (requiresGroup and group.collapsedGroup ~= true)) and v.itemId ~= nil then
     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)
     local attempts = v.attempts or 0
     local dropChance = (1.00 / (v.chance or 100))
     if v.method == BOSS and v.groupSize ~= nil and v.groupSize > 1 then dropChance = dropChance / v.groupSize end
     local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
     local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
     local lucky = L["Lucky"]
     if medianLoots < attempts then lucky = L["Unlucky"] end
     line = tooltip:AddLine("", (itemTexture and "|T"..itemTexture..":0|t " or "")..(itemLink or v.name or L["Unknown"]), attempts, format("%.2f%%", chance), "4:41", lucky)
     added = true
    end

   end
  end
  return added
 end
	 
	
	function R:ShowTooltip()
		if qtip:IsAcquired("RarityTooltip") and tooltip then
			tooltip:Clear()
		else
			tooltip = qtip:Acquire("RarityTooltip", 7, "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT", "RIGHT") -- intentionally one column more than we need to avoid text clipping
		end
		
		table.wipe(headers)
  local addedLast
		
  -- Item groups
  addedLast = addGroup(self.db.profile.groups.mounts)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.pets)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.items)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.user)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.mounts, true)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.pets, true)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.items, true)
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
  addedLast = addGroup(self.db.profile.groups.user, true)
		
		-- Hint
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Click to open options"], gray), nil, nil, 3)

		tooltip:SetAutoHideDelay(0.01, frame)
		tooltip:SmartAnchorTo(frame)
		tooltip:UpdateScrolling()
		tooltip:Show()
	end
end



--[[
      PRESENTATION -------------------------------------------------------------------------------------------------------------
  ]]

function R:ShowFoundAlert(itemId, attempts)
 --itemId = 8494 -- Hyacinth Macaw, for testing
 local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
 if itemName == nil then return end -- Server doesn't know this item, we can't award it
 if itemTexture == nil then itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]] end
	
 -- The following code is adapted from Blizzard's AchievementAlertFrame_ShowAlert function found in FrameXML\AlertFrames.lua

	if ( not AchievementFrame ) then
		AchievementFrame_LoadUI();
	end

	local frame = AchievementAlertFrame_GetAlertFrame();
	if ( not frame ) then
		-- We ran out of frames! Bail!
		return;
	end

	local frameName = frame:GetName();
	local displayName = _G[frameName.."Name"];
	local shieldPoints = _G[frameName.."ShieldPoints"];
	local shieldIcon = _G[frameName.."ShieldIcon"];
	
	displayName:SetText(itemName);
	
	frame.guildDisplay = nil;
	frame:SetHeight(88);
	local background = _G[frameName.."Background"];
	background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background");
	background:SetTexCoord(0, 0.605, 0, 0.703);
	background:SetPoint("TOPLEFT", 0, 0);
	background:SetPoint("BOTTOMRIGHT", 0, 0);
	local iconBorder = _G[frameName.."IconOverlay"];
	iconBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame");
	iconBorder:SetTexCoord(0, 0.5625, 0, 0.5625);
	iconBorder:SetPoint("CENTER", -1, 2);
	_G[frameName.."Icon"]:SetPoint("TOPLEFT", -26, 16);
	displayName:SetPoint("BOTTOMLEFT", 72, 36);
	displayName:SetPoint("BOTTOMRIGHT", -60, 36);
	_G[frameName.."Shield"]:SetPoint("TOPRIGHT", -10, -13);
	shieldPoints:SetPoint("CENTER", 7, 2);
	shieldPoints:SetVertexColor(1, 1, 1);
	shieldIcon:SetTexCoord(0, 0.5, 0, 0.45);
	local unlocked = _G[frameName.."Unlocked"];
	unlocked:SetPoint("TOP", 7, -23);
 if attempts == nil or attempts <= 0 then attempts = 1 end
 if attempts == 1 then unlocked:SetText(L["Obtained On Your First Attempt"])
 else unlocked:SetText(format(L["Obtained After %d Attempts"], attempts)) end
	_G[frameName.."GuildName"]:Hide();
	_G[frameName.."GuildBorder"]:Hide();
	_G[frameName.."GuildBanner"]:Hide();
	frame.glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow");
	frame.glow:SetTexCoord(0, 0.78125, 0, 0.66796875);
	frame.shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow");
	frame.shine:SetTexCoord(0.78125, 0.912109375, 0, 0.28125);
	frame.shine:SetPoint("BOTTOMLEFT", 0, 8);
	
	shieldIcon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]]);
	
	_G[frameName.."IconTexture"]:SetTexture(itemTexture);
	
	frame.id = 0;
	
	AlertFrame_AnimateIn(frame);
	AlertFrame_FixAnchors();

 self:ScheduleTimer(function()
  -- Put the achievement frame back to normal when we're done
	 unlocked:SetText(ACHIEVEMENT_UNLOCKED);
 end, 10)

 PlaySoundFile("Sound\\Spells\\AchievmentSound1.ogg")
end


function R:OutputAttempts(item)
 if type(item) == "table" and item.enabled ~= false and item.found ~= true and item.itemId ~= nil and item.attempts ~= nil then
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
  local s
  if item.attempts == 1 then s = format(L["%s: %d attempt"], itemLink, item.attempts)
  else s = format(L["%s: %d attempts"], itemLink, item.attempts) end
  self:Pour(s, nil, nil, nil, nil, nil, nil, nil, nil, itemTexture)
 end
 self:UpdateText()
end



--[[
      CORE FUNCTIONALITY -------------------------------------------------------------------------------------------------------
  ]]

function R:ScanExistingItems(reason)
 self:Debug("Scanning for existing items ("..reason..")")
 -- Look for mount and pet spell IDs and mark as found/disabled

 -- Scan all archaeology races and set any item attempts to the number of solves for that race
 local s = 0
 for x = 1, GetNumArchaeologyRaces() do
  local c = GetNumArtifactsByRace(x)
  local a = 0
  for y = 1, c do
   local t = select(9, GetArtifactInfoByRace(x, y))
   a = a + t
   s = s + t
  end

  for k, v in pairs(self.db.profile.groups) do
   if type(v) == "table" then
    for kk, vv in pairs(v) do
     if type(vv) == "table" then
      if vv.enabled ~= false then
       if vv.method == ARCH and vv.raceId ~= nil then
        if vv.raceId == x then vv.attempts = a end
       end
      end
     end
    end
   end
  end
 end

end


function R:FoundItem(itemId, item)
 if item.found then return end
 if (item.heroic == true and self:IsHeroic()) or (item.heroic == false and not self:IsHeroic()) or item.heroic == nil then
  self:Debug("FOUND ITEM %d!", itemId)
  if item.attempts == nil then item.attempts = 1 end
  self:ShowFoundAlert(itemId, item.attempts)
  item.enabled = false
  item.found = true
  self:UpdateInterestingThings()
  if self:InTooltip() then self:ShowTooltip() end
  self:UpdateText()
 end
end

