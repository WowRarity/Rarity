if not Rarity then return end
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
local R = Rarity
local mod = R:NewModule("Options")
local lbz = LibStub("LibBabble-Zone-3.0")
local lbsz = LibStub("LibBabble-SubZone-3.0")
local media = LibStub("LibSharedMedia-3.0")
local compress = LibStub("LibCompress")


local GetItemInfo = function(id)
	if Rarity:IsInitializing() then return nil end
	return R:GetItemInfo(id)
end


-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"

-- Categories of origin
local BASE = "BASE"
local TBC = "TBC"
local WOTLK = "WOTLK"
local CATA = "CATA"
local MOP = "MOP"
local WOD = "WOD"
local LEGION = "LEGION"
local HOLIDAY = "HOLIDAY"

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

-- Classes
local classes = {
	["DEATHKNIGHT"] = "|c"..RAID_CLASS_COLORS["DEATHKNIGHT"]["colorStr"]..L["Death Knight"].."|r",
	["DEMONHUNTER"] = "|c"..RAID_CLASS_COLORS["DEMONHUNTER"]["colorStr"]..L["Demon Hunter"].."|r",
	["DRUID"] = "|c"..RAID_CLASS_COLORS["DRUID"]["colorStr"]..L["Druid"].."|r",
	["HUNTER"] = "|c"..RAID_CLASS_COLORS["HUNTER"]["colorStr"]..L["Hunter"].."|r",
	["MAGE"] = "|c"..RAID_CLASS_COLORS["MAGE"]["colorStr"]..L["Mage"].."|r",
	["MONK"] = "|c"..RAID_CLASS_COLORS["MONK"]["colorStr"]..L["Monk"].."|r",
	["PALADIN"] = "|c"..RAID_CLASS_COLORS["PALADIN"]["colorStr"]..L["Paladin"].."|r",
	["PRIEST"] = "|c"..RAID_CLASS_COLORS["PRIEST"]["colorStr"]..L["Priest"].."|r",
	["ROGUE"] = "|c"..RAID_CLASS_COLORS["ROGUE"]["colorStr"]..L["Rogue"].."|r",
	["SHAMAN"] = "|c"..RAID_CLASS_COLORS["SHAMAN"]["colorStr"]..L["Shaman"].."|r",
	["WARLOCK"] = "|c"..RAID_CLASS_COLORS["WARLOCK"]["colorStr"]..L["Warlock"].."|r",
	["WARRIOR"] = "|c"..RAID_CLASS_COLORS["WARRIOR"]["colorStr"]..L["Warrior"].."|r",
}

local red = { r = 1.0, g = 0.2, b = 0.2 }
local blue = { r = 0.4, g = 0.4, b = 1.0 }
local green = { r = 0.2, g = 1.0, b = 0.2 }
local yellow = { r = 1.0, g = 1.0, b = 0.2 }
local gray = { r = 0.5, g = 0.5, b = 0.5 }
local black = { r = 0.0, g = 0.0, b = 0.0 }
local white = { r = 1.0, g = 1.0, b = 1.0 }

local IMPORTEXPORT_SIGNATURE = "RFI2PD4jOjJ0NntgInc/ZA=="




do
	local isInitialized = false

	function mod:OnEnable()
		R:Options_DoEnable()
	end

	function R:Options_DoEnable()
		if isInitialized then return end

		if R.db == nil then
			R:ScheduleTimer(function() R:Options_DoEnable() end, 1.0)
			return
		end

		isInitialized = true
		R.modulesEnabled.options = true

		R:PrepareOptions()
		if AddonLoader and AddonLoader.RemoveInterfaceOptions then
			AddonLoader:RemoveInterfaceOptions("Rarity")
		end
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Rarity", R.options)
		R.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Rarity", "Rarity")
		R.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(R.db)
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Rarity-Profiles", R.profileOptions)
		R.profileFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Rarity-Profiles", "Profiles", "Rarity")
		
	end
	
end


------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- UTILITIES
------------------------------------------------------------------------------------------------------------------------------------------------------------------

local newOrder
do
	local current = 0
	function newOrder()
		current = current + 1
		return current
	end
end

local function formatItem(item)
	local s
	if tonumber(item) ~= nil then s = format(L["Item %d"], item) else s = item end
	local itemName, itemLink = GetItemInfo(item)
	if itemName then s = itemLink end
	return s
end

local function colorize(s, color)
	if color and s then
		return string.format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
	else
		return s
	end
end


local function compareName(a, b)
 if not a or not b then return 0 end
 if type(a) ~= "table" or type(b) ~= "table" then return 0 end
 return (a.name or "") < (b.name or "")
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


local function alert(msg)
 StaticPopupDialogs["RARITY_OPTIONS_ALERT"] = {
	 text = msg,
	 button1 = OKAY,
	 hideOnEscape = 1,
	 timeout = 0,
	 exclusive = 1,
	 whileDead = 1,
 }
	StaticPopup_Show("RARITY_OPTIONS_ALERT")
end


local function alertWithCopy(msg, textToCopy)
	StaticPopupDialogs["RARITY_OPTIONS_ALERT_WITH_COPY"] = {
		text = msg,
		button1 = L["Close"],
		hasEditBox = 1,	
		button2 = "",
	
		OnShow = function(self)
			self.editBox:SetText(textToCopy);
			self.editBox:SetFocus();
			self.editBox:HighlightText();
			_G[self:GetName().."Button2"]:Hide();
			_G[self:GetName().."Button1"]:ClearAllPoints();
			_G[self:GetName().."Button1"]:SetPoint("TOP", self.editBox, "BOTTOM", 0, -8);		
		end,
		OnHide = function(self)
			self.editBox:SetText("");
			_G[self:GetName().."Button2"]:Show();
		end,
		EditBoxOnEnterPressed = function(self)
			self:GetParent():Hide()
		end,
		EditBoxOnEscapePressed = function(self)
			self:GetParent():Hide()
		end,
		timeout = 0,
		exclusive = 1,
		whileDead = 1,
		hideOnEscape = 1
	};
	StaticPopup_Show("RARITY_OPTIONS_ALERT_WITH_COPY")
end


local function allitems()
 local t = {}
 for k, v in pairs(R.db.profile.groups.mounts) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.pets) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.items) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.user) do if type(v) == "table" then t[k] = v end end
 return t
end


local b = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

function enc64(data)
    return ((data:gsub('.', function(x) 
        local r,b='',x:byte()
        for i=8,1,-1 do r=r..(b%2^i-b%2^(i-1)>0 and '1' or '0') end
        return r;
    end)..'0000'):gsub('%d%d%d?%d?%d?%d?', function(x)
        if (#x < 6) then return '' end
        local c=0
        for i=1,6 do c=c+(x:sub(i,i)=='1' and 2^(6-i) or 0) end
        return b:sub(c+1,c+1)
    end)..({ '', '==', '=' })[#data%3+1])
end

function dec64(data)
	if not data then return nil end
    data = string.gsub(data, '[^'..b..'=]', '')
    return (data:gsub('.', function(x)
        if (x == '=') then return '' end
        local r,f='',(b:find(x)-1)
        for i=6,1,-1 do r=r..(f%2^i-f%2^(i-1)>0 and '1' or '0') end
        return r;
    end):gsub('%d%d%d?%d?%d?%d?%d?%d?', function(x)
        if (#x ~= 8) then return '' end
        local c=0
        for i=1,8 do c=c+(x:sub(i,i)=='1' and 2^(8-i) or 0) end
        return string.char(c)
    end))
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- METHODS
------------------------------------------------------------------------------------------------------------------------------------------------------------------




------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PRIMARY OPTIONS TABLE
------------------------------------------------------------------------------------------------------------------------------------------------------------------

function R:PrepareOptions()

	self.options = {
		name = function()
			local debugMsg = "    "
			if self.db.profile.debugMode then
				debugMsg = debugMsg..L["(running in debug mode)"]
			end
			return "Rarity         r|cff20ff20"..self.MINOR_VERSION.."|r"..debugMsg
		end,
		handler = Rarity,
		type = "group",
		childGroups = "tab",
		args = {
		
-- General --------------------------------------------------------------------------------------------------------------------------------------

			general = {
				type = "group",
				name = L["General"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				

					general = {
						type = "group",
						name = L["General Options"],
						order = newOrder(),
						inline = true,
						args = {
						
							minimap = {
								type = "toggle",
								order = newOrder(),
								name = L["Show minimap icon"],
								desc = L["Turns on a minimap icon for Rarity. Use this option if you don't have an LDB display add-on."],
								get = function() return not self.db.profile.minimap.hide end,
								set = function(info, val)
									self.db.profile.minimap.hide = not val
									if val then LibStub("LibDBIcon-1.0"):Show("Rarity") else LibStub("LibDBIcon-1.0"):Hide("Rarity") end
									self:Update("OPTIONS")
								end,
							}, -- minimap
							
							holidayReminder = {
								type = "toggle",
								order = newOrder(),
								name = L["Holiday reminders"],
								desc = L["When on, Rarity will remind you to go farm holiday items you're missing if the holiday is active and the item is set as Undefeated. (This only works for items that originate from holiday dungeons or daily quests.) The reminder occurs each time you log in or reload your UI, and stops for the day once you defeat the holiday dungeon or complete the	quest."],
								get = function() return self.db.profile.holidayReminder end,
								set = function(info, val)
									self.db.profile.holidayReminder = val
									self:UpdateText()
								end,
							},

							takeScreenshot = {
								type = "toggle",
								order = newOrder(),
								name = L["Take screenshots"],
								desc = L["When on, Rarity will take a screenshot when the achievement alert pops up indicating that you obtained an item."],
								get = function() return self.db.profile.takeScreenshot end,
								set = function(info, val)
									self.db.profile.takeScreenshot = val
									self:UpdateText()
								end,
							},

							feedText = {
								type = "select",
								name = L["Feed text"],
								desc = L["Controls what type of text is shown in Rarity's LDB feed. Minimal shows just the number of attempts. Normal adds the likelihood percent, and verbose adds the item link."],
								values = {
									[FEED_MINIMAL] = L["Minimal"],
									[FEED_NORMAL] = L["Normal"],
									[FEED_VERBOSE] = L["Verbose"],
								},
								get = function() return self.db.profile.feedText end,
								set = function(info, val)
									self.db.profile.feedText = val
									self:Update("OPTIONS")
								end,
								order = newOrder(),
							}, -- feedText

					  debug = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Debug mode"],
						  get = function() return self.db.profile.debugMode end,
						  set = function(info, val)
							  self.db.profile.debugMode = val
         if self.db.profile.debugMode then	self:Print(L["Debug mode ON"]) else self:Print(L["Debug mode OFF"]) end
						  end,
					  }, -- debug

					  enableProfiling = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Enable profiling"],
								desc = L["When enabled, Rarity will print debug profiling messages to the chat window when certain things happen. This is used to determine which parts of the code are slow."],
						  get = function() return self.db.profile.enableProfiling end,
						  set = function(info, val)
							  self.db.profile.enableProfiling = val
         if self.db.profile.enableProfiling then	self:Print(L["Profiling ON"]) else self:Print(L["Profiling OFF"]) end
						  end,
					  }, -- enableProfiling

						}, -- args
					}, -- general


					rarityTooltip = {
						type = "group",
						name = L["Rarity Tooltip Options"],
						order = newOrder(),
						inline = true,
						args = {
						
							showCategoryIcons = {
								type = "toggle",
								order = newOrder(),
								name = L["Show category icons"],
								desc = L["When on, Rarity will show an icon next to each item in the tooltip indicating which expansion the item belongs to."],
								get = function() return self.db.profile.showCategoryIcons end,
								set = function(info, val)
									self.db.profile.showCategoryIcons = val
									self:UpdateText()
								end,
							},

							hideHighChance = {
								type = "toggle",
								order = newOrder(),
								name = L["Hide high chance items"],
								desc = L["When on, this option hides any item with a drop chance of 1 in 49 or better. The item is merely hidden from the tooltip in order to keep it clean. Items hidden in this fashion are still tracked like normal."],
								get = function() return self.db.profile.hideHighChance end,
								set = function(info, val)
									self.db.profile.hideHighChance = val
									self:UpdateText()
								end,
							},

							hideUnavailable = {
								type = "toggle",
								order = newOrder(),
								name = L["Hide unavailable items"],
								desc = L["When on, items marked as Unavailable will be hidden from the tooltip. This way, items requiring a certain holiday will automatically be hidden when the holiday is not active."],
								get = function() return self.db.profile.hideUnavailable end,
								set = function(info, val)
									self.db.profile.hideUnavailable = val
									self:UpdateText()
								end,
							},

							hideDefeated = {
								type = "toggle",
								order = newOrder(),
								name = L["Hide defeated items"],
								desc = L["When on, items marked as Defeated will be hidden from the tooltip."],
								get = function() return self.db.profile.hideDefeated end,
								set = function(info, val)
									self.db.profile.hideDefeated = val
									self:UpdateText()
								end,
							},

							onlyShowItemsWithAttempts = {
								type = "toggle",
								order = newOrder(),
								name = L["Hide items with no attempts"],
								desc = L["When on, items that have no attempts yet will be hidden from the tooltip."],
								get = function() return self.db.profile.onlyShowItemsWithAttempts end,
								set = function(info, val)
									self.db.profile.onlyShowItemsWithAttempts = val
									self:UpdateText()
								end,
							},

							hideOutsideZone = {
								type = "toggle",
								order = newOrder(),
								name = L["Hide items not in your zone"],
								desc = L["When on, only items that can be obtained in your current zone will be shown in the tooltip. When this is on and you're in an instance, the instance difficulty is also checked to make sure it matches what the item supports."],
								get = function() return self.db.profile.hideOutsideZone end,
								set = function(info, val)
									self.db.profile.hideOutsideZone = val
									self:UpdateText()
								end,
							},

							showTimeColumn = {
								type = "toggle",
								order = newOrder(),
								name = L["Show Time column"],
								desc = L["When on, the Time column will be shown in the main tooltip."],
								get = function() return self.db.profile.showTimeColumn end,
								set = function(info, val)
									self.db.profile.showTimeColumn = val
									self:UpdateText()
								end,
							},

							showLuckinessColumn = {
								type = "toggle",
								order = newOrder(),
								name = L["Show Luckiness column"],
								desc = L["When on, the Luckiness column will be shown in the main tooltip."],
								get = function() return self.db.profile.showLuckinessColumn end,
								set = function(info, val)
									self.db.profile.showLuckinessColumn = val
									self:UpdateText()
								end,
							},

							showZoneColumn = {
								type = "toggle",
								order = newOrder(),
								name = L["Show Zone column"],
								desc = L["When on, the Zone column will be shown in the main tooltip."],
								get = function() return self.db.profile.showZoneColumn end,
								set = function(info, val)
									self.db.profile.showZoneColumn = val
									self:UpdateText()
								end,
							},

				   tooltipScale = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Primary tooltip scale"],
								desc = L["Adjusts the scale of the primary tooltip. This will take effect the next time the tooltip is shown."],
					   min = .1,
					   max = 5,
					   step = .05,
					   get = function() return self.db.profile.tooltipScale or 1 end,
					   set = function(_, val)
         self.db.profile.tooltipScale = val
        end,
				   },

				   tooltipHideDelay = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Primary tooltip hide delay"],
								desc = L["When you move your mouse out of the Rarity tooltip, it will take this long before it automatically hides itself."],
					   min = 0,
					   max = 5,
					   step = .1,
					   get = function() return self.db.profile.tooltipHideDelay or 0.6 end,
					   set = function(_, val)
         self.db.profile.tooltipHideDelay = val
        end,
				   },

							statusTip = {
								type = "select",
								name = L["Secondary tooltip display"],
								desc = L["Controls on which side the secondary tooltip appears when you hover over an item in the main tooltip. If the main tooltip is on the right side of your screen, change this to Left. Otherwise, choose Right. You can also hide the status tooltip completely."],
								values = {
									[TIP_LEFT] = L["Left"],
									[TIP_RIGHT] = L["Right"],
									[TIP_HIDDEN] = L["Hidden"],
								},
								get = function() return self.db.profile.statusTip or TIP_RIGHT end,
								set = function(info, val)
									self.db.profile.statusTip = val
									self:Update("OPTIONS")
								end,
								order = newOrder(),
							}, -- statusTip

						}, -- args
					}, -- rarityTooltip



					worldTooltips = {
						type = "group",
						name = L["World Tooltip Options"],
						order = newOrder(),
						inline = true,
						args = {
						
							enableTooltipAdditions = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Enable tooltip additions"],
								desc = L["When enabled, Rarity will add obtainable items to game tooltips whenever possible."],
								get = function() return self.db.profile.enableTooltipAdditions end,
								set = function(info, val)
									self.db.profile.enableTooltipAdditions = val
									self:UpdateText()
								end,
							},

							blankLineAfterRarity = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Put \"Rarity:\" on a separate line"],
								desc = L["When on, the text \"Rarity:\" will be put on its own line in world and item tooltips."],
								get = function() return self.db.profile.blankLineAfterRarity end,
								set = function(info, val)
									self.db.profile.blankLineAfterRarity = val
									self:UpdateText()
								end,
							},

							blankLineBeforeTooltipAdditions = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Blank line before tooltip additions"],
								desc = L["This causes Rarity to put a blank line above its tooltip additions."],
								get = function() return self.db.profile.blankLineBeforeTooltipAdditions end,
								set = function(info, val)
									self.db.profile.blankLineBeforeTooltipAdditions = val
									self:UpdateText()
								end,
							},

							tooltipAttempts = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Show attempts in tooltips"],
								desc = L["When enabled, Rarity tooltips will include how many attempts you've made."],
								get = function() return self.db.profile.tooltipAttempts end,
								set = function(info, val)
									self.db.profile.tooltipAttempts = val
									self:UpdateText()
								end,
							},

						}, -- args
					}, -- worldTooltips


					--[[groupFinder = {
						type = "group",
						name = L["Group Finder Options"],
						order = newOrder(),
						inline = true,
						args = {
						
							showGroupFinderAutoRefresh = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Show auto refresh checkbox"],
								desc = L["When enabled, Rarity will add an Auto checkbox to the Group Finder's search window. You can check this checkbox to enable auto-refresh of your searches every 5 seconds."],
								get = function() return self.db.profile.showGroupFinderAutoRefresh end,
								set = function(info, val)
									self.db.profile.showGroupFinderAutoRefresh = val
									if RarityGroupFinderAutoRefresh ~= nil then
										if self.db.profile.showGroupFinderAutoRefresh then RarityGroupFinderAutoRefresh:Show() else RarityGroupFinderAutoRefresh:Hide() end
									end
								end,
							},

							enableGroupFinderAlert = {
								type = "toggle",
								order = newOrder(),
								width = "double",
								name = L["Play a sound when groups are found"],
								desc = L["When enabled, Rarity will play a sound when an auto-refresh search results in one or more groups found in the Group Finder. This sound cannot play more than once per minute."],
								get = function() return self.db.profile.enableGroupFinderAlert end,
								set = function(info, val)
									self.db.profile.enableGroupFinderAlert = val
									self:UpdateText()
								end,
							},

						}, -- args
					}, -- groupFinder
]]

					contentCategory = {
						type = "group",
						name = L["Content Category"],
						order = newOrder(),
						inline = true,
						args = {
						
						desc = {
							type = "description",
							name = L["These toggles control which items appear in the main Rarity tooltip. Items are categorized by the expansion they were introduced in (although holiday items have a separate category). Turning off these checkboxes does not turn off tracking for any items within the category; it simply hides the item from the tooltip in order to help reduce the number of items in it."],
							order = newOrder(),
						},

					  holiday = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Holiday"],
						  get = function() return self.db.profile.cats[HOLIDAY] end,
						  set = function(info, val)
							  self.db.profile.cats[HOLIDAY] = val
							  self:UpdateText()
						  end,
					  },

					  base = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Classic"],
						  get = function() return self.db.profile.cats[BASE] end,
						  set = function(info, val)
							  self.db.profile.cats[BASE] = val
							  self:UpdateText()
						  end,
					  },

					  tbc = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["The Burning Crusade"],
						  get = function() return self.db.profile.cats[TBC] end,
						  set = function(info, val)
							  self.db.profile.cats[TBC] = val
							  self:UpdateText()
						  end,
					  },

					  wotlk = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Wrath of the Lich King"],
						  get = function() return self.db.profile.cats[WOTLK] end,
						  set = function(info, val)
							  self.db.profile.cats[WOTLK] = val
							  self:UpdateText()
						  end,
					  },

					  cata = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Cataclysm"],
						  get = function() return self.db.profile.cats[CATA] end,
						  set = function(info, val)
							  self.db.profile.cats[CATA] = val
							  self:UpdateText()
						  end,
					  },

					  mop = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Mists of Pandaria"],
						  get = function() return self.db.profile.cats[MOP] end,
						  set = function(info, val)
							  self.db.profile.cats[MOP] = val
							  self:UpdateText()
						  end,
					  },

					  wod = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Warlords of Draenor"],
						  get = function() return self.db.profile.cats[WOD] end,
						  set = function(info, val)
							  self.db.profile.cats[WOD] = val
							  self:UpdateText()
						  end,
					  },

					  legion = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Legion"],
						  get = function() return self.db.profile.cats[LEGION] end,
						  set = function(info, val)
							  self.db.profile.cats[LEGION] = val
							  self:UpdateText()
						  end,
					  },

						}, -- args
					}, -- contentCategory


					bar = {
						type = "group",
						name = L["Progress Bar"],
						order = newOrder(),
						inline = true,
						args = {
						
					  anchor = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Show anchor"],
						  get = function() return self.db.profile.bar.anchor end,
						  set = function(info, val)
							  self.db.profile.bar.anchor = val
							  self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

					  locked = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Locked"],
						  get = function() return self.db.profile.bar.locked end,
						  set = function(info, val)
							  self.db.profile.bar.locked = val
							  self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

					  growUp = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Grow Up"],
						  get = function() return self.db.profile.bar.growUp end,
						  set = function(info, val)
							  self.db.profile.bar.growUp = val
									self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

					  rightAligned = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Right-Aligned"],
						  get = function() return self.db.profile.bar.rightAligned end,
						  set = function(info, val)
							  self.db.profile.bar.rightAligned = val
									self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

					  showIcon = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Show Icon"],
						  get = function() return self.db.profile.bar.showIcon end,
						  set = function(info, val)
							  self.db.profile.bar.showIcon = val
									self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

					  showText = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Show Text"],
						  get = function() return self.db.profile.bar.showText end,
						  set = function(info, val)
							  self.db.profile.bar.showText = val
									self:UpdateBar()
							  self:UpdateText()
						  end,
					  },

				   width = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Width"],
					   min = 10,
					   max = 1000,
					   step = 1,
					   get = function() return self.db.profile.bar.width or 150 end,
					   set = function(_, val)
         self.db.profile.bar.width = val
							  self:UpdateBar()
         self:UpdateText()
        end,
				   },

				   height = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Height"],
					   min = 1,
					   max = 300,
					   step = 1,
					   get = function() return self.db.profile.bar.height or 12 end,
					   set = function(_, val)
         self.db.profile.bar.height = val
							  self:UpdateBar()
         self:UpdateText()
        end,
				   },

				   scale = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Scale"],
					   min = .1,
					   max = 5,
					   step = .05,
					   get = function() return self.db.profile.bar.scale or 1 end,
					   set = function(_, val)
         self.db.profile.bar.scale = val
							  self:UpdateBar()
         self:UpdateText()
        end,
				   },

							font = {
					   order = newOrder(),
								type = "select",
								dialogControl = "LSM30_Font",
								width = "double",
								name = L["Font"],
								values = media:HashTable("font"),
								get = function()
									return self.db.profile.bar.font
								end,
								set = function(_, key)
									self.db.profile.bar.font = key
									self:UpdateBar()
									self:UpdateText()
								end,
							},

				   fontSize = {
					   order = newOrder(),
					   type = "range",
        width = "double",
					   name = L["Font Size"],
					   min = 1,
					   max = 100,
					   step = 1,
					   get = function() return self.db.profile.bar.fontSize or 8 end,
					   set = function(_, val)
         self.db.profile.bar.fontSize = val
									self:UpdateBar()
         self:UpdateText()
        end,
				   },

							texture = {
					   order = newOrder(),
								type = "select",
								dialogControl = "LSM30_Statusbar",
								width = "double",
								name = L["Texture"],
								values = media:HashTable("statusbar"),
								get = function()
									return self.db.profile.bar.texture
								end,
								set = function(_, key)
									self.db.profile.bar.texture = key
									self:UpdateBar()
									self:UpdateText()
								end,
							},

						}, -- args
					}, -- bar

					announcements = {
						type = "group",
						name = L["Announcements"],
						order = newOrder(),
						inline = true,
						args = {
						
					  onlyAnnounceFound = {
						  type = "toggle",
						  order = newOrder(),
						  name = L["Only announce when found"],
								desc = L["Announcements will only be triggered when the item is found. When this is off, Rarity will announce every attempt and when the item is found."],
						  get = function() return self.db.profile.onlyAnnounceFound end,
						  set = function(info, val)
							  self.db.profile.onlyAnnounceFound = val
						  end,
					  },

							output = self:GetSinkAce3OptionsDataTable(),

						}, -- args
					}, -- announcements

				}, -- args
			}, -- general
		
-- Mounts ---------------------------------------------------------------------------------------------------------------------------------------

			mounts = {
				type = "group",
				name = L["Mounts"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:CreateGroup(...)
			
				}, -- args
			}, -- mounts

-- Companions -----------------------------------------------------------------------------------------------------------------------------------

			companions = {
				type = "group",
				name = L["Battle Pets"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:CreateGroup(...)
			
				}, -- args
			}, -- companions

-- Items ----------------------------------------------------------------------------------------------------------------------------------------

			items = {
				type = "group",
				name = L["Toys & Items"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:CreateGroup(...)
			
				}, -- args
			}, -- items

-- Custom ---------------------------------------------------------------------------------------------------------------------------------------

			custom = {
				type = "group",
				name = L["Custom"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:CreateGroup(...)
			
				}, -- args
			}, -- custom


	-- Import/Export --------------------------------------------------------------------------------------------------------------------------------

			importExport = {
				type = "group",
				name = L["Import/Export"],
				order = newOrder(),
				childGroups = "tree",
				args = {

					head1 = {
						type = "description",
						order = newOrder(),
						name = L["This tab lets you import and export items into and out of your Custom tab."],
					},

					blankLine1 = {
						type = "description",
						order = newOrder(),
						name = " ",
					},
				
					spacer1 = { type = "header", name = L["Import Rarity Item Pack"], order = newOrder(), },
				
					head2 = {
						type = "description",
						order = newOrder(),
						name = L["To import a group of items, paste a Rarity Item Pack string into the Import text box below and click the Import button. Rarity will tell you which items were imported (or which ones failed to import) in your chat window. You can find many Rarity Item Packs on the Curse web site, or elsewhere on the web."],
					},

					importPreview = {
						type = "description",
						order = newOrder(),
						name = function()
							self.db.profile.importIsError = false
							local s

							-- Validate the import (this also can disable the Import button, so we only do validation here)
							local enc = dec64(self.db.profile.lastImportString)
							if not enc then
								self.db.profile.importIsError = true
								s = colorize(L["The selected Rarity Item Pack string is invalid."], red)
								if R.db.profile.debugMode then s = s..colorize(" (Reason: Decoding failed)", red) end
								return "\n"..s.."\n"
							end
							local c = R:Decompress(enc)
							if not c then
								self.db.profile.importIsError = true
								s = colorize(L["The selected Rarity Item Pack string is invalid."], red)
								if R.db.profile.debugMode then s = s..colorize(" (Reason: Decompression failed)", red) end
								return "\n"..s.."\n"
							end
							local success, e = R:Deserialize(c)
							if not success or not e then
								self.db.profile.importIsError = true
								s = colorize(L["The selected Rarity Item Pack string is invalid."], red)
								if R.db.profile.debugMode then s = s..colorize(" (Reason: Deserialization failed)", red) end
								return "\n"..s.."\n"
							end
							Rarity.itemPack = e -- The decoded object is placed here for use during Import, this way we only have to do all of this one time
							
							-- We have an object, now do logical validation
							local numItems = 0
							if type(e) == "table" and e.items and type(e.items) == "table" then
								for k, v in pairs(e.items) do
									numItems = numItems + 1
									break
								end
							end
							if type(e) == "table" and e.items and type(e.items) == "table" and numItems > 0 and e.build and tonumber(e.build) > 0 and e.signature and e.signature == IMPORTEXPORT_SIGNATURE then

								-- Import is good; create a preview
								s = "\n"..L["Here is a preview of what will (or won't) be imported:"].."\n\n"

								for itemkey, item in pairs(e.items) do
									local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
									local status = colorize(" - "..L["will be imported"], green)
									R:CleanItemForImport(item)
									item.import = true
									if not itemLink then status = status.." "..colorize(L["(Warning: item could not be retrieved from server)"], red) end

									for k, v in pairs(allitems()) do
										if strupper(strtrim(k)) == strupper(item.name) or strupper(strtrim(v.name or "")) == strupper(item.name) then
											item.import = false
											status = colorize(" - "..L["an item already exists by this name, so it will not be imported"], red)
										end
									end

									for k, v in pairs(allitems()) do
										if item.itemId == v.itemId then
											item.import = false
											status = colorize(" - "..L["an item with the same Item ID already exists, so it will not be imported"], red)
										end
									end

									s = s..(itemLink or item.name or "Unknown")..status.."\n"
								end

								return s
							else
								self.db.profile.importIsError = true
								s = "\n"..colorize(L["The selected Rarity Item Pack string is invalid."], red).."\n"
								if R.db.profile.debugMode then s = s..colorize(" (Reason: Validation failed)", red) end
								return "\n"..s.."\n"
							end

						end,
						hidden = function() return not self.db.profile.lastImportString or strtrim(self.db.profile.lastImportString) == "" end,
					},
				
					importText = {
						order = newOrder(),
						type = "input",
						width = "double",
						name = L["Rarity Item Pack String"],
						desc = L["Paste a Rarity Item Pack String here using Ctrl-V, then click the Import button."],
						set = function(info, val)
							self.db.profile.lastImportString = val
						end,
						get = function()
							return self.db.profile.lastImportString or ""
						end,
					}, -- importText

					import = {
						type = "execute",
						name = L["Import"],
						confirm = true,
						confirmText = L["Are you sure you want to import the Rarity Item Pack you entered?"],
						func = function(info)
							if not Rarity.itemPack then return end

							-- Do the import
							for itemkey, item in pairs(Rarity.itemPack.items) do
								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
								if not item.import then
									R:Print((itemLink or item.name or "Unknown").." - "..colorize(L["not imported"], red))
								else
									item.import = false
									item.export = false
									self.db.profile.groups.user[item.name] = item
									R:Print((itemLink or item.name or "Unknown").." - "..colorize(L["imported successfully"], green))
								end
							end
							
							self:CreateGroup(self.options.args.custom, self.db.profile.groups.user, true)
							self:Update("IMPORT")
							self.db.profile.lastImportString = ""
						end,
						order = newOrder(),
						disabled = function()
							if not self.db.profile.lastImportString or strtrim(self.db.profile.lastImportString) == "" then return true end
							if self.db.profile.importIsError then return true end
							return false
						end
					}, -- import

					blankLine2 = {
						type = "description",
						order = newOrder(),
						name = " ",
					},
				
					spacer2 = { type = "header", name = L["Export Rarity Item Pack"], order = newOrder(), },
				
					head3 = {
						type = "description",
						order = newOrder(),
						name = L["To export a group of items, go through each item in your Custom tab and check or uncheck the Export checkbox. The checkbox will be disabled if you haven't yet filled out enough information for Rarity to detect the item. Once you've done that, return here and click the Export button. A Rarity Item Pack string will be generated that you can copy to the clipboard using Ctrl-C."],
					},

					exportPreview = {
						type = "description",
						order = newOrder(),
						name = function()
							local s = ""
							local numItems = 0
							local g = sort(self.db.profile.groups.user)
							local foundRed = false
							for itemkey, item in pairs(g) do
								if item and type(item) == "table" and item.export and Rarity:CanItemBeExportedImported(item) then
									local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice = GetItemInfo(item.itemId)
									s = s..(itemLink or colorize(item.name, red)).."\n"
									if not itemLink then foundRed = true end
									numItems = numItems + 1
								end
							end
							if foundRed then s = s.."\n"..colorize(L["(Items listed in red could not be found on the server and may not exist. Consider removing them.)"], red) end
							s = "\n"..format(L["The following %d item(s) have been selected to export:"], numItems).."\n\n"..s
							return s
						end,
						hidden = function()
							for itemkey, item in pairs(self.db.profile.groups.user) do
								if item and type(item) == "table" and item.export then return false end
							end
							return true
	     end,
					},
				
					export = {
						type = "execute",
						name = L["Export"],
						func = function(info)
							-- Do the export
							local e = { items = {} }
							local g = sort(self.db.profile.groups.user)
							for itemkey, item in pairs(g) do
								if item and type(item) == "table" and item.export and Rarity:CanItemBeExportedImported(item) then
									e.items[itemkey] = item
								end
							end
							e.build = Rarity.MINOR_VERSION
							e.signature = IMPORTEXPORT_SIGNATURE
							local s = R:Serialize(e)
							if not s then
								alert(L["Error serializing item pack"])
								return
							end
							local c = R:Compress(s)
							if not c then
								alert(L["Error compressing item pack"])
								return
							end
							local enc = enc64(c)
							if not enc then
								alert(L["Error encoding item pack"])
								return
							end

							alertWithCopy(L["Copy the generated Rarity Item Pack string below using Ctrl-C. You can then paste it elsewhere using Ctrl-V.\n\nFeel free to comment on the Curse web site to share your Item Pack. Allara will promote the best ones to the main add-on page."], enc)
						end,
						order = newOrder(),
						disabled = function()
							for itemkey, item in pairs(self.db.profile.groups.user) do
								if item and type(item) == "table" and item.export then return false end
							end
							return true
	     end,
					}, -- export

					clearAllExport = {
						type = "execute",
						name = L["Clear All Exports"],
						confirm = true,
						confirmText = L["Are you sure you want to turn off the Export toggle for all your Custom items?"],
						func = function(info)
							for itemkey, item in pairs(self.db.profile.groups.user) do
								if item and type(item) == "table" then item.export = false end
							end
						end,
						order = newOrder(),
						disabled = function()
							for itemkey, item in pairs(self.db.profile.groups.user) do
								if item and type(item) == "table" and item.export then return false end
							end
							return true
	     end,
					}, -- export

				},
			},

-------------------------------------------------------------------------------------------------------------------------------------------------

		}, -- args
	} -- self.options

 -- Create the options for each group of items
	self:CreateGroup(self.options.args.mounts, self.db.profile.groups.mounts, false)
	self:CreateGroup(self.options.args.companions, self.db.profile.groups.pets, false)
	self:CreateGroup(self.options.args.items, self.db.profile.groups.items, false)
	self:CreateGroup(self.options.args.custom, self.db.profile.groups.user, true)

end -- function R:PrepareOptions()




------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEM GROUPS
------------------------------------------------------------------------------------------------------------------------------------------------------------------


function R:CreateGroup(options, group, isUser)

 options.args = {
		name = {
			type = "execute",
			type = "input",
			width = "double",
			name = L["Create a new item to track"],
   desc = L["To create a new item, enter a unique name for the item, and click Okay. The name will be used if the server does not return the item link or if the item is invalid.\n\nYou can't change this name after you create the item, so choose it well."],
			set = function(info, val)
				if strtrim(val) ~= "" then
     val = strtrim(val)
     if strupper(val) == "NAME" or strupper(val) == "COLLAPSED" or strupper(val) == "COLLAPSEDGROUP" then
      alert(L["You entered a reserved name. Please enter the correct item name as it appears in game."])
      return
     end
     for k, v in pairs(allitems()) do
      if strupper(strtrim(k)) == strupper(val) or strupper(strtrim(v.name or "")) == strupper(val) then
       alert(L["The name you entered is already being used by another item. Please enter a unique name."])
       return
      end
     end
     self.db.profile.groups.user[val] = { name = val }
     self:Update("OPTIONS")
	    self:CreateGroup(self.options.args.custom, self.db.profile.groups.user, true)
				end
			end,
			hidden = not isUser,
		},
 }

 local g = sort(group)
 for itemkey, item in pairs(g) do
  local optionkey = tostring(newOrder())
  options.args[optionkey] = {
		 type = "group",
   order = newOrder(),
		 name = function() return select(2, GetItemInfo(item.itemId or 0)) or item.name end,
		 args = {
			
			 head = {
				 type = "description",
				 order = newOrder(),
				 name = function() return select(2, GetItemInfo(item.itemId or 0)) or item.name end,
				 fontSize = "large"
			 },
				
			 head = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["Unable to retrieve item information from the server"], red),
				 fontSize = "large",
					hidden = function() return GetItemInfo(item.itemId) end
			 },
				
				export = {
					order = newOrder(),
					type = "toggle",
					name = L["Export this item"],
					desc = L["Check this for every Custom item you wish to export. Then click on the Import/Export tab and click the Export button. This checkbox will be disabled until enough information has been filled in below to make it a detectable item."],
					get = function()
      if item.export == true and R:CanItemBeExportedImported(item) then
							return true
						else
							item.export = false
							return false
						end
     end,
					set = function(info, val)
						item.export = val
					end,
     hidden = not isUser,
     disabled = function()
						return not R:CanItemBeExportedImported(item)
					end,
				},

			 delete = {
				 type = "execute",
				 name = L["Delete this item"],
				 confirm = true,
				 confirmText = L["Are you sure you want to delete this item?"],
				 func = function(info)
      self.db.profile.groups.user[item.name] = nil
	     self:CreateGroup(self.options.args.custom, self.db.profile.groups.user, true)
					 self:Update("OPTIONS")
				 end,
				 order = newOrder(),
				 hidden = not isUser,
			 },
				
			 source = {
				 type = "description",
				 order = newOrder(),
				 name = function()
						if item.type == MOUNT and item.spellId ~= nil and Rarity.mount_sources[item.spellId] ~= nil then
							return Rarity.mount_sources[item.spellId]
						end
						if item.type == PET and item.creatureId ~= nil and Rarity.pet_sources[item.creatureId] ~= nil then
							return Rarity.pet_sources[item.creatureId]
						end
					end,
					hidden = function()
						if item.type == MOUNT and item.spellId ~= nil and Rarity.mount_sources[item.spellId] ~= nil then
							return false
						end
						if item.type == PET and item.creatureId ~= nil and Rarity.pet_sources[item.creatureId] ~= nil then
							return false
						end
						return true
					end,
			 },
				
			 sourceExtra = {
				 type = "description",
				 order = newOrder(),
				 name = item.sourceText or "",
					hidden = item.sourceText == nil or item.sourceText == "",
			 },
				
			 worldBossFactionless = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["All players can participate in killing this world boss once per week, regardless of faction"], blue),
					hidden = item.worldBossFactionless == false or item.worldBossFactionless == nil,
			 },
				
			 wasGuaranteed = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["This was a guaranteed drop for players who defeated the encounter when it was current"], blue),
					hidden = item.wasGuaranteed == false or item.wasGuaranteed == nil,
			 },
				
			 bonusSatchel = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["Contained in bonus satchels"], yellow),
					hidden = item.bonusSatchel == false or item.bonusSatchel == nil,
			 },
				
			 blackMarket = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["Appears in the Black Market"], yellow),
					hidden = item.blackMarket == false or item.blackMarket == nil,
			 },
				
			 enableCoinD = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["Can be obtained with a bonus roll"], yellow),
					hidden = item.enableCoin == false or item.enableCoin == nil,
			 },
				
			 requiresAllianceT = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["This mount is only obtainable by Alliance players"], red),
					hidden = item.requiresAlliance == false or item.requiresAlliance == nil,
			 },
				
			 requiresHordeT = {
				 type = "description",
				 order = newOrder(),
				 name = colorize(L["This mount is only obtainable by Horde players"], red),
					hidden = item.requiresHorde == false or item.requiresHorde == nil,
			 },
				
			 blankLine = {
				 type = "description",
				 order = newOrder(),
				 name = " ",
					hidden = item.sourceText == nil or item.sourceText == "",
			 },
				
			 spacer1 = { type = "header", name = L["Identify the Item"], order = newOrder(), },

				method = {
					type = "select",
					name = L["Method of obtaining"],
					desc = L["Determines how this item is obtained."],
     width = "double",
					values = {
						[NPC] = R.string_methods[NPC],
						[BOSS] = R.string_methods[BOSS],
						[ZONE] = R.string_methods[ZONE],
						[USE] = R.string_methods[USE],
						[FISHING] = R.string_methods[FISHING],
						[ARCH] = R.string_methods[ARCH],
						[COLLECTION] = R.string_methods[COLLECTION]
					},
					get = function() return item.method end,
					set = function(info, val)
						item.method = val
						self:Update("OPTIONS")
					end,
					order = newOrder(),
     disabled = not isUser,
				},

				type = {
					type = "select",
					name = L["Type of item"],
					desc = L["Determines what type of item this is."],
					values = {
						[MOUNT] = L["Mount"],
						[PET] = L["Battle Pet"],
						[ITEM] = L["Toy or Item"],
					},
					get = function() return item.type end,
					set = function(info, val)
						item.type = val
						self:Update("OPTIONS")
					end,
					order = newOrder(),
     hidden = not isUser,
				},

		  itemId = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Item ID"],
     desc = L["The item ID to track. This is the item as it appears in your inventory or in a loot window. Use WowHead or a similar service to lookup item IDs. This must be a valid number and must be unique."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an item ID."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       for _, v in pairs(allitems()) do
        if v.itemId == tonumber(val) then
         alert(L["You entered an item ID that is already being used by another item."])
         return
        end
       end
       if tonumber(val) <= 0 then alert(L["You must enter a number larger than 0."])
       else item.itemId = tonumber(val) end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.itemId then return tostring(item.itemId) else return nil end end,
			  disabled = not isUser,
		  },
							
		  collectedItemId = {
			  type = "input",
     order = newOrder(),
			  name = L["Item ID to Collect"],
     desc = L["The item ID that you need to collect. Rarity uses the number of this item that you have in your bags as your progress. Use WowHead or a similar service to lookup item IDs. This must be a valid number and must not be used by another item."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an item ID."])
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" then
         alert(L["Please enter a comma-separated list of item IDs."])
         return
        end
       end
       item.collectedItemId = {}
       for k, v in pairs(list) do
        table.insert(item.collectedItemId, strtrim(v))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.collectedItemId and type(item.collectedItemId) == "table" then
       local s = ""
       for k, v in pairs(item.collectedItemId) do
        if strlen(s) > 0 then s = s.."," end
        s = s..v
       end
       return s
      elseif item.collectedItemId then
							return tostring(item.collectedItemId)
						else
							return nil
						end
     end,
			  disabled = not isUser,
			  hidden = function() return item.method ~= COLLECTION end,
		  },
							
		  spellId = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Spell ID"],
     desc = L["The spell ID of the item once you've learned it. This applies only to mounts and companions, and is the spell as it appears in your spell book after learning the item. Use WowHead or a similar service to lookup spell IDs. This must be a valid number and must be unique."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter a spell ID."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       for _, v in pairs(allitems()) do
        if v.spellId == tonumber(val) then
         alert(L["You entered a spell ID that is already being used by another item."])
         return
        end
       end
       if tonumber(val) <= 0 then alert(L["You must enter a number larger than 0."])
       else item.spellId = tonumber(val) end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.spellId then return tostring(item.spellId) else return nil end end,
			  hidden = function()
      if item.type == MOUNT or item.type == PET then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
		  creatureId = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Creature ID"],
     desc = L["The NPC ID of the creature that is spawned when you summon this pet. This is used to track account-wide battle pets."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter a creature ID."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       for _, v in pairs(allitems()) do
        if v.creatureId == tonumber(val) then
         alert(L["You entered a creature ID that is already being used by another item."])
         return
        end
       end
       if tonumber(val) <= 0 then alert(L["You must enter a number larger than 0."])
       else item.creatureId = tonumber(val) end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.creatureId then return tostring(item.creatureId) else return nil end end,
			  hidden = function()
      if item.type == PET then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
				raceId = {
					type = "select",
					name = L["Archaeology race"],
					desc = L["Determines which race includes this archaeology project."],
					values = R.string_archraces,
					get = function() return item.raceId end,
					set = function(info, val)
						item.raceId = val
						self:Update("OPTIONS")
					end,
					order = newOrder(),
     disabled = not isUser,
     hidden = function() return item.method ~= ARCH end,
				},

		  zones = {
			  type = "input",
     order = newOrder(),
     width = "double",
			  name = L["Zones"],
     desc = L["A comma-separated list of the zones or sub-zones this item can be found in. For zones, you can enter either the Map ID (i.e. 811 is Vale of Eternal Blossoms), or the full name of the zone. For sub-zones, you must enter the full name of the sub-zone.\n\nEnter zone names with proper spelling, capitalization, and punctuation. They can be entered either in US English or your client's local language. Use WowHead or a similar service to make sure you're entering the zone names perfectly.\n\nPLEASE NOTE: Zone translations may not be correct. For zones, it is highly recommended that you use the Map ID instead of the name. For sub-zones, you must enter the name. If sub-zone detection isn't working for you, please visit the LibBabble-SubZone-3.0 library page on wowace.com and update the translations for your language."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter at least one zone."])
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" then
         alert(L["Please enter a comma-separated list of zones."])
         return
        else
									if tonumber(v) == nil then
										if lbz:GetUnstrictLookupTable()[v] == nil and lbz:GetReverseLookupTable()[v] == nil and lbsz:GetUnstrictLookupTable()[v] == nil and lbsz:GetReverseLookupTable()[v] == nil then
											alert(format(L["One of the zones or sub-zones you entered (%s) cannot be found. Check that it is spelled correctly, and is either US English or your client's local language."], v))
											return
										end
									else
										local mapID = tonumber(v)
										if mapID <= 0 then
											alert(format(L["One of the Map IDs you entered (%s) is incorrect. Please enter numbers larger than zero."], v))
											return
										end
									end
        end
       end
       item.zones = {}
       for k, v in pairs(list) do
        table.insert(item.zones, strtrim(v))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.zones and type(item.zones) == "table" then
       local s = ""
       for k, v in pairs(item.zones) do
        if strlen(s) > 0 then s = s.."," end
        s = s..v
       end
       return s
      else return "" end
     end,
			  hidden = function()
      if item.method == ZONE or item.method == FISHING then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
		  items = {
			  type = "input",
     order = newOrder(),
     width = "double",
			  name = L["Items to Use"],
     desc = L["A comma-separated list of item IDs which, when used or opened, can give you this item. Use WowHead or a similar service to lookup item IDs."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter at least one item ID."])
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" or tonumber(strtrim(v)) == nil then
         alert(L["Please enter a comma-separated list of item IDs."])
         return
        elseif tonumber(strtrim(v)) <= 0 then
         alert(L["Every item ID must be a number greater than 0."])
         return
        end
       end
       item.items = {}
       for k, v in pairs(list) do
        table.insert(item.items, tonumber(strtrim(v)))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.items and type(item.items) == "table" then
       local s = ""
       for k, v in pairs(item.items) do
        if strlen(s) > 0 then s = s.."," end
        s = s..tostring(v)
       end
       return s
      else return "" end
     end,
			  hidden = function()
      if item.method == USE then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
		  npcs = {
			  type = "input",
     order = newOrder(),
     width = "double",
			  name = L["NPCs"],
     desc = L["A comma-separated list of NPC IDs who drop this item. Use WowHead or a similar service to lookup NPC IDs."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter at least one NPC ID."])
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" or tonumber(strtrim(v)) == nil then
         alert(L["Please enter a comma-separated list of NPC IDs."])
         return
        elseif tonumber(strtrim(v)) <= 0 then
         alert(L["Every NPC ID must be a number greater than 0."])
         return
        end
       end
       item.npcs = {}
       for k, v in pairs(list) do
        table.insert(item.npcs, tonumber(strtrim(v)))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.npcs and type(item.npcs) == "table" then
       local s = ""
       for k, v in pairs(item.npcs) do
        if strlen(s) > 0 then s = s.."," end
        s = s..tostring(v)
       end
       return s
      else return "" end
     end,
			  hidden = function()
      if item.method == NPC or item.method == BOSS then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
		  statistics = {
			  type = "input",
     order = newOrder(),
     width = "double",
			  name = L["Kill Statistic IDs"],
     desc = L["A comma-separated list of Statistic IDs that track the number of kills toward obtaining this item. These statistics will be added together. Use WowHead or a similar service to locate statistic IDs."],
			  set = function(info, val)
				  if strtrim(val) == "" then item.statisticId = {}
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" or tonumber(strtrim(v)) == nil then
         alert(L["Please enter a comma-separated list of Statistic IDs."])
         return
        elseif tonumber(strtrim(v)) <= 0 then
         alert(L["Every Statistic ID must be a number greater than 0."])
         return
        end
       end
       item.statisticId = {}
       for k, v in pairs(list) do
        table.insert(item.statisticId, tonumber(strtrim(v)))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.statisticId and type(item.statisticId) == "table" then
       local s = ""
       for k, v in pairs(item.statisticId) do
        if strlen(s) > 0 then s = s.."," end
        s = s..tostring(v)
       end
       return s
      else return "" end
     end,
			  hidden = function()
      if item.method == NPC or item.method == BOSS then return false else return true end
     end,
			  disabled = not isUser,
		  },
							
				requiresPool = {
					order = newOrder(),
					type = "toggle",
					name = L["Requires a pool"],
					desc = L["Determines whether the item can only be obtained from fishing in pools. In order for this option to work, the fishing pools must have all been translated into your client's language."],
					get = function()
      if item.requiresPool == true then return true else return false end
     end,
					set = function(info, val)
						item.requiresPool = val
						self:Update("OPTIONS")
					end,
     hidden = function()
      if item.method == FISHING then return false else return true end
     end,
     disabled = not isUser,
				},

			 spacer2 = { type = "header", name = L["Options"], order = newOrder(), },

				enabled = {
					order = newOrder(),
					type = "toggle",
					name = L["Track this"],
					desc = L["Determines whether tracking should be enabled for this item. Items that are disabled will not appear in the tooltip."],
					get = function()
      if item.enabled == false then return false else return true end
     end,
					set = function(info, val)
						item.enabled = val
						self:Update("OPTIONS")
					end,
				},

				found = {
					order = newOrder(),
					type = "toggle",
					name = "Found",
					get = function()
      if item.found == true then return true else return false end
     end,
					set = function(info, val)
						item.found = val
						self:Update("OPTIONS")
					end,
     hidden = function()
      return not R.db.profile.debugMode
     end,
				},

				repeatable = {
					order = newOrder(),
					type = "toggle",
					name = L["Repeatable"],
					desc = L["Determines whether you want to repeatedly farm this item. If you turn this on and find the item, Rarity will mark the item as un-found after a few seconds."],
					get = function()
      if item.repeatable == true then return true else return false end
     end,
					set = function(info, val)
						item.repeatable = val
      if val then item.enabled = true end
						self:Update("OPTIONS")
					end,
				},

				enableAnnouncements = {
					order = newOrder(),
					type = "toggle",
					name = L["Announce"],
					desc = L["Enables announcements whenever you complete a new attempt toward this item."],
					get = function()
      if item.announce == false then return false else return true end
     end,
					set = function(info, val)
						item.announce = val
						self:Update("OPTIONS")
					end,
				},

			 spacer4 = { type = "header", name = L["Attempts"], order = newOrder(), },

		  attempts = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = function()
						if item.method == COLLECTION then return L["Collected"] end
						return L["Attempts"]
					end,
			  desc = function()
						if item.method == COLLECTION then return L["How many items you've collected so far."] end
						return L["How many attempts you've made so far."]
					end,
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an amount."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       local n = tonumber(val)
       if n < 0 then alert(L["You must enter a number larger than or equal to 0."])
       else
        item.attempts = n
        item.lastAttempts = 0
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) return tostring((item.attempts or 0) - (item.lastAttempts or 0)) end,
		  },
							
		  chance = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = function()
						if item.method == COLLECTION then return L["Collection Size"] end
						return L["Chance"]
					end,
			  desc = function()
						if item.method == COLLECTION then return L["How many items you need to collect."] end
						return L["How likely the item is to appear, expressed as 1 in X, where X is the number you enter here."]
					end,
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an amount."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       local n = tonumber(val)
       if n <= 1 then alert(L["You must enter a number larger than 1."])
       else item.chance = n end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.chance then return tostring(item.chance) else return nil end end,
		  },
							
				enableCoin = {
					order = newOrder(),
					type = "toggle",
					name = L["Enable Coins"],
					desc = L["When any good-luck coin is used within about 90 seconds of an attempt on this item, another attempt will be counted for this item. Only enable this for items which can legitimately be obtained from coin rolls."],
					get = function()
      if item.enableCoin == true then return true else return false end
     end,
					set = function(info, val)
						item.enableCoin = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.method == COLLECTION end,
				},

				holidayReminder = {
					order = newOrder(),
					type = "toggle",
					name = L["Holiday reminders"],
					desc = L["When on, Rarity will remind you to go farm holiday items you're missing if the holiday is active and the item is set as Undefeated. (This only works for items that originate from holiday dungeons or daily quests.) The reminder occurs each time you log in or reload your UI, and stops for the day once you defeat the holiday dungeon or complete the	quest."],
					get = function()
      if item.holidayReminder == false then return false else return true end
     end,
					set = function(info, val)
						item.holidayReminder = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.cat ~= HOLIDAY or (item.questId == nil and item.lockDungeonId == nil and item.holidayTexture == nil) end,
				},

			 spacer3 = { type = "header", name = L["Defeat Detection"], order = newOrder(), },

		  questId = {
			  type = "input",
     order = newOrder(),
     width = "double",
			  name = L["Quest ID"],
			  desc = L["A comma-separated list of quest IDs. When these quest IDs are completed, the item is considered defeated."],
			  set = function(info, val)
				  if strtrim(val) == "" then item.questId = nil
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" or tonumber(strtrim(v)) == nil then
         alert(L["Please enter a comma-separated list of Quest IDs."])
         return
        elseif tonumber(strtrim(v)) <= 0 then
         alert(L["Every Quest ID must be a number greater than 0."])
         return
        end
       end
       item.questId = {}
       for k, v in pairs(list) do
        table.insert(item.questId, tonumber(strtrim(v)))
       end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into)
      if item.questId and type(item.questId) == "table" then
       local s = ""
       for k, v in pairs(item.questId) do
        if strlen(s) > 0 then s = s.."," end
        s = s..tostring(v)
       end
       return s
      elseif item.questId ~= nil and tonumber(item.questId) ~= nil then return tostring(item.questId) end
						return ""
     end,
			  disabled = not isUser,
		  },
							
		  lockDungeonId = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Dungeon ID"],
			  desc = L["A dungeon ID which, when marked as completed by the game client, will cause this item to be considered Defeated. This is primarily used for holiday items which have unique dungeon IDs."],
			  set = function(info, val)
				  if strtrim(val) == "" then item.lockDungeonId = nil
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       local n = tonumber(val)
       if n < 0 then alert(L["You must enter a number larger than or equal to 0."])
       else item.lockDungeonId = n end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) return tostring(item.lockDungeonId or "") end,
			  disabled = not isUser,
		  },
							
		  lockBossName = {
			  type = "input",
     order = newOrder(),
     width = "full",
			  name = L["Boss Name"],
			  desc = L["The boss name, in English (enUS), which appears in the instance lock inside the Raid Info panel. The name will be translated to your local language automatically using the LibBoss library (if detection fails, check that the translation exists in this library). IMPORTANT: This method of defeat detection only works when the boss exists in one place at a time. Certain bosses, such as Ragnaros and Kael'thas Sunstrider, exist in two instances at once. Those bosses can be used here, but killing them in either of their instances will result in this Defeat Detection triggering."],
			  set = function(info, val)
				  item.lockBossName = val
						self:Update("OPTIONS")
			  end,
     get = function(into) return item.lockBossName or "" end,
			  disabled = not isUser,
		  },
							
			 spacer5 = { type = "header", name = L["Other Requirements"], order = newOrder(), },

				pickpocket = {
					order = newOrder(),
					type = "toggle",
					name = L["Requires Pickpocketing"],
					desc = L["When enabled, the item can only be obtained by pickpocketing. The item will be marked Unavailable for non-rogues."],
					get = function()
      if item.pickpocket == true then return true else return false end
     end,
					set = function(info, val)
						item.pickpocket = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.method ~= NPC end,
				},

		  groupSize = {
			  type = "input",
     order = newOrder(),
			  name = L["Group size"],
     desc = L["The number of players it takes to obtain the item. This will lower your chances of obtaining the item."].." "..L["Enter 1 or leave this blank to mark the item as soloable."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an amount."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       local n = tonumber(val)
       if n <= 0 then alert(L["You must enter a number larger than 0."])
       else item.groupSize = n end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.groupSize then return tostring(item.groupSize) else return nil end end,
     hidden = function() return item.method ~= BOSS and item.method ~= USE end,
		  },
							
				equalOdds = {
					order = newOrder(),
					type = "toggle",
					name = L["Equal odds"],
					desc = L["Turn this on if the item requires a group to obtain, but every player gets an equal chance to obtain the item. This currently only applies to some of the holiday mounts. When you turn this on, Rarity will stop lowering your chance to obtain based on the group size."],
					get = function()
      if item.equalOdds == true then return true else return false end
     end,
					set = function(info, val)
						item.equalOdds = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.method ~= BOSS and item.method ~= USE end,
				},

				instanceDifficulty = {
					order = newOrder(),
					type = "multiselect",
					width = "double",
					name = L["Instance Difficulty"],
					desc = L["Determines which instance difficulties this item may be obtained in. Leave everything unchecked if the instance difficulty doesn't matter.\n\nIf you specified a Statistic ID for this item, the Instance Difficulty is probably meaningless, because all modern statistics already incorporate the difficulty.\n\nYou can check multiple items in this list at once."],
					values = {
						[0] = L["None (not in an instance)"],
						[1] = L["5-player instance"],
						[2] = L["5-player Heroic instance"],
						[3] = L["10-player Raid instance (legacy content; not flexible)"],
						[4] = L["25-player Raid instance (legacy content; not flexible)"],
						[5] = L["10-player Heroic Raid instance (legacy content; not flexible)"],
						[6] = L["25-player Heroic Raid instance (legacy content; not flexible)"],
						[7] = L["Raid Finder instance (legacy content; fixed at 25 players)"],
						[8] = L["Challenge Mode instance"],
						[9] = L["40-player Raid instance (legacy content; not flexible)"],
						[11] = L["Heroic Scenario instance"],
						[12] = L["Scenario instance"],
						[14] = L["Normal Raid (10-30 players)"],
						[15] = L["Heroic Raid (10-30 players)"],
						[16] = L["Mythic Raid (20 player)"],
						[17] = L["Looking For Raid (10-30 players)"],
						[18] = L["40-player Event raid"],
						[19] = L["5-player Event instance"],
						[20] = L["25-player Event scenario"],
						[23] = L["Mythic 5-player instance"],
						[24] = L["Timewalker 5-player instance"],
					},
					get = function(s, key)
      if item.instanceDifficulties then return item.instanceDifficulties[key] or false end
						return false
     end,
					set = function(s, key, state)
						if item.instanceDifficulties == nil then item.instanceDifficulties = {} end
						item.instanceDifficulties[key] = state
						self:Update("OPTIONS")
					end,
				},

				disableForClass = {
					order = newOrder(),
					type = "multiselect",
					name = L["Disable for classes"],
					desc = L["Choose which classes this item should be disabled for. Checking a class below hides the item from the Rarity tooltip and prevents it from being tracked. You can still toggle Track This, but the item will not track for any classes specified here."],
					values = classes,
					get = function(s, key)
      if item.disableForClass then return item.disableForClass[key] or false end
						return false
     end,
					set = function(s, key, state)
						if item.disableForClass == nil then item.disableForClass = {} end
						item.disableForClass[key] = state
					end,
				},

				requiresHorde = {
					order = newOrder(),
					type = "toggle",
					name = L["Horde only"],
					desc = L["This item is only available to Horde players."],
					get = function()
      if item.requiresHorde == true then return true else return false end
     end,
					set = function(info, val)
						item.requiresHorde = val
      if val then item.requiresAlliance = false end
						self:Update("OPTIONS")
					end,
				},

				requiresAlliance = {
					order = newOrder(),
					type = "toggle",
					name = L["Alliance only"],
					desc = L["This item is only available to Alliance players."],
					get = function()
      if item.requiresAlliance == true then return true else return false end
     end,
					set = function(info, val)
						item.requiresAlliance = val
      if val then item.requiresHorde = false end
						self:Update("OPTIONS")
					end,
				},

			 spacer6 = { type = "header", name = "", order = newOrder(), hidden = not isUser },

		  obtainedQuestId = {
			  type = "input",
     order = newOrder(),
			  name = L["Obtained Quest ID"],
     desc = L["Certain items, such as Illusions in your wardrobe, flag a completed Quest ID when you learn them. Rarity can automatically stop tracking this item if you enter that Quest ID here. (Only one ID, not a list.)"],
			  set = function(info, val)
				  if strtrim(val) == "" then item.obtainedQuestId = nil
      elseif tonumber(val) == nil then item.obtainedQuestId = nil
      else
       local n = tonumber(val)
       if n <= 0 then alert(L["You must enter a number larger than 0."])
       else item.obtainedQuestId = n end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.obtainedQuestId then return tostring(item.obtainedQuestId) else return nil end end,
		  },
							
		  achievementId = {
			  type = "input",
     order = newOrder(),
			  name = L["Obtained Achievement ID"],
     desc = L["Set this to the achievement ID which indicates this item has been obtained. This is useful for items which do not yield mounts or pets, but which do grant an achievement when obtained, such as Old Crafty or Old Ironjaw. Leave this blank for mounts and pets. Use WowHead to find achievement IDs."],
			  set = function(info, val)
				  if strtrim(val) == "" then item.achievementId = nil
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       for _, v in pairs(allitems()) do
        if v.achievementId == tonumber(val) then
         alert(L["You entered a achievement ID that is already being used by another item."])
         return
        end
       end
       if tonumber(val) <= 0 then alert(L["You must enter a number larger than 0."])
       else item.achievementId = tonumber(val) end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.achievementId then return tostring(item.achievementId) else return nil end end,
			  disabled = not isUser,
		  },
							
   }
  }
 end

end



