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
--- Addon API
local CONSTANTS = addonTable.constants
local colorize = Rarity.Utils.String.Colorize
local scanTip = Rarity.GUI.scanTip
--- Constants
local red = Rarity.Enum.Colors.Red
local green = Rarity.Enum.Colors.Green
local yellow = Rarity.Enum.Colors.Yellow
local gray = Rarity.Enum.Colors.Gray
local white = Rarity.Enum.Colors.White

-- Game Tooltip hijacking stuff
_G.GameTooltip:HookScript(
	"OnTooltipSetUnit",
	function(self)
		-- If debug mode is on, find NPCID from mouseover target and append it to the tooltip
		if R.db.profile.debugMode then
			GameTooltip:AddLine("NPCID: " .. R:GetNPCIDFromGUID(UnitGUID("mouseover")), 255, 255, 255)
		end

		if not R.db or R.db.profile.enableTooltipAdditions == false then
			return
		end

		local name, unit = self:GetUnit()
		if not unit then
			return
		end
		local creatureType = UnitCreatureType(unit)
		--Rarity:Debug("Creature type: "..(creatureType or "nil").." (translation: "..(lbct[creatureType] or "nil")..")")
		if
			creatureType == "Critter" or lbct[creatureType] == "Critter" or creatureType == "Non-combat Pet" or
				lbct[creatureType] == "Non-combat Pet" or
				creatureType == "Wild Pet" or
				lbct[creatureType] == "Wild Pet"
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
						(v.requiresHorde and R.Caching:IsHorde()) or (v.requiresAlliance and not R.Caching:IsHorde()) or
							(not v.requiresHorde and not v.requiresAlliance)
					 then
						local itemName,
							itemLink,
							itemRarity,
							itemLevel,
							itemMinLevel,
							itemType,
							itemSubType,
							itemStackCount,
							itemEquipLoc,
							itemTexture,
							itemSellPrice = GetItemInfo(v.itemId)
						if itemLink or itemName or v.name then
							if v.known and R.db.profile.hideKnownItemsInTooltip then
								GameTooltip:Show()
							else
								if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
									blankAdded = true
									GameTooltip:AddLine(" ")
								end
								local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], v.attempts or 0, v.chance or 0), white)
								if v.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
									attemptText = " " .. colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white)
								end
								if v.known or Rarity.db.profile.tooltipAttempts == false then
									attemptText = ""
								end
								GameTooltip:AddLine(
									colorize(
										(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
											(itemLink or itemName or v.name) .. attemptText,
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
				local itemName,
					itemLink,
					itemRarity,
					itemLevel,
					itemMinLevel,
					itemType,
					itemSubType,
					itemStackCount,
					itemEquipLoc,
					itemTexture,
					itemSellPrice = GetItemInfo(Rarity.db.profile.oneTimeItems[npcid].itemId)
				if itemLink or itemName then
					if
						Rarity.db.profile.oneTimeItems[npcid].questId ~= nil and
							IsQuestFlaggedCompleted(Rarity.db.profile.oneTimeItems[npcid].questId)
					 then
						if not R.db.profile.hideKnownItemsInTooltip then
							if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
								blankAdded = true
								GameTooltip:AddLine(" ")
							end
							GameTooltip:AddLine(
								colorize(
									(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
										(itemLink or itemName),
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
								(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
									(itemLink or itemName),
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

		-- NPC is required for an achievement
		if Rarity.ach_npcs_achId[name] then
			local link = GetAchievementLink(Rarity.ach_npcs_achId[name])
			if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
				blankAdded = true
				GameTooltip:AddLine(" ")
			end
			if not Rarity.ach_npcs_isKilled[name] then
				GameTooltip:AddLine(
					colorize((not rarityAdded and L["Rarity: "] or ""), yellow) .. colorize(format(L["Required for %s"], link), green)
				)
			else
				GameTooltip:AddLine(
					colorize((not rarityAdded and L["Rarity: "] or ""), yellow) ..
						colorize(format(L["Already defeated for %s"], link), red)
				)
			end
			rarityAdded = true
		end

		-- This whole zone is used for obtaining something
		if not UnitCanAttack("player", unit) then
			return
		end -- Something you can't attack
		if UnitIsPlayer(unit) then
			return
		end -- A player
		local unitType = tonumber(guid:sub(5, 5), 16) or 0
		if unitType ~= 3 and unitType ~= 5 then
			return
		end

		local zone = GetRealZoneText()
		local subzone = GetSubZoneText()
		local zone_t = LibStub("LibBabble-Zone-3.0"):GetReverseLookupTable()[zone]
		local subzone_t = LibStub("LibBabble-SubZone-3.0"):GetReverseLookupTable()[subzone]
		if
			Rarity.zones[tostring(GetBestMapForUnit("player"))] or Rarity.zones[zone] or Rarity.zones[lbz[zone] or "."] or
				Rarity.zones[lbsz[subzone] or "."] or
				Rarity.zones[zone_t] or
				Rarity.zones[subzone_t] or
				Rarity.zones[lbz[zone_t] or "."] or
				Rarity.zones[lbsz[subzone_t] or "."]
		 then
			for k, v in pairs(R.db.profile.groups) do
				if type(v) == "table" then
					for kk, vv in pairs(v) do
						if type(vv) == "table" then
							local found = false
							if vv.method == CONSTANTS.DETECTION_METHODS.ZONE and vv.zones ~= nil and type(vv.zones) == "table" then
								for kkk, vvv in pairs(vv.zones) do
									if tonumber(vvv) ~= nil and tonumber(vvv) == GetBestMapForUnit("player") then
										found = true
									end
									if
										vvv == zone or vvv == lbz[zone] or vvv == subzone or vvv == lbsz[subzone] or vvv == zone_t or vvv == subzone_t or
											vvv == lbz[zone_t] or
											vvv == subzone or
											vvv == lbsz[subzone_t]
									 then
										found = true
									end
								end
							end
							if found then
								if R:IsAttemptAllowed(vv) then
									local itemName,
										itemLink,
										itemRarity,
										itemLevel,
										itemMinLevel,
										itemType,
										itemSubType,
										itemStackCount,
										itemEquipLoc,
										itemTexture,
										itemSellPrice = GetItemInfo(vv.itemId)
									if itemLink or itemName or vv.name then
										if vv.known and R.db.profile.hideKnownItemsInTooltip then
											GameTooltip:Show()
										else
											if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
												blankAdded = true
												GameTooltip:AddLine(" ")
											end
											local chance = select(2, Rarity.Statistics.GetRealDropPercentage(vv))
											local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
											if vv.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
												attemptText = " " .. colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white)
											end
											if vv.known or Rarity.db.profile.tooltipAttempts == false then
												attemptText = ""
											end
											GameTooltip:AddLine(
												colorize(
													(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
														(itemLink or itemName or vv.name) .. attemptText,
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
)

-- TOOLTIP: ITEMS IN INVENTORY

hooksecurefunc(
	GameTooltip,
	"SetBagItem",
	function(self, bag, slot)
		local blankAdded = false
		local id = GetContainerItemID(bag, slot)
		if id then
			local item
			local rarityAdded = false

			-- This item is used to obtain another item
			if Rarity.items_to_items[id] then
				for k, v in pairs(Rarity.items_to_items[id]) do
					if v.itemId then
						local itemName,
							itemLink,
							itemRarity,
							itemLevel,
							itemMinLevel,
							itemType,
							itemSubType,
							itemStackCount,
							itemEquipLoc,
							itemTexture,
							itemSellPrice = GetItemInfo(v.itemId)
						if itemLink or itemName or v.name then
							if v.known and R.db.profile.hideKnownItemsInTooltip then
								GameTooltip:Show()
							else
								if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
									blankAdded = true
									GameTooltip:AddLine(" ")
								end
								local chance = select(2, Rarity.Statistics.GetRealDropPercentage(v))
								local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], v.attempts or 0, chance or 0), white)
								if v.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
									attemptText = " " .. colorize(format(L["(%d/%d collected)"], v.attempts or 0, v.chance or 0), white)
								end
								if v.known or Rarity.db.profile.tooltipAttempts == false then
									attemptText = ""
								end
								GameTooltip:AddLine(
									colorize(
										(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
											(itemLink or itemName or v.name) .. attemptText,
										yellow
									)
								)
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
			end

			blankAdded = false

			-- Extra item tooltips
			if R.db.profile.extraTooltips.inventoryItems[id] then
				for x, y in pairs(R.db.profile.extraTooltips.inventoryItems[id]) do
					local itemName,
						itemLink,
						itemRarity,
						itemLevel,
						itemMinLevel,
						itemType,
						itemSubType,
						itemStackCount,
						itemEquipLoc,
						itemTexture,
						itemSellPrice = GetItemInfo(y)
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
											if R:IsAttemptAllowed(vv) then
												itemName,
													itemLink,
													itemRarity,
													itemLevel,
													itemMinLevel,
													itemType,
													itemSubType,
													itemStackCount,
													itemEquipLoc,
													itemTexture,
													itemSellPrice = GetItemInfo(vv.itemId)
												if itemLink or itemName or vv.name then
													if vv.known and R.db.profile.hideKnownItemsInTooltip then
														GameTooltip:Show()
													else
														if not blankAdded and R.db.profile.blankLineBeforeTooltipAdditions then
															blankAdded = true
															GameTooltip:AddLine(" ")
														end
														local chance = select(2, Rarity.Statistics.GetRealDropPercentage(vv))
														local attemptText = " " .. colorize(format(L["(%d/%d attempts)"], vv.attempts or 0, chance or 0), white)
														if vv.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
															attemptText = " " .. colorize(format(L["(%d/%d collected)"], vv.attempts or 0, vv.chance or 0), white)
														end
														if vv.known or Rarity.db.profile.tooltipAttempts == false then
															attemptText = ""
														end
														GameTooltip:AddLine(
															colorize(
																(not rarityAdded and L["Rarity: "] .. (R.db.profile.blankLineAfterRarity and "\n" or "") or "") ..
																	(itemLink or itemName or vv.name) .. attemptText,
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
			end
		end
	end
)
