local _, addonTable = ...

local R = Rarity

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local lbct = LibStub("LibBabble-CreatureType-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()

-- Upvalues
--- WoW API
local GetBestMapForUnit = _G.C_Map.GetBestMapForUnit
local IsQuestFlaggedCompleted = _G.C_QuestLog.IsQuestFlaggedCompleted
local UnitFactionGroup = _G.UnitFactionGroup
local GetItemInfo = _G.C_Item.GetItemInfo
local tinsert = table.insert
--- Addon API
local CONSTANTS = addonTable.constants
local colorize = Rarity.Utils.String.Colorize
local scanTip = Rarity.GUI.scanTip
local DEBUG_MESSAGE_COLOR = Rarity.Enum.Colors.DebugMessageColor
--- Constants
local red = Rarity.Enum.Colors.Red
local green = Rarity.Enum.Colors.Green
local yellow = Rarity.Enum.Colors.Yellow
local gray = Rarity.Enum.Colors.Gray
local white = Rarity.Enum.Colors.White

-- Game Tooltip hijacking stuff
local function onTooltipSetUnit(tooltip, data)
	if tooltip ~= _G.GameTooltip then
		return -- Probably a tooltip created by another addon, that does use the new GameTooltipDataMixin (triggers post-hooks globally...)
	end

	local self = tooltip -- For backwards compatibility with the legacy code below (should be refactored eventually...)

	if R.db.profile.enableTooltipAdditions == false then
		return
	end

	if not self.GetUnit then
		-- Probably a tooltip created by another addon, that hasn't been updated to use GameTooltipDataMixin (risky assumption)
		return
	end

	-- If debug mode is on, find NPCID from mouseover target and append it to the tooltip
	if R.db.profile.debugMode then
		GameTooltip:AddLine("NPCID: " .. R:GetNPCIDFromGUID(UnitGUID("mouseover")), 255, 255, 255)
	end

	local name, unit = self:GetUnit()
	if not unit then
		return
	end
	local creatureType = UnitCreatureType(unit)
	-- Rarity:Debug("Creature type: "..(creatureType or "nil").." (translation: "..(lbct[creatureType] or "nil")..")")
	if
		creatureType == "Critter"
		or lbct[creatureType] == "Critter"
		or creatureType == "Non-combat Pet"
		or lbct[creatureType] == "Non-combat Pet"
		or creatureType == "Wild Pet"
		or lbct[creatureType] == "Wild Pet"
	then
		return
	end

	local guid = UnitGUID(unit)
	if not unit or not guid then
		return
	end
	local npcid = R:GetNPCIDFromGUID(guid)
	if not UnitCanAttack("player", unit) and not Rarity.db.profile.oneTimeItems[npcid] then
		return
	end -- Something you can't attack (but allow this for one-time items)
	if UnitIsPlayer(unit) then
		return
	end -- A player
	if UnitIsPVP(unit) then
		return
	end -- A PVP flagged unit

	local blankAdded = false
	local rarityAdded = false

	-- This NPC is known to be used for obtaining something
	if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
		for k, v in pairs(Rarity.npcs_to_items[npcid]) do
			if R:IsAttemptAllowed(v) then
				if
					(v.requiresHorde and R.Caching:IsHorde())
					or (v.requiresAlliance and not R.Caching:IsHorde())
					or (not v.requiresHorde and not v.requiresAlliance)
				then
					local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
						GetItemInfo(v.itemId)
					if itemLink or itemName or v.name then
						if
							(v.known and R.db.profile.hideKnownItemsInTooltip)
							or (not v.enabled and R.db.profile.hideUntrackedItemsInTooltip)
						then
							GameTooltip:Show()
						else
							if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
								blankAdded = true
								GameTooltip:AddLine(" ")
							end
							local attemptText = " "
								.. colorize(format(L["(%d/%d attempts)"], v.attempts or 0, v.chance or 0), white)
							if v.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
								attemptText = " "
									.. colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white)
							end
							if v.known or Rarity.db.profile.tooltipAttempts == false then
								attemptText = ""
							end
							GameTooltip:AddLine(
								colorize(
									(
										not rarityAdded
											and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "")
										or ""
									)
										.. (itemLink or itemName or v.name)
										.. attemptText,
									yellow
								)
							)
							rarityAdded = true
							if v.pickpocket then
								local class, classFileName = UnitClass("player")
								local pickcolor
								if classFileName == "ROGUE" then
									pickcolor = green
								else
									pickcolor = red
								end
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
	end

	blankAdded = false

	-- One-time items
	if Rarity.db.profile.oneTimeItems[npcid] and type(Rarity.db.profile.oneTimeItems[npcid]) == "table" then
		if Rarity.db.profile.oneTimeItems[npcid].itemId ~= 99999 then
			local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
				GetItemInfo(Rarity.db.profile.oneTimeItems[npcid].itemId)
			if itemLink or itemName then
				if
					Rarity.db.profile.oneTimeItems[npcid].questId ~= nil
					and IsQuestFlaggedCompleted(Rarity.db.profile.oneTimeItems[npcid].questId)
				then
					if not R.db.profile.hideKnownItemsInTooltip then
						if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
							-- blankAdded = true -- Why?
							GameTooltip:AddLine(" ")
						end
						GameTooltip:AddLine(
							colorize(
								(
									not rarityAdded
										and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "")
									or ""
								) .. (itemLink or itemName),
								yellow
							)
						)
						GameTooltip:AddLine(colorize(L["Already defeated"], red))
						blankAdded = false
						rarityAdded = true
					end
				else
					if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
						blankAdded = true
						GameTooltip:AddLine(" ")
					end
					scanTip:ClearLines()
					scanTip:SetItemByID(Rarity.db.profile.oneTimeItems[npcid].itemId)

					GameTooltip:AddDoubleLine(
						colorize(
							(
								not rarityAdded
									and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "")
								or ""
							) .. (itemLink or itemName),
							yellow
						),
						"|T" .. itemTexture .. ":22|t"
					)
					rarityAdded = true

					for i = 2, scanTip:NumLines() do
						local myLeft = _G["__Rarity_ScanTipTextLeft" .. i]
						local txtLeft = myLeft:GetText()
						local leftR, leftG, leftB, leftAlpha = myLeft:GetTextColor()
						local myRight = _G["__Rarity_ScanTipTextRight" .. i]
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

	-- blankAdded = false -- Why?

	-- This whole zone is used for obtaining something
	if not UnitCanAttack("player", unit) then
		return
	end -- Something you can't attack
	if UnitIsPlayer(unit) then
		return
	end -- A player

	local UNIT_TYPES = {
		CREATURE = "Creature",
		PET = "Pet",
		GAME_OBJECT = "GameObject",
		VEHICLE = "Vehicle",
		VIGNETTE = "Vignette",
	}

	local UNIT_GUID_SEPARATOR = "-"
	-- GUID Format: <unitType>-<token2>-<...> etc
	local FIND_FIRST_GUID_TOKEN_PATTERN = "([^-]+)%" .. UNIT_GUID_SEPARATOR

	local unitType = guid:match(FIND_FIRST_GUID_TOKEN_PATTERN)

	if R.db.profile.debugMode then
		GameTooltip:AddLine("Type: " .. tostring(unitType), 255, 255, 255)
	end

	if unitType ~= UNIT_TYPES.CREATURE and unitType ~= UNIT_TYPES.PET then
		Rarity:Debug(format("Not showing GameTooltip info since the hovered unit is of type %s", unitType))
		return
	end

	local zone = GetRealZoneText()
	local subzone = GetSubZoneText()
	local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
	local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]
	if
		Rarity.zones[tostring(GetBestMapForUnit("player"))]
		or Rarity.zones[zone]
		or Rarity.zones[lbz[zone] or "."]
		or Rarity.zones[lbsz[subzone] or "."]
		or Rarity.zones[zone_t]
		or Rarity.zones[subzone_t]
		or Rarity.zones[lbz[zone_t] or "."]
		or Rarity.zones[lbsz[subzone_t] or "."]
	then
		for k, v in pairs(R.db.profile.groups) do
			if type(v) == "table" then
				for kk, vv in pairs(v) do
					if type(vv) == "table" then
						local found = false
						if
							vv.method == CONSTANTS.DETECTION_METHODS.ZONE
							and vv.zones ~= nil
							and type(vv.zones) == "table"
						then
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
							if R:IsAttemptAllowed(vv) then
								local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
									GetItemInfo(vv.itemId)
								if itemLink or itemName or vv.name then
									if
										(vv.known and R.db.profile.hideKnownItemsInTooltip)
										or (not vv.enabled and R.db.profile.hideUntrackedItemsInTooltip)
									then
										GameTooltip:Show()
									else
										if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
											blankAdded = true
											GameTooltip:AddLine(" ")
										end
										local chance = select(2, Rarity.Statistics.GetRealDropPercentage(vv))
										local attemptText = " "
											.. colorize(
												format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0),
												white
											)
										if vv.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
											attemptText = " "
												.. colorize(
													format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0),
													white
												)
										end
										if vv.known or Rarity.db.profile.tooltipAttempts == false then
											attemptText = ""
										end
										GameTooltip:AddLine(
											colorize(
												(
													not rarityAdded
														and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "")
													or ""
												)
													.. (itemLink or itemName or vv.name)
													.. attemptText,
												yellow
											)
										)
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

function Rarity:RegisterGameTooltipHooks()
	if not _G.TooltipDataProcessor then
		-- Blizzard hasn't ported the tooltip changes to their classic client, yet?
	else
		_G.TooltipDataProcessor.AddTooltipPostCall(_G.Enum.TooltipDataType.Unit, onTooltipSetUnit)
	end

	if not _G.TooltipDataProcessor then
		-- Blizzard hasn't ported the tooltip changes to their classic client, yet?
	else
		_G.TooltipDataProcessor.AddTooltipPostCall(_G.Enum.TooltipDataType.Item, Rarity.OnGameTooltipSetToItem)
	end
end

function Rarity.TooltipProcessItem(tooltip, itemID)
	if not itemID then
		return
	end

	local tooltipLines = {}
	-- This item is used to obtain another item (containers, paragon caches, etc.)
	local containedItems = Rarity.items_to_items[itemID]
	if containedItems then
		for sourceItemID, itemInfo in ipairs(containedItems) do
			local nextLine = Rarity.TooltipProcessItemInfo(tooltip, itemInfo)
			local coloredLine = colorize(nextLine or "", yellow)
			if nextLine then
				tinsert(tooltipLines, coloredLine)
			end
		end
	end

	-- Extra item tooltips (for eggs and other items that will turn into containers later)
	local linkedItems = R.db.profile.extraTooltips.inventoryItems[itemID]
	if linkedItems then
		for sourceItemID, linkedItemID in ipairs(linkedItems) do
			-- Some items are part of the DB and others are not... should probably use a different approach
			local itemName, itemLink = GetItemInfo(linkedItemID)
			local itemInfo = Rarity.items[linkedItemID]
			local nextLine = Rarity.TooltipProcessItemInfo(tooltip, itemInfo) or itemLink or itemName
			local coloredLine = colorize(nextLine or "", yellow)
			if nextLine then
				tinsert(tooltipLines, coloredLine)
			end
		end
	end

	Rarity.TooltipAppendLines(tooltip, tooltipLines)
	if Rarity.db.profile.debugMode then
		local debugInfo = format("Item ID: %d", itemID)
		debugInfo = colorize(debugInfo, DEBUG_MESSAGE_COLOR)
		tooltip:AddLine(" ")
		tooltip:AddLine(debugInfo)
	end
	tooltip:Show()

	return tooltipLines -- Ignored ingame, but useful for debugging/testing
end

function Rarity.OnGameTooltipSetToItem(tooltip, tooltipData)
	if not R.db.profile.enableTooltipAdditions then
		Rarity:Debug("Failed to set GameTooltip text (tooltip additions have been disabled)")
		return
	end

	if tooltip ~= _G.GameTooltip and tooltip ~= _G.ItemRefTooltip then
		Rarity:Debug("Failed to set GameTooltip text (not a game tooltip)")
		return
	end

	local itemID = tooltipData.id
	if not itemID then
		Rarity:Debug("Failed to set GameTooltip text (the provided data doesn't include an item ID)")
		return
	end

	Rarity.TooltipProcessItem(tooltip, itemID)
end

function Rarity.ShouldDisplayTooltipAdditionsForItem(item)
	if not item.itemId then
		return false
	end

	local playerFaction = UnitFactionGroup("player")
	local isItemAvailableToPlayer = Rarity.Database.IsItemAvailableToFactionGroup(item, playerFaction)
	if not isItemAvailableToPlayer then
		return false
	end

	if item.known == true and R.db.profile.hideKnownItemsInTooltip then
		return false
	end

	if item.enabled == false and R.db.profile.hideUntrackedItemsInTooltip then
		return false
	end

	local itemName, itemLink = GetItemInfo(item.itemId)
	if not itemLink or not itemName or not item.name then
		return false
	end

	return true
end

function Rarity.TooltipAppendLines(tooltip, tooltipLines)
	if #tooltipLines == 0 then
		return
	end

	if R.db.profile.blankLineBeforeTooltipAdditions then
		tooltip:AddLine(" ")
	end

	local separator = (R.db.profile.blankLineAfterRarity and "\n" or "")
	local heading = colorize(L["Rarity: "], yellow) .. separator
	tooltipLines[1] = heading .. tooltipLines[1]
	for lineNumber, line in ipairs(tooltipLines) do
		tooltip:AddLine(line)
	end
end

function Rarity.TooltipProcessItemInfo(tooltip, item)
	if not item then
		return
	end

	if not Rarity.ShouldDisplayTooltipAdditionsForItem(item) then
		return
	end

	local itemName, itemLink = GetItemInfo(item.itemId)
	local itemText = (itemLink or itemName or item.name) or ""

	local chance = select(2, Rarity.Statistics.GetRealDropPercentage(item))
	local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], item.attempts or 0, chance or 0), white)
	if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		attemptText = " " .. colorize(format(L["(%d/%d collected)"], item.attempts or 0, item.chance or 0), white)
	end

	if item.known and not item.repeatable then
		attemptText = attemptText
			.. " "
			.. colorize("(", white)
			.. colorize(L["Already known"], red)
			.. colorize(")", white)
	end

	if not Rarity.db.profile.tooltipAttempts then
		attemptText = ""
	end

	return itemText .. attemptText
end
