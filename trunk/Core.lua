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
local auctionOpen = false
local tradeOpen = false
local tradeSkillOpen = false

local prevSpell, curSpell, foundTarget, gatherEvents, ga
local fishSpell = (GetSpellInfo(33095))
local spells = {
	[fishSpell] = "Fishing",
}
local tooltipLeftText1 = _G["GameTooltipTextLeft1"]
local fishing = false
local fishingTimer
local FISHING_DELAY = 19
local trackedItem

local inSession = false
local sessionStarted = 0
local sessionLast = 0
local SESSION_LENGTH = 60 * 5 -- 5 minutes
local sessionTimer

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

		self:ScanExistingItems("INITIALIZING") -- Checks for items you already have
  self:ScanBags() -- Initialize our inventory list, as well as checking if you've obtained an item
  self:UpdateInterestingThings()
  self:FindTrackedItem()
  self:UpdateText()
		
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
  self:RegisterEvent("PLAYER_LOGOUT", "OnEvent")
  self:RegisterEvent("AUCTION_HOUSE_CLOSED", "OnEvent")
  self:RegisterEvent("AUCTION_HOUSE_SHOW", "OnEvent")
  self:RegisterEvent("TRADE_CLOSED", "OnEvent")
  self:RegisterEvent("TRADE_SHOW", "OnEvent")
  self:RegisterEvent("TRADE_SKILL_SHOW", "OnEvent")
  self:RegisterEvent("TRADE_SKILL_CLOSE", "OnEvent")

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
 inSession = false
 if sessionTimer then self:CancelTimer(sessionTimer, true) end
 sessionTimer = nil
	self.db:RegisterDefaults(self.defaults)
 self:UpdateInterestingThings()
 self:ScanAllArch(event)
	self:ScanExistingItems(event)
 self:ScanBags()
 self:FindTrackedItem()
 self:UpdateText()
 if self:InTooltip() then self:ShowTooltip() end
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


function R:IsRaid25()
	local name, type, difficultyIndex, difficultyName, maxPlayers, dynamicDifficulty, isDynamic = GetInstanceInfo()
 if maxPlayers == 25 then return true end
 return false
end


function R:IsHorde()
 local _, r = UnitRace("player")
 if r == "Tauren" or r == "Orc" or r == "Troll" or r == "Scourge" or r == "Blood Elf" or r == "Undead" or r == "Goblin" then return true end
 return false
end


function R:FormatTime(t)
	if t == 0 then
		return "0:00"
	end

	local h = math.floor(t / (60 * 60))
	t = t - (60 * 60 * h)
	local m = math.floor(t / 60)
	t = t - (60 * m)
	local s = t

	if h > 0 then
		return format("%d:%02d:%02d", h, m, s)
	end

	if m > 0 then
		return format("%d:%02d", m, s)
	end

	return format("%d", s).."s"
end



--[[
      OBTAIN DETECTION ---------------------------------------------------------------------------------------------------------
      -- Some easy, some fairly arcane methods to detect when we've obtained something we're looking for
  ]]

function R:OnEvent(event, ...)

 -------------------------------------------------------------------------------------
 -- You opened a loot window on a corpse or fishing node.
 -------------------------------------------------------------------------------------
	if event == "LOOT_OPENED" then
  local zone = GetRealZoneText()

  -- Handle fishing
  if fishing then
   self:Debug("Successfully fished from a pool")
   if fishzones[zone] then
    -- We're interested in fishing in this zone; let's find the item(s) involved
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
  if npcs[npcid] == nil then -- Not an NPC we need, abort
   if zones[zone] == nil and zones[lbz[zone]] == nil then return end -- Not a zone we need either, abort
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
  if not bankOpen and not guildBankOpen and not auctionOpen and not tradeOpen and not tradeSkillOpen then
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


 -- Detect bank, guild bank, auction house, tradeskill, and trade. This turns off item use detection.
 elseif event == "BANKFRAME_OPENED" then
  bankOpen = true
 elseif event == "GUILDBANKFRAME_OPENED" then
  guildBankOpen = true
 elseif event == "AUCTION_HOUSE_SHOW" then
  auctionOpen = true
 elseif event == "TRADE_SHOW" then
  tradeOpen = true
 elseif event == "TRADE_SKILL_SHOW" then
  tradeSkillOpen = true

 elseif event == "BANKFRAME_CLOSED" then
  bankOpen = false
 elseif event == "GUILDBANKFRAME_CLOSED" then
  guildBankOpen = false
 elseif event == "AUCTION_HOUSE_CLOSED" then
  auctionOpen = false
 elseif event == "TRADE_CLOSED" then
  tradeOpen = false
 elseif event == "TRADE_SKILL_CLOSE" then
  tradeSkillOpen = false

 -- Logging out; end any open session
 elseif event == "PLAYER_LOGOUT" then
  if inSession then self:EndSession() end


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
      if not items[id].repeatable and not items[id].found and items[id].enabled then -- Only support bag scans for non-repeatable items
       if items[id].attempts == nil then items[id].attempts = 0 end
       items[id].attempts = items[id].attempts + 1
       self:OutputAttempts(items[id])
       self:FoundItem(id, items[id])
      end
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
         if (v.raid25 and self:IsRaid25()) or not v.raid25 then
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
  if not trackedItem or (trackedItem and not trackedItem.itemId) then
   dataobj.text = L["None"]
   return
  end
  itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem.itemId)
  if not itemTexture then dataobj.icon = [[Interface\Icons\spell_nature_forceofnature]]
  else dataobj.icon = itemTexture end
  local attempts = 0
  if trackedItem.attempts then attempts = trackedItem.attempts end
  if trackedItem.lastAttempts then attempts = attempts - trackedItem.lastAttempts end
  if trackedItem.realAttempts and trackedItem.found then attempts = trackedItem.realAttempts end
  if trackedItem.found then
   if attempts == 1 then dataobj.text = format(L["Found on your first attempt!"], attempts)
   else dataobj.text = format(L["Found after %d attempts!"], attempts) end
  else
   local dropChance = (1.00 / (trackedItem.chance or 100))
   if trackedItem.method == BOSS and trackedItem.groupSize ~= nil and trackedItem.groupSize > 1 and not trackedItem.equalOdds then dropChance = dropChance / trackedItem.groupSize end
   local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
   if attempts == 1 then dataobj.text = format(L["%d attempt - %.2f%%"], attempts, chance)
   else dataobj.text = format(L["%d attempts - %.2f%%"], attempts, chance) end
  end
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
	
	
	local function showSubTooltip(cell, item)
  if not item or not item.itemId then return end
		local self = R
		if qtip:IsAcquired("RaritySubTooltip") and tooltip2 then
			qtip:Release(tooltip2)
			tooltip2 = nil
		end
		tooltip2 = qtip:Acquire("RaritySubTooltip", 3, "LEFT", "RIGHT")
		tooltip2:ClearAllPoints()
		tooltip2:SetClampedToScreen(true)
		tooltip2:SetPoint("LEFT", cell, "RIGHT", 10, 0) -- Right side
		--tooltip2:SetPoint("RIGHT", cell, "LEFT", -10, 0) -- Left side

  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)

  -- Item's game tooltip
  if itemName then
   GameTooltip:SetOwner(cell, "ANCHOR_LEFT");
   GameTooltip:SetHyperlink(itemLink);
   GameTooltip_ShowCompareItem();
  end

  -- Rarity extended information tooltip
		tooltip2:AddHeader(itemLink or item.name)
		tooltip2:AddSeparator(1, 1, 1, 1, 1)

  tooltip2:AddLine(colorize(R.string_types[item.type], yellow))
  if item.groupSize and item.groupSize > 1 then
   tooltip2:AddLine(colorize(format(L["Usually requires a group of around %d players"], item.groupSize), red))
  end
  tooltip2:AddLine(colorize(R.string_methods[item.method], blue))
  if item.method == ZONE or item.method == FISHING then
   if item.zones and type(item.zones) == "table" then
    for k, v in pairs(item.zones) do
     local zone = lbz[v]
     if not zone then zone = v end
     tooltip2:AddLine(colorize("    "..v, gray))
    end
   end
  elseif item.method == ARCH then
   if item.raceId then
    tooltip2:AddLine(colorize("    "..R.string_archraces[item.raceId], gray))
   end
  elseif item.method == USE then
   if item.items and type(item.items) == "table" then
    for k, v in pairs(item.items) do
     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v)
     if itemLink then tooltip2:AddLine("    "..itemLink) end
    end
   end
  end
  tooltip2:AddLine(colorize(format(L["1 in %d chance"], item.chance or 100), white))
  local dropChance = (1.00 / (item.chance or 100))
  if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
  local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
  tooltip2:AddLine(colorize(format(L["Lucky if you obtain in %d or less"], medianLoots), gray))

		tooltip2:AddSeparator(1, 1, 1, 1, 1)

  if item.totalFinds then
   tooltip2:AddLine(colorize(L["Since last drop"], yellow))
  end
  local attempts = (item.attempts or 0) - (item.lastAttempts or 0)
  tooltip2:AddLine(L["Attempts"], attempts)
  if item.method == NPC or item.method == ZONE or item.method == FISHING then
   tooltip2:AddLine(L["Time spent farming"], R:FormatTime((item.time or 0) - (item.lastTime or 0)))
  end
  if attempts > 0 then
   local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
   tooltip2:AddLine(L["Chance so far"], format("%.2f%%", chance))
  end
  
  if item.totalFinds then
		 tooltip2:AddSeparator(1, 1, 1, 1, 1)
   tooltip2:AddLine(colorize(L["Total"], yellow))
   local attempts = (item.attempts or 0)
   tooltip2:AddLine(L["Attempts"], attempts)
   if item.method == NPC or item.method == ZONE or item.method == FISHING then
    tooltip2:AddLine(L["Time spent farming"], R:FormatTime((item.time or 0)))
   end
   tooltip2:AddLine(L["Total found"], item.totalFinds)
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
	
	
	local function hideSubTooltip()
		if tooltip2 then
			qtip:Release(tooltip2)
			tooltip2 = nil
		end
  GameTooltip:Hide()
	end


 local function onClickGroup(cell, group)
  if type(group) == "table" then
   if group.collapsed == true then group.collapsed = false else group.collapsed = true end
   R:ShowTooltip()
  end
 end


 local function onClickGroup2(cell, group)
  if type(group) == "table" then
   if group.collapsedGroup == true then group.collapsedGroup = false else group.collapsedGroup = true end
   R:ShowTooltip()
  end
 end


 local function onClickItem(cell, item)
  if trackedItem ~= item and inSession then R:EndSession() end
  R:UpdateTrackedItem(item)
 end


 local function comparator(a, b)
  return (a.name or "") < (b.name or "")
 end


 local function sort(t)
  local nt = {}
  local i, j, n, min = 0, 0, 0, 0
  local k, v
  for k, v in pairs(t) do
   n = n + 1
   nt[n] = v
  end
  for i = 1, n, 1 do
	  min = i
	  for j = i + 1, n, 1 do
		  if comparator(nt[j], nt[min]) then min = j end
	  end
	  nt[i], nt[min] = nt[min], nt[i]
  end
  return nt
 end


 local function addGroup(group, requiresGroup)
  if type(group) ~= "table" then return end
  if group.name == nil then return end

  local line
  local added = false
  local g = sort(group)
  for k, v in pairs(g) do
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
     if v.lastAttempts then attempts = attempts - v.lastAttempts end
     local dropChance = (1.00 / (v.chance or 100))
     if v.method == BOSS and v.groupSize ~= nil and v.groupSize > 1 and not v.equalOdds then dropChance = dropChance / v.groupSize end
     local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
     local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
     local lucky = L["Lucky"]
     if medianLoots < attempts then lucky = L["Unlucky"] end
     local icon = ""
     if trackedItem == v then icon = [[|TInterface\Buttons\UI-CheckBox-Check:0|t]] end
     local time = 0
     if v.time then time = v.time end
     if v.lastTime then time = v.time - v.lastTime end
     if inSession and trackedItem == v then
      local len = sessionLast - sessionStarted
      time = time + len
     end
     time = R:FormatTime(time)
     local likelihood = format("%.2f%%", chance)
     if attempts == 0 then
      attempts = ""
      lucky = ""
      time = ""
      likelihood = ""
     end
     if time == "0:00" then time = "" end
     line = tooltip:AddLine(icon, (itemTexture and "|T"..itemTexture..":0|t " or "")..(itemLink or v.name or L["Unknown"]), attempts, likelihood, time, lucky)
     tooltip:SetLineScript(line, "OnMouseUp", onClickItem, v)
				 tooltip:SetLineScript(line, "OnEnter", showSubTooltip, v)
				 tooltip:SetLineScript(line, "OnLeave", hideSubTooltip)
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
      CORE FUNCTIONALITY -------------------------------------------------------------------------------------------------------
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
  -- Output the attempt count
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
  local s
  local attempts = item.attempts or 1
  local total = item.attempts or 1
  if item.lastAttempts then attempts = attempts - item.lastAttempts end
  if total <= attempts then
   if attempts == 1 then s = format(L["%s: %d attempt"], itemLink, attempts)
   else s = format(L["%s: %d attempts"], itemLink, attempts) end
  else
   if attempts == 1 then s = format(L["%s: %d attempt (%d total)"], itemLink, attempts, total)
   else s = format(L["%s: %d attempts (%d total)"], itemLink, attempts, total) end
  end
  self:Pour(s, nil, nil, nil, nil, nil, nil, nil, nil, itemTexture)

  -- Handle time tracking
  if trackedItem == item then
   self:UpdateSession()
  else
   self:EndSession()
   self:StartSession()
  end
 end
 self:UpdateTrackedItem(item)
end


function R:ScanExistingItems(reason)
 self:Debug("Scanning for existing items ("..reason..")")

 -- Sprite Darter Egg is farmed by horde only. Alliance get it as part of a quest.
 if not self:IsHorde() then self.db.profile.groups.pets["Sprite Darter Egg"].enabled = false end

 -- Look for mount and pet spell IDs and mark as found/disabled (if repeatable set to off)

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
 self:Debug("FOUND ITEM %d!", itemId)
 if item.attempts == nil then item.attempts = 1 end
 if item.lastAttempts == nil then item.lastAttempts = 0 end
 self:ShowFoundAlert(itemId, item.attempts - item.lastAttempts)
 if inSession then self:EndSession() end
 item.realAttempts = item.attempts - item.lastAttempts
 item.lastAttempts = item.attempts
 item.lastTime = item.time
 item.enabled = false
 item.found = true
 item.totalFinds = (item.totalFinds or 0) + 1
 self:UpdateTrackedItem(item)
 self:UpdateInterestingThings()
 if item.repeatable and (item.method == NPC or item.method == ZONE or item.method == FISHING) then self:ScheduleTimer(function()
  -- If this is a repeatable item, turn it back on in a few seconds.
  -- FoundItem() gets called repeatedly when we get an item, so we need to lock it out for 2 seconds.
  item.enabled = nil
  item.found = nil
  self:UpdateInterestingThings()
  self:UpdateText()
  if R:InTooltip() then R:ShowTooltip() end
 end, 5) end
end


function R:FindTrackedItem()
 trackedItem = self.db.profile.groups.pets["Parrot Cage (Hyacinth Macaw)"]

 if self.db.profile.trackedGroup and self.db.profile.groups[self.db.profile.trackedGroup] then
  if self.db.profile.trackedItem then
   for k, v in pairs(self.db.profile.groups[self.db.profile.trackedGroup]) do
    if type(v) == "table" and v.itemId and v.itemId == self.db.profile.trackedItem then
     trackedItem = v
    end
   end
  end
 end

	if self.db.profile.debugMode then
  R.trackedItem = trackedItem
	end
end


function R:UpdateTrackedItem(item)
 if not item or not item.itemId then return end
 self.db.profile.trackedItem = item.itemId
 for k, v in pairs(R.db.profile.groups) do
  if type(v) == "table" then
   for kk, vv in pairs(v) do
    if type(vv) == "table" then
     if vv.itemId == item.itemId then
      self.db.profile.trackedGroup = k
     end
    end
   end
  end
 end
 self:FindTrackedItem()
 self:UpdateText()
 if self:InTooltip() then self:ShowTooltip() end
end


function R:EndSession()
	if inSession then
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem.itemId)
		local len = sessionLast - sessionStarted
  if trackedItem and (trackedItem.method == NPC or trackedItem.method == ZONE or trackedItem.method == FISHING) then trackedItem.time = (trackedItem.time or 0) + len end
  self:Debug("Ending session for %s (%s)", itemLink, self:FormatTime(trackedItem.time))
	end
	inSession = false
end


function timeoutSession()
 R:Debug("Nothing happened in 5 minutes. Ending your session.")
 sessionTimer = nil
 R:EndSession()
end


function R:StartSession()
 self:Debug("Starting a session")
	inSession = true
	sessionStarted = GetTime()
	sessionLast = sessionStarted
	sessionStarted = sessionStarted - 1
 if sessionTimer then self:CancelTimer(sessionTimer, true) end
 sessionTimer = self:ScheduleTimer(timeoutSession, SESSION_LENGTH)
end


function R:UpdateSession()
	if inSession then
		sessionLast = GetTime()
  self:Debug("Extending current session")
  if sessionTimer then self:CancelTimer(sessionTimer, true) end
  sessionTimer = self:ScheduleTimer(timeoutSession, SESSION_LENGTH)
	else
		self:StartSession()
	end
end
