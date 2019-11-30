local _, addonTable = ...

local Serialization = {}

-- Upvalues
local tonumber = tonumber
local pairs = pairs
local type = type
local CONSTANTS = addonTable.constants
local FormatTime = Rarity.Utils.PrettyPrint.FormatTime -- Utils are loaded before Core modules, so this should be fine

--- Sets some default values for items (used before importing them)?
--- TODO: LuaDoc
function Serialization:CleanItemForImport(item)
	item.attempts = 0
	item.lastAttempts = 0
	item.enabled = true
	item.found = false
	item.enableAnnouncements = true
	item.holidayReminder = true
end

--- Returns true if an item has a valid format ?
-- TODO: LuaDoc
function Serialization:CanItemBeExportedImported(item)
	if not item then
		return false
	end
	if not item.method then
		return false
	end
	if not item.type then
		return false
	end

	if not item.itemId or tonumber(item.itemId) == nil or item.itemId <= 0 then
		return false
	end
	if not item.chance or tonumber(item.chance) == nil or item.chance <= 0 then
		return false
	end

	if item.method == CONSTANTS.DETECTION_MODES.COLLECTION then
		if not item.collectedItemId or tonumber(item.collectedItemId) == nil or item.collectedItemId <= 0 then
			return false
		end
	end

	if item.type ~= CONSTANTS.ITEM_TYPES.ITEM then
		if not item.spellId or tonumber(item.spellId) == nil or item.spellId <= 0 then
			return false
		end
	end

	if item.type == CONSTANTS.ITEM_TYPES.PET then
		if not item.creatureId or tonumber(item.creatureId) == nil or item.creatureId <= 0 then
			return false
		end
	end

	if item.method == CONSTANTS.DETECTION_MODES.ARCH then
		if not item.raceId or tonumber(item.raceId) == nil or item.raceId <= 0 then
			return false
		end
	end

	if item.method == CONSTANTS.DETECTION_MODES.ZONE or item.method == CONSTANTS.DETECTION_MODES.FISHING then
		if not item.zones or #item.zones <= 0 then
			return false
		end
	end

	if item.method == CONSTANTS.DETECTION_MODES.USE then
		if not item.items or #item.items <= 0 then
			return false
		end
	end

	if item.method == CONSTANTS.DETECTION_MODES.NPC or item.method == CONSTANTS.DETECTION_MODES.BOSS then
		if (not item.npcs or #item.npcs <= 0) and (not item.statisticId or #item.statisticId <= 0) then
			return false
		end
	end

	return true
end

--- Attempts to import data from the BunnyHunter addon?
-- This must be ancient, I've never even heard of it before...
-- TODO: LuaDoc
function Serialization:ImportFromBunnyHunter()

	self = Rarity

	if self.db.profile.importedFromBunnyHunter then
		return
	end

	if BunnyHunterDB then
		StaticPopupDialogs["RARITY_IMPORT_FROM_BUNNYHUNTER"] = {
			text = L[
				"Bunny Hunter is running. Would you like Rarity to import data from Bunny Hunter now? Disable Bunny Hunter or click Yes if you don't want to be asked again."
			],
			button1 = YES,
			button2 = NO,
			hideOnEscape = 1,
			timeout = 0,
			exclusive = 1,
			whileDead = 1,
			OnAccept = function()
				local self = Rarity
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
										self:Debug("%s: adding a kill after %d attempts, %s time", itemkey, vv.loots, FormatTime(vv.time))
										if not item.finds then
											item.finds = {}
										end
										local count = 0
										for x, y in pairs(item.finds) do
											count = count + 1
										end
										table.insert(
											item.finds,
											{
												num = count + 1,
												totalAttempts = vv.loots,
												totalTime = vv.time,
												attempts = vv.loots,
												time = vv.time
											}
										)
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
				Rarity.GUI:UpdateText()
				--if self:InTooltip() then self:ShowTooltip() end
				self.db.profile.importedFromBunnyHunter = true
				self:Print(L["Data has been imported from Bunny Hunter"])
			end
		}
		StaticPopup_Show("RARITY_IMPORT_FROM_BUNNYHUNTER")
	end
end

Rarity.Serialization = Serialization
return Serialization
