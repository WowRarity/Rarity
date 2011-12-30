if not Rarity then return end
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
local R = Rarity
local mod = R:NewModule("Options")
local lbz = LibStub("LibBabble-Zone-3.0")
local lbsz = LibStub("LibBabble-SubZone-3.0")


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

-- Feed text
local FEED_MINIMAL = "FEED_MINIMAL"
local FEED_NORMAL = "FEED_NORMAL"
local FEED_VERBOSE = "FEED_VERBOSE"

-- Tooltip position
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"



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


local function allitems()
 local t = {}
 for k, v in pairs(R.db.profile.groups.mounts) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.pets) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.items) do if type(v) == "table" then t[k] = v end end
 for k, v in pairs(R.db.profile.groups.user) do if type(v) == "table" then t[k] = v end end
 return t
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
							
					display = {
						type = "group",
						name = L["Display"],
						order = newOrder(),
						inline = true,
						args = {
						
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

							itemTip = {
								type = "select",
								name = L["Item tooltip"],
								values = {
									[TIP_LEFT] = L["Left"],
									[TIP_RIGHT] = L["Right"],
									[TIP_HIDDEN] = L["Hidden"],
								},
								get = function() return self.db.profile.itemTip or TIP_LEFT end,
								set = function(info, val)
									self.db.profile.itemTip = val
									self:Update("OPTIONS")
								end,
								order = newOrder(),
							}, -- itemTip

							statusTip = {
								type = "select",
								name = L["Status tooltip"],
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
					}, -- display

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
				name = L["Companions"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:CreateGroup(...)
			
				}, -- args
			}, -- companions

-- Items ----------------------------------------------------------------------------------------------------------------------------------------

			items = {
				type = "group",
				name = L["Items"],
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


-------------------------------------------------------------------------------------------------------------------------------------------------

		}, -- args
	} -- self.options

 -- Create the options for each group of items
	self:CreateGroup(self.options.args.mounts, self.db.profile.groups.mounts, false)
	self:CreateGroup(self.options.args.companions, self.db.profile.groups.pets, false)
	self:CreateGroup(self.options.args.items, self.db.profile.groups.items, false)
	self:CreateGroup(self.options.args.custom, self.db.profile.groups.user, true)

	self.PrepareOptions = nil

end -- function R:PrepareOptions()




------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- ITEM GROUPS
------------------------------------------------------------------------------------------------------------------------------------------------------------------


function R:CreateGroup(options, group, isUser)

 options.args = {
		name = {
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
		 name = select(2, GetItemInfo(item.itemId or 0)) or item.name,
		 args = {
			
			 head = {
				 type = "description",
				 order = newOrder(),
				 name = select(2, GetItemInfo(item.itemId or 0)) or item.name,
				 fontSize = "large"
			 },
				
			 spacer1 = { type = "header", name = L["Identify the Item"], order = newOrder(), },

				method = {
					type = "select",
					name = L["Method of obtaining"],
					desc = L["Determines how this item is obtained."],
     width = "double",
					values = {
      [NPC] = L["Drops from NPC(s)"],
      [BOSS] = L["Drops from a boss requiring a group"],
      [ZONE] = L["Drops from any mob in a zone"],
      [USE] = L["Obtained by using an item or opening a container"],
      [FISHING] = L["Obtained by fishing"],
      [ARCH] = L["Obtained as an archaeology project"],
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
     width = "half",
					values = {
						[MOUNT] = L["Mount"],
						[PET] = L["Companion"],
						[ITEM] = L["Item"],
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
							
				raceId = {
					type = "select",
					name = L["Archaeology race"],
					desc = L["Determines which race includes this archaeology project."],
     width = "half",
					values = {
      [1] = L["Dwarf"],
      [2] = L["Draenei"],
      [3] = L["Fossil"],
      [4] = L["Night Elf"],
      [5] = L["Nerubian"],
      [6] = L["Orc"],
      [7] = L["Tol'vir"],
      [8] = L["Troll"],
      [9] = L["Vrykul"],
      --[10] = L["Other"],
					},
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
     desc = L["A comma-separated list of the zones or sub-zones this item can be found in. Enter zone names with proper spelling, capitalization, and punctuation. They can be entered either in US English or your client's local language. Use WowHead or a similar service to make sure you're entering the zone names perfectly."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter at least one zone."])
      else
       local list = { strsplit(",", val) }
       for k, v in pairs(list) do
        if strtrim(v) == "" then
         alert(L["Please enter a comma-separated list of zones."])
         return
        else
         if lbz:GetUnstrictLookupTable()[v] == nil and lbz:GetReverseLookupTable()[v] == nil and lbsz:GetUnstrictLookupTable()[v] == nil and lbsz:GetReverseLookupTable()[v] == nil then
          alert(format(L["One of the zones or sub-zones you entered (%s) cannot be found. Check that it is spelled correctly, and is either US English or your client's local language."], v))
          return
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
				  if strtrim(val) == "" then alert(L["You must enter at least one Statistic ID."])
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

			 spacer2 = { type = "header", name = L["Toggles"], order = newOrder(), },

				enabled = {
					order = newOrder(),
					type = "toggle",
					name = L["Track this"],
					desc = L["Determines whether tracking should be enabled for this item. Items that are disabled will not appear in the tooltip."],
     width = "half",
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
     width = "half",
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
     width = "half",
					get = function()
      if item.repeatable == true then return true else return false end
     end,
					set = function(info, val)
						item.repeatable = val
      if val then item.enabled = true end
						self:Update("OPTIONS")
					end,
     hidden = function()
      if R.db.profile.debugMode then return false end
      --if item.method == USE then return true end
      if item.type == MOUNT or item.type == ARCH then return true else return false end
     end,
				},

				enableAnnouncements = {
					order = newOrder(),
					type = "toggle",
					name = L["Announce"],
					desc = L["Enables announcements whenever you complete a new attempt toward this item."],
     width = "half",
					get = function()
      if item.announce == false then return false else return true end
     end,
					set = function(info, val)
						item.announce = val
						self:Update("OPTIONS")
					end,
				},

			 spacer3 = { type = "header", name = L["Attempts"], order = newOrder(), },

		  attempts = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Attempts"],
     desc = L["How many attempts you've made so far."],
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
			  name = L["Chance"],
     desc = L["How likely the item is to appear, expressed as 1 in X, where X is the number you enter here."],
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
							
			 spacer3 = { type = "header", name = L["Other Requirements"], order = newOrder(), },

		  groupSize = {
			  type = "input",
     order = newOrder(),
     width = "half",
			  name = L["Group size"],
     desc = L["The number of players it takes to obtain the item. This will lower your chances of obtaining the item."],
			  set = function(info, val)
				  if strtrim(val) == "" then alert(L["You must enter an amount."])
      elseif tonumber(val) == nil then alert(L["You must enter a valid number."])
      else
       local n = tonumber(val)
       if n <= 1 then alert(L["You must enter a number larger than 1."])
       else item.groupSize = n end
				  end
						self:Update("OPTIONS")
			  end,
     get = function(into) if item.groupSize then return tostring(item.groupSize) else return nil end end,
     hidden = function() return item.method ~= BOSS and item.method ~= USE end,
		  },
							
				raid25 = {
					order = newOrder(),
					type = "toggle",
					name = L["Requires a 25-player raid"],
					desc = L["Determines whether this item can only be obtained in 25-player mode."],
					get = function()
      if item.raid25 == true then return true else return false end
     end,
					set = function(info, val)
						item.raid25 = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.method ~= BOSS end,
				},

				equalOdds = {
					order = newOrder(),
					type = "toggle",
					name = L["Equal odds"],
					desc = L["Turn this on if the item requires a group to obtain, but every player gets an equal chance to obtain the item. This currently only applies to some of the holiday mounts. When you turn this on, Rarity will stop lowering your chance to obtain based on the group size."],
     width = "half",
					get = function()
      if item.equalOdds == true then return true else return false end
     end,
					set = function(info, val)
						item.equalOdds = val
						self:Update("OPTIONS")
					end,
     hidden = function() return item.method ~= BOSS and item.method ~= USE end,
				},

				requiresHorde = {
					order = newOrder(),
					type = "toggle",
					name = L["Horde only"],
					desc = L["This item is only available to Horde players."],
     width = "half",
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
     width = "half",
					get = function()
      if item.requiresAlliance == true then return true else return false end
     end,
					set = function(info, val)
						item.requiresAlliance = val
      if val then item.requiresHorde = false end
						self:Update("OPTIONS")
					end,
				},

			 spacer4 = { type = "header", name = "", order = newOrder(), hidden = not isUser },

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
			 }, -- delete
				
   }
  }
 end

end



