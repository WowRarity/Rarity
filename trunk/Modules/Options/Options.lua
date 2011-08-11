if not Rarity then return end
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
local R = Energized
local mod = R:NewModule("Options")



do
	local isInitialized = false

	function mod:OnEnable()
		E:Options_DoEnable()
	end

	function E:Options_DoEnable()
		if isInitialized then return end

		if E.db == nil then
			E:ScheduleTimer(function() E:Options_DoEnable() end, 1.0)
			return
		end

		isInitialized = true
		E.modulesEnabled.options = true

		E:PrepareOptions()
		if AddonLoader and AddonLoader.RemoveInterfaceOptions then
			AddonLoader:RemoveInterfaceOptions("Energized")
		end
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Energized", E.options)
		E.optionsFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Energized", "Energized")
		E.profileOptions = LibStub("AceDBOptions-3.0"):GetOptionsTable(E.db)
		local LibDualSpec = LibStub("LibDualSpec-1.0")
		LibDualSpec:EnhanceOptions(E.profileOptions, E.db)
		LibStub("AceConfig-3.0"):RegisterOptionsTable("Energized-Profiles", E.profileOptions)
		E.profileFrame = LibStub("AceConfigDialog-3.0"):AddToBlizOptions("Energized-Profiles", "Profiles", "Energized")
		
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

local function iconSet(set)
	return L[set]
end

local function iconTextures(set)
	return format("\n"..[[  %s: |TInterface\AddOns\Energized\Icons\%s\green:0|t |TInterface\AddOns\Energized\Icons\%s\yellow:0|t |TInterface\AddOns\Energized\Icons\%s\red:0|t]], L[set], set, set, set)
end

local function formatItem(item)
	local s
	if tonumber(item) ~= nil then s = format(L["Item %d"], item) else s = item end
	local itemName, itemLink = GetItemInfo(item)
	if itemName then s = itemLink end
	return s
end

local function getGroupIcons(k, v)
	if E.isPetClass then
		return format([[|TInterface\AddOns\Energized\Icons\%s:0|t |TInterface\AddOns\Energized\Icons\%s:0|t ]], strlower(E.db.profile.groups[k].me), strlower(E.db.profile.groups[k].pet))
	else
		return format([[|TInterface\AddOns\Energized\Icons\%s:0|t ]], strlower(E.db.profile.groups[k].me))
	end
end

local function strstarts(s, start)
 return strsub(s, 1, strlen(start)) == start
end

local function strends(s, ending)
 return ending == "" or strsub(s, -strlen(ending)) == ending
end

local function colorize(s, color)
	if color and s then
		return string.format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
	else
		return s
	end
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- METHODS
------------------------------------------------------------------------------------------------------------------------------------------------------------------

function E:CreateNewGroup(name)
	local newKey = 0
	for k, v in pairs(self.db.profile.groups) do
		if tonumber(k) and tonumber(k) > newKey then newKey = tonumber(k) end
	end
	newKey = newKey + 1
	if newKey < 1000 then newKey = 1000 end -- Start user defined groups at 1000 to allow new defaults to be added over time

	self.db.profile.groups[newKey] = {
		name = "",
	}
	self.db.profile.groups[newKey].name = name
	self.db:RegisterDefaults(self.defaults)
	self:SetupGroupList()
	self:Update("OPTIONS")
	return newKey
end


function E:GetGroupDescription(key, val)
	local s = ""
	
	if val.me == "EXPECTED" and val.pet == "EXPECTED" then
		--s = L["Expected for you and your pet"]
		s = L["Expected for you"]
	elseif val.me == "NONE" and val.pet == "EXPECTED" then
	 s = L["Expected for your pet"]
	elseif val.me == "EXPECTED" and val.pet == "NONE" then
		s = L["Expected for you"]
	elseif val.me == "UNEXPECTED" and val.pet == "UNEXPECTED" then
		--s = L["Unexpected for you and your pet"]
		s = L["Unexpected for you"]
	elseif val.me == "NONE" and val.pet == "UNEXPECTED" then
	 s = L["Unexpected for your pet"]
	elseif val.me == "UNEXPECTED" and val.pet == "NONE" then
		s = L["Unexpected for you"]
	elseif val.me == "NONE" and val.pet == "NONE" then
		s = L["|cffff0000Disabled|r"]
	else
		if val.me == "EXPECTED" then s = L["Expected for you"]
		elseif val.me == "UNEXPECTED" then s = L["Unexpected for you"]
		end
		if val.pet == "EXPECTED" then
			if s ~= "" then s = s..L["; "] end
			s = s..L["Expected for your pet"]
		elseif val.pet == "UNEXPECTED" then
			if s ~= "" then s = s..L["; "] end
			s = s..L["Unexpected for your pet"]
		end
	end
	
	s = "|cff29e287"..L["Expectations: "].."|r"..s.."\n"..
     "|cff29e287"..L["Rules: "].."|r"..format(L["This rule group contains %d |4rule:rules;"], #val.items)
 
 if val.locked then
		s = s.."\n|cffff3333"..L["Locked: "].."|r"..L["You can't delete this group because it has been locked by the author"]
 end
	
	return s
end


function E:SetupItemList(groupKey, groupValue)
	for k, v in pairs(self.db.profile.groups[groupKey].items) do
		if not v.hidden and k ~= "**" then
			self:CreateItemOptions(groupKey, groupValue, k, v)
		end
	end
end


function E:CreateNewItem(groupKey)
	local newKey = 0
	for k, v in pairs(self.db.profile.groups[groupKey].items) do
		if tonumber(k) and tonumber(k) > newKey then newKey = tonumber(k) end
	end
	newKey = newKey + 1
	if newKey < 1000 then newKey = 1000 end -- Start user defined items at 1000 to allow new defaults to be added over time

	self.db.profile.groups[groupKey].items[newKey] = {
		type = self.db.profile._currentRuleType,
	}
	self.db:RegisterDefaults(self.defaults)
	self:CreateGroupOptions(groupKey, self.db.profile.groups[groupKey])
	self.db.profile._currentRuleType = nil
	self:Update("OPTIONS")
	return newKey
end


function E:SetupGroupList()
	if not E.modulesEnabled.options then return end
	self.options.args.rules.args = {
		name = {
			type = "input",
			width = "double",
			name = L["Create a new rule group"],
			desc = L["Each rule group in Energized defines a set of rules. If any rule in the group is met, the entire group is considered to be met. This lets you group together equivalent buffs.\n\nTo create a new rule group, type a name for your new rule group, then click Okay. Groups are usually named after their most popular buff (Well Fed) or their effects (+Spellpower)."],
			set = function(info, val)
				if strtrim(val) ~= "" then
					self:CreateNewGroup(val)
				end
			end,
		},
	}
	
	for k, v in pairs(self.db.profile.groups) do
		if not v.hidden and k ~= "**" then
			self:CreateGroupOptions(k, v)
		end
	end
end


function E:GetItemDescription(itemValue)
	if itemValue.value == nil or itemValue.value == "" then return "" end
	
	local s = "|cffffff00"..L["You entered:"].."|r\n"
	local list = { strsplit(",", itemValue.value) }
	for k, v in pairs(list) do
		local val = strtrim(v)
		if strstarts(val, "\"") and strends(val, "\"") then
			val = strsub(val, 2, strlen(val) - 1)
		end
		local name = self:_GetItemName(val, itemValue.type)
		s = s.."    "..name.."\n"
	end
	return s
end


function E:GetTalentTreeList(c)
	local t = {}
	if c == "HUNTER" then
		t = {
			[1] = L["Beast Mastery"],
			[2] = L["Marksmanship"],
			[3] = L["Survival"]
		}
	elseif c == "ROGUE" then
		t = {
			[1] = L["Assassination"],
			[2] = L["Combat"],
			[3] = L["Subtlety"]
		}
	elseif c == "DRUID" then
		t = {
			[1] = L["Balance"],
			[2] = L["Feral Combat"],
			[3] = L["Restoration"]
		}
	elseif c == "PRIEST" then
		t = {
			[1] = L["Discipline"],
			[2] = L["Holy"],
			[3] = L["Shadow"]
		}
	elseif c == "WARRIOR" then
		t = {
			[1] = L["Arms"],
			[2] = L["Fury"],
			[3] = L["Protection"]
		}
	elseif c == "SHAMAN" then
		t = {
			[1] = L["Elemental"],
			[2] = L["Enhancement"],
			[3] = L["Restoration"]
		}
	elseif c == "DEATHKNIGHT" then
		t = {
			[1] = L["Blood"],
			[2] = L["Frost"],
			[3] = L["Unholy"]
		}
	elseif c == "PALADIN" then
		t = {
			[1] = L["Holy"],
			[2] = L["Protection"],
			[3] = L["Retribution"]
		}
	elseif c == "MAGE" then
		t = {
			[1] = L["Arcane"],
			[2] = L["Fire"],
			[3] = L["Frost"]
		}
	elseif c == "WARLOCK" then
		t = {
			[1] = L["Affliction"],
			[2] = L["Demonology"],
			[3] = L["Destruction"]
		}
	end
	t[0] = L["No talent required"]
	return t
end


function E:FindItem(itemId)
	for k, v in pairs(self.db.profile.groups) do
		for kk, vv in pairs(v.items) do
			if vv.id == itemId then
				return vv, v
			end
		end
	end
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- PRIMARY OPTIONS TABLE
------------------------------------------------------------------------------------------------------------------------------------------------------------------

function E:PrepareOptions()

	self.options = {
		name = function()
			local debugMsg = "    "
			if self.db.profile.debugMode then
				debugMsg = debugMsg..L["(running in debug mode)"]
			end
			return "Energized         r|cff20ff20"..self.MINOR_VERSION.."|r"..debugMsg
		end,
		handler = Energized,
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
						desc = L["Turns on a minimap icon for Energized. Use this option if you don't have an LDB display add-on."],
						get = function() return not self.db.profile.minimap.hide end,
						set = function(info, val)
							self.db.profile.minimap.hide = not val
							if val then LibStub("LibDBIcon-1.0"):Show("Energized") else LibStub("LibDBIcon-1.0"):Hide("Energized") end
							self:Update("OPTIONS")
						end,
					}, -- minimap
							
					enable = {
						type = "group",
						name = L["Enable"],
						order = newOrder(),
						inline = true,
						args = {
						
							enableSolo = {
								order = newOrder(),
								type = "toggle",
								name = L["Solo"],
								width = "half",
								get = function() return self.db.profile.enableSolo end,
								set = function(info, val)
									self.db.profile.enableSolo = val
									self:Update("OPTIONS")
								end,
							}, -- enableSolo
						
							enableParty = {
								order = newOrder(),
								type = "toggle",
								name = L["Party"],
								width = "half",
								get = function() return self.db.profile.enableParty end,
								set = function(info, val)
									self.db.profile.enableParty = val
									self:Update("OPTIONS")
								end,
							}, -- enableParty
						
							enableBattleground = {
								order = newOrder(),
								type = "toggle",
								name = L["Battleground"],
								width = "half",
								get = function() return self.db.profile.enableBattleground end,
								set = function(info, val)
									self.db.profile.enableBattleground = val
									self:Update("OPTIONS")
								end,
							}, -- enableBattleground
						
							enableArena = {
								order = newOrder(),
								type = "toggle",
								name = L["Arena"],
								width = "half",
								get = function() return self.db.profile.enableArena end,
								set = function(info, val)
									self.db.profile.enableArena = val
									self:Update("OPTIONS")
								end,
							}, -- enableArena
						
							enableRaid = {
								order = newOrder(),
								type = "toggle",
								name = L["Raid"],
								width = "half",
								get = function() return self.db.profile.enableRaid end,
								set = function(info, val)
									self.db.profile.enableRaid = val
									self:Update("OPTIONS")
								end,
							}, -- enableRaid
						
						}, -- args
					}, -- enable
				
					misc = {
						type = "group",
						name = L["Behavior"],
						order = newOrder(),
						inline = true,
						args = {
						
							lowWarn = {
								order = newOrder(),
								type = "toggle",
								name = L["Enable low buff warnings"],
								desc = L["When checked, Energized will warn you if any of your buffs are running low."],
								get = function() return self.db.profile.lowWarn end,
								set = function(info, val)
									self.db.profile.lowWarn = val
									self:Update("OPTIONS")
								end,
							}, -- lowWarn
							
							itemWarn = {
								order = newOrder(),
								type = "toggle",
								name = L["Enable inventory item warnings"],
								desc = L["When checked, Energized will warn you if you're missing various inventory items (i.e. healthstones). These items are configured in the Advanced section."],
								get = function() return self.db.profile.itemWarn end,
								set = function(info, val)
									self.db.profile.itemWarn = val
									self:Update("OPTIONS")
								end, -- itemWarn
							},

							equippedWarn = {
								order = newOrder(),
								type = "toggle",
								name = L["Check for equipped slots"],
								desc = L["When checked, Energized will warn you if you don't have something equipped in every slot."],
								get = function() return self.db.profile.equippedWarn end,
								set = function(info, val)
									self.db.profile.equippedWarn = val
									self:Update("OPTIONS")
								end, -- equippedWarn
							},

							petBuffs = {
								order = newOrder(),
								type = "toggle",
								name = L["Enable pet buff checks"],
								desc = L["When checked, Energized will check your pet for any buffs configured in the Rules section. You can disable all pet checks by unchecking this."],
								hidden = function() return not self.isPetClass end,
								get = function() return self.db.profile.petBuffs end,
								set = function(info, val)
									self.db.profile.petBuffs = val
									self:Update("OPTIONS")
								end, -- petBuffs
							},

							petFood = {
								order = newOrder(),
								type = "toggle",
								name = L["Check for pet food"],
								desc = L["When checked, Energized will check to see if your pet is Well Fed. This can also be configured in the Advanced section."],
								hidden = function() return not self.isPetClass end,
								disabled = function() return not self.db.profile.petBuffs end,
								get = function()
									if not self.db.profile.petBuffs then return false end
									return select(2, E:FindItem("fed")).pet == "EXPECTED"
								end,
								set = function(info, val)
									if val then
										select(2, E:FindItem("fed")).pet = "EXPECTED"
									else
										select(2, E:FindItem("fed")).pet = "NONE"
									end
									self:SetupGroupList()
									self:Update("OPTIONS")
								end, -- petFood
							},

							weaponBuffs = {
								order = newOrder(),
								type = "toggle",
								name = L["Check for weapon buffs"],
								desc = L["When checked, Energized will check that you have applied temporary enchants to your weapon. Only applies to certain classes."],
								disabled = function() return not (E.class == "ROGUE" or E.class == "SHAMAN") end,
								get = function()
									if not (E.class == "WARLOCK" or E.class == "ROGUE" or E.class == "SHAMAN") then return false end
									return self.db.profile.weaponBuffs
								end,
								set = function(info, val)
									self.db.profile.weaponBuffs = val
									self:Update("OPTIONS")
								end, -- weaponBuffs
							},

							inCombatScan = {
								order = newOrder(),
								type = "toggle",
								name = L["Keep scanning slowly in combat"],
								desc = L["When checked, Energized will scan for issues every 10 seconds during combat. If you uncheck this, no scanning will take place during combat unless you hover your mouse over the icon."],
								get = function() return self.db.profile.inCombatScan end,
								set = function(info, val) self.db.profile.inCombatScan = val end, -- inCombatScan
							},

							scanThrottle = {
								order = newOrder(),
								type = "range",
								name = L["Scan throttle"],
								desc = L["Energized will scan no more frequently than this number of seconds. It may not scan this frequently, but it will never scan more frequently than this."],
								min = 1,
								max = 60,
								step = .1,
								bigStep = 1.0,
								get = function() return self.db.profile.scanThrottle end,
								set = function(info, val)
									self.db.profile.scanThrottle = val
									self:ChangeThrottle(val)
								end,
							}, -- scanThrottle

						}, -- args
					}, -- misc

					display = {
						type = "group",
						name = L["Display Options"],
						order = newOrder(),
						inline = true,
						args = {

							iconSet = {
								type = "select",
								name = L["Icon set"],
								desc = L["Controls which set of icons Energized uses to show your status."].."\n"..
									iconTextures("Classic")..
									iconTextures("Default")..
									iconTextures("Glass Circle")..
									iconTextures("Glass Square")..
									iconTextures("Star"),
								values = {
									["Classic"] = iconSet("Classic"),
									["Default"] = iconSet("Default"),
									["Glass Circle"] = iconSet("Glass Circle"),
									["Glass Square"] = iconSet("Glass Square"),
									["Star"] = iconSet("Star"),
								},
								get = function() return self.db.profile.iconSet end,
								set = function(info, val)
									self.db.profile.iconSet = val
									self:Update("OPTIONS")
								end,
								order = newOrder(),
							}, -- iconSet
							
							feedText = {
								type = "select",
								order = newOrder(),
								name = L["Feed text"],
								desc = L["Controls how the LDB feed's text label is shown."],
								values = {
									[1] = L["No text"],
									[2] = L["Short"],
									[3] = L["Verbose"],
								},
								get = function() return self.db.profile.feedText end,
								set = function(info, val)
									self.db.profile.feedText = val
									self:Update("OPTIONS")
								end,
							}, -- feedText
							
							recentCaster = {
								type = "select",
								order = newOrder(),
								name = L["Recent casters"],
								desc = L["Controls how recent casters are shown in the tooltip."],
								values = {
									[1] = L["Not shown"],
									[2] = L["Caster name"],
									[3] = L["Caster name and last seen time"],
								},
								get = function() return self.db.profile.recentCaster end,
								set = function(info, val)
									self.db.profile.recentCaster = val
									self:Update("OPTIONS")
								end,
							}, -- recentCaster
							
							showYourselfAsRecentCaster = {
								type = "toggle",
								order = newOrder(),
								name = L["Show yourself as recent caster"],
								desc = L["When checked, buffs you provided yourself or your pet will show your name as the recent caster. Uncheck this if you don't want to see yourself mentioned."],
								get = function() return self.db.profile.showYourselfAsRecentCaster end,
								set = function(info, val)
									self.db.profile.showYourselfAsRecentCaster = val
									self:Update("OPTIONS")
								end,
							}, -- showYourselfAsRecentCaster
							
							hideTime = {
								order = newOrder(),
								type = "range",
								name = L["Hide after being energized for"],
								desc = L["After a specified number of seconds of being energized (fully buffed), the icon and text will be hidden. The value specified below is approximate; it might take a few seconds longer to actually hide.\n\nSet to 0 to disable this feature."],
								min = 0,
								max = 60,
								step = 1,
								get = function() return self.db.profile.hideTime end,
								set = function(info, val)
									self.db.profile.hideTime = val
									self:Update("OPTIONS")
								end,
							}, -- hideTime
							
							subtipAnchor = {
								type = "select",
								order = newOrder(),
								name = L["Secondary tooltip anchor"],
								desc = L["Controls which side the secondary tooltip anchors on."],
								values = {
									[1] = L["Left"],
									[2] = L["Right"],
								},
								get = function() return self.db.profile.subtipAnchor end,
								set = function(info, val)
									self.db.profile.subtipAnchor = val
									self:Update("OPTIONS")
								end,
							}, -- subtipAnchor
							
							showHint = {
								type = "toggle",
								order = newOrder(),
								name = L["Show tooltip hint"],
								desc = L["Enables the hint text at the bottom of the tooltip."],
								get = function() return self.db.profile.showHint end,
								set = function(info, val)
									self.db.profile.showHint = val
									self:Update("OPTIONS")
								end,
							}, -- showHint
							
							showZeroIssuesMessage = {
								type = "toggle",
								order = newOrder(),
								name = L["Show text for zero issues"],
								desc = L["When enabled and you have no issues, Energized will show text in the LDB feed. With this disabled, there will be no text displayed when you have zero issues."],
								get = function() return self.db.profile.showZeroIssuesMessage end,
								set = function(info, val)
									self.db.profile.showZeroIssuesMessage = val
									self:Update("OPTIONS")
								end,
							}, -- showZeroIssuesMessage
							
						}, -- args
					}, -- display
					
					reporting = {
						type = "group",
						name = L["Reporting"],
						order = newOrder(),
						inline = true,
						args = {
						
							enableReporting = {
								order = newOrder(),
								type = "toggle",
								name = L["Enable reporting"],
								desc = L["Enables click to report functionality in Energized. Turn this off if you don't want to accidentally report anything."],
								get = function() return self.db.profile.enableReporting end,
								set = function(info, val)
									self.db.profile.enableReporting = val
									self:Update("OPTIONS")
								end,
							}, -- enableReporting
							
							--[[reportPetIssues = {
								order = newOrder(),
								type = "toggle",
								name = L["Report pet issues"],
								desc = L["When checked, Energized will include pet issues in reports."],
								get = function() return self.db.profile.reportPetIssues end,
								set = function(info, val)
									self.db.profile.reportPetIssues = val
									self:Update("OPTIONS")
								end,
							},]] -- reportPetIssues
							
							reportUnexpected = {
								order = newOrder(),
								type = "toggle",
								name = L["Report unexpected buffs"],
								desc = L["When checked, Energized will include unexpected buffs in reports."],
								get = function() return self.db.profile.reportUnexpected end,
								set = function(info, val)
									self.db.profile.reportUnexpected = val
									self:Update("OPTIONS")
								end,
							}, -- reportUnexpected
							
						}, -- args
					}, -- reporting

				}, -- args
			}, -- general
		
-- Equipment ------------------------------------------------------------------------------------------------------------------------------------

			equipment = {
				type = "group",
				name = L["Equipment"],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					durability = {
						type = "group",
						name = L["Durability"],
						order = newOrder(),
						inline = true,
						args = {
						
							minDurability = {
								order = newOrder(),
								type = "range",
								name = L["Warn when durability reaches"],
								desc = L["Energized will warn you when any equipped items reach this percentage of durability or lower. Set to 0 to disable."],
								min = 0,
								max = .7,
								step = .01,
								isPercent = true,
								width = "double",
								get = function() return self.db.profile.minDurability end,
								set = function(info, val)
									self.db.profile.minDurability = val
									self:Update("OPTIONS")
								end,
							}, -- minDurability
							
						}, -- args
					}, -- durability
				
					doNotEquip = {
						type = "group",
						name = L["Do not equip"],
						order = newOrder(),
						inline = true,
						args = {
						
							desc = {
								order = newOrder(),
								type = "description",
								name = L["Energized will make sure you don't have certain items equipped. You can delete items from the list by picking the item in the drop down and clicking Delete. Add items by typing in the item ID or name in the text box below and clicking Okay."],
							},
						
							itemList = {
								type = "select",
								name = L["Items"],
								desc = L["A list of items that you should not have equipped. Pick an item from this list and click Delete to remove it."],
								width = "double",
								values = function()
									local t = {}
									for k, v in pairs(self.db.profile.doNotEquip) do
										if v == true then
											local insert = formatItem(k)
											t[insert] = insert
										end
									end
									return t
								end,
								get = function() return self.db.profile._currentDoNotEquipItem end,
								set = function(info, val)
									self.db.profile._currentDoNotEquipItem = val
								end,
								order = newOrder(),
							}, -- itemList
							
							delete = {
								order = newOrder(),
								type = "execute",
								name = L["Delete"],
								desc = L["Deletes the currently selected item from the do-not-equip list."],
								func = function()
									local t = {}
									for k, v in pairs(self.db.profile.doNotEquip) do
										if v == true then
											local insert = formatItem(k)
											t[insert] = k
										end
									end
									if self.db.profile._currentDoNotEquipItem ~= nil and t[self.db.profile._currentDoNotEquipItem] then
										self.db.profile.doNotEquip[t[self.db.profile._currentDoNotEquipItem]] = false
									end
									for k, v in pairs(self.db.profile.doNotEquip) do
										if v == false then
											local found = false
											for kk, vv in pairs(self.defaults.profile.doNotEquip) do
												if k == kk then found = true end
											end
											if not found then self.db.profile.doNotEquip[k] = nil end
										end
									end
									self:Update("OPTIONS")
								end,
								disabled = function()
									local t = {}
									for k, v in pairs(self.db.profile.doNotEquip) do
										if v == true then
											local insert = formatItem(k)
											t[insert] = insert
										end
									end
									if self.db.profile._currentDoNotEquipItem and t[self.db.profile._currentDoNotEquipItem] then return false end
									return true
								end,
							}, -- delete

							add = {
								type = "input",
								name = L["Add an item"],
								desc = L["Type an item ID or name and click Okay or press Enter. The item will be added to the do-not-equip list."],
								width = "double",
								set = function(info, val)
									if val and val ~= "" then
										if tonumber(val) ~= nil then
											self.db.profile.doNotEquip[tonumber(val)] = true
										else
											self.db.profile.doNotEquip[val] = true
										end
										self:Update("OPTIONS")
									end
								end,
								order = newOrder(),
							}, -- add

						}, -- args
					}, -- doNotEquip

				}, -- args
			}, -- equipment
			
-- Special Cases --------------------------------------------------------------------------------------------------------------------------------

			specialCases = {
				type = "group",
				name = L["Special Cases"],
				order = newOrder(),
				childGroups = "tree",
				hidden = function() return not (self.shouldHavePet or E.class == "HUNTER" or E.class == "WARRIOR" or E.class == "ROGUE" or E.class == "WARLOCK") end,
				args = {
				
					pets = {
						type = "group",
						name = L["Pets"],
						order = newOrder(),
						inline = true,
						hidden = function() return not self.shouldHavePet end,
						args = {
						
							petMode = {
								type = "select",
								name = L["Pet mode should be"],
								desc = L["Energized can check your pet's stance to make sure it is correct."],
								values = {
									["NONE"] = L["Don't check"],
									["PET_MODE_ASSIST"] = PET_MODE_ASSIST,
									["PET_MODE_PASSIVE"] = PET_MODE_PASSIVE,
									["PET_MODE_DEFENSIVE"] = PET_MODE_DEFENSIVE,
								},
								get = function() return self.db.profile.petMode end,
								set = function(info, val)
									self.db.profile.petMode = val
									self:Update("OPTIONS")
								end,
								order = newOrder(),
							}, -- petMode
						
						}, -- args
					}, -- pets
				
					-- Removed in patch 4.0.3a
					--[[hunter = {
						type = "group",
						name = L["Hunter"],
						order = newOrder(),
						inline = true,
						hidden = function() return E.class ~= "HUNTER" end,
						args = {

							hunterPetFed = {
								order = newOrder(),
								type = "toggle",
								name = L["Check Pet Food"],
								desc = L["When enabled, Energized will expect your pet to have the Well Fed buff when you're in a raid."],
								get = function() return self.db.profile.hunterPetFed end,
								set = function(info, val)
									self.db.profile.hunterPetFed = val
									self:Update("OPTIONS")
								end,
							}, -- hunterPetFed
						
						}, -- args
					}, -- hunter]]

					rogue = {
						type = "group",
						name = L["Rogue"],
						order = newOrder(),
						inline = true,
						hidden = function() return E.class ~= "ROGUE" end,
						args = {
						
							rogueThrownEnchant = {
								order = newOrder(),
								type = "toggle",
								width = "double",
								name = L["Check for Throwing Weapon Enchant"],
								desc = L["When enabled, Energized will require you to have an enchant applied to your equipped throwing weapon."],
								get = function() return self.db.profile.rogueThrownEnchant end,
								set = function(info, val)
									self.db.profile.rogueThrownEnchant = val
									self:Update("OPTIONS")
								end,
							}, -- rogueThrownEnchant
						
						}, -- args
					}, -- rogue

					warrior = {
						type = "group",
						name = L["Warrior"],
						order = newOrder(),
						inline = true,
						hidden = function() return E.class ~= "WARRIOR" end,
						args = {
						
							warriorStance = {
								order = newOrder(),
								type = "toggle",
								name = L["Check Defensive Stance"],
								desc = L["If you're a Protection warrior, you are expected to be in Defensive Stance. If not, you're expected to be in some other stance."],
								get = function() return self.db.profile.warriorStance end,
								set = function(info, val)
									self.db.profile.warriorStance = val
									self:Update("OPTIONS")
								end,
							}, -- warriorStance
						
							warriorVigilance = {
								order = newOrder(),
								type = "toggle",
								name = L["Check Vigilance"],
								desc = L["If you have the Vigilance talent, you are expected to cast it on a nearby player."],
								get = function() return self.db.profile.warriorVigilance end,
								set = function(info, val)
									self.db.profile.warriorVigilance = val
									self:Update("OPTIONS")
								end,
							}, -- warriorVigilance
						
						}, -- args
					}, -- warrior

					warlock = {
						type = "group",
						name = L["Warlock"],
						order = newOrder(),
						inline = true,
						hidden = function() return E.class ~= "WARLOCK" end,
						args = {
						
							warlockDarkIntent = {
								order = newOrder(),
								type = "toggle",
								name = GetSpellInfo(80398),
								desc = L["Requires you to have cast Dark Intent on another player."],
								get = function() return self.db.profile.warlockDarkIntent end,
								set = function(info, val)
									self.db.profile.warlockDarkIntent = val
									self:Update("OPTIONS")
								end,
							}, -- warlockDarkIntent
						
						}, -- args
					}, -- warlock

				}, -- args
			}, -- specialCases


-- Advanced -------------------------------------------------------------------------------------------------------------------------------------

			rules = {
				type = "group",
				name = L["Advanced"],
				desc = L["Advanced configuration options. This section controls all the rules that Energized uses."],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Energized:SetupGroupList()
			
				}, -- args
			}, -- new


-------------------------------------------------------------------------------------------------------------------------------------------------

		}, -- args
	} -- self.options

	self:SetupGroupList()
	self.PrepareOptions = nil

end -- function E:PrepareOptions()



------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RULE GROUP OPTIONS TABLE
------------------------------------------------------------------------------------------------------------------------------------------------------------------

function E:CreateGroupOptions(k, v)
	if not v.hidden and k ~= "**" then
		local newKey = tostring(k)
		
		self.options.args.rules.args[newKey] = {
			type = "group",
			name = getGroupIcons(k, v)..(v.name or L["Unknown"]),
			args = {
			
				head = {
					type = "description",
					order = newOrder(),
					name = (v.name or L["Unknown"]),
					fontSize = "large"
				},
				
				note = {
					hidden = self.db.profile.groups[k].note == nil,
					type = "description",
					order = newOrder(),
					fontSize = "medium",
					name = function()
						local s = self.db.profile.groups[k].note
						if not s then return " " end
						return "|cffffff00"..self.db.profile.groups[k].note.."|r"
					end,
				},
			
				desc = {
					type = "description",
					order = newOrder(),
					name = self:GetGroupDescription(k, v),
				},
			
				delete = {
					type = "execute",
					name = L["Delete this rule group"],
					desc = L["Click to delete this rule group."],
					confirm = true,
					confirmText = format(L["Are you sure you want to delete |cffffff00%s|r?"], (v.name or L["Unknown"])),
					func = function(info)
						if self.defaults.profile.groups[k] then
							self.db.profile.groups[k].hidden = true
						else
							self.db.profile.groups[k] = nil
						end
						self.options.args.rules.args[newKey] = nil
						self:Update("OPTIONS")
					end,
					order = newOrder(),
					disabled = self.db.profile.groups[k].locked,
				}, -- delete
				
				spacer1 = { type = "description", name = " ", order = newOrder(), },

				new = {
					type = "group",
					inline = true,
					name = L["Create a New Rule"],
					order = newOrder(),
					args = {
					
						desc = {
							type = "description",
							name = L["Each rule group consists of one or more rules. If any rule is satisfied, the entire group is satisfied. This is useful for combining equivalent buffs or consumables."],
							order = newOrder(),
						},

						type = {
							type = "select",
							name = L["New rule type"],
							desc = L["Choose which type of new rule to create, then click New rule below.\n\n"]..
							       L["|cffffff00Buff:|r A buff that you should have on you.\n\n"]..
							       L["|cffffff00Consumable:|r A buff that you gain through a consumable.\n\n"]..
							       L["|cffffff00Inventory item:|r Verifies that you have a certain item in your inventory, like a healthstone."],
							       --L["|cffffff00Buff cast on others:|r A buff that you should cast on others, such as Vigilance."],
							order = newOrder(),
							values = {
								["BUFF"] = L["Buff"],
								["CONSUMABLE"] = L["Consumable"],
								["ITEM"] = L["Inventory item"],
							},
							get = function() return self.db.profile._currentRuleType end,
							set = function(info, val) self.db.profile._currentRuleType = val end,
						}, -- type

						new = {
							type = "execute",
							name = L["New rule"],
							desc = L["Choose which type of rule to create from the drop down above, then click this to create a new rule within this rule group."],
							width = "half",
							func = function(info)
								self:CreateNewItem(k)
							end,
							disabled = function() return self.db.profile._currentRuleType == nil or self.db.profile._currentRuleType == "" end,
							order = newOrder(),
						}, -- new
						
					}, -- args
				}, -- new
							
				spacer2 = { type = "description", name = " ", order = newOrder(), },

				basic = {
					type = "group",
					inline = true,
					name = L["Basic Options"],
					order = newOrder(),
					args = {
			
						name = {
							type = "input",
							name = L["Name"],
							desc = L["The rule group's name. Groups are usually named after their most popular buff (Well Fed) or their effects (+Spellpower)."],
							width = "double",
							get = function()
								return self.db.profile.groups[k].name
							end,
							set = function(info, val)
								if val and val ~= "" then
									self.db.profile.groups[k].name = val
									self.options.args.rules.args[newKey].name = getGroupIcons(k, v)..val
									self:Update("OPTIONS")
								end
							end,
							order = newOrder(),
						}, -- name
						
						me = {
							type = "select",
							name = L["For me"],
							desc = L["Indicates if this group should be expected or unexpected for you."],
							order = newOrder(),
							width = "half",
							values = {
								["EXPECTED"] = L["Expected"],
								["UNEXPECTED"] = L["Unexpected"],
								["NONE"] = L["None"],
							},
							get = function() return self.db.profile.groups[k].me end,
							set = function(info, val)
								self.db.profile.groups[k].me = val
								self.options.args.rules.args[newKey].name = getGroupIcons(k, v)..(v.name or L["Unknown"])
								self:Update("OPTIONS")
							end,
						}, -- me
						
						pet = {
							type = "select",
							name = L["For my pet"],
							desc = L["Indicates if this group should be expected or unexpected for your pet. This only applies to pet classes."],
							hidden = function() return not self.isPetClass end,
							order = newOrder(),
							width = "half",
							values = {
								["EXPECTED"] = L["Expected"],
								["UNEXPECTED"] = L["Unexpected"],
								["NONE"] = L["None"],
							},
							get = function() return self.db.profile.groups[k].pet end,
							set = function(info, val)
								self.db.profile.groups[k].pet = val
								self.options.args.rules.args[newKey].name = getGroupIcons(k, v)..(v.name or L["Unknown"])
								self:Update("OPTIONS")
							end,
						}, -- pet
												
					}, -- args
				}, -- basic
				
				spacer3 = { type = "description", name = " ", order = newOrder(), },

				advanced = {
					type = "group",
					inline = true,
					name = L["Advanced Options"],
					order = newOrder(),
					args = {
					
						report = {
							type = "toggle",
							order = newOrder(),
							name = L["Report this group"],
							desc = L["When checked, this group will be included when reporting missing or unexpected buffs. Turn this off for personal buffs.\n\nGroups containing all consumable or inventory item rules will never be reported."],
							get = function() return self.db.profile.groups[k].report end,
							set = function(info, val) self.db.profile.groups[k].report = val end
						},
					
						when = {
							type = "select",
							name = L["Enable this group"],
							desc = L["Defines special circumstances when this group should apply.\n\n"]..L["Check the Frequently Asked Questions at the Energized web site for more information."],
							order = newOrder(),
							width = "double",
							values = {
								["WHEN_TANK"] = L["When I'm a tank"],
								["WHEN_NOT_TANK"] = L["When I'm not a tank"],
								["ALWAYS"] = L["Always"],
							},
							get = function() return self.db.profile.groups[k].when end,
							set = function(info, val)
								self.db.profile.groups[k].when = val
								self:Update("OPTIONS")
							end,
						}, -- when
					
					}, -- args
				}, -- advanced

			}, -- args
		} -- group
	end
	
	self:SetupItemList(k, v)
end



------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- RULE ITEM OPTIONS TABLE
------------------------------------------------------------------------------------------------------------------------------------------------------------------

function E:CreateItemOptions(groupKey, groupValue, itemKey, itemValue)
	if groupValue.hidden or itemValue.hidden then return end
	local groupOptionsKey = tostring(groupKey)
	local itemOptionsKey = tostring(itemKey)
	
-- Inventory item -------------------------------------------------------------------------------------------------------------------------------

	if itemValue.type == "ITEM" then
		self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = {
			type = "group",
			name = self:GetItemName(itemValue),
			args = {
			
				head = {
					type = "description",
					name = L["Inventory item"],
					fontSize = "large",
					order = newOrder(),
				},
				
				desc = {
					type = "description",
					name = L["Inventory Item rules are used to check that you have a certain item in your inventory. This is typically used for healthstones or similar items."],
					order = newOrder(),
				},
			
				delete = {
					type = "execute",
					order = newOrder(),
					name = L["Delete this rule"],
					confirmText = L["Are you sure you want to delete this rule?"],
					confirm = true,
					func = function(info)
						self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = nil
						if self.defaults.profile.groups[groupKey] and self.defaults.profile.groups[groupKey].items[itemKey] ~= nil then
							self.db.profile.groups[groupKey].items[itemKey].hidden = true
						else							
							self.db.profile.groups[groupKey].items[itemKey] = nil
						end
					end,
					disabled = self.db.profile.groups[groupKey].locked,
				},
			
				spacer1 = { type = "description", name = " ", order = newOrder(), },

				basic = {
					type = "group",
					name = L["Basic Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						value = {
							type = "input",
							name = L["Item(s)"],
							desc = L["A comma-separated list of items. If any of these items are found in the player's inventory, the rule is considered to be satisfied.\n\nItems can be specified by name, partial name, ID, or ID string.\n\n"]..
														L["|cffffff00Name or partial name:|r Plain text. Use all or part of a spell/item name in your client's native language. For example:\n\n"]..
														L["  Well Fed\n\n"]..
														L["|cffffff00ID:|r Number. Use a spell/item ID. This will only match one particular rank or version of a spell. For example:\n\n"]..
														"  57399\n\n"..
														L["|cffffff00ID string:|r Number surrounded by quotes (\"). Use a spell/item ID and put it in double quotation marks (\"). Energized will ask the server for the name that belongs to the ID. It will then use that localized name for all of it's scanning. This lets you simultaneously match all types of Well Fed, all ranks of Blessing of Might, or all types of Fel Healthstone, without having to know each and every separate ID. For example:\n\n"]..
														"  \"57399\"\n\n",
							width = "double",
							get = function()
								return self.db.profile.groups[groupKey].items[itemKey].value
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].value = val
								self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey].name = self:GetItemName(itemValue)
								self:Update("OPTIONS")
							end,
							order = newOrder(),
						},
						
						desc = {
							type = "description",
							name = function() return self:GetItemDescription(itemValue) end,
							order = newOrder(),
						},
						
						quantity = {
							type = "input",
							name = L["Quantity"],
							desc = L["Determines how many of this item you should have in your inventory. Typically set to 1."],
							order = newOrder(),
							get = function() return tostring(self.db.profile.groups[groupKey].items[itemKey].quantity) end,
							set = function(info, val)
								local n = tonumber(val)
								if n then self.db.profile.groups[groupKey].items[itemKey].quantity = math.floor(n) end
								self:Update("OPTIONS")
							end,
						},
						
						class = {
							type = "select",
							order = newOrder(),
							name = L["Class"],
							desc = L["Specify which class contributes this item, or none."],
							values = {
							 ["0"] = colorize(L["None"], GRAY_FONT_COLOR),
								["HUNTER"] = colorize(L["Hunter"], RAID_CLASS_COLORS["HUNTER"]),
								["MAGE"] = colorize(L["Mage"], RAID_CLASS_COLORS["MAGE"]),
								["WARRIOR"] = colorize(L["Warrior"], RAID_CLASS_COLORS["WARRIOR"]),
								["ROGUE"] = colorize(L["Rogue"], RAID_CLASS_COLORS["ROGUE"]),
								["PALADIN"] = colorize(L["Paladin"], RAID_CLASS_COLORS["PALADIN"]),
								["DRUID"] = colorize(L["Druid"], RAID_CLASS_COLORS["DRUID"]),
								["DEATHKNIGHT"] = colorize(L["Death Knight"], RAID_CLASS_COLORS["DEATHKNIGHT"]),
								["WARLOCK"] = colorize(L["Warlock"], RAID_CLASS_COLORS["WARLOCK"]),
								["SHAMAN"] = colorize(L["Shaman"], RAID_CLASS_COLORS["SHAMAN"]),
								["PRIEST"] = colorize(L["Priest"], RAID_CLASS_COLORS["PRIEST"]),
							},
							get = function()
								local c = self.db.profile.groups[groupKey].items[itemKey].class
								if not c or c == "" then return "0" end
								return c
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].class = val
								self:Update("OPTIONS")
							end,
						},
						
					},	-- args
				}, -- basic
							
				spacer2 = { type = "description", name = " ", order = newOrder(), },

				advanced = {
					type = "group",
					name = L["Advanced Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						mode = {
							type = "select",
							order = newOrder(),
							name = L["Name matching mode"],
							desc = L["Determines how Energized should match spell/item names. You can set this to Partial, Starts With, or Ends With if you want to match just part of a name. This is useful, for example, to match all types of flasks by entering \"Flask of\" and selecting Starts With."],
							values = {
								["PARTIAL"] = L["Partial"],
								["EXACT"] = L["Exact"],
								["STARTSWITH"] = L["Starts with"],
								["ENDSWITH"] = L["Ends with"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].mode end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].mode = val
								self:Update("OPTIONS")
							end,
						},
						
						enableSolo = {
							type = "toggle",
							order = newOrder(),
							name = L["Enable when solo"],
							desc = L["Determines whether this rule should be applied when you're solo (not in a party or raid)."],
							get = function() return self.db.profile.groups[groupKey].items[itemKey].enableSolo end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].enableSolo = val
								self:Update("OPTIONS")
							end
						},

						partyFormat = {
							type = "select",
							order = newOrder(),
							name = L["Party size"],
							desc = L["Determines the type of party that this rule should be required for. You can have it apply only to 5 player parties, all raids, or a specific raid size. If you want the rule to always apply, select \"Doesn't matter\"."],
							values = {
								["RAID_10"] = L["10 player raid"],
								["RAID_25"] = L["25 player raid"],
								["ANY"] = L["Doesn't matter"],
								["ANY_RAID"] = L["Any raid"],
								["PARTY"] = L["5 player party"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].partyFormat end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].partyFormat = val
								self:Update("OPTIONS")
							end,
						},
						
						difficulty = {
							type = "select",
							order = newOrder(),
							name = L["Instance difficulty"],
							desc = L["Determines the instance difficulty that this rule should be required for. If you're not in an instance, this option is ignored."],
							values = {
								["NORMAL"] = L["Normal"],
								["HEROIC"] = L["Heroic"],
								["ANY"] = L["Any"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].difficulty end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].difficulty = val
								self:Update("OPTIONS")
							end,
						},
						
					},	-- args
				}, -- advanced
				
			},
		}
		
		
-- Consumable -----------------------------------------------------------------------------------------------------------------------------------

	elseif itemValue.type == "CONSUMABLE" then
		self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = {
			type = "group",
			name = self:GetItemName(itemValue),
			args = {
			
				head = {
					type = "description",
					name = L["Consumable"],
					fontSize = "large",
					order = newOrder(),
				},
			
				desc = {
					type = "description",
					name = L["Consumable rules are used to check that you have a specific buff, such as Well Fed or a flask. Energized doesn't check who else is in your raid for these; it expects you to always have consumable buffs."],
					order = newOrder(),
				},
			
				delete = {
					type = "execute",
					order = newOrder(),
					name = L["Delete this rule"],
					confirmText = L["Are you sure you want to delete this rule?"],
					confirm = true,
					func = function(info)
						self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = nil
						if self.defaults.profile.groups[groupKey] and self.defaults.profile.groups[groupKey].items[itemKey] ~= nil then
							self.db.profile.groups[groupKey].items[itemKey].hidden = true
						else							
							self.db.profile.groups[groupKey].items[itemKey] = nil
						end
					end,
					disabled = self.db.profile.groups[groupKey].locked,
				},
			
				spacer1 = { type = "description", name = " ", order = newOrder(), },

				basic = {
					type = "group",
					name = L["Basic Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						value = {
							type = "input",
							name = L["Buff(s) from consumables"],
							desc = L["A comma-separated list of buffs. If the player has any of these buffs, the rule is considered to be satisfied.\n\nBuffs can be specified by name, partial name, ID, or ID string.\n\n"]..
														L["|cffffff00Name or partial name:|r Plain text. Use all or part of a spell/item name in your client's native language. For example:\n\n"]..
														L["  Well Fed\n\n"]..
														L["|cffffff00ID:|r Number. Use a spell/item ID. This will only match one particular rank or version of a spell. For example:\n\n"]..
														"  57399\n\n"..
														L["|cffffff00ID string:|r Number surrounded by quotes (\"). Use a spell/item ID and put it in double quotation marks (\"). Energized will ask the server for the name that belongs to the ID. It will then use that localized name for all of it's scanning. This lets you simultaneously match all types of Well Fed, all ranks of Blessing of Might, or all types of Fel Healthstone, without having to know each and every separate ID. For example:\n\n"]..
														"  \"57399\"\n\n",
							width = "double",
							get = function()
								return self.db.profile.groups[groupKey].items[itemKey].value
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].value = val
								self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey].name = self:GetItemName(itemValue)
								self:Update("OPTIONS")
							end,
							order = newOrder(),
						},
												
						desc = {
							type = "description",
							name = function() return self:GetItemDescription(itemValue) end,
							order = newOrder(),
						},
						
					},	-- args
				}, -- basic
			
				spacer2 = { type = "description", name = " ", order = newOrder(), },

				advanced = {
					type = "group",
					name = L["Advanced Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						mode = {
							type = "select",
							order = newOrder(),
							name = L["Name matching mode"],
							desc = L["Determines how Energized should match spell/item names. You can set this to Partial, Starts With, or Ends With if you want to match just part of a name. This is useful, for example, to match all types of flasks by entering \"Flask of\" and selecting Starts With."],
							values = {
								["PARTIAL"] = L["Partial"],
								["EXACT"] = L["Exact"],
								["STARTSWITH"] = L["Starts with"],
								["ENDSWITH"] = L["Ends with"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].mode end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].mode = val
								self:Update("OPTIONS")
							end,
						},
						
						enableSolo = {
							type = "toggle",
							order = newOrder(),
							name = L["Enable when solo"],
							desc = L["Determines whether this rule should be applied when you're solo (not in a party or raid)."],
							get = function() return self.db.profile.groups[groupKey].items[itemKey].enableSolo end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].enableSolo = val
								self:Update("OPTIONS")
							end
						},

						partyFormat = {
							type = "select",
							order = newOrder(),
							name = L["Party size"],
							desc = L["Determines the type of party that this rule should be required for. You can have it apply only to 5 player parties, all raids, or a specific raid size. If you want the rule to always apply, select \"Doesn't matter\"."],
							values = {
								["RAID_10"] = L["10 player raid"],
								["RAID_25"] = L["25 player raid"],
								["ANY"] = L["Doesn't matter"],
								["ANY_RAID"] = L["Any raid"],
								["PARTY"] = L["5 player party"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].partyFormat end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].partyFormat = val
								self:Update("OPTIONS")
							end,
						},
						
						difficulty = {
							type = "select",
							order = newOrder(),
							name = L["Instance difficulty"],
							desc = L["Determines the instance difficulty that this rule should be required for. If you're not in an instance, this option is ignored."],
							values = {
								["NORMAL"] = L["Normal"],
								["HEROIC"] = L["Heroic"],
								["ANY"] = L["Any"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].difficulty end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].difficulty = val
								self:Update("OPTIONS")
							end,
						},
						
						warn = {
							type = "input",
							order = newOrder(),
							name = L["Warn when duration is less than"],
							desc = L["Energized will warn you if this buff's duration is low. Enter the time in seconds."],
							get = function() return tostring(self.db.profile.groups[groupKey].items[itemKey].warn) end,
							set = function(info, val)
								local n = tonumber(val)
								if n then
									self.db.profile.groups[groupKey].items[itemKey].warn = math.floor(n)
									self:Update("OPTIONS")
								end
							end,
						},
						
					},	-- args
				}, -- advanced

			},
		}
		
		
-- Buff -----------------------------------------------------------------------------------------------------------------------------------------

	elseif itemValue.type == "BUFF" then
		self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = {
			type = "group",
			name = self:GetItemName(itemValue),
			args = {
			
				head = {
					type = "description",
					name = L["Buff"],
					fontSize = "large",
					order = newOrder(),
				},
			
				desc = {
					type = "description",
					name = L["Buff rules are used to check that you have a specific buff, such as Blessing of Kings or Trueshot Aura. Energized will verify that someone in your raid is capable of casting the buff before checking for it."],
					order = newOrder(),
				},
			
				delete = {
					type = "execute",
					order = newOrder(),
					name = L["Delete this rule"],
					confirmText = L["Are you sure you want to delete this rule?"],
					confirm = true,
					func = function(info)
						self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey] = nil
						if self.defaults.profile.groups[groupKey] and self.defaults.profile.groups[groupKey].items[itemKey] ~= nil then
							self.db.profile.groups[groupKey].items[itemKey].hidden = true
						else							
							self.db.profile.groups[groupKey].items[itemKey] = nil
						end
					end,
					disabled = self.db.profile.groups[groupKey].locked,
				},
			
				spacer1 = { type = "description", name = " ", order = newOrder(), },

				basic = {
					type = "group",
					name = L["Basic Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						value = {
							type = "input",
							name = L["Buff(s)"],
							desc = L["A comma-separated list of buffs. If the player has any of these buffs, the rule is considered to be satisfied.\n\nBuffs can be specified by name, partial name, ID, or ID string.\n\n"]..
														L["|cffffff00Name or partial name:|r Plain text. Use all or part of a spell/item name in your client's native language. For example:\n\n"]..
														L["  Well Fed\n\n"]..
														L["|cffffff00ID:|r Number. Use a spell/item ID. This will only match one particular rank or version of a spell. For example:\n\n"]..
														"  57399\n\n"..
														L["|cffffff00ID string:|r Number surrounded by quotes (\"). Use a spell/item ID and put it in double quotation marks (\"). Energized will ask the server for the name that belongs to the ID. It will then use that localized name for all of it's scanning. This lets you simultaneously match all types of Well Fed, all ranks of Blessing of Might, or all types of Fel Healthstone, without having to know each and every separate ID. For example:\n\n"]..
														"  \"57399\"\n\n",
							width = "double",
							get = function()
								return self.db.profile.groups[groupKey].items[itemKey].value
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].value = val
								self.options.args.rules.args[groupOptionsKey].args[itemOptionsKey].name = self:GetItemName(itemValue)
								self:Update("OPTIONS")
							end,
							order = newOrder(),
						},
						
						desc = {
							type = "description",
							name = function() return self:GetItemDescription(itemValue) end,
							order = newOrder(),
						},
						
						class = {
							type = "select",
							order = newOrder(),
							name = L["Class"],
							desc = L["Specify which class contributes this buff."],
							values = {
								["HUNTER"] = colorize(L["Hunter"], RAID_CLASS_COLORS["HUNTER"]),
								["MAGE"] = colorize(L["Mage"], RAID_CLASS_COLORS["MAGE"]),
								["WARRIOR"] = colorize(L["Warrior"], RAID_CLASS_COLORS["WARRIOR"]),
								["ROGUE"] = colorize(L["Rogue"], RAID_CLASS_COLORS["ROGUE"]),
								["PALADIN"] = colorize(L["Paladin"], RAID_CLASS_COLORS["PALADIN"]),
								["DRUID"] = colorize(L["Druid"], RAID_CLASS_COLORS["DRUID"]),
								["DEATHKNIGHT"] = colorize(L["Death Knight"], RAID_CLASS_COLORS["DEATHKNIGHT"]),
								["WARLOCK"] = colorize(L["Warlock"], RAID_CLASS_COLORS["WARLOCK"]),
								["SHAMAN"] = colorize(L["Shaman"], RAID_CLASS_COLORS["SHAMAN"]),
								["PRIEST"] = colorize(L["Priest"], RAID_CLASS_COLORS["PRIEST"]),
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].class end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].class = val
								self:Update("OPTIONS")
							end,
						},
						
						talentTree = {
							type = "select",
							order = newOrder(),
							name = L["Talent tree"],
							desc = L["If this buff requires a specific talent, choose which tree the talent is located in."],
							values = function() return self:GetTalentTreeList(self.db.profile.groups[groupKey].items[itemKey].class) end,
							get = function()
								if not self.db.profile.groups[groupKey].items[itemKey].class then return 0 end
								return self.db.profile.groups[groupKey].items[itemKey].talentTree
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].talentTree = val
								self:Update("OPTIONS")
							end,
							disabled = function() return not self.db.profile.groups[groupKey].items[itemKey].class end,
						},
						
						talentIndex = {
							type = "input",
							order = newOrder(),
							name = L["Talent index"],
							desc = L["The index of the required talent. The talent index is counted left-to-right, top-to-bottom. The left-most talent in the top row is number 1, followed by the one immediately to its right being number 2. If there are no more talents to the right then it continues from the left-most talent on the next row."],
							get = function()
								if self.db.profile.groups[groupKey].items[itemKey].talentIndex then
									return tostring(self.db.profile.groups[groupKey].items[itemKey].talentIndex)
								end
							end,
							set = function(info, val)
								local n = tonumber(val)
								if n and n > 0 then
									self.db.profile.groups[groupKey].items[itemKey].talentIndex = math.floor(n)
									self:Update("OPTIONS")
								end
							end,
							disabled = function() return self.db.profile.groups[groupKey].items[itemKey].talentTree == 0 end,
						},
						
						talentWho = {
							type = "select",
							order = newOrder(),
							name = L["Evaluate if"],
							desc = L["Determines when Energized should evaluate this rule."],
							values = {
								["ANYONE"] = L["Anyone has this talent"],
								["ME"] = L["I have this talent"],
								["NOT_ME"] = L["I don't have this talent"],
							},
							get = function()
								if not self.db.profile.groups[groupKey].items[itemKey].class then return "ANYONE" end
								return self.db.profile.groups[groupKey].items[itemKey].talentWho
							end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].talentWho = val
								self:Update("OPTIONS")
							end,
							disabled = function() return self.db.profile.groups[groupKey].items[itemKey].talentTree == 0 end,
						},
						
					},	-- args
				}, -- basic
			
				spacer2 = { type = "description", name = " ", order = newOrder(), },

				advanced = {
					type = "group",
					name = L["Advanced Options"],
					order = newOrder(),
					inline = true,
					
				 args = {
				
						mode = {
							type = "select",
							order = newOrder(),
							name = L["Name matching mode"],
							desc = L["Determines how Energized should match spell/item names. You can set this to Partial, Starts With, or Ends With if you want to match just part of a name. This is useful, for example, to match all types of flasks by entering \"Flask of\" and selecting Starts With."],
							values = {
								["PARTIAL"] = L["Partial"],
								["EXACT"] = L["Exact"],
								["STARTSWITH"] = L["Starts with"],
								["ENDSWITH"] = L["Ends with"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].mode end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].mode = val
								self:Update("OPTIONS")
							end,
						},
						
						enableSolo = {
							type = "toggle",
							order = newOrder(),
							name = L["Enable when solo"],
							desc = L["Determines whether this rule should be applied when you're solo (not in a party or raid)."],
							get = function() return self.db.profile.groups[groupKey].items[itemKey].enableSolo end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].enableSolo = val
								self:Update("OPTIONS")
							end
						},

						partyFormat = {
							type = "select",
							order = newOrder(),
							name = L["Party size"],
							desc = L["Determines the type of party that this rule should be required for. You can have it apply only to 5 player parties, all raids, or a specific raid size. If you want the rule to always apply, select \"Doesn't matter\"."],
							values = {
								["RAID_10"] = L["10 player raid"],
								["RAID_25"] = L["25 player raid"],
								["ANY"] = L["Doesn't matter"],
								["ANY_RAID"] = L["Any raid"],
								["PARTY"] = L["5 player party"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].partyFormat end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].partyFormat = val
								self:Update("OPTIONS")
							end,
						},
						
						difficulty = {
							type = "select",
							order = newOrder(),
							name = L["Instance difficulty"],
							desc = L["Determines the instance difficulty that this rule should be required for. If you're not in an instance, this option is ignored."],
							values = {
								["NORMAL"] = L["Normal"],
								["HEROIC"] = L["Heroic"],
								["ANY"] = L["Any"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].difficulty end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].difficulty = val
								self:Update("OPTIONS")
							end,
						},
						
						warn = {
							type = "input",
							order = newOrder(),
							name = L["Warn when duration is less than"],
							desc = L["Energized will warn you if this buff's duration is low. Enter the time in seconds."],
							get = function() return tostring(self.db.profile.groups[groupKey].items[itemKey].warn) end,
							set = function(info, val)
								local n = tonumber(val)
								if n then
									self.db.profile.groups[groupKey].items[itemKey].warn = math.floor(n)
									self:Update("OPTIONS")
								end
							end,
						},
						
						priorityMe = {
							type = "select",
							order = newOrder(),
							name = L["Priority"],
							desc = L["Specifies how many of the class should be present before this buff is expected."],
							values = {
								["0"] = L["N/A"],
								["1"] = L["1"],
								["2"] = L["2"],
								["3"] = L["3"],
								["4"] = L["4"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].priorityMe end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].priorityMe = val
								self:Update("OPTIONS")
							end,
						},
						
						--[[priorityPet = {
							type = "select",
							order = newOrder(),
							name = L["Priority (pet)"],
							desc = L["Specifies how many of the class should be present before this buff is expected."],
							hidden = function() return not self.isPetClass end,
							values = {
								["0"] = L["N/A"],
								["1"] = L["1"],
								["2"] = L["2"],
								["3"] = L["3"],
								["4"] = L["4"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].priorityPet end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].priorityPet = val
								self:Update("OPTIONS")
							end,
						},]]
						
						mountMode = {
							type = "select",
							order = newOrder(),
							name = L["Mount conditions"],
							desc = L["Determines if the rule should be evaluated only when mounted, only when not mounted, or always."],
							values = {
								["NONE"] = L["Doesn't matter"],
								["MOUNTED"] = L["Only when mounted"],
								["NOT_MOUNTED"] = L["Only when not mounted"],
							},
							get = function() return self.db.profile.groups[groupKey].items[itemKey].mountMode or "NONE" end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].mountMode = val
								self:Update("OPTIONS")
							end,
						},
						
						fromPet = {
							type = "toggle",
							order = newOrder(),
							name = L["Comes from a pet"],
							desc = L["Check this to tell Energized that the buff is coming from the player's pet. When this is checked, Energized won't require the buff just because the class is in the raid, but the buff will still satisfy the rule group if it is present."],
							get = function() return self.db.profile.groups[groupKey].items[itemKey].fromPet end,
							set = function(info, val)
								self.db.profile.groups[groupKey].items[itemKey].fromPet = val
								self:Update("OPTIONS")
							end
						},

					},	-- args
				}, -- advanced

			},
		}

	end
end
