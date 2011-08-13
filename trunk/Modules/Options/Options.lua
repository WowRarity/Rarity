if not Rarity then return end
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", false)
local R = Rarity
local mod = R:NewModule("Options")


-- Feed text
local FEED_MINIMAL = "FEED_MINIMAL"
local FEED_NORMAL = "FEED_NORMAL"
local FEED_VERBOSE = "FEED_VERBOSE"



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

						}, -- args
					}, -- display

					announcements = {
						type = "group",
						name = L["Announcements"],
						order = newOrder(),
						inline = true,
						args = {
						
							enableAnnouncements = {
								order = newOrder(),
								type = "toggle",
								name = L["Enable announcements"],
								desc = L["Enables announcements whenever you complete a new attempt toward anything Rarity is tracking. You can also enable announcements per-item, but this is the master switch."],
								get = function() return self.db.profile.enableAnnouncements end,
								set = function(info, val)
									self.db.profile.enableAnnouncements = val
									self:Update("OPTIONS")
								end,
							}, -- enableAnnouncements

							output = self:GetSinkAce3OptionsDataTable(),

						}, -- args
					}, -- announcements

				}, -- args
			}, -- general
		
-- Advanced -------------------------------------------------------------------------------------------------------------------------------------

			--[[rules = {
				type = "group",
				name = L["Advanced"],
				desc = L["Advanced configuration options. This section controls all the rules that Rarity uses."],
				order = newOrder(),
				childGroups = "tree",
				args = {
				
					-- Filled in by Rarity:SetupGroupList()
			
				}, -- args
			}, -- new]]


-------------------------------------------------------------------------------------------------------------------------------------------------

		}, -- args
	} -- self.options

	--self:SetupGroupList()
	self.PrepareOptions = nil

end -- function R:PrepareOptions()
