Rarity = LibStub("AceAddon-3.0"):NewAddon("Rarity", "AceConsole-3.0", "AceEvent-3.0", "AceTimer-3.0", "LibSink-2.0", "AceBucket-3.0", "LibBars-1.0")
Rarity.MINOR_VERSION = tonumber(("$Revision$"):match("%d+"))
local FORCE_PROFILE_RESET_BEFORE_REVISION = 1 -- Set this to one higher than the Revision on the line above this
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local R = Rarity
local qtip = LibStub("LibQTip-1.0")
local media = LibStub("LibSharedMedia-3.0")
local ldb = LibStub:GetLibrary("LibDataBroker-1.1")
local dbicon = LibStub("LibDBIcon-1.0")
local dataobj = ldb:NewDataObject("Rarity", {
 type = "data source",
 text = L["Loading"],
 label = "Rarity",
 tocname = "Rarity",
 icon = [[Interface\Icons\spell_nature_forceofnature]]
})
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbct = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local lbb = LibStub("LibBabble-Boss-3.0"):GetUnstrictLookupTable()
---


--[[
      VARIABLES ----------------------------------------------------------------------------------------------------------------
  ]]

R.modulesEnabled = {}

local npcs = {}
local bosses = {}
local zones = {}
local guids = {}
local items = {}
local npcs_to_items = {}
local items_to_items = {}
local bagitems = {}
local tempbagitems = {}
local used = {}
local fishzones = {}
local archfragments = {}
local coinamounts = {}
local architems = {}
local rarity_stats = {}
local toys = {}
Rarity.mount_sources = {}
Rarity.pet_sources = {}
Rarity.lockouts = {}
Rarity.lockouts_holiday = {}
Rarity.holiday_textures = {}
Rarity.ach_npcs_isKilled = {}
Rarity.ach_npcs_achId = {}
Rarity.stats_to_scan = {}
Rarity.items_with_stats = {}
Rarity.collection_items = {}

local bankOpen = false
local guildBankOpen = false
local auctionOpen = false
local tradeOpen = false
local tradeSkillOpen = false
local mailOpen = false

local prevSpell, curSpell, foundTarget, gatherEvents, ga
local miningSpell = (GetSpellInfo(2575))
local herbSpell = (GetSpellInfo(2366))
local fishSpell = (GetSpellInfo(131474))
local gasSpell = (GetSpellInfo(30427))
local openSpell = (GetSpellInfo(3365))
local openNoTextSpell = (GetSpellInfo(22810))
local pickSpell = (GetSpellInfo(1804))
local archSpell = (GetSpellInfo(73979))
local skinSpell = (GetSpellInfo(8613))
local disenchantSpell = (GetSpellInfo(13262))
local spells = {
	[miningSpell] = "Mining",
	[herbSpell] = "Herb Gathering",
	[fishSpell] = "Fishing",
	[gasSpell] = "Extract Gas",
	[openSpell] = "Treasure",
	[openNoTextSpell] = "Treasure",
	[pickSpell] = "Treasure",
	[archSpell] = "Archaeology",
 [skinSpell] = "Skinning",
	[disenchantSpell] = "Disenchant",
}
local tooltipLeftText1 = _G["GameTooltipTextLeft1"]
local fishing = false
local opening = false
local fishingTimer
local FISHING_DELAY = 22
local trackedItem
local trackedItem2
local lastAttemptTime
local lastAttemptItem
local DUAL_TRACK_THRESHOLD = 5
local isPool = false
local lastNode
local STATUS_TOOLTIP_MAX_WIDTH = 200
local numHolidayReminders = 0
local showedHolidayReminderOverflow = false
local canPlayGroupFinderAlert = true
local wasGroupFinderAutoRefresh = false

local inSession = false
local sessionStarted = 0
local sessionLast = 0
local SESSION_LENGTH = 60 * 10 -- 10 minutes
local sessionTimer

local red = { r = 1.0, g = 0.2, b = 0.2 }
local blue = { r = 0.4, g = 0.4, b = 1.0 }
local green = { r = 0.2, g = 1.0, b = 0.2 }
local yellow = { r = 1.0, g = 1.0, b = 0.2 }
local gray = { r = 0.5, g = 0.5, b = 0.5 }
local black = { r = 0.0, g = 0.0, b = 0.0 }
local white = { r = 1.0, g = 1.0, b = 1.0 }
local orange = { r = 1.0, g = 0.3, b = 0.0 }

local scanTip = CreateFrame("GameTooltip", "__Rarity_ScanTip", nil, "GameTooltipTemplate")
scanTip:SetOwner(WorldFrame, "ANCHOR_NONE")

R.coins = {
	-- Mists of Pandaria
	[697] = true, -- Elder Charm of Good Fortune
	[752] = true, -- Mogu Rune of Fate
	[776] = true, -- Warforged Seal
	-- Warlords of Draenor
	[994] = true, -- Seal of Tempered Fate
	[1129] = true, -- Seal of Inevitable Fate
	-- Legion
	[1273] = true, -- Seal of Broken Fate
}

R.fishnodes = {
	-- Classic through Cataclysm
 [L["Floating Wreckage"]] = true,
 [L["Patch of Elemental Water"]] = true,
 [L["Floating Debris"]] = true,
 [L["Floating Debris Pool"]] = true,
 [L["Oil Spill"]] = true,
 [L["Firefin Snapper School"]] = true,
 [L["Greater Sagefish School"]] = true,
 [L["Oily Blackmouth School"]] = true,
 [L["Sagefish School"]] = true,
 [L["School of Deviate Fish"]] = true,
 [L["Stonescale Eel Swarm"]] = true,
 [L["Muddy Churning Water"]] = true,
 [L["Highland Mixed School"]] = true,
 [L["Pure Water"]] = true,
 [L["Bluefish School"]] = true,
 [L["Feltail School"]] = true,
 [L["Brackish Mixed School"]] = true,
 [L["Mudfish School"]] = true,
 [L["School of Darter"]] = true,
 [L["Sporefish School"]] = true,
 [L["Steam Pump Flotsam"]] = true,
 [L["School of Tastyfish"]] = true,
 [L["Borean Man O' War School"]] = true,
 [L["Deep Sea Monsterbelly School"]] = true,
 [L["Dragonfin Angelfish School"]] = true,
 [L["Fangtooth Herring School"]] = true,
 [L["Floating Wreckage Pool"]] = true,
 [L["Glacial Salmon School"]] = true,
 [L["Glassfin Minnow School"]] = true,
 [L["Imperial Manta Ray School"]] = true,
 [L["Moonglow Cuttlefish School"]] = true,
 [L["Musselback Sculpin School"]] = true,
 [L["Nettlefish School"]] = true,
 [L["Strange Pool"]] = true,
 [L["Schooner Wreckage"]] = true,
 [L["Schooner Wreckage Pool"]] = true,
 [L["Waterlogged Wreckage"]] = true,
 [L["Waterlogged Wreckage Pool"]] = true,
 [L["Bloodsail Wreckage"]] = true,
 [L["Bloodsail Wreckage Pool"]] = true,
 [L["Lesser Sagefish School"]] = true,
 [L["Lesser Oily Blackmouth School"]] = true,
 [L["Sparse Oily Blackmouth School"]] = true,
 [L["Abundant Oily Blackmouth School"]] = true,
 [L["Teeming Oily Blackmouth School"]] = true,
 [L["Lesser Firefin Snapper School"]] = true,
 [L["Sparse Firefin Snapper School"]] = true,
 [L["Abundant Firefin Snapper School"]] = true,
 [L["Teeming Firefin Snapper School"]] = true,
 [L["Lesser Floating Debris"]] = true,
 [L["Sparse Schooner Wreckage"]] = true,
 [L["Abundant Bloodsail Wreckage"]] = true,
 [L["Teeming Floating Wreckage"]] = true,
 [L["Albino Cavefish School"]] = true,
 [L["Algaefin Rockfish School"]] = true,
 [L["Blackbelly Mudfish School"]] = true,
 [L["Fathom Eel Swarm"]] = true,
 [L["Highland Guppy School"]] = true,
 [L["Mountain Trout School"]] = true,
 [L["Pool of Fire"]] = true,
 [L["Shipwreck Debris"]] = true,
 [L["Deepsea Sagefish School"]] = true,
 -- Mists of Pandaria
	[L["Emperor Salmon School"]] = true,
	[L["Giant Mantis Shrimp Swarm"]] = true,
	[L["Golden Carp School"]] = true,
	[L["Jade Lungfish School"]] = true,
	[L["Krasarang Paddlefish School"]] = true,
	[L["Redbelly Mandarin School"]] = true,
	[L["Reef Octopus Swarm"]] = true,
	[L["Floating Shipwreck Debris"]] = true,
	[L["Jewel Danio School"]] = true,
	[L["Spinefish School"]] = true,
	[L["Tiger Gourami School"]] = true,
	[L["Large Swarm of Migrated Reef Octopus"]] = true,
	[L["Large Pool of Sha-Touched Spinefish"]] = true,
	[L["Large Pool of Glowing Jade Lungfish"]] = true,
	[L["Large Pool of Crowded Redbelly Mandarin"]] = true,
	[L["Large Tangled Mantis Shrimp Cluster"]] = true,
	[L["Large Swarm of Panicked Paddlefish"]] = true,
	[L["Large Pool of Tiger Gourami Slush"]] = true,
	[L["Large Pool of Glimmering Jewel Danio Pool"]] = true,
	[L["Large Pool of Brew Frenzied Emperor Salmon"]] = true,
	[L["Brew Frenzied Emperor Salmon"]] = true,
	[L["Glimmering Jewel Danio Pool"]] = true,
	[L["Tiger Gourami Slush"]] = true,
	[L["Swarm of Panicked Paddlefish"]] = true,
	[L["Tangled Mantis Shrimp Cluster"]] = true,
	[L["Crowded Redbelly Mandarin"]] = true,
	[L["Glowing Jade Lungfish"]] = true,
	[L["Sha-Touched Spinefish"]] = true,
	-- Warlords of Draenor
	[L["Abyssal Gulper School"]] = true,
	[L["Oily Abyssal Gulper School"]] = true,
	[L["Blackwater Whiptail School"]] = true,
	[L["Blind Lake Sturgeon School"]] = true,
	[L["Fat Sleeper School"]] = true,
	[L["Fire Ammonite School"]] = true,
	[L["Jawless Skulker School"]] = true,
	[L["Sea Scorpion School"]] = true,
	[L["Oily Sea Scorpion School"]] = true,
	[L["Savage Piranha Pool"]] = true,
	-- Legion
	[L["Black Barracuda School"]]	= true,
	[L["Cursed Queenfish School"]]	= true,
	[L["Runescale Koi School"]]	= true,
	[L["Fever of Stormrays"]]		= true,
	[L["Highmountain Salmon School"]]	= true,
	[L["Mossgill Perch School"]]	= true,
}

R.miningnodes = {
	-- Classic through Cataclysm
 [L["Copper Vein"]] = true,
 [L["Tin Vein"]] = true,
 [L["Iron Deposit"]] = true,
 [L["Silver Vein"]] = true,
 [L["Gold Vein"]] = true,
 [L["Mithril Deposit"]] = true,
 [L["Ooze Covered Mithril Deposit"]] = true,
 [L["Truesilver Deposit"]] = true,
 [L["Ooze Covered Silver Vein"]] = true,
 [L["Ooze Covered Gold Vein"]] = true,
 [L["Ooze Covered Truesilver Deposit"]] = true,
 [L["Ooze Covered Rich Thorium Vein"]] = true,
 [L["Ooze Covered Thorium Vein"]] = true,
 [L["Small Thorium Vein"]] = true,
 [L["Rich Thorium Vein"]] = true,
 [L["Dark Iron Deposit"]] = true,
 [L["Lesser Bloodstone Deposit"]] = true,
 [L["Incendicite Mineral Vein"]] = true,
 [L["Indurium Mineral Vein"]] = true,
 [L["Fel Iron Deposit"]] = true,
 [L["Adamantite Deposit"]] = true,
 [L["Rich Adamantite Deposit"]] = true,
 [L["Khorium Vein"]] = true,
 [L["Large Obsidian Chunk"]] = true,
 [L["Small Obsidian Chunk"]] = true,
 [L["Nethercite Deposit"]] = true,
 [L["Cobalt Deposit"]] = true,
 [L["Rich Cobalt Deposit"]] = true,
 [L["Titanium Vein"]] = true,
 [L["Saronite Deposit"]] = true,
 [L["Rich Saronite Deposit"]] = true,
 [L["Obsidium Deposit"]] = true,
 [L["Huge Obsidian Slab"]] = true,
 [L["Pure Saronite Deposit"]] = true,
 [L["Elementium Vein"]] = true,
 [L["Rich Elementium Vein"]] = true,
 [L["Pyrite Deposit"]] = true,
 [L["Rich Obsidium Deposit"]] = true,
 [L["Rich Pyrite Deposit"]] = true,
 -- Mists of Pandaria
	[L["Rich Pyrite Deposit"]] = true,
	[L["Ghost Iron Deposit"]] = true,
	[L["Rich Ghost Iron Deposit"]] = true,
	[L["Black Trillium Deposit"]] = true,
	[L["White Trillium Deposit"]] = true,
	[L["Kyparite Deposit"]] = true,
	[L["Rich Kyparite Deposit"]] = true,
	[L["Trillium Vein"]] = true,
	[L["Rich Trillium Vein"]] = true,
	-- Warlords of Draenor
	[L["True Iron Deposit"]] = true,
	[L["Rich True Iron Deposit"]] = true,
	[L["Blackrock Deposit"]] = true,
	[L["Rich Blackrock Deposit"]] = true,
	-- Legion
	[L["Leystone Deposit"]]	= true,
	[L["Rich Leystone Deposit"]]	= true,
	[L["Leystone Seam"]]	= true,
	[L["Felslate Deposit"]]	= true,
	[L["Rich Felslate Deposit"]]	= true,
	[L["Felslate Seam"]]	= true,
}

R.opennodes = {
	[L["Crane Nest"]] = true,
	[L["Timeless Chest"]] = true,
	[L["Snow Mound"]] = true,
}



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
local SPECIAL = "SPECIAL"
local MINING = "MINING"
local COLLECTION = "COLLECTION"

-- Feed text
local FEED_MINIMAL = "FEED_MINIMAL"
local FEED_NORMAL = "FEED_NORMAL"
local FEED_VERBOSE = "FEED_VERBOSE"

-- Tooltip position
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"

-- Sort modes
local SORT_NAME = "SORT_NAME"
local SORT_DIFFICULTY = "SORT_DIFFICULTY"
local SORT_PROGRESS = "SORT_PROGRESS"
local SORT_CATEGORY = "SORT_CATEGORY"

-- Categories of origin
local BASE = "BASE"
local TBC = "TBC"
local WOTLK = "WOTLK"
local CATA = "CATA"
local MOP = "MOP"
local WOD = "WOD"
local LEGION = "LEGION"
local HOLIDAY = "HOLIDAY"
local categories = {
	[BASE] =    L["Classic"],
	[TBC] =     L["The Burning Crusade"],
	[WOTLK] =   L["Wrath of the Lich King"],
	[CATA] =    L["Cataclysm"],
	[MOP] =     L["Mists of Pandaria"],
	[WOD] =     L["Warlords of Draenor"],
	[LEGION] =  L["Legion"],
	[HOLIDAY] = L["Holiday"],
}



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
local GetItemInfo = _G.GetItemInfo
local GetRealZoneText = _G.GetRealZoneText
local GetContainerNumSlots = _G.GetContainerNumSlots
local GetContainerItemID = _G.GetContainerItemID
local GetContainerItemInfo = _G.GetContainerItemInfo
local GetNumArchaeologyRaces = _G.GetNumArchaeologyRaces
local GetArchaeologyRaceInfo = _G.GetArchaeologyRaceInfo
local SetSelectedArtifact = _G.SetSelectedArtifact
local GetSelectedArtifactInfo = _G.GetSelectedArtifactInfo
local GetStatistic = _G.GetStatistic
local GetLootSourceInfo = _G.GetLootSourceInfo
local pet_journal = _G.C_PetJournal
local GetCurrentMapAreaID = _G.GetCurrentMapAreaID
local mount_journal = _G.C_MountJournal

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
		isInitialized = true
	
		self:PrepareDefaults() -- Loads in any new items
		
		self.db = LibStub("AceDB-3.0"):New("RarityDB", self.defaults, true)
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
   R.items_to_items = items_to_items
   R.used = used
   R.tempbagitems = tempbagitems
   R.bagitems = bagitems
   R.fishzones = fishzones
   R.archfragments = archfragments
   R.architems = architems
   R.stats = rarity_stats
		end

  -- LibSink still tries to call a non-existent Blizzard function sometimes
  if not CombatText_StandardScroll then CombatText_StandardScroll = 0 end
  if not UIERRORS_HOLD_TIME then UIERRORS_HOLD_TIME = 2 end
  if not CombatText_AddMessage then
   CombatText_AddMessage = function(text, _, r, g, b, sticky, _)
    UIErrorsFrame:AddMessage(text, r, g, b, 1, UIERRORS_HOLD_TIME)
   end
  end

  -- Initialize bar
  self.barGroup = self:NewBarGroup("Rarity", nil, self.db.profile.bar.width, self.db.profile.bar.height)
		self.barGroup.RegisterCallback(self, "AnchorClicked", "BarAnchorClicked")
		self:UpdateBar()
  self.bar = nil

		self:ScanExistingItems("INITIALIZING") -- Checks for items you already have
  self:ScanBags() -- Initialize our inventory list, as well as checking if you've obtained an item
		self:OnBagUpdate() -- This will update counters for collection items
		self:OnCurrencyUpdate("INITIALIZING") -- Prepare our currency list
  self:UpdateInterestingThings()
  self:FindTrackedItem()
  self:UpdateText()
		self:UpdateBar()

  self:ImportFromBunnyHunter()
		
		self:UnregisterAllEvents()
  self:RegisterBucketEvent("BAG_UPDATE", 0.5, "OnBagUpdate")
  self:RegisterEvent("LOOT_READY", "OnEvent")
  self:RegisterEvent("CURRENCY_DISPLAY_UPDATE", "OnCurrencyUpdate")
  self:RegisterEvent("COMBAT_LOG_EVENT_UNFILTERED", "OnCombat") -- Used to detect boss kills that we didn't solo
  self:RegisterEvent("BANKFRAME_OPENED", "OnEvent")
  self:RegisterEvent("BANKFRAME_CLOSED", "OnEvent")
  self:RegisterEvent("GUILDBANKFRAME_OPENED", "OnEvent")
  self:RegisterEvent("GUILDBANKFRAME_CLOSED", "OnEvent")
  self:RegisterEvent("MAIL_CLOSED", "OnEvent")
  self:RegisterEvent("MAIL_SHOW", "OnEvent")
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
  self:RegisterEvent("UPDATE_MOUSEOVER_UNIT", "OnMouseOver")
  self:RegisterEvent("CRITERIA_COMPLETE", "OnCriteriaComplete")
  self:RegisterEvent("PLAYER_REGEN_ENABLED", "OnCombatEnded")
  self:RegisterEvent("PET_BATTLE_OPENING_START", "OnPetBattleStart")
  self:RegisterEvent("PET_BATTLE_CLOSE", "OnPetBattleEnd")
  self:RegisterBucketEvent("LFG_LIST_SEARCH_RESULT_UPDATED", 1, "GroupFinderResultsUpdated")
  self:RegisterBucketEvent("LFG_LIST_SEARCH_RESULTS_RECEIVED", 1, "GroupFinderResultsUpdated")
  self:RegisterBucketEvent("UPDATE_INSTANCE_INFO", 1, "OnEvent")
  self:RegisterBucketEvent("LFG_UPDATE_RANDOM_INFO", 1, "OnEvent")
  self:RegisterBucketEvent("CALENDAR_UPDATE_EVENT_LIST", 1, "OnEvent")
  self:RegisterBucketEvent("TOYS_UPDATED", 1, "OnEvent")
  self:RegisterBucketEvent("COMPANION_UPDATE", 1, "OnEvent")

		if R.Options_DoEnable then R:Options_DoEnable() end
		self.db.profile.lastRevision = R.MINOR_VERSION

		self.db.RegisterCallback(self, "OnProfileChanged", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileCopied", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileReset", "OnProfileChanged")
		self.db.RegisterCallback(self, "OnProfileDeleted", "OnProfileChanged")

  RequestArtifactCompletionHistory() -- Request archaeology info from the server
		RequestRaidInfo() -- Request raid lock info from the server
		RequestLFDPlayerLockInfo() -- Request LFD data from the server; this is used for holiday boss detection
		OpenCalendar() -- Request calendar info from the server

		local refresh = nil

		-- Setup the Group Finder refresh timer
		self:ScheduleRepeatingTimer(function()
			if refresh == nil and LFGListFrame ~= nil and LFGListFrame.SearchPanel ~= nil and LFGListFrame.SearchPanel.RefreshButton ~= nil then
				refresh = CreateFrame("CheckButton", "RarityGroupFinderAutoRefresh", LFGListFrame.SearchPanel, "OptionsSmallCheckButtonTemplate")
				refresh:ClearAllPoints()
				refresh:SetPoint("TOPRIGHT", -65, -28)
				_G[refresh:GetName() .. "Text"]:SetText(L["Auto"])
				refresh:SetScript("OnEnter", function()
					GameTooltip:SetOwner(refresh, "ANCHOR_RIGHT")
					GameTooltip:SetText(L["Check this to automatically refresh your search every 5 seconds while this window is visible. Auto refresh only works if you've typed something in the search box, and if you haven't selected something in the list below.\n\nThis checkbox is provided by Rarity. You can hide the checkbox in Rarity options."], nil, nil, nil, nil, true)
					GameTooltip:Show()
				end)
				refresh:SetScript("OnLeave", function()
					GameTooltip_Hide()
				end)
			end

			if RarityGroupFinderAutoRefresh ~= nil then
				if self.db.profile.showGroupFinderAutoRefresh then RarityGroupFinderAutoRefresh:Show() else RarityGroupFinderAutoRefresh:Hide() end
			end

		 if RarityGroupFinderAutoRefresh ~= nil and RarityGroupFinderAutoRefresh:GetChecked() and self.db.profile.showGroupFinderAutoRefresh and InCombatLockdown() ~= 1 and LFGListFrame ~= nil and LFGListFrame:IsShown() then
				if LFGListFrame.SearchPanel ~= nil and LFGListFrame.SearchPanel.RefreshButton ~= nil and PVEFrame ~= nil and PVEFrame:IsShown() == true then
					if LFGListFrame.SearchPanel.SignUpButton ~= nil and LFGListFrame.SearchPanel.SignUpButton:IsEnabled() == false then
						if LFGListFrame.SearchPanel.SearchBox ~= nil and LFGListFrame.SearchPanel.SearchBox:GetText() ~= "" then
							LFGListFrame.SearchPanel.RefreshButton:Click()
							wasGroupFinderAutoRefresh = true
							self:Debug("Refreshing Group Finder search")
						end
					end
				end
			end
		end, 5)

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
				local _, month, _, year = CalendarGetDate()
				CalendarSetAbsMonth(month, year)
			end
		end, 7)
		self:ScheduleTimer(function()
			if type(CalendarFrame) ~= "table" or not CalendarFrame:IsShown() then
				local _, month, _, year = CalendarGetDate()
				CalendarSetAbsMonth(month, year)
			end
		end, 20)

		-- Trigger holiday reminders
		self:ScheduleTimer(function()
			Rarity:ShowTooltip(true)
		end, 10)

  -- Update text again several times later - this helps get the icon right after login
  self:ScheduleTimer(function() R:DelayedInit() end, 10)
  self:ScheduleTimer(function() R:DelayedInit() end, 20)
  self:ScheduleTimer(function() R:DelayedInit() end, 30)
  self:ScheduleTimer(function() R:DelayedInit() end, 60)
  self:ScheduleTimer(function() R:DelayedInit() end, 120)
  self:ScheduleTimer(function() R:DelayedInit() end, 180)
  self:ScheduleTimer(function()
			self:ScanCalendar("FINAL INIT")
			self:ScanExistingItems("FINAL INIT")
			self:UpdateText()
		end, 240)
		
		self:Debug(L["Loaded (running in debug mode)"])
	end
end


function R:DelayedInit()
	self:ScanStatistics("DELAYED INIT")
	self:ScanCalendar("DELAYED INIT")
	self:ScanToys("DELAYED INIT")
	self:UpdateText()
 self:UpdateBar()
end


function R:GroupFinderResultsUpdated()
	if LFGListFrame.SearchPanel.ScrollFrame.buttons[1]:IsShown() and self.db.profile.showGroupFinderAutoRefresh and IsInGroup() ~= true and PVEFrame ~= nil and PVEFrame:IsShown() == true then
		if canPlayGroupFinderAlert == true and wasGroupFinderAutoRefresh == true then
			if LFGListFrame.SearchPanel.SearchBox ~= nil and LFGListFrame.SearchPanel.SearchBox:GetText() ~= "" and LFGListFrame:IsShown() and InCombatLockdown() ~= 1 and RarityGroupFinderAutoRefresh ~= nil and RarityGroupFinderAutoRefresh:GetChecked() then
				canPlayGroupFinderAlert = false
				self:Print(L["Group(s) found!"])
				self:ScheduleTimer(function() canPlayGroupFinderAlert = true end, 60)
				if self.db.profile.enableGroupFinderAlert then
					PlaySound("ReadyCheck", "master")
					if FlashClientIcon then FlashClientIcon() end
				end
			end
		end
	end
	wasGroupFinderAutoRefresh = false
end


function R:BarAnchorClicked(cbk, group, button)
 local point, relativeTo, relativePoint, x, y = self.barGroup:GetPoint()
 self:Debug("Clicked anchor", point, relativePoint, x, y)
 self.db.profile.bar.x = x
 self.db.profile.bar.y = y
 self.db.profile.bar.point = point
 self.db.profile.bar.relativePoint = relativePoint
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
	self:OnCurrencyUpdate(event)
 self:ScanAllArch(event)
	self:ScanExistingItems(event)
 self:ScanBags()
 self:FindTrackedItem()
 self:UpdateText()
 --if self:InTooltip() then self:ShowTooltip() end
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


local function containsOrIs(a, b)
	-- "a" can be a table or a value
	if type(a) == "table" then
		for k, v in pairs(a) do
			if v == b then return true end
		end
	else
		if a == b then return true end
	end
	return false
end


local function getDate(delta)
 local dt = date("*t", time() - (delta or 0))
 return dt.year * 10000 + dt.month * 100 + dt.day
end


local function compareName(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end
 return (a.name or "") < (b.name or "")
end


local function compareCategory(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end
	if (a.cat or "") == (b.cat or "") then return (a.name or "") < (b.name or "") end
	return (R.catOrder[a.cat or 0] or 0) < (R.catOrder[b.cat or 0] or 0)
end


local function compareDifficulty(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end

 local item
 item = a
 local dropChance = (1.00 / (item.chance or 100))
 if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
 local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
 local median1 = medianLoots

 item = b
 dropChance = (1.00 / (item.chance or 100))
 if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
 medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
 local median2 = medianLoots

 return (median1 or 0) < (median2 or 0)
end


local function compareProgress(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end

 local item
 item = a
 local dropChance = (1.00 / (item.chance or 100))
 if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
 local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
 local median1 = medianLoots
 local progress1 = 0
 if item.attempts or 0 > 0 then progress1 = 100 * (1 - math.pow(1 - dropChance, item.attempts or 0)) end

 item = b
 dropChance = (1.00 / (item.chance or 100))
 if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
 medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
 local median2 = medianLoots
 local progress2 = 0
 if item.attempts or 0 > 0 then progress2 = 100 * (1 - math.pow(1 - dropChance, item.attempts or 0)) end

 return progress1 > progress2
end


local function compareNum(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end
 return (a.num or 0) < (b.num or 0)
end


local function sort(t)
 local nt = {}
 local i, j, n, min = 0, 0, 0, 0
 local k, v
 for k, v in pairs(t) do
  if type(v) == "table" and v.name then
   n = n + 1
   nt[n] = v
  end
 end
 for i = 1, n, 1 do
	 min = i
	 for j = i + 1, n, 1 do
		 if compareName(nt[j], nt[min]) then min = j end
	 end
	 nt[i], nt[min] = nt[min], nt[i]
 end
 return nt
end


local function sort2(t)
 local nt = {}
 local i, j, n, min = 0, 0, 0, 0
 local k, v
 for k, v in pairs(t) do
  if type(v) == "table" and v.num then
   n = n + 1
   nt[n] = v
  end
 end
 for i = 1, n, 1 do
	 min = i
	 for j = i + 1, n, 1 do
		 if compareNum(nt[j], nt[min]) then min = j end
	 end
	 nt[i], nt[min] = nt[min], nt[i]
 end
 return nt
end


local function sort_difficulty(t)
 local nt = {}
 local i, j, n, min = 0, 0, 0, 0
 local k, v
 for k, v in pairs(t) do
  if type(v) == "table" and v.name then
   n = n + 1
   nt[n] = v
  end
 end
 for i = 1, n, 1 do
	 min = i
	 for j = i + 1, n, 1 do
		 if compareDifficulty(nt[j], nt[min]) then min = j end
	 end
	 nt[i], nt[min] = nt[min], nt[i]
 end
 return nt
end


local function sort_progress(t)
 local nt = {}
 local i, j, n, min = 0, 0, 0, 0
 local k, v
 for k, v in pairs(t) do
  if type(v) == "table" and v.name then
   n = n + 1
   nt[n] = v
  end
 end
 for i = 1, n, 1 do
	 min = i
	 for j = i + 1, n, 1 do
		 if compareProgress(nt[j], nt[min]) then min = j end
	 end
	 nt[i], nt[min] = nt[min], nt[i]
 end
 return nt
end


local function sort_category(t)
 local nt = {}
 local i, j, n, min = 0, 0, 0, 0
 local k, v
 for k, v in pairs(t) do
  if type(v) == "table" and v.name then
   n = n + 1
   nt[n] = v
  end
 end
 for i = 1, n, 1 do
	 min = i
	 for j = i + 1, n, 1 do
		 if compareCategory(nt[j], nt[min]) then min = j end
	 end
	 nt[i], nt[min] = nt[min], nt[i]
 end
 return nt
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


local function colorizeV(s, r, g, b)
	if r and g and b and s then
		return format("|cff%02x%02x%02x%s|r", (r or 1) * 255, (g or 1) * 255, (b or 1) * 255, s)
	else
		return s
	end
end


function R:Debug(s, ...)
	if self.db.profile.debugMode then self:Print(format(s, ...)) end
end


do
	local start1, stop1, start2, stop2

	function R:ProfileStart()
		if self.db.profile.enableProfiling then
			start1 = debugprofilestop()
		end
	end

	function R:ProfileStart2()
		if self.db.profile.enableProfiling then
			start2 = debugprofilestop()
		end
	end

	function R:ProfileStop(s)
		if self.db.profile.enableProfiling then
			stop1 = debugprofilestop()
			R:Print(format(s, stop1 - start1))
		end
	end

	function R:ProfileStop2(s)
		if self.db.profile.enableProfiling then
			stop2 = debugprofilestop()
			R:Print(format(s, stop2 - start2))
		end
	end

	function R:ProfileDebug(s)
		if self.db.profile.enableProfiling then
			R:Print(s)
		end
	end

end


-- Prepares a set of lookup tables to let us quickly determine if we're interested in various things.
-- Many of the events we handle fire quite frequently, so speed is of the essence.
-- Any item that is not enabled for tracking won't show up in these lists.
function R:UpdateInterestingThings()
 self:Debug("Updating interesting things tables")

	-- Store an internal table listing every MapID
	if self.db.profile.mapIds == nil then self.db.profile.mapIds = {} else table.wipe(self.db.profile.mapIds) end
	for map_id = 1, 5000 do
		if GetMapNameByID(map_id) ~= nil then self.db.profile.mapIds[map_id] = GetMapNameByID(map_id) end
	end

 table.wipe(npcs)
 table.wipe(bosses)
 table.wipe(zones)
 table.wipe(items)
 table.wipe(guids)
 table.wipe(npcs_to_items)
 table.wipe(items_to_items)
 table.wipe(used)
 table.wipe(fishzones)
 table.wipe(architems)
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
						if numStats > 0 then Rarity.items_with_stats[kk] = vv end
					end
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
       if lbz[vvv] then zones[lbz[vvv]] = vv end
       if lbsz[vvv] then zones[lbsz[vvv]] = vv end
       zones[vvv] = vv
      end
     elseif vv.method == USE and vv.items ~= nil and type(vv.items) == "table" then
      for kkk, vvv in pairs(vv.items) do
       used[vvv] = vv
       if items_to_items[vvv] == nil then items_to_items[vvv] = {} end
       table.insert(items_to_items[vvv], vv)
      end
     elseif vv.method == FISHING and vv.zones ~= nil and type(vv.zones) == "table" then
      for kkk, vvv in pairs(vv.zones) do
       if lbz[vvv] then fishzones[lbz[vvv]] = vv end
       if lbsz[vvv] then fishzones[lbsz[vvv]] = vv end
       fishzones[vvv] = vv
      end
     elseif vv.method == ARCH and vv.itemId ~= nil then
      local itemName = GetItemInfo(vv.itemId)
      if itemName then architems[itemName] = vv end
     end
     if vv.itemId ~= nil and vv.method ~= COLLECTION then items[vv.itemId] = vv end
     if vv.itemId2 ~= nil and vv.method ~= COLLECTION then items[vv.itemId2] = vv end
					if vv.method == COLLECTION and vv.collectedItemId ~= nil then
						if type(vv.collectedItemId) == "table" then
							for kkk, vvv in pairs(vv.collectedItemId) do
								items[vvv] = vv
							end
						else
							items[vv.collectedItemId] = vv
						end
						table.insert(Rarity.collection_items, vv)
					end
					if vv.tooltipNpcs and type(vv.tooltipNpcs) == "table" then
      for kkk, vvv in pairs(vv.tooltipNpcs) do
       if npcs_to_items[vvv] == nil then npcs_to_items[vvv] = {} end
       table.insert(npcs_to_items[vvv], vv)
      end
					end
    end
   end
  end
 end
end


function R:GetNPCIDFromGUID(guid)
	if guid then
		local unit_type, _, _, _, _, mob_id = strsplit('-', guid)
		if unit_type == "Pet" or unit_type == "Player" then return 0 end
		return (guid and mob_id and tonumber(mob_id)) or 0
	end
	return 0
end


function R:IsInstanceAppropriate(item)
	if item == nil then return true end
	if item.instanceDifficulties == nil or type(item.instanceDifficulties) ~= "table" or next(item.instanceDifficulties) == nil then return true end
	local foundTrue = false
	for k, v in pairs(item.instanceDifficulties) do
		if v == true then foundTrue = true end
	end
	if foundTrue == false then return true end
	local name, type, difficulty, difficultyName, maxPlayers, playerDifficulty, isDynamicInstance, mapID, instanceGroupSize = GetInstanceInfo()
	if item.instanceDifficulties[difficulty] and item.instanceDifficulties[difficulty] == true then return true end
	return false
end


function R:IsHorde()
	if Rarity.isHorde == nil then
		local englishFaction, localizedFaction = UnitFactionGroup("player")
		if englishFaction == "Horde" then Rarity.isHorde = true else Rarity.isHorde = false end
	end
	return Rarity.isHorde
end


function R:FormatTime(t)
 if not t then return "0:00" end
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
 -- You opened a loot window on a corpse or fishing node
 -------------------------------------------------------------------------------------
	if event == "LOOT_READY" then
		self:Debug("LOOT_READY with target: "..(UnitGUID("target") or "NO TARGET"))
  local zone = GetRealZoneText()
  local subzone = GetSubZoneText()
  local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
  local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]

		if fishing and opening then
			self:Debug("Opened something")
		end

		if fishing and opening and lastNode then
			self:Debug("Opened a node: "..lastNode)
		end

  -- Handle opening Crane Nest
  if fishing and opening and lastNode and (lastNode == L["Crane Nest"]) then
   local v = self.db.profile.groups.pets["Azure Crane Chick"]
   if v and type(v) == "table" and v.enabled ~= false then
    if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
    self:OutputAttempts(v)
   end
  end

  -- Handle opening Timeless Chest
  if fishing and opening and lastNode and (lastNode == L["Timeless Chest"]) then
   local v = self.db.profile.groups.pets["Bonkers"]
   if v and type(v) == "table" and v.enabled ~= false then
    if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
    self:OutputAttempts(v)
   end
  end

  -- Handle opening Snow Mound
  if fishing and opening and lastNode and (lastNode == L["Snow Mound"]) then
   local v = self.db.profile.groups.pets["Grumpling"]
   if v and type(v) == "table" and v.enabled ~= false then
    if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
    self:OutputAttempts(v)
   end
  end

  -- HANDLE FISHING
  if fishing and opening == false then
   if isPool then self:Debug("Successfully fished from a pool")
   else self:Debug("Successfully fished") end
   if fishzones[tostring(GetCurrentMapAreaID())] or fishzones[zone] or fishzones[subzone] or fishzones[zone_t] or fishzones[subzone_t] then
    -- We're interested in fishing in this zone; let's find the item(s) involved
    for k, v in pairs(self.db.profile.groups) do
     if type(v) == "table" then
      for kk, vv in pairs(v) do
       if type(vv) == "table" then
        if vv.enabled ~= false then
         local found = false
         if vv.method == FISHING and vv.zones ~= nil and type(vv.zones) == "table" then
          for kkk, vvv in pairs(vv.zones) do
           if vvv == tostring(GetCurrentMapAreaID()) or vvv == zone or vvv == lbz[zone] or vvv == subzone or vvv == lbsz[subzone] or vvv == zone_t or vvv == subzone_t or vvv == lbz[zone_t] or vvv == subzone or vvv == lbsz[subzone_t] then
            if (vv.requiresPool and isPool) or not vv.requiresPool then
             found = true
            end
           end
          end
         end
         if found then
          if self:IsInstanceAppropriate(vv) then
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
  isPool = false

  -- Handle mining Elementium
  if prevSpell == miningSpell and (lastNode == L["Elementium Vein"] or lastNode == L["Rich Elementium Vein"]) then
   local v = self.db.profile.groups.pets["Elementium Geode"]
   if v and type(v) == "table" and v.enabled ~= false then
    if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
    self:OutputAttempts(v)
   end
  end

  -- HANDLE NORMAL NPC LOOTING
		local numItems = GetNumLootItems()
  local slotID

  -- Legacy support for pre-5.0 single-target looting
		local guid = UnitGUID("target")
		local name = UnitName("target")
		if not name or not guid then return end -- No target when looting
		if not UnitCanAttack("player", "target") then return end -- You targeted something you can't attack
		if UnitIsPlayer("target") then return end -- You targetted a player

		-- You're looting something that's alive -- this is only done for pickpocketing
		local requiresPickpocket = false
		if not UnitIsDead("target") then requiresPickpocket = true end

		-- Disallow "minus" NPCs; nothing good drops from them
		if UnitClassification(guid) == "minus" then return end -- (This doesn't actually work currently; UnitClassification needs a unit, not a GUID)

  local numChecked = 0
		for slotID = 1, numItems, 1 do -- Loop through all loot slots (for AoE looting)
   local guidlist
   if GetLootSourceInfo then
    guidlist = { GetLootSourceInfo(slotID) }
   else
    guidlist = { guid }
   end
   local guidIndex
   for k, v in pairs(guidlist) do -- Loop through all NPC GUIDs being looted (will be 1 for single-target looting pre-5.0)
    guid = v
    if guid and type(guid) == "string" then
     self:Debug("Checking NPC guid: "..guid)
     self:CheckNpcInterest(guid, zone, subzone, zone_t, subzone_t, curSpell, requiresPickpocket) -- Decide if we should increment an attempt count for this NPC
     numChecked = numChecked + 1
    else
     --self:Debug("Didn't check guid: "..guid or "nil")
    end -- Loop through all NPC GUIDs being looted (will be 1 for single-target looting pre-5.0)
   end -- Haven't seen this corpse yet
  end -- Loop through all loot slots (for AoE looting)

  -- If we failed to scan anything, scan the current target
  if numChecked <= 0 then self:CheckNpcInterest(UnitGUID("target"), zone, subzone, zone_t, subzone_t, curSpell) end
  
  -- Scan the loot to see if we found something we're looking for
		local numItems = GetNumLootItems()
  local slotID
		for slotID = 1, numItems, 1 do
			local _, _, qty = GetLootSlotInfo(slotID)
			if (qty or 0) > 0 then -- Coins have quantity of 0, so skip those
				local itemLink = GetLootSlotLink(slotID)
    if itemLink then
				 local _, itemId = strsplit(":", itemLink)
     itemId = tonumber(itemId)
     if items[itemId] ~= nil and items[itemId].method ~= COLLECTION then
      self:FoundItem(itemId, items[itemId])
     end
    end
			end
		end

  -- Update the tooltip if we're in it
  --if self:InTooltip() then self:ShowTooltip() end


 -- Detect bank, guild bank, auction house, tradeskill, trade, and mail. This turns off item use detection.
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
 elseif event == "MAIL_SHOW" then
  mailOpen = true

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
 elseif event == "MAIL_CLOSED" then
  mailOpen = false


	-- Instance lock info updated
	elseif event == "UPDATE_INSTANCE_INFO" then
		self:ScanInstanceLocks(event)
	elseif event == "LFG_UPDATE_RANDOM_INFO" then
		self:ScanInstanceLocks(event)

	-- Calendar updated
	elseif event == "CALENDAR_UPDATE_EVENT_LIST" then
		self:ScanCalendar(event)

	-- Toy box updated
	elseif event == "TOYS_UPDATED" then
		self:ScanExistingItems(event)

	-- Pets updated
	elseif event == "COMPANION_UPDATE" then
		self:ScanExistingItems(event)

 -- Logging out; end any open session
 elseif event == "PLAYER_LOGOUT" then
  if inSession then self:EndSession() end


 end
end


function R:CheckNpcInterest(guid, zone, subzone, zone_t, subzone_t, curSpell, requiresPickpocket)
 if guid == nil then return end
 if type(guid) ~= "string" then return end
 if guids[guid] ~= nil then return end -- Already seen this NPC

 local npcid = self:GetNPCIDFromGUID(guid)
 if npcs[npcid] == nil then -- Not an NPC we need, abort
		self:Debug("NPC ID not on the list of needed NPCs: "..(npcid or "nil"))
  -- Not a zone we need, abort
  if zones[tostring(GetCurrentMapAreaID())] == nil and zones[zone] == nil and zones[lbz[zone] or "."] == nil and zones[lbsz[subzone] or "."] == nil and zones[zone_t] == nil and zones[subzone_t] == nil and zones[lbz[zone_t] or "."] == nil and zones[lbsz[subzone_t] or "."] == nil then return end
 else
		self:Debug("NPC ID is one we need: "..(npcid or "nil"))
	end

 -- If the loot is the result of certain spell casts (mining, herbing, opening, pick lock, archaeology, disenchanting, etc), stop here
 if spells[curSpell] then
		self:Debug("Aborting because we were casting a disallowed spell: "..curSpell)
		return
	end

	-- If the loot is not from an NPC (could be from yourself or a world object), we don't want to process this
 local unitType, _, _, _, _, mob_id = strsplit('-', guid)
 if unitType ~= "Creature" and unitType ~= "Vehicle" then
		self:Debug("This loot isn't from an NPC; disregarding. Loot source identified as unit type: "..(unitType or "nil"))
		return
	end

	-- We're interested in this loot, process further
 guids[guid] = true
  
 -- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
 if npcs_to_items[npcid] and type(npcs_to_items[npcid]) == "table" then
  for k, v in pairs(npcs_to_items[npcid]) do
   if v.enabled ~= false and (v.method == NPC or v.method == ZONE) then
    if self:IsInstanceAppropriate(v) then
     -- Don't increment attempts if this NPC also has a statistic defined. This would result in two attempts counting instead of one.
     if not v.statisticId or type(v.statisticId) ~= "table" or #v.statisticId <= 0 then
						-- Don't increment attempts for unique items if you already have the item in your bags
						if not (v.unique == true and (bagitems[v.itemId] or 0) > 0) then
							-- Don't increment attempts for non-pickpocketed items if this item isn't being pickpocketed
							if (requiresPickpocket and v.pickpocket) or (requiresPickpocket == false and not v.pickpocket) then
								if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
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
								if tonumber(vvv) ~= nil and tonumber(vvv) == GetCurrentMapAreaID() then found = true end
        if vvv == zone or vvv == lbz[zone] or vvv == subzone or vvv == lbsz[subzone] or vvv == zone_t or vvv == subzone_t or vvv == lbz[zone_t] or vvv == subzone or vvv == lbsz[subzone_t] then found = true end
       end
      end
      if found then
       if self:IsInstanceAppropriate(vv) then
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


-------------------------------------------------------------------------------------
-- Something in your bags changed.
--
-- This is used for a couple things. First, for boss drops that require a group, you may not have obtained the item even if it dropped from the boss.
-- Therefore, we only say you obtained it when it appears in your inventory. Secondly, this is useful as a second line of defense in case
-- you somehow obtain an item without us noticing it. This event fires a lot, so we need to be fast.
--
-- We also store how many of every item you have on you at the moment. If we notice an item decreasing in quantity, and it's something we care
-- about, you just used an item or opened a container.
--
-- This event is bucketed because it tends to fire tons of times in a row rapidly, leading to innaccurate results.
-------------------------------------------------------------------------------------
function R:OnBagUpdate()
 self:Debug("BAG_UPDATE")

 -- Save a copy of your bags before this event
 table.wipe(tempbagitems)
 for k, v in pairs(bagitems) do
  tempbagitems[k] = v
 end

 -- Get a list of the items you have now, alerting if we find anything we're looking for
 self:ScanBags()

 if not bankOpen and not guildBankOpen and not auctionOpen and not tradeOpen and not tradeSkillOpen and not mailOpen then

		-- Check for a decrease in quantity of any items we're watching for
  for k, v in pairs(tempbagitems) do
   if (bagitems[k] or 0) < (tempbagitems[k] or 0) then -- An inventory item went down in count or disappeared
    if used[k] then -- It's an item we care about
					-- Scan through the whole item database now to find all items that could want this
					for _k, _v in pairs(self.db.profile.groups) do
						if type(_v) == "table" then
							for kk, vv in pairs(_v) do
								if type(vv) == "table" then
									if vv.enabled ~= false then
										if vv.method == USE and vv.items ~= nil and type(vv.items) == "table" then
											for kkk, vvv in pairs(vv.items) do
												if vvv == k then
													local i = vv
													if i.attempts == nil then i.attempts = 1 else i.attempts = i.attempts + 1 end
													self:OutputAttempts(i)
												end
											end
										end
									end
								end
							end
						end
					end
     -- End scan through all items
    end
   end
  end


		-- Check for an increase in quantity of any items we're watching for
  for k, v in pairs(bagitems) do

			-- Handle collection items
			if items[k] then
				if items[k].method == COLLECTION then
					local bagCount = (bagitems[k] or 0)

					-- Our items hashtable only saves one item for this collected item, so we have to scan to find them all now.
					-- Earlier, we pre-built a list of just the items that are COLLECTION items to save some time here.
					for kk, vv in pairs(Rarity.collection_items) do

						-- This item is a collection of several items; add them all up and check for attempts
						if type(vv.collectedItemId) == "table" then
							if vv.enabled ~= false then
								local total = 0
								local originalCount = (vv.attempts or 0)
								local goal = (vv.chance or 100)
								for kkk, vvv in pairs(vv.collectedItemId) do
									if (bagitems[vvv] or 0) > 0 then total = total + bagitems[vvv] end
								end
								if total > originalCount then
									vv.attempts = total
									if originalCount < goal and total >= goal then
										self:FoundItem(vv.itemId, vv)
									elseif total > originalCount then
										self:OutputAttempts(vv)
									end
								end
							end

						-- This item is a collection of a single type of item
						else
							if containsOrIs(items[k].collectedItemId, vv.collectedItemId) and vv.enabled ~= false then
								local originalCount = (vv.attempts or 0)
								local goal = (vv.chance or 100)
								vv.lastAttempts = 0
								if vv.attempts ~= bagCount then
									vv.attempts = bagCount
								end
								if originalCount < bagCount and originalCount < goal and bagCount >= goal then
									self:FoundItem(vv.itemId, vv)
								elseif originalCount < bagCount then
									self:OutputAttempts(vv)
								end
							end
						end

					end

				end
			end

			-- Other items
			if (bagitems[k] or 0) > (tempbagitems[k] or 0) then -- An inventory item went up in count
				if items[k] and items[k].enabled ~= false and items[k].method ~= COLLECTION then
					self:FoundItem(k, items[k])
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
 local i, ii
	table.wipe(bagitems)
	for i = 0, NUM_BAG_SLOTS do
		local numSlots = GetContainerNumSlots(i)
		if numSlots then
			for ii = 1, numSlots do
				local id = GetContainerItemID(i, ii)
				if id then
					local qty = select(2, GetContainerItemInfo(i, ii))
     if qty and qty > 0 then
						if not bagitems[id] then bagitems[id] = 0 end
						bagitems[id] = bagitems[id] + qty
     end
				end
			end
		end
	end
end


-------------------------------------------------------------------------------------
-- Handle boss kills. You may not ever open a loot window on a boss, so we need to watch the combat log for it's death.
-- This event also handles some special cases.
-------------------------------------------------------------------------------------
function R:OnCombat(event, timestamp, eventType, hideCaster, srcGuid, srcName, srcFlags, srcRaidFlags, dstGuid, dstName, dstFlags, dstRaidFlags, spellId, spellName, spellSchool, auraType, ...)
 if eventType == "UNIT_DIED" then -- A unit died near you
  local npcid = self:GetNPCIDFromGUID(dstGuid)
  if bosses[npcid] then -- It's a boss we're interested in
   if bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_MINE) or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_PARTY) or bit_band(srcFlags, COMBATLOG_OBJECT_AFFILIATION_RAID) then -- You, a party member, or a raid member killed it
    if not guids[dstGuid] then

     -- Increment attempts counter(s). One NPC might drop multiple things we want, so scan for them all.
     if npcs_to_items[npcid] and type(npcs_to_items[npcid]) == "table" then
      for k, v in pairs(npcs_to_items[npcid]) do
       if v.enabled ~= false and v.method == BOSS then
        if self:IsInstanceAppropriate(v) then
									guids[dstGuid] = true
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
-- When combat ends, we scan your statistics a few times. This helps catch some items that can't be tracked by normal means (i.e. Ragnaros),
-- as well as acting as another backup to detect attempts if we missed one. WoW can take a few seconds to update statistics, thus the repeated scans.
-------------------------------------------------------------------------------------
do
 local timer1, timer2, timer3
 function R:OnCombatEnded(event)
  --if R:InTooltip() then Rarity:ShowTooltip() end

		self:CancelTimer(timer1, true)
  self:CancelTimer(timer2, true)
  self:CancelTimer(timer3, true)

		self:ScanStatistics(event)

  timer1 = self:ScheduleTimer(function() Rarity:ScanStatistics(event.." 1") end, 2)
  timer2 = self:ScheduleTimer(function() Rarity:ScanStatistics(event.." 2") end, 5)
  timer3 = self:ScheduleTimer(function() Rarity:ScanStatistics(event.." 3") end, 10)
 end
end


-------------------------------------------------------------------------------------
-- Gathering detection (fishing, mining, etc.)
-------------------------------------------------------------------------------------

function R:GatherCompleted(event)
	prevSpell, curSpell = nil, nil
	foundTarget = false
 self:ScheduleTimer(function()
		R:Debug("Setting lastNode to nil")
		lastNode = nil
	end, 1)
end

function R:CursorChange(event)
	if foundTarget then return end
	if (MinimapCluster:IsMouseOver()) then return end
	local t = tooltipLeftText1:GetText()
 if self.miningnodes[t] or self.fishnodes[t] or self.opennodes[t] then lastNode = t end
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

local function cancelFish()
 R:Debug("You didn't loot anything from that fishing. Giving up.")
 fishingTimer = nil
 fishing = false
 isPool = false
	opening = false
end

function R:SpellStarted(event, unit, spellcast, rank, target)
	if unit ~= "player" then return end
	foundTarget = false
	ga ="No"
	if spells[spellcast] then
		curSpell = spellcast
		prevSpell = spellcast
  if spellcast == fishSpell or spellcast == openSpell then
   self:Debug("Fishing or opening something")
			if spellcast == openSpell then
				self:Debug("Opening detected")
				opening = true
			else
				opening = false
			end
   fishing = true
   if fishingTimer then self:CancelTimer(fishingTimer, true) end
   fishingTimer = self:ScheduleTimer(cancelFish, FISHING_DELAY)
		 self:GetWorldTarget()
  end
	else
		prevSpell, curSpell = nil, nil
	end
end

function R:GetWorldTarget()
	if foundTarget or not spells[curSpell] then return end
	if (MinimapCluster:IsMouseOver()) then return end
	local t = tooltipLeftText1:GetText()
	if t and prevSpell and t ~= prevSpell and R.fishnodes[t] then
  self:Debug("------YOU HAVE STARTED FISHING A NODE ------")
		fishing = true
  isPool = true
  if fishingTimer then self:CancelTimer(fishingTimer, true) end
  fishingTimer = self:ScheduleTimer(cancelFish, FISHING_DELAY)
		foundTarget = true
	end
end



-------------------------------------------------------------------------------------
-- Currency updates. Used for coin roll and archaeology solve detection.
-------------------------------------------------------------------------------------

function R:OnCurrencyUpdate(event)
	self:Debug("Currency updated ("..event..")")

	-- Check if any archaeology projects were solved
	self:ScanArchFragments(event)

	-- Check if any coins were used
 for k, v in pairs(self.coins) do
		local name, currencyAmount, texture, earnedThisWeek, weeklyMax, totalMax, isDiscovered = GetCurrencyInfo(k)
		local diff = currencyAmount - (coinamounts[k] or 0)
		coinamounts[k] = currencyAmount
  if diff < 0 then
			self:Debug("Used coin: "..name)
			R:CheckForCoinItem()
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 2)
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 5)
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 10)
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 15)
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 20)
			self:ScheduleTimer(function() R:CheckForCoinItem() end, 25)
		end
	end
end


function R:CheckForCoinItem()
	if self.lastCoinItem and self.lastCoinItem.enableCoin then
		self:Debug("COIN USE DETECTED FOR AN ITEM")
  if self.lastCoinItem.attempts == nil then self.lastCoinItem.attempts = 1 else self.lastCoinItem.attempts = self.lastCoinItem.attempts + 1 end
		self:OutputAttempts(self.lastCoinItem)
		self.lastCoinItem = nil
	end
end



-------------------------------------------------------------------------------------
-- Archaeology detection. Basically we look to see if you spent any fragments, and rescan your projects if so.
-------------------------------------------------------------------------------------

function R:ScanAllArch(event)
 self:UnregisterEvent("ARTIFACT_HISTORY_READY")
 self:ScanArchFragments(event)
 self:ScanArchProjects(event)
end

function R:ScanArchFragments(event)
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
 if scan then
  -- Scan now, and later. The server takes a while to decide on the next project. The time it takes varies considerably.
  self:ScanArchProjects(event)
  self:ScheduleTimer(function() R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 1") end, 2)
  self:ScheduleTimer(function() R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 2") end, 5)
  self:ScheduleTimer(function() R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 3") end, 10)
  self:ScheduleTimer(function() R:ScanArchProjects("SOLVED AN ARTIFACT - DELAYED 4") end, 20)
 end
end

function R:ScanArchProjects(reason)
	self:Debug("Scanning archaeology projects (%s)", reason)
	if GetNumArchaeologyRaces() == 0 then return end
	for race_id = 1, GetNumArchaeologyRaces() do
		local name = GetActiveArtifactByRace(race_id)
  		if architems[name] then
   			-- We started a project we were looking for!
   			local id = architems[name].itemId
   			if id then 
   				self:FoundItem(id, items[id]) 
   			end
  		end
 	end
end

-------------------------------------------------------------------------------------
-- Mouseover detection, currently used for Mysterious Camel Figurine as a special case
-------------------------------------------------------------------------------------

function R:OnMouseOver(event)
 local guid = UnitGUID("mouseover")
 local npcid = self:GetNPCIDFromGUID(guid)

 if npcid == 50409 or npcid == 50410 then
  if not guids[guid] then
   guids[guid] = true
   local v = self.db.profile.groups.mounts["Reins of the Grey Riding Camel"]
   if v and type(v) == "table" and v.enabled ~= false then
    if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
    self:OutputAttempts(v)
   end
  end
 end

end

-------------------------------------------------------------------------------------
-- Criteria in a dungeon completed, currently used for Reins of the Infinite Timereaver detection as a special case
-------------------------------------------------------------------------------------

function R:OnCriteriaComplete(event, id)
	if id == 24801 --[[ Ozumat ]] or id == 24803 --[[ Murozond ]] then
		local v = self.db.profile.groups.mounts["Reins of the Infinite Timereaver"]
		if v and type(v) == "table" and v.enabled ~= false and R:IsInstanceAppropriate(v) then
			if v.attempts == nil then v.attempts = 1 else v.attempts = v.attempts + 1 end
			R:OutputAttempts(v)
		end
	end
end


-------------------------------------------------------------------------------------
-- Pet battles: we want to hide the progress bar(s) during them
-------------------------------------------------------------------------------------

local wasBarVisibleBeforePetBattle = false

function R:OnPetBattleStart(event)
	R:Debug("Pet battle started")
	wasBarVisibleBeforePetBattle = R.db.profile.bar.visible
 R.db.profile.bar.visible = false
	Rarity:UpdateBar()
 Rarity:UpdateText()
end

function R:OnPetBattleEnd(event)
	R:Debug("Pet battle ended")
 R.db.profile.bar.visible = wasBarVisibleBeforePetBattle
	Rarity:UpdateBar()
 Rarity:UpdateText()
end



--[[
      GAME TOOLTIPS ------------------------------------------------------------------------------------------------------------
  ]]

		
		
-- TOOLTIP: NPCS

_G.GameTooltip:HookScript("OnTooltipSetUnit", function(self)
	if R.db.profile.enableTooltipAdditions == false then return end



	local name, unit = self:GetUnit()
	if not unit then return end
	local creatureType = UnitCreatureType(unit)
	--Rarity:Debug("Creature type: "..(creatureType or "nil").." (translation: "..(lbct[creatureType] or "nil")..")")
	if creatureType == "Critter" or lbct[creatureType] == "Critter" or creatureType == "Non-combat Pet" or lbct[creatureType] == "Non-combat Pet" or creatureType == "Wild Pet" or lbct[creatureType] == "Wild Pet" then
		return
	end

	local guid = UnitGUID(unit)
	if not unit or not guid then return end
	local npcid = R:GetNPCIDFromGUID(guid)
	if not UnitCanAttack("player", unit) and not Rarity.db.profile.oneTimeItems[npcid] then return end -- Something you can't attack (but allow this for one-time items)
	if UnitIsPlayer(unit) then return end -- A player
	if UnitIsPVP(unit) then return end -- A PVP flagged unit

	local blankAdded = false
	local rarityAdded = false

	-- This NPC is known to be used for obtaining something
 if npcs_to_items[npcid] and type(npcs_to_items[npcid]) == "table" then
  for k, v in pairs(npcs_to_items[npcid]) do
   if R:IsInstanceAppropriate(v) then
    if (v.requiresHorde and R:IsHorde()) or (v.requiresAlliance and not R:IsHorde()) or (not v.requiresHorde and not v.requiresAlliance) then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)
					if itemLink or itemName or v.name then
						if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
							blankAdded = true
							GameTooltip:AddLine(" ")
						end
						local chance = v.chance or 0
						if v.method == BOSS and v.groupSize ~= nil and v.groupSize > 1 and not v.equalOdds then chance = chance * v.groupSize end
						local attemptText = " "..colorize(format(L["(%d/%d attempts)"], v.attempts or 0, chance or 0), white)
						if v.method == COLLECTION then attemptText = " "..colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white) end
						if v.known or Rarity.db.profile.tooltipAttempts == false then attemptText = "" end
						GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName or v.name)..attemptText, yellow))
						rarityAdded = true
						if v.pickpocket then
							local class, classFileName = UnitClass("player")
							local pickcolor
							if classFileName == "ROGUE" then pickcolor = green else pickcolor = red end
							GameTooltip:AddLine(colorize(L["Requires Pickpocketing"], pickcolor))
						end
						if v.known then
							GameTooltip:AddLine(colorize(L["Already known"], red))
							blankAdded = false
						end
						GameTooltip:Show()
					end
				end
			end
		end
	end

	blankAdded = false

	-- One-time items
 if Rarity.db.profile.oneTimeItems[npcid] and type(Rarity.db.profile.oneTimeItems[npcid]) == "table" then
		if Rarity.db.profile.oneTimeItems[npcid].itemId ~= 99999 then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(Rarity.db.profile.oneTimeItems[npcid].itemId)
			if itemLink or itemName then
				if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
					blankAdded = true
					GameTooltip:AddLine(" ")
				end
				if Rarity.db.profile.oneTimeItems[npcid].questId ~= nil and IsQuestFlaggedCompleted(Rarity.db.profile.oneTimeItems[npcid].questId) then
					GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName), yellow))
					GameTooltip:AddLine(colorize(L["Already defeated"], red))
					blankAdded = false
					rarityAdded = true
				else
					scanTip:ClearLines()
					scanTip:SetItemByID(Rarity.db.profile.oneTimeItems[npcid].itemId)

					GameTooltip:AddDoubleLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName), yellow), "|T"..itemTexture..":22|t")
					rarityAdded = true

					for i = 2, scanTip:NumLines() do
						local myLeft = _G["__Rarity_ScanTipTextLeft"..i]
						local txtLeft = myLeft:GetText()
						local leftR, leftG, leftB, leftAlpha = myLeft:GetTextColor() 
						local myRight = _G["__Rarity_ScanTipTextRight"..i]
						local txtRight = myRight:GetText()
						local rightR, rightG, rightB, rightAlpha = myRight:GetTextColor() 
						if txtRight then
							GameTooltip:AddDoubleLine(txtLeft, txtRight, leftR, leftG, leftB, rightR, rightB, rightG)
						else
							GameTooltip:AddLine(txtLeft, leftR, leftG, leftB, true)
						end
					end
				end -- showing item tooltip
			end
		end
	end

	blankAdded = false

	-- NPC is required for an achievement
	if Rarity.ach_npcs_achId[name] then
		local link = GetAchievementLink(Rarity.ach_npcs_achId[name])
		if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
			blankAdded = true
			GameTooltip:AddLine(" ")
		end
		if not Rarity.ach_npcs_isKilled[name] then
			GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or ""), yellow)..colorize(format(L["Required for %s"], link), green))
		else
			GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or ""), yellow)..colorize(format(L["Already defeated for %s"], link), red))
		end
		rarityAdded = true
	end

	-- This whole zone is used for obtaining something
	if not UnitCanAttack("player", unit) then return end -- Something you can't attack
	if UnitIsPlayer(unit) then return end -- A player
	local unitType = tonumber(guid:sub(5, 5), 16) or 0
	if unitType ~= 3 and unitType ~= 5 then return end

 local zone = GetRealZoneText()
 local subzone = GetSubZoneText()
 local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
 local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]
 if zones[tostring(GetCurrentMapAreaID())] or zones[zone] or zones[lbz[zone] or "."] or zones[lbsz[subzone] or "."] or zones[zone_t] or zones[subzone_t] or zones[lbz[zone_t] or "."] or zones[lbsz[subzone_t] or "."] then
		for k, v in pairs(R.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						local found = false
						if vv.method == ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
							for kkk, vvv in pairs(vv.zones) do
								if tonumber(vvv) ~= nil and tonumber(vvv) == GetCurrentMapAreaID() then found = true end
								if vvv == zone or vvv == lbz[zone] or vvv == subzone or vvv == lbsz[subzone] or vvv == zone_t or vvv == subzone_t or vvv == lbz[zone_t] or vvv == subzone or vvv == lbsz[subzone_t] then found = true end
							end
						end
						if found then
							if R:IsInstanceAppropriate(vv) then
								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(vv.itemId)
								if itemLink or itemName or vv.name then
									if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
										blankAdded = true
										GameTooltip:AddLine(" ")
									end
									local chance = vv.chance or 0
									if vv.method == BOSS and vv.groupSize ~= nil and vv.groupSize > 1 and not vv.equalOdds then chance = chance * vv.groupSize end
									local attemptText = " "..colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
									if vv.method == COLLECTION then attemptText = " "..colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white) end
									if vv.known or Rarity.db.profile.tooltipAttempts == false then attemptText = "" end
									GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName or vv.name)..attemptText, yellow))
									rarityAdded = true
									if vv.known then
										GameTooltip:AddLine(colorize(L["Already known"], red))
										blankAdded = false
									end
									GameTooltip:Show()
								end
							end
						end
					end
				end
			end
		end
	end


	
end)



-- TOOLTIP: ITEMS IN INVENTORY

hooksecurefunc(GameTooltip, "SetBagItem", function(self, bag, slot)
	local blankAdded = false
 local id = GetContainerItemID(bag, slot)
 if id then
		local item
		local rarityAdded = false

		-- This item is used to obtain another item
		if items_to_items[id] then
			for k, v in pairs(items_to_items[id]) do
				if v.itemId then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)
					if itemLink or itemName or v.name then
						if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
							blankAdded = true
							GameTooltip:AddLine(" ")
						end
						local chance = v.chance or 0
						if v.method == BOSS and v.groupSize ~= nil and v.groupSize > 1 and not v.equalOdds then chance = chance * v.groupSize end
						local attemptText = " "..colorize(format(L["(%d/%d attempts)"], v.attempts or 0, chance or 0), white)
						if v.method == COLLECTION then attemptText = " "..colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white) end
						if v.known or Rarity.db.profile.tooltipAttempts == false then attemptText = "" end
						GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName or v.name)..attemptText, yellow))
						rarityAdded = true
						if v.known then
							GameTooltip:AddLine(colorize(L["Already known"], red))
							blankAdded = false
						end
						GameTooltip:Show()
					end
				end
			end
		end

		blankAdded = false
		
		-- Extra item tooltips
		if R.db.profile.extraTooltips.inventoryItems[id] then
			for x, y in pairs(R.db.profile.extraTooltips.inventoryItems[id]) do
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(y)
				if itemLink or itemName then
					if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
						blankAdded = true
						GameTooltip:AddLine(" ")
					end
					for k, v in pairs(R.db.profile.groups) do
						if type(v) == "table" then
							for kk, vv in pairs(v) do
								if type(vv) == "table" then
									if vv.itemId == y then
										if R:IsInstanceAppropriate(vv) then
											local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(vv.itemId)
											if itemLink or itemName or vv.name then
												if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
													blankAdded = true
													GameTooltip:AddLine(" ")
												end
												local chance = vv.chance or 0
												if vv.method == BOSS and vv.groupSize ~= nil and vv.groupSize > 1 and not vv.equalOdds then chance = chance * vv.groupSize end
												local attemptText = " "..colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
												if vv.method == COLLECTION then attemptText = " "..colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white) end
												if vv.known or Rarity.db.profile.tooltipAttempts == false then attemptText = "" end
												GameTooltip:AddLine(colorize((not rarityAdded and L["Rarity: "] or "")..(itemLink or itemName or vv.name)..attemptText, yellow))
												rarityAdded = true
												if vv.known then
													GameTooltip:AddLine(colorize(L["Already known"], red))
													blankAdded = false
												end
												GameTooltip:Show()
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

 end
end)
		
		
		
		
		
--[[
      DATA BROKER OBJECT, AND TOOLTIP, BAR -------------------------------------------------------------------------------------------
  ]]

		
function R:UpdateBar()
	if not self.barGroup:GetBars() then return end
	if not self.db.profile.bar.font then self.barGroup:SetFont(self.db.profile.bar.font, self.db.profile.bar.fontSize or 8)
	else	self.barGroup:SetFont(media:Fetch("font", self.db.profile.bar.font), self.db.profile.bar.fontSize or 8) end
	if self.db.profile.bar.texture then self.barGroup:SetTexture(media:Fetch("statusbar", self.db.profile.bar.texture)) end
	if self.db.profile.bar.rightAligned then self.barGroup:SetOrientation(3) else self.barGroup:SetOrientation(1) end
	if self.db.profile.bar.showIcon then self.barGroup:ShowIcon() else self.barGroup:HideIcon() end
	if self.db.profile.bar.showText then self.barGroup:ShowLabel() else self.barGroup:HideLabel() end
	self.barGroup:SetColorAt(1.00, 1, 0, 0, 1) -- These SetColorAt calls appear to take longer and longer to execute every time they are called.
	self.barGroup:SetColorAt(0.66, 1, 1, 0, 1) -- Only do this when absolutely necessary.
	self.barGroup:SetColorAt(0.33, 0, 1, 1, 1)
	self.barGroup:SetColorAt(0.00, 0, 0, 1, 1)
 self.barGroup:ClearAllPoints()
	self.barGroup:SetPoint(self.db.profile.bar.point, UIParent, self.db.profile.bar.relativePoint, self.db.profile.bar.x, self.db.profile.bar.y)
	self.barGroup:SetScale(self.db.profile.bar.scale)
 self.barGroup:SetWidth(self.db.profile.bar.width)
 self.barGroup:SetHeight(self.db.profile.bar.height)
 if not self.db.profile.bar.visible then self.barGroup:Hide() else self.barGroup:Show() end
 if not self.db.profile.bar.anchor then self.barGroup:HideAnchor() else self.barGroup:ShowAnchor() end
 if not self.db.profile.bar.locked then self.barGroup:Unlock() else self.barGroup:Lock() end
end
		
do
	local tooltip, tooltip2
	local frame, frame2
	local headers = {}

 function R:UpdateText()
		self:ProfileStart()
  local attempts, dropChance, chance = 0, 0, 0

  if not trackedItem or (trackedItem and not trackedItem.itemId) then
   dataobj.text = L["None"]
   return
  end

  -- Feed text
  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem.itemId)
  if not itemTexture then dataobj.icon = [[Interface\Icons\spell_nature_forceofnature]]
  else dataobj.icon = itemTexture end
  attempts = 0
  if trackedItem.attempts then attempts = trackedItem.attempts end
  if trackedItem.lastAttempts then attempts = attempts - trackedItem.lastAttempts end
  if trackedItem.realAttempts and trackedItem.found and not trackedItem.repeatable then attempts = trackedItem.realAttempts end
  if trackedItem.found and not trackedItem.repeatable then
			if trackedItem.method == COLLECTION then
				dataobj.text = L["Collection complete!"]
			else
				if attempts == 1 then dataobj.text = format(L["Found on your first attempt!"], attempts)
				else dataobj.text = format(L["Found after %d attempts!"], attempts) end
			end
   chance = 100.0
  else
			if trackedItem.method == COLLECTION then
				chance = (trackedItem.attempts or 0) / (trackedItem.chance or 100)
				if chance < 0 then chance = 0 end
				if chance > 1 then chance = 1 end
				chance = chance * 100
				dataobj.text = format(L["%d collected - %.2f%%"], attempts, chance)
			else
				dropChance = (1.00 / (trackedItem.chance or 100))
				if trackedItem.method == BOSS and trackedItem.groupSize ~= nil and trackedItem.groupSize > 1 and not trackedItem.equalOdds then dropChance = dropChance / trackedItem.groupSize end
				chance = 100 * (1 - math.pow(1 - dropChance, attempts))
				if self.db.profile.feedText == FEED_MINIMAL then
					if attempts == 1 then dataobj.text = format(L["%d attempt"], attempts)
					else dataobj.text = format(L["%d attempts"], attempts) end
				elseif self.db.profile.feedText == FEED_VERBOSE then
					if attempts == 1 then dataobj.text = format(L["%s: %d attempt - %.2f%%"], itemLink or trackedItem.name, attempts, chance)
					else dataobj.text = format(L["%s: %d attempts - %.2f%%"], itemLink or trackedItem.name, attempts, chance) end
				else
					if attempts == 1 then dataobj.text = format(L["%d attempt - %.2f%%"], attempts, chance)
					else dataobj.text = format(L["%d attempts - %.2f%%"], attempts, chance) end
				end
			end
  end

  -- Bar 1
  if not chance then chance = 0 end
  if chance > 100 then chance = 100 end
  if chance < 0 then chance = 0 end
  local text = format("%s: %d (%.2f%%)", itemName or trackedItem.name, attempts, chance)
		if not self.bar then
			self.bar = self.barGroup:NewCounterBar("Track", text, chance, 100, itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
		else
			self.bar:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
			self.bar:SetLabel(text)
			self.bar:SetValue(chance, 100)
		end
		if self.hadBarTwo then -- If we've transitioning from 2 bars to 1, hiding/showing the bars collapses them upwards
			self.barGroup:Hide()
			if self.db.profile.bar.visible then self.barGroup:Show() end
		end

		-- Bar 2
		if trackedItem2 == nil or trackedItem2.itemId == nil then
			self.barGroup:RemoveBar("Track2")
			self.bar2 = nil
		else
			self.hadBarTwo = true
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem2.itemId)
			attempts = 0
			if trackedItem2.attempts then attempts = trackedItem2.attempts end
			if trackedItem2.lastAttempts then attempts = attempts - trackedItem2.lastAttempts end
			if trackedItem2.realAttempts and trackedItem2.found and not trackedItem2.repeatable then attempts = trackedItem2.realAttempts end
			if trackedItem2.found and not trackedItem2.repeatable then
				chance = 1.0
			else
				if trackedItem2.method == COLLECTION then
					chance = (trackedItem2.attempts or 0) / (trackedItem2.chance or 100)
					if chance < 0 then chance = 0 end
					if chance > 1 then chance = 1 end
					chance = chance * 100
				else
					dropChance = (1.00 / (trackedItem2.chance or 100))
					if trackedItem2.method == BOSS and trackedItem2.groupSize ~= nil and trackedItem2.groupSize > 1 and not trackedItem2.equalOdds then dropChance = dropChance / trackedItem2.groupSize end
					chance = 100 * (1 - math.pow(1 - dropChance, attempts))
				end
			end
			if not chance then chance = 0 end
			if chance > 100 then chance = 100 end
			if chance < 0 then chance = 0 end
			local text = format("%s: %d (%.2f%%)", trackedItem2.name or "", attempts, chance)
			if not self.bar2 then
				self.bar2 = self.barGroup:NewCounterBar("Track2", text, chance, 100, itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
			else
				self.bar2:SetIcon(itemTexture or [[Interface\Icons\spell_nature_forceofnature]])
				self.bar2:SetLabel(text)
				self.bar2:SetValue(chance, 100)
			end
		end
		self:ProfileStop("UpdateText: %fms")
 end


	function dataobj.OnEnter(self)
		frame = self
		Rarity:ShowTooltip()
	end


	function dataobj.OnLeave(self)
	end
	
	
	function R:InTooltip()
		return qtip:IsAcquired("RarityTooltip")
	end


	function dataobj:OnClick(button)
  if IsShiftKeyDown() then
   -- Show options
		 LoadAddOn("Rarity_Options")
		 if R.optionsFrame then
			 InterfaceOptionsFrame_OpenToCategory(R.optionsFrame)
		 else
			 R:Print(L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."])
		 end
  elseif IsControlKeyDown() then
   -- Change sort order
   if R.db.profile.sortMode == SORT_NAME then R.db.profile.sortMode = SORT_CATEGORY
   elseif R.db.profile.sortMode == SORT_CATEGORY then R.db.profile.sortMode = SORT_DIFFICULTY
   elseif R.db.profile.sortMode == SORT_DIFFICULTY then R.db.profile.sortMode = SORT_PROGRESS
   else R.db.profile.sortMode = SORT_NAME
   end
   Rarity:ShowTooltip()
  else
   -- Toggle progress bar visibility
   R.db.profile.bar.visible = not R.db.profile.bar.visible
			Rarity:UpdateBar()
   Rarity:UpdateText()
  end
	end


	local function tooltip2AddLine(value)
		local lineIndex = tooltip2:AddLine()
		tooltip2:SetCell(lineIndex, 1, value, nil, nil, 2, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
	end


	local function tooltip2AddDoubleLine(value1, value2)
		local lineIndex = tooltip2:AddLine()
		tooltip2:SetCell(lineIndex, 1, value1, nil, nil, 1, qtip.LabelProvider, nil, nil, STATUS_TOOLTIP_MAX_WIDTH)
		tooltip2:SetCell(lineIndex, 2, value2)
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

  if R.db.profile.statusTip == TIP_RIGHT then
		 tooltip2:SetPoint("LEFT", cell, "RIGHT", 30, 0)
  elseif R.db.profile.statusTip == TIP_LEFT then
		 tooltip2:SetPoint("RIGHT", cell, "LEFT", -30, 0)
  end

  local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)

  -- Rarity extended information tooltip
  if R.db.profile.statusTip == TIP_HIDDEN then return end

		if itemTexture ~= nil then
			tooltip2:AddHeader(itemLink or item.name, "|T"..itemTexture..":22|t")
		else
			tooltip2:AddHeader(itemLink or item.name)
		end
		scanTip:ClearLines()
		if item.isToy then scanTip:SetToyByItemID(item.itemId) else scanTip:SetItemByID(item.itemId) end
		for i = 2, scanTip:NumLines() do
			local myLeft = _G["__Rarity_ScanTipTextLeft"..i]
			local txtLeft = myLeft:GetText()
			local leftR, leftG, leftB, leftAlpha = myLeft:GetTextColor() 
			local myRight = _G["__Rarity_ScanTipTextRight"..i]
			local txtRight = myRight:GetText()
			local rightR, rightG, rightB, rightAlpha = myRight:GetTextColor() 
			if txtRight then
				tooltip2AddDoubleLine(colorizeV(txtLeft, leftR, leftG, leftB), colorizeV(txtRight, rightR, rightG, rightB))
			else
				tooltip2AddLine(colorizeV(txtLeft, leftR, leftG, leftB))
			end
		end
		tooltip2:AddSeparator(1, 1, 1, 1, 1)

		local catIcon = ""
		if item.cat and Rarity.catIcons[item.cat] then catIcon = [[ |TInterface\AddOns\Rarity\Icons\]]..Rarity.catIcons[item.cat]..".blp:0:4|t" end
  if R.string_types[item.type] ~= nil then tooltip2AddLine(colorize((R.string_types[item.type] or "UNKNOWN")..catIcon, yellow)) end
  if item.groupSize and item.groupSize > 1 then
   tooltip2AddLine(colorize(format(L["Usually requires a group of around %d players"], item.groupSize), red))
  end
  if item.method == SPECIAL and item.obtain then
   tooltip2AddLine(colorize(item.obtain, blue))
  else
		local actualMethod = item.method
		if item.method == BOSS and item.groupSize and item.groupSize > 1 then actualMethod = BOSS else if item.method == BOSS then actualMethod = NPC end end
   tooltip2AddLine(colorize(R.string_methods[actualMethod], blue))
  end
		if item.pickpocket then
			local class, classFileName = UnitClass("player")
			local pickcolor
			if classFileName == "ROGUE" then pickcolor = green else pickcolor = red end
			tooltip2AddLine(colorize(L["Requires Pickpocketing"], pickcolor))
		end
  if item.method == ZONE or item.method == FISHING then
   if item.zones and type(item.zones) == "table" then
    for k, v in pairs(item.zones) do
     local zone = lbz[v]
     if not zone then zone = lbsz[v] end
     if not zone then zone = v end
     if not tonumber(v) then tooltip2AddLine(colorize("    "..v, gray)) end
    end
   end
  elseif item.method == ARCH then
   if item.raceId then
    tooltip2AddLine(colorize("    "..R.string_archraces[item.raceId], gray))
   end
  elseif item.method == USE then
   if item.items and type(item.items) == "table" then
    for k, v in pairs(item.items) do
     local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v)
     if itemLink then tooltip2AddLine("    "..itemLink) end
    end
   end
  end
		
		-- Source text, bonus satchel, black market, etc.
		local hadSource = false
		if item.type == MOUNT and item.spellId ~= nil and Rarity.mount_sources[item.spellId] ~= nil then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
			tooltip2AddLine(Rarity.mount_sources[item.spellId])
			hadSource = true
		end
		if item.type == PET and item.creatureId ~= nil and Rarity.pet_sources[item.creatureId] ~= nil then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
			tooltip2AddLine(Rarity.pet_sources[item.creatureId])
			hadSource = true
		end
		if item.sourceText ~= nil and item.sourceText ~= "" then
			tooltip2AddLine(item.sourceText)
			hadSource = true
		end
		if item.worldBossFactionless then
			tooltip2AddLine(colorize(L["All players can participate in killing this world boss once per week, regardless of faction"], blue))
		end
		if item.wasGuaranteed then
			tooltip2AddLine(colorize(L["This was a guaranteed drop for players who defeated the encounter when it was current"], blue))
		end
		if item.bonusSatchel then
			tooltip2AddLine(colorize(L["Contained in bonus satchels"], yellow))
		end
		if item.blackMarket then
			tooltip2AddLine(colorize(L["Appears in the Black Market"], yellow))
		end
		if item.enableCoin then
			tooltip2AddLine(colorize(L["Can be obtained with a bonus roll"], yellow))
		end
		if item.requiresAlliance then
			tooltip2AddLine(colorize(L["This mount is only obtainable by Alliance players"], red))
		end
		if item.requiresHorde then
			tooltip2AddLine(colorize(L["This mount is only obtainable by Horde players"], red))
		end
		if hadSource or item.bonusSatchel or item.blackMarket or item.wasGuaranteed or item.worldBossFactionless or item.requiresAlliance or item.requiresHorde then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
		end

		-- Zone(s)
		local zoneText = ""
		local currentZone = GetCurrentMapAreaID()
		if item.coords ~= nil and type(item.coords) == "table" then
			local zoneList = {}
			for _, zoneValue in pairs(item.coords) do
				if type(zoneValue) == "table" and zoneValue.m ~= nil then
					local doThisZone = false
					if zoneList[zoneValue.m] == nil then
						zoneList[zoneValue.m] = true
						doThisZone = true
					end
					if doThisZone then
						if zoneText ~= "" then zoneText = zoneText..", " end
						if currentZone == zoneValue.m then
							zoneText = zoneText..colorize(GetMapNameByID(zoneValue.m) or "", green)
						else
							zoneText = zoneText..colorize(GetMapNameByID(zoneValue.m) or "", gray)
						end
					end
				end
			end
			if zoneText ~= "" then
				tooltip2AddLine(L["Found in: "]..zoneText)
				tooltip2:AddSeparator(1, 1, 1, 1, 1)
			end
		end

		-- Collection info
		if item.method == COLLECTION then
			local collectText = ""
			if type(item.collectedItemId) ~= "table" then
				local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.collectedItemId)
				collectText = itemLink or itemName or ""
			else
				for k, v in pairs(item.collectedItemId) do
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v)
					if collectText ~= "" then collectText = collectText..", " end
					collectText = collectText..(itemLink or itemName or "")
				end
			end
			tooltip2AddLine(colorize(format(L["Collect %d %s"], item.chance or 100, collectText), white))
			if item.obtain then tooltip2AddLine(colorize(item.obtain, white)) end
		else
			tooltip2AddLine(colorize(format(L["1 in %d chance"], item.chance or 100), white))
		end
  local dropChance = (1.00 / (item.chance or 100))
  if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
  local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
  if item.method ~= COLLECTION then tooltip2AddLine(colorize(format(L["Lucky if you obtain in %d or less"], medianLoots), gray)) end

		-- Time and progress
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
  local len = (sessionLast or 0) - (sessionStarted or 0)
  local tracked = R:FindTrackedItem()
  if not inSession or not len or tracked ~= item then len = 0 end

  if item.totalFinds and item.method ~= COLLECTION then
   tooltip2AddLine(colorize(L["Since last drop"], yellow))
  end
  local attempts = (item.attempts or 0) - (item.lastAttempts or 0)
  if item.method == COLLECTION then
			tooltip2AddDoubleLine(L["Collected"], attempts)
		else
			tooltip2AddDoubleLine(L["Attempts"], attempts)
		end
  if item.method == NPC or item.method == ZONE or item.method == FISHING or item.method == USE then
   tooltip2AddDoubleLine(L["Time spent farming"], R:FormatTime((item.time or 0) - (item.lastTime or 0) + len))
  end
  if attempts > 0 then
			if item.method == COLLECTION then
				local chance = 100 * (attempts / (item.chance or 100))
				if chance > 100 then chance = 100 end
				if chance < 0 then chance = 0 end
				tooltip2AddDoubleLine(L["Progress"], format("%.2f%%", chance))
			else
				local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
				tooltip2AddDoubleLine(L["Chance so far"], format("%.2f%%", chance))
			end
  end
  
  if item.totalFinds and item.method ~= COLLECTION then
		 tooltip2:AddSeparator(1, 1, 1, 1, 1)
   tooltip2AddLine(colorize(L["Total"], yellow))
   local attempts = (item.attempts or 0)
   tooltip2AddDoubleLine(L["Attempts"], attempts)
   if item.method == NPC or item.method == ZONE or item.method == FISHING or item.method == USE then
    tooltip2AddDoubleLine(L["Time spent farming"], R:FormatTime((item.time or 0) + len))
   end
   tooltip2AddDoubleLine(L["Total found"], item.totalFinds)
   if item.finds then
		  tooltip2:AddSeparator(1, 1, 1, 1, 1)
    local f = sort2(item.finds)
    for k, v in pairs(f) do
     local dropChance = (1.00 / (item.chance or 100))
     local chance = 100 * (1 - math.pow(1 - dropChance, v.attempts))
     if item.method == BOSS and item.groupSize ~= nil and item.groupSize > 1 and not item.equalOdds then dropChance = dropChance / item.groupSize end
     if v.attempts == 1 then tooltip2AddDoubleLine(format(L["#%d: %d attempt (%.2f%%)"], v.num, v.attempts, chance), R:FormatTime((v.time or 0) + len))
     else tooltip2AddDoubleLine(format(L["#%d: %d attempts (%.2f%%)"], v.num, v.attempts, chance), R:FormatTime((v.time or 0) + len)) end
    end
   end
  end

		-- Session/time period breakdown
  if item.dates and item.method ~= COLLECTION then
   tooltip2:AddSeparator(1, 1, 1, 1, 1)

   if item.session then
    local sessionAttempts = item.session.attempts or 0
    local sessionTime = item.session.time or 0
    tooltip2AddDoubleLine(L["Session"], format("%d (%s)", sessionAttempts, R:FormatTime(sessionTime + len)))
   end

   local todayDate = getDate() 
   local yesterDate = getDate(86400)
   local todayAttempts = item.dates[todayDate] and item.dates[todayDate].attempts or 0
   local todayTime = item.dates[todayDate] and item.dates[todayDate].time or 0
   if tracked == item and inSession then todayTime = todayTime + len end
   local yesterAttempts = item.dates[yesterDate] and item.dates[yesterDate].attempts or 0
   local yesterTime = item.dates[yesterDate] and item.dates[yesterDate].time or 0
   local weekAttempts = (todayAttempts or 0) + (yesterAttempts or 0)
   local weekTime = (todayTime or 0) + (yesterTime or 0)
   for day = 2, 6 do
    local dt = getDate(day * 86400)
	   local dayAttempts = item.dates[dt] and item.dates[dt].attempts or 0
    local dayTime = item.dates[dt] and item.dates[dt].time or 0
    weekAttempts = weekAttempts + dayAttempts
    weekTime = weekTime + dayTime
   end
   local monthAttempts = weekAttempts
   local monthTime = weekTime
   for day = 7, 29 do
    local dt = getDate(day * 86400)
	   local dayAttempts = item.dates[dt] and item.dates[dt].attempts or 0
    local dayTime = item.dates[dt] and item.dates[dt].time or 0
    monthAttempts = monthAttempts + dayAttempts
    monthTime = monthTime + dayTime
   end

   tooltip2AddDoubleLine(L["Today"], format("%d (%s)", todayAttempts or 0, R:FormatTime((todayTime or 0) + len)))
   tooltip2AddDoubleLine(L["Yesterday"], format("%d (%s)", yesterAttempts or 0, R:FormatTime(yesterTime or 0)))
   tooltip2AddDoubleLine(L["Last Week"], format("%d (%s)", weekAttempts or 0, R:FormatTime(weekTime or 0)))
   tooltip2AddDoubleLine(L["Last Month"], format("%d (%s)", monthAttempts or 0, R:FormatTime(monthTime or 0)))

  end

		-- Multi-step defeat detection
		if item.defeatSteps ~= nil and type(item.defeatSteps) == "table" then
			tooltip2:AddSeparator(1, 1, 1, 1, 1)
			for defeatStepQuest, defeatStepText in pairs(item.defeatSteps) do
				local defeated = colorize(L["Undefeated"], green)
				if IsQuestFlaggedCompleted(defeatStepQuest) then defeated = colorize(L["Defeated"], red) end
				tooltip2AddDoubleLine(defeatStepText, defeated)
			end
		end
		
		-- Click instructions
		tooltip2:AddSeparator(1, 1, 1, 1, 1)
  tooltip2AddLine(colorize(L["Click to switch to this item"], gray))
  tooltip2AddLine(colorize(L["Shift-Click to link your progress to chat"], gray))

		-- Waypoint instructions
		if item.coords ~= nil and type(item.coords) == "table" then
			local numCoords = 0
			local totalCoords = 0
			for _, coord in pairs(item.coords) do
				if type(coord) == "table" and coord.x ~= nil and coord.y ~= nil and coord.m ~= nil then
					totalCoords = totalCoords + 1
					if coord.q ~= nil then
						if IsQuestFlaggedCompleted(coord.q) == false then numCoords = numCoords + 1 end
					else
						numCoords = numCoords + 1
					end
				end
			end
			if totalCoords > 0 then
				local s = format(L["Rarity has %d |4coordinate:coordinates; for this item."], totalCoords).." "
				if totalCoords > numCoords then
					if numCoords <= 0 then s = s..L["You already defeated all of them."]
					else s = s..format(L["You already defeated %d of them."], totalCoords - numCoords).." " end
				end
				if TomTom ~= nil and TomTom.AddMFWaypoint ~= nil then
					if numCoords > 0 then
						if totalCoords > numCoords then s = s..L["Ctrl-Click to create the remaining TomTom waypoint(s)."]
						else s = s..L["Ctrl-Click to create TomTom waypoint(s)."]
						end
					end
				else
					s = s..L["Install TomTom to enable waypoint creation."]
				end
				tooltip2:AddSeparator(1, 1, 1, 1, 1)
				tooltip2AddLine(colorize(s, green))
			end
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
			if tooltip then tooltip:Hide() end
			if qtip:IsAcquired("RarityTooltip") then qtip:Release("RarityTooltip") end
   Rarity:ShowTooltip()
  end
 end


 local function onClickGroup2(cell, group)
  if type(group) == "table" then
   if group.collapsedGroup == true then group.collapsedGroup = false else group.collapsedGroup = true end
			if tooltip then tooltip:Hide() end
			if qtip:IsAcquired("RarityTooltip") then qtip:Release("RarityTooltip") end
   Rarity:ShowTooltip()
  end
 end


 local function onClickItem(cell, item)
  if IsShiftKeyDown() then
   if not item or type(item) ~= "table" or not item.itemId then return end
   local v = item
   local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)
   local attempts = v.attempts or 0
   if v.lastAttempts then attempts = attempts - v.lastAttempts end
   local dropChance = (1.00 / (v.chance or 100))
   if v.method == BOSS and v.groupSize ~= nil and v.groupSize > 1 and not v.equalOdds then dropChance = dropChance / v.groupSize end
   local chance = 100 * (1 - math.pow(1 - dropChance, attempts))
   local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
   local lucky = L["lucky"]
   if medianLoots < attempts then lucky = L["unlucky"] end
   local s = format(L["%s: 0/%d attempts so far (%.2f%% - %s)"], itemLink or item.name, attempts, chance, lucky)
   if attempts == 1 then s = format(L["%s: 0/%d attempt so far (%.2f%% - %s)"], itemLink or item.name, attempts, chance, lucky) end
   if attempts <= 0 then s = format("%s", itemLink or item.name) end
   ChatEdit_InsertLink(s)
		elseif IsControlKeyDown() then
   if not item or type(item) ~= "table" or not item.itemId then return end
			if item.coords ~= nil and type(item.coords) == "table" then
				local added = 0
				local instance = 0
				for _, coord in pairs(item.coords) do
					local good = false
					if coord.q ~= nil then
						if IsQuestFlaggedCompleted(coord.q) == false then good = true end
					else
						good = true
					end
					if good and TomTom ~= nil and TomTom.AddMFWaypoint ~= nil and coord.m ~= nil and coord.x ~= nil and coord.y ~= nil then
						local extraName = ""
						if coord.n ~= nil then extraName = " ("..coord.n..")" end
						TomTom:AddMFWaypoint(coord.m, coord.f or nil, coord.x / 100.0, coord.y / 100.0, { title = "Rarity"..": "..item.name..extraName })
						added = added + 1
						if coord.i == true then instance = instance + 1 end
						if TomTom.SetClosestWaypoint ~= nil then TomTom:SetClosestWaypoint() end
					end
				end
				if added > 0 then Rarity:Print(format(L["Added %d |4waypoint:waypoints; to TomTom"], added)) end
				if instance > 0 then Rarity:Print(format(L["%d |4waypoint:waypoints; |4is:are; located inside |4an instance:instances;"], added)) end
			end
  else
   if trackedItem ~= item and inSession then R:EndSession() end
			trackedItem2 = nil
   Rarity:UpdateTrackedItem(item)
  end
 end


 local function addGroup(group, requiresGroup)
  if type(group) ~= "table" then return end
  if group.name == nil then return end

		local dt = date("*t", time())
  local line
  local added = false
		local headerAdded = false
  local g
  if R.db.profile.sortMode == SORT_NAME then g = sort(group)
  elseif R.db.profile.sortMode == SORT_DIFFICULTY then g = sort_difficulty(group)
  elseif R.db.profile.sortMode == SORT_CATEGORY then g = sort_category(group)
  else g = sort_progress(group)
  end
  for k, v in pairs(g) do
   if type(v) == "table" and v.enabled ~= false and ((requiresGroup and v.groupSize ~= nil and v.groupSize > 1) or (not requiresGroup and (v.groupSize == nil or v.groupSize <= 1))) then

    -- Item
    if ((not requiresGroup and group.collapsed ~= true) or (requiresGroup and group.collapsedGroup ~= true)) and v.itemId ~= nil then
     if (v.requiresHorde and R:IsHorde()) or (v.requiresAlliance and not R:IsHorde()) or (not v.requiresHorde and not v.requiresAlliance) then
						if (R.db.profile.cats[v.cat]) or v.cat == nil then
							if not (R.db.profile.hideHighChance and (v.chance or 0) < 50) then

								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(v.itemId)
								local attempts = v.attempts or 0
								if type(attempts) ~= "number" then attempts = 0 end
								if v.lastAttempts then attempts = attempts - v.lastAttempts end

								local lucky, chance, dropChance

								if v.method ~= COLLECTION then
									dropChance = (1.00 / (v.chance or 100))
									if v.method == BOSS and v.groupSize ~= nil and tonumber(v.groupSize) ~= nil and v.groupSize > 1 and not v.equalOdds then dropChance = dropChance / v.groupSize end
									chance = 100 * (1 - math.pow(1 - dropChance, attempts))
									local medianLoots = round(math.log(1 - 0.5) / math.log(1 - dropChance))
									lucky = colorize(L["Lucky"], green)
									if medianLoots < attempts then lucky = colorize(L["Unlucky"], red) end
								else
									chance = 100 * (attempts / (v.chance or 100))
									if chance < 0 then chance = 0 end
									if chance > 100 then chance = 100 end
									lucky = colorize(L["Lucky"], green)
								end

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
								if v.method ~= NPC and v.method ~= ZONE and v.method ~= FISHING and v.method ~= USE then time = "" end
								local status = ""
								if v.questId and not v.holidayTexture then
									if type(v.questId) == "table" then
										status = colorize(L["Undefeated"], green)
										for key, questId in pairs(v.questId) do
											if IsQuestFlaggedCompleted(questId) then status = colorize(L["Defeated"], red) end
										end
									else
										if IsQuestFlaggedCompleted(v.questId) then status = colorize(L["Defeated"], red) else status = colorize(L["Undefeated"], green) end
									end
								elseif v.questId and v.holidayTexture then
									if Rarity.holiday_textures[v.holidayTexture] == nil then
										status = colorize(L["Unavailable"], gray)
									elseif v.christmasOnly and dt.month == 12 and dt.day < 25 then
										status = colorize(L["Unavailable"], gray)
									else
										if type(v.questId) == "table" then
											status = colorize(L["Undefeated"], green)
											for key, questId in pairs(v.questId) do
												if IsQuestFlaggedCompleted(questId) then status = colorize(L["Defeated"], red) end
											end
										else
											if IsQuestFlaggedCompleted(v.questId) then status = colorize(L["Defeated"], red) else status = colorize(L["Undefeated"], green) end
									end
								end
								elseif v.lockBossName then
									if lbb[v.lockBossName] and (Rarity.lockouts[lbb[v.lockBossName]] == true or Rarity.lockouts[v.lockBossName] == true) then status = colorize(L["Defeated"], red) else status = colorize(L["Undefeated"], green) end
								elseif v.lockDungeonId then
									if Rarity.lockouts_holiday[v.lockDungeonId] == true then
										status = colorize(L["Defeated"], red)
									else
										if Rarity.lockouts_holiday[v.lockDungeonId] == false then
											status = colorize(L["Undefeated"], green)
										else
											status = colorize(L["Unavailable"], gray)
										end
									end
								elseif v.holidayTexture and Rarity.holiday_textures[v.holidayTexture] == nil then
									status = colorize(L["Unavailable"], gray)
								end
								if v.pickpocket then
									local class, classFileName = UnitClass("player")
									if classFileName ~= "ROGUE" then status = colorize(L["Unavailable"], gray) end
								end

								-- Support for Defeated items with multiple steps of defeat (supports quests only)
								if status == colorize(L["Defeated"], red) and v.defeatAllQuests and v.questId ~= nil and type(v.questId) == "table" then
									local totalQuests = 0
									local numQuests = 0
									for _, quest in pairs(v.questId) do
										totalQuests = totalQuests + 1
										if IsQuestFlaggedCompleted(quest) then numQuests = numQuests + 1 end
									end
									if totalQuests > numQuests then
										status = colorize(format(L["Defeated"].." (%d of %d)", numQuests, totalQuests), yellow)
									end
								end

								if Rarity.db.profile.hideUnavailable == false or status ~= colorize(L["Unavailable"], gray) then
									if Rarity.db.profile.hideDefeated == false or status ~= colorize(L["Defeated"], red) then

										-- Holiday reminder
										if Rarity.db.profile.holidayReminder and Rarity.allRemindersDone == nil and v.holidayReminder ~= false and v.cat == HOLIDAY and status == colorize(L["Undefeated"], green) then
											Rarity.anyReminderDone = true
											numHolidayReminders = numHolidayReminders + 1
											if numHolidayReminders <= 2 then
												local text = format(L["A holiday event is available today for %s! Go get it!"], itemLink or itemName or v.name)
												Rarity:Print(text)
												if tostring(SHOW_COMBAT_TEXT) ~= "0" then
													if type(CombatText_AddMessage) == "nil" then UIParentLoadAddOn("Blizzard_CombatText") end
													CombatText_AddMessage(text, CombatText_StandardScroll, 1, 1, 1, true, false)
												else
													UIErrorsFrame:AddMessage(text, 1, 1, 1, 1.0)
												end
											else
												if showedHolidayReminderOverflow == false then
													Rarity:Print(colorize(L["There are more holiday items available, but Rarity only reminds you about the first two."], gray))
												end
												showedHolidayReminderOverflow = true
											end
										end

										-- Header
										if not added then
											headerAdded = true
											local groupName = group.name
											if requiresGroup then groupName = groupName..L[" (Group)"] end
											if not headers[groupName] and v.itemId ~= nil then
												headers[groupName] = true
												local collapsed = group.collapsed or false
												if ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
													line = tooltip:AddLine("|TInterface\\Buttons\\UI-PlusButton-Up:16|t", colorize(groupName, yellow))
												else
													line = tooltip:AddLine("|TInterface\\Buttons\\UI-MinusButton-Up:16|t", colorize(groupName, yellow), colorize(L["Attempts"], yellow), colorize(L["Likelihood"], yellow), Rarity.db.profile.showTimeColumn and colorize(L["Time"], yellow) or nil, Rarity.db.profile.showLuckinessColumn and colorize(L["Luckiness"], yellow) or nil, Rarity.db.profile.showZoneColumn and colorize(L["Zone"], yellow) or nil, colorize(L["Defeated"], yellow))
												end
												tooltip:SetLineScript(line, "OnMouseUp", requiresGroup and onClickGroup2 or onClickGroup, group)
											end
										end

										-- Zone
										local zoneText = ""
										local inMyZone = false
										local zoneColor = gray
										local currentZone = GetCurrentMapAreaID()
										if v.coords ~= nil and type(v.coords) == "table" then
											local zoneList = {}
											local numZones = 0
											for _, zoneValue in pairs(v.coords) do
												if type(zoneValue) == "table" and zoneValue.m ~= nil then
													if zoneList[zoneValue.m] == nil then
														numZones = numZones + 1
														zoneList[zoneValue.m] = true
													end
													zoneText = GetMapNameByID(zoneValue.m)
													if currentZone == zoneValue.m then inMyZone = true end
												end
											end
											if numZones > 1 then zoneText = format(L["%d |4zone:zones;"], numZones) end
											if v.coords.zoneOverride ~= nil then zoneText = v.coords.zoneOverride end
											if inMyZone then
												zoneColor = green
												if numZones > 1 then
													zoneText = GetMapNameByID(currentZone).." "..colorize(format("+%d", numZones - 1), gray)
												end
											end
										end

										-- Add the item to the tooltip
										local catIcon = ""
										if Rarity.db.profile.showCategoryIcons and v.cat and Rarity.catIcons[v.cat] then catIcon = [[|TInterface\AddOns\Rarity\Icons\]]..Rarity.catIcons[v.cat]..".blp:0:4|t " end
										line = tooltip:AddLine(icon, catIcon..(itemTexture and "|T"..itemTexture..":0|t " or "")..(itemLink or v.name or L["Unknown"]), attempts, likelihood, Rarity.db.profile.showTimeColumn and time or nil, Rarity.db.profile.showLuckinessColumn and lucky or nil, Rarity.db.profile.showZoneColumn and colorize(zoneText, zoneColor) or nil, status)
										tooltip:SetLineScript(line, "OnMouseUp", onClickItem, v)
										tooltip:SetLineScript(line, "OnEnter", showSubTooltip, v)
										tooltip:SetLineScript(line, "OnLeave", hideSubTooltip)
										added = true

									end
								end


							end
						end
     end
    end

   end
  end

		-- Collapsed Header
		if not headerAdded and ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
			headerAdded = true
			local groupName = group.name
			if requiresGroup then groupName = groupName..L[" (Group)"] end
			if not headers[groupName] then
				headers[groupName] = true
				local collapsed = group.collapsed or false
				if ((not requiresGroup and group.collapsed == true) or (requiresGroup and group.collapsedGroup == true)) then
					line = tooltip:AddLine("|TInterface\\Buttons\\UI-PlusButton-Up:16|t", colorize(groupName, yellow))
				else
					line = tooltip:AddLine("|TInterface\\Buttons\\UI-MinusButton-Up:16|t", colorize(groupName, yellow), colorize(L["Attempts"], yellow), colorize(L["Likelihood"], yellow), Rarity.db.profile.showTimeColumn and colorize(L["Time"], yellow) or nil, Rarity.db.profile.showLuckinessColumn and colorize(L["Luckiness"], yellow) or nil, Rarity.db.profile.showZoneColumn and colorize(L["Zone"], yellow) or nil, colorize(L["Defeated"], yellow))
				end
				tooltip:SetLineScript(line, "OnMouseUp", requiresGroup and onClickGroup2 or onClickGroup, group)
			end
		end

  return added
 end
	 
	
	function R:ShowTooltip(hidden)
		-- The tooltip can't be built in combat; it takes too long and the script will receive a "script ran too long" error
		if InCombatLockdown() then return end

		if qtip:IsAcquired("RarityTooltip") and tooltip then
			tooltip:Clear()
		else
			tooltip = qtip:Acquire("RarityTooltip", 9, "LEFT", "LEFT", "RIGHT", "RIGHT", "RIGHT", "CENTER", "CENTER", "CENTER") -- intentionally one column more than we need to avoid text clipping
			tooltip:SetScale(self.db.profile.tooltipScale or 1)
		end
		
		table.wipe(headers)
  local addedLast
		numHolidayReminders = 0
		showedHolidayReminderOverflow = false

  -- Sort header
  local sortDesc = L["Sorting by name"]
  if self.db.profile.sortMode == SORT_DIFFICULTY then sortDesc = L["Sorting by difficulty"]
  elseif self.db.profile.sortMode == SORT_PROGRESS then sortDesc = L["Sorting by percent complete"]
  elseif self.db.profile.sortMode == SORT_CATEGORY then sortDesc = L["Sorting by category, then name"]
  end
		local line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(sortDesc, green), nil, nil, 3)
		
  -- Item groups
		R:ProfileStart()
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
  if addedLast then tooltip:AddSeparator(1, 1, 1, 1, 1.0) end
		R:ProfileStop("Tooltip rendering took %fms")
		
		-- Footer
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Click to toggle the progress bar"], gray), nil, nil, 3)
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Shift-Click to open options"], gray), nil, nil, 3)
		line = tooltip:AddLine()
		tooltip:SetCell(line, 1, colorize(L["Ctrl-Click to change sort order"], gray), nil, nil, 3)

		if Rarity.anyReminderDone and not Rarity.allRemindersDone then
			Rarity.allRemindersDone = true
			if Rarity.db.profile.holidayReminder then
				Rarity:Print(colorize(L["You can turn off holiday reminders as a whole or on an item-by-item basis by visiting the Rarity Options screen."], gray))
			end
		end
		if hidden == true or frame == nil then return end

		tooltip:SetAutoHideDelay(0.6, frame, function()
			tooltip = nil
			qtip:Release("RarityTooltip")
		end)
		tooltip:SmartAnchorTo(frame)
		tooltip:UpdateScrolling()
		tooltip:Show()
	end
end



--[[
      CORE FUNCTIONALITY -------------------------------------------------------------------------------------------------------
  ]]


local function RarityAchievementAlertFrame_SetUp(frame, itemId, attempts)
 local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
 if itemName == nil then return end
 if itemTexture == nil then itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]] end

 -- The following code is adapted from Blizzard's AchievementAlertFrame_SetUp function found in FrameXML\AlertFrameSystems.lua [introduced in 7.0]

	local displayName = frame.Name;
	local shieldPoints = frame.Shield.Points;
	local shieldIcon = frame.Shield.Icon;
	local unlocked = frame.Unlocked;
	local oldCheevo = frame.OldAchievement;
	
	displayName:SetText(itemName);

	AchievementShield_SetPoints(0, shieldPoints, GameFontNormal, GameFontNormalSmall);
	
	if (frame.guildDisplay or frame.oldCheevo) then
		frame.oldCheevo = nil
		shieldPoints:Show();
		shieldIcon:Show();
		oldCheevo:Hide();
		frame.guildDisplay = nil;
		frame:SetHeight(88);
		local background = frame.Background;
		background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background");
		background:SetTexCoord(0, 0.605, 0, 0.703);
		background:SetPoint("TOPLEFT", 0, 0);
		background:SetPoint("BOTTOMRIGHT", 0, 0);
		local iconBorder = frame.Icon.Overlay;
		iconBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame");
		iconBorder:SetTexCoord(0, 0.5625, 0, 0.5625);
		iconBorder:SetPoint("CENTER", -1, 2);
		frame.Icon:SetPoint("TOPLEFT", -26, 16);
		displayName:SetPoint("BOTTOMLEFT", 72, 36);
		displayName:SetPoint("BOTTOMRIGHT", -60, 36);
		frame.Shield:SetPoint("TOPRIGHT", -10, -13);
		shieldPoints:SetPoint("CENTER", 7, 2);
		shieldPoints:SetVertexColor(1, 1, 1);
		shieldIcon:SetTexCoord(0, 0.5, 0, 0.45);
		unlocked:SetPoint("TOP", 7, -23);
		frame.GuildName:Hide();
		frame.GuildBorder:Hide();
		frame.GuildBanner:Hide();
		frame.glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow");
		frame.glow:SetTexCoord(0, 0.78125, 0, 0.66796875);
		frame.shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow");
		frame.shine:SetTexCoord(0.78125, 0.912109375, 0, 0.28125);
		frame.shine:SetPoint("BOTTOMLEFT", 0, 8);
	end
		
	shieldIcon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]]);
	
	frame.Icon.Texture:SetTexture(itemTexture);

	if attempts == nil or attempts <= 0 then attempts = 1 end
	if item and item.method and item.method == COLLECTION then
		unlocked:SetText(L["Collection Complete"])
	else
		if attempts == 1 then unlocked:SetText(L["Obtained On Your First Attempt"])
		else unlocked:SetText(format(L["Obtained After %d Attempts"], attempts)) end
	end
	Rarity:ScheduleTimer(function()
		-- Put the achievement frame back to normal when we're done
		unlocked:SetText(ACHIEVEMENT_UNLOCKED);
	end, 10)
	
	frame.id = itemId;
	return true;
end


local RarityAchievementAlertSystem = AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", RarityAchievementAlertFrame_SetUp, 2, 6);
RarityAchievementAlertSystem:SetCanShowMoreConditionFunc(function() return not C_PetBattles.IsInBattle() end);


-- test with: /run Rarity:ShowFoundAlert(32458, 5)
function R:ShowFoundAlert(itemId, attempts)
 local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(itemId)
 if itemName == nil then return end -- Server doesn't know this item, we can't award it
 if itemTexture == nil then itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]] end
	
 -- The following code is adapted from Blizzard's AlertFrameMixin:OnEvent function found in FrameXML\AlertFrames.lua [heavily updated in 7.0]

	if (IsKioskModeEnabled()) then
		return
	end

	if ( not AchievementFrame ) then
		AchievementFrame_LoadUI();
	end

	RarityAchievementAlertSystem:AddAlert(itemId, attempts);

 self:ScheduleTimer(function()
  -- Take a screenshot
	 if Rarity.db.profile.takeScreenshot then
			if ( ActionStatus:IsShown() ) then ActionStatus:Hide() end
			Screenshot()
		end
 end, 2)


 PlaySoundFile("Sound\\Spells\\AchievmentSound1.ogg")
end


hooksecurefunc("BonusRollFrame_StartBonusRoll", function(spellID, text, duration, currencyID)
	local self = Rarity
	if self.lastCoinItem and self.lastCoinItem.enableCoin and self.lastCoinItem.enabled ~= false then
		if self.lastCoinItem.itemId then
			if not currencyID then currencyID = BONUS_ROLL_REQUIRED_CURRENCY end
			local _, count, icon = GetCurrencyInfo(currencyID)
			if count == 0 then return end
			local name, link, quality, iLevel, reqLevel, class, subclass, maxStack, equipSlot, texture, vendorPrice = GetItemInfo(self.lastCoinItem.itemId)
			local _, _, _, fontString = StorePurchaseAlertFrame:GetRegions()
			fontString:SetText(L["Use your bonus roll for a chance at this item"])
			self:ScheduleTimer(function() fontString:SetText(BLIZZARD_STORE_PURCHASE_COMPLETE_DESC) end, duration + 2)
			StorePurchaseAlertFrame_ShowAlert(texture, link, self.lastCoinItem.itemId)
		end
	end
end)


function R:OutputAttempts(item, skipTimeUpdate)
 if not item then return end
 if (item.requiresHorde and R:IsHorde()) or (item.requiresAlliance and not R:IsHorde()) or (not item.requiresHorde and not item.requiresAlliance) then
  self:Debug("New attempt found for %s", item.name)

  if type(item) == "table" and item.enabled ~= false and (item.found ~= true or item.repeatable == true) and item.itemId ~= nil and item.attempts ~= nil then

   if skipTimeUpdate == nil or skipTimeUpdate == false then
    -- Increment attempt counter for today
    local dt = getDate()
    if not item.dates then item.dates = {} end
    if not item.dates[dt] then item.dates[dt] = {} end
    if not item.dates[dt].attempts then item.dates[dt].attempts = 0 end
    item.dates[dt].attempts = item.dates[dt].attempts + 1
    if not item.session then item.session = {} end
    if not item.session.attempts then item.session.attempts = 0 end
    item.session.attempts = item.session.attempts + 1

    -- Handle time tracking
				if lastAttemptItem and lastAttemptItem ~= item and GetTime() - (lastAttemptTime or 0) <= DUAL_TRACK_THRESHOLD then -- Beginning to track two things at once
					self:UpdateSession()
				else
					if trackedItem == item or trackedItem2 == item then
						self:UpdateSession()
					else
						self:EndSession()
						self:StartSession()
					end
				end
   end

			-- Update LDB text
			self:UpdateText()

   -- Switch to track this item
   self:UpdateTrackedItem(item)

			-- Save what we last tracked and when it happened
			lastAttemptTime = GetTime()
			lastAttemptItem = item

			-- If this item supports lockout detection, request updated instance info from the server now and in 10 seconds
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

			-- Save this item for coin tracking, but only for 90 seconds
			if item.enableCoin then
				self:Debug("Allowing this item to be counted again if a coin is used in the next 90 seconds")
				self.lastCoinItem = item
				self:ScheduleTimer(function() self.lastCoinItem = nil end, 90)
			else
				self.lastCoinItem = nil
			end

   -- Don't go any further if we don't want to announce this
   if self.db.profile.enableAnnouncements == false then return end
   if item.announce == false then return end

   -- Output the attempt count
   local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
   if itemName or item.name then
    local s
    local attempts = item.attempts or 1
    local total = item.attempts or 1
    if item.lastAttempts then attempts = attempts - item.lastAttempts end
    if total <= attempts then
     if attempts == 1 then s = format(L["%s: %d attempt"], itemName or item.name, attempts)
     else s = format(L["%s: %d attempts"], itemName or item.name, attempts) end
    else
     if attempts == 1 then s = format(L["%s: %d attempt (%d total)"], itemName or item.name, attempts, total)
     else s = format(L["%s: %d attempts (%d total)"], itemName or item.name, attempts, total) end
    end
				if item.method == COLLECTION then
					s = format(L["%s: %d collected"], itemName or item.name, attempts)
				end
    self:Pour(s, nil, nil, nil, nil, nil, nil, nil, nil, itemTexture)
   end

  end
 end
end


function R:ScanExistingItems(reason)
	-- Don't allow this scan in combat; it takes too long and the script will receive a "script ran too long" error
	-- Under normal conditions this shouldn't be called during combat, except during the 5-minute final init, or
	-- if the user is messing around with Options in combat.
	if InCombatLockdown() then return end

 self:Debug("Scanning for existing items ("..reason..")")
	self:ProfileStart()

	-- Scans need to index by spellId, creatureId, achievementId, raceId, itemId (for toys), statisticId (which is a table; for stats)

 -- Mounts (pre-7.0)
	if (mount_journal.GetMountInfo ~= nil) then
		for id = 1, mount_journal.GetNumMounts() do
			local creatureName, spellId, icon, active, isUsable, sourceType, isFavorite, isFactionSpecific, faction, hideOnChar, isCollected = mount_journal.GetMountInfo(id)
			local creatureDisplayID, descriptionText, sourceText, isSelfMount, mountType = C_MountJournal.GetMountInfoExtra(id)

			Rarity.mount_sources[spellId] = sourceText

			if isCollected then
				for k, v in pairs(R.db.profile.groups) do
					if type(v) == "table" then
						for kk, vv in pairs(v) do
							if type(vv) == "table" then
								if vv.spellId and vv.spellId == spellId then vv.known = true end
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
	
	-- Mounts (7.0+)
	else
 	for i,id in pairs(mount_journal.GetMountIDs()) do
			local _, spellId, _, _, _, _, _, _, _, _, isCollected = mount_journal.GetMountInfoByID(id)
			local _, _, sourceText = mount_journal.GetMountInfoExtraByID(id)

			Rarity.mount_sources[spellId] = sourceText

			if isCollected then
				for k, v in pairs(R.db.profile.groups) do
					if type(v) == "table" then
						for kk, vv in pairs(v) do
							if type(vv) == "table" then
								if vv.spellId and vv.spellId == spellId then vv.known = true end
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
	if (pet_journal.SetFlagFilter ~= nil) then -- Pre-7.0
		pet_journal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_COLLECTED, true)
		pet_journal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_FAVORITES, false)
		pet_journal.SetFlagFilter(_G.LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)
		pet_journal.AddAllPetTypesFilter()
		pet_journal.AddAllPetSourcesFilter()
	else -- 7.0+
		pet_journal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_COLLECTED, true)
		pet_journal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_FAVORITES, false)
		pet_journal.SetFilterChecked(_G.LE_PET_JOURNAL_FLAG_NOT_COLLECTED, true)
		pet_journal.SetAllPetTypesChecked(true)
		pet_journal.SetAllPetSourcesChecked(true)
	end
 local total, owned = pet_journal.GetNumPets()
 for i = 1, total do
  local petID, speciesID, owned, customName, level, favorite, isRevoked, speciesName, icon, petType, companionID, tooltip, description, isWild, canBattle, isTradeable, isUnique, obtainable = pet_journal.GetPetInfoByIndex(i)
		Rarity.pet_sources[companionID] = tooltip
		if owned then
			for k, v in pairs(R.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							if vv.creatureId and vv.creatureId == companionID then vv.known = true end
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
						local IDNumber, Name, Points, Completed, Month, Day, Year, Description, Flags, Image, RewardText, isGuildAch = GetAchievementInfo(vv.achievementId)
						if Completed and not vv.repeatable then
							vv.enabled = false
							vv.found = true
						end
					end
				end
			end
		end
	end


 -- Scan all archaeology races and set any item attempts to the number of solves for that race (if we've never seen attempts for the race before)
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

	self:ProfileStop("ScanExistingItems: Mounts/Pets/Achievements/Archaeology took %fms")

 -- Other scans
 self:ScanStatistics(reason)
	self:ProfileStart2() -- Statistics does its own profiling

	self:ScanToys(reason)
	self:ProfileStop2("Toys took %fms")
	self:ProfileStart2()

	self:ScanCalendar(reason)
	self:ProfileStop2("Calendar took %fms")
	self:ProfileStart2()

	self:ScanInstanceLocks(reason)
	self:ProfileStop2("Instances took %fms")

	self:ProfileStop("ScanExistingItems: Total time %fms")
end


function R:ScanToys(reason)
	if InCombatLockdown() then return end
 self:Debug("Scanning toys ("..reason..")")

	if not Rarity.toysScanned then
		if not ToyBox_OnLoad then UIParentLoadAddOn("Blizzard_Collections") end
		--if ToyBox_OnShow then ToyBox_OnShow() end
		if CollectionsJournal_SetTab then CollectionsJournal_SetTab(CollectionsJournal, 3) end
	end

	table.wipe(toys)
 for id = 1, C_ToyBox.GetNumToys() do
		local itemId = C_ToyBox.GetToyFromIndex(id)
		toys[itemId] = true
		Rarity.toysScanned = true
		if PlayerHasToy(itemId) then
			for k, v in pairs(R.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							if vv.itemId and vv.itemId == itemId and not vv.repeatable then
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
end


function R:ScanCalendar(reason)
 self:Debug("Scanning calendar ("..reason..")")

	table.wipe(Rarity.holiday_textures)
	local _, month, day, year = CalendarGetDate()
	local curMonth, curYear = CalendarGetMonth()
	local monthOffset = -12 * (curYear - year) + month - curMonth
	local numEvents = CalendarGetNumDayEvents(monthOffset, day)
	local numLoaded = 0

	for i = 1, numEvents, 1 do
		local _, _, _, calendarType, _, _, texture = CalendarGetDayEvent(monthOffset, day, i)

		if calendarType == "HOLIDAY" then
			Rarity.holiday_textures[texture] = true
		end
	end
end


function R:ScanInstanceLocks(reason)
 self:Debug("Scanning instance locks ("..reason..")")

	table.wipe(Rarity.lockouts)
	local savedInstances = GetNumSavedInstances()
	for i = 1, savedInstances do
		local instanceName, instanceID, instanceReset, instanceDifficulty, locked, extended, instanceIDMostSig = GetSavedInstanceInfo(i)
		if instanceReset > 0 then
			scanTip:ClearLines()
			scanTip:SetInstanceLockEncountersComplete(i)
			for i = 2, scanTip:NumLines() do
				local txtRight = _G["__Rarity_ScanTipTextRight"..i]:GetText()
				if txtRight then
					if txtRight == BOSS_DEAD then self.lockouts[_G["__Rarity_ScanTipTextLeft"..i]:GetText()] = true end
				end
			end
		end		
	end

	table.wipe(Rarity.lockouts_holiday)
	local num = GetNumRandomDungeons()
	for i = 1, num do 
		local dungeonID, name = GetLFGRandomDungeonInfo(i)
		local _, _, _, _, _, _, _, _, _, _, _, _, _, desc, isHoliday = GetLFGDungeonInfo(dungeonID)
		if isHoliday and dungeonID ~= 828 then		
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


function R:BuildStatistics(reason)
	self:ProfileStart2()
 --self:Debug("Building statistics table ("..reason..")")

 local tbl = {}
	Rarity.lastStatCount = 0

	for k, v in pairs(R.stats_to_scan) do
		local s = GetStatistic(k)
		tbl[k] = (tonumber(s or "0") or 0)
		Rarity.lastStatCount = Rarity.lastStatCount + 1
	end

	self:ProfileStop2("BuildStatistics: %fms")
 return tbl
end


function R:ScanStatistics(reason)
	self:ProfileStart2()
 --self:Debug("Scanning statistics ("..reason..")")

 if rarity_stats == nil or (Rarity.lastStatCount or 0) <= 0 then
  self:Debug("Building initial statistics table")
  rarity_stats = self:BuildStatistics(reason)
 end

 local newStats = self:BuildStatistics(reason)

 for kk, vv in pairs(Rarity.items_with_stats) do
  if type(vv) == "table" then
   if (vv.requiresHorde and R:IsHorde()) or (vv.requiresAlliance and not R:IsHorde()) or (not vv.requiresHorde and not vv.requiresAlliance) then
    if vv.statisticId and type(vv.statisticId) == "table" then
     local count = 0

     for kkk, vvv in pairs(vv.statisticId) do
      local newAmount = newStats[vvv] or 0
      local oldAmount = rarity_stats[vvv] or 0
      count = count + newAmount

      -- One of the statistics has gone up; add one attempt for this item
      if newAmount > oldAmount then
       vv.attempts = (vv.attempts or 0) + 1
       self:OutputAttempts(vv, true)
      end

     end

     -- We've never seen any attempts for this yet; update to this player's statistic total
     if count > 0 and (vv.attempts or 0) <= 0 then
      vv.attempts = count
      self:OutputAttempts(vv, true)

     -- We seem to have gathered more attempts on this character than accounted for yet; update to new total
     elseif count > 0 and count > (vv.attempts or o) and vv.doNotUpdateToHighestStat ~= true then -- Some items don't want us doing this (generally when Blizzard has a statistic overcounting bug)
      vv.attempts = count
      self:OutputAttempts(vv, true)
     end

    end
   end
  end
 end

 -- Done with scan; update our saved table to the current scan
 rarity_stats = newStats

 if self.db.profile.debugMode then R.stats = rarity_stats end


	-- Scan rare NPC achievements
	table.wipe(Rarity.ach_npcs_isKilled)
	table.wipe(Rarity.ach_npcs_achId)
	for k, v in pairs(self.db.profile.achNpcs) do
		local count = GetAchievementNumCriteria(v)
		for i = 1, count do
			local description, type, completed = GetAchievementCriteriaInfo(v, i)
			Rarity.ach_npcs_achId[description] = v
			if completed then Rarity.ach_npcs_isKilled[description] = true end
		end
	end

	self:ProfileStop2("ScanStatistics: %fms")
end


function R:FoundItem(itemId, item)
 if item.found and not item.repeatable then return end
	
 self:Debug("FOUND ITEM %d!", itemId)
 if item.attempts == nil then item.attempts = 1 end
 if item.lastAttempts == nil then item.lastAttempts = 0 end

	-- Hacky: If the item is unique and has 0 attempts, don't do this (if you really find a unique item on your first attempt, sorry)
	if item.unique and item.attempts - item.lastAttempts <= 1 then return end

 self:ShowFoundAlert(itemId, item.attempts - item.lastAttempts, item)
 if inSession then self:EndSession() end
 item.realAttempts = item.attempts - item.lastAttempts
 item.lastAttempts = item.attempts
 item.enabled = false
 item.found = true
 item.totalFinds = (item.totalFinds or 0) + 1
 if not item.finds then item.finds = {} end
 local count = 0
 for k, v in pairs(item.finds) do count = count + 1 end
 table.insert(item.finds, {
  num = count + 1,
  totalAttempts = item.attempts,
  totalTime = item.time,
  attempts = item.realAttempts,
  time = (item.time or 0) - (item.lastTime or 0)
 })
 item.lastTime = item.time
 self:UpdateTrackedItem(item)
 self:UpdateInterestingThings()
 if item.repeatable then self:ScheduleTimer(function()
  -- If this is a repeatable item, turn it back on in a few seconds.
  -- FoundItem() gets called repeatedly when we get an item, so we need to lock it out for a few seconds.
  item.enabled = nil
  item.found = nil
  self:UpdateInterestingThings()
  self:UpdateText()
  --if R:InTooltip() then Rarity:ShowTooltip() end
 end, 5) end
end


function R:FindTrackedItem()
 trackedItem = self.db.profile.groups.pets["Parrot Cage (Hyacinth Macaw)"]

 if self.db.profile.trackedGroup and self.db.profile.groups[self.db.profile.trackedGroup] then
  if self.db.profile.trackedItem then
   for k, v in pairs(self.db.profile.groups[self.db.profile.trackedGroup]) do
    if type(v) == "table" and v.itemId and v.itemId == self.db.profile.trackedItem then
     trackedItem = v
	    if self.db.profile.debugMode then
      R.trackedItem = trackedItem
	    end
     return v
    end
   end
  end
 end

end


function R:UpdateTrackedItem(item)
	self:ProfileStart2()
 if not item or not item.itemId then return end
	if self.db.profile.trackedItem == item.itemId then return end -- Already tracking this item
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
	if lastAttemptItem and lastAttemptItem ~= item and GetTime() - (lastAttemptTime or 0) <= DUAL_TRACK_THRESHOLD then
		trackedItem2 = lastAttemptItem
		self:Debug("Setting second tracked item to "..trackedItem2.name)
	else
		if trackedItem2 then self:Debug("Clearing second tracked item") end
		trackedItem2 = nil
	end
 self:UpdateText()
 --if self:InTooltip() then self:ShowTooltip() end
	self:ProfileStop2("UpdateTrackedItem: %fms")
end


function R:EndSession()
	if inSession then
  if trackedItem and trackedItem.itemId then
   local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem.itemId)
		 local len = sessionLast - sessionStarted
   local i = R:FindTrackedItem()
   if i then
    i.time = (i.time or 0) + len
    local dt = getDate()
    if not i.dates then i.dates = {} end
    if not i.dates[dt] then i.dates[dt] = {} end
    i.dates[dt].time = (i.dates[dt].time or 0) + len
    if not i.session then i.session = {} end
    i.session.time = (i.session.time or 0) + len
   end
   self:Debug("Ending session for %s (%s)", itemLink, self:FormatTime(trackedItem.time or 0))
	 end
  if trackedItem2 and trackedItem2.itemId then
   local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(trackedItem2.itemId)
		 local len = sessionLast - sessionStarted
   local i = trackedItem2
   if i then
    i.time = (i.time or 0) + len
    local dt = getDate()
    if not i.dates then i.dates = {} end
    if not i.dates[dt] then i.dates[dt] = {} end
    i.dates[dt].time = (i.dates[dt].time or 0) + len
    if not i.session then i.session = {} end
    i.session.time = (i.session.time or 0) + len
   end
   self:Debug("Also ending session for %s (%s)", itemLink, self:FormatTime(trackedItem2.time or 0))
	 end
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
  --self:Debug("Extending current session")
  if sessionTimer then self:CancelTimer(sessionTimer, true) end
  sessionTimer = self:ScheduleTimer(timeoutSession, SESSION_LENGTH)
	else
		self:StartSession()
	end
end


function R:ImportFromBunnyHunter()
 if self.db.profile.importedFromBunnyHunter then return end

 if BunnyHunterDB then
  StaticPopupDialogs["RARITY_IMPORT_FROM_BUNNYHUNTER"] = {
	  text = L["Bunny Hunter is running. Would you like Rarity to import data from Bunny Hunter now? Disable Bunny Hunter or click Yes if you don't want to be asked again."],
	  button1 = YES,
   button2 = NO,
	  hideOnEscape = 1,
	  timeout = 0,
	  exclusive = 1,
	  whileDead = 1,
	  OnAccept = function()
    local self = R
		  -- Do the import
    if BunnyHunterDB.loots and type(BunnyHunterDB.loots) == "table" then
     for k, v in pairs(BunnyHunterDB.loots) do
      for groupkey, group in pairs(self.db.profile.groups) do
       for itemkey, item in pairs(group) do
        if item.itemId == tonumber(k) then
         self:Debug("Resetting found record for %s", itemkey)
         item.finds = nil
         item.totalFinds = nil
        end
       end
      end
     end
     for k, v in pairs(BunnyHunterDB.loots) do
      for groupkey, group in pairs(self.db.profile.groups) do
       for itemkey, item in pairs(group) do
        if item.itemId == tonumber(k) then
         for kk, vv in pairs(v) do
          self:Debug("%s: adding a kill after %d attempts, %s time", itemkey, vv.loots, self:FormatTime(vv.time))
          if not item.finds then item.finds = {} end
          local count = 0
          for x, y in pairs(item.finds) do count = count + 1 end
          table.insert(item.finds, {
            num = count + 1,
            totalAttempts = vv.loots,
            totalTime = vv.time,
            attempts = vv.loots,
            time = vv.time
           })
           item.totalFinds = (item.totalFinds or 0) + 1
          end
         end
       end
      end
     end
    end
    if BunnyHunterDB.kills_by_id and type(BunnyHunterDB.kills_by_id) == "table" then
     for k, v in pairs(BunnyHunterDB.kills_by_id) do
      for groupkey, group in pairs(self.db.profile.groups) do
       for itemkey, item in pairs(group) do
        if item.npcs then
         for npckey, npcid in pairs(item.npcs) do
          if npcid == tonumber(k) then
           self:Debug("Resetting attempts for %s", itemkey)
           item.attempts = 0
           item.lastAttempts = nil
          end
         end
        end
       end
      end
     end
     for k, v in pairs(BunnyHunterDB.kills_by_id) do
      for groupkey, group in pairs(self.db.profile.groups) do
       for itemkey, item in pairs(group) do
        if item.npcs then
         for npckey, npcid in pairs(item.npcs) do
          if npcid == tonumber(k) then
           self:Debug("%s: adding %d attempt(s)", itemkey, v)
           item.attempts = (item.attempts or 0) + v
          end
         end
        end
       end
      end
     end
    end
    if BunnyHunterDB.times and type(BunnyHunterDB.times) == "table" then
     for k, v in pairs(BunnyHunterDB.times) do
      for groupkey, group in pairs(self.db.profile.groups) do
       for itemkey, item in pairs(group) do
        if item.itemId == tonumber(k) then
         self:Debug("%s: updating time to %f", itemkey, v)
         item.time = v
         item.lastTime = nil
        end
       end
      end
     end
    end
    self:UpdateInterestingThings()
    self:UpdateText()
    --if self:InTooltip() then self:ShowTooltip() end
    self.db.profile.importedFromBunnyHunter = true
    self:Print(L["Data has been imported from Bunny Hunter"])
	  end
  }
		StaticPopup_Show("RARITY_IMPORT_FROM_BUNNYHUNTER")
 end
end


function R:Update(reason)
 self:ScanExistingItems(reason)
 self:UpdateInterestingThings(reason)
 self:FindTrackedItem()
 self:UpdateText()
 --if self:InTooltip() then self:ShowTooltip() end
end

