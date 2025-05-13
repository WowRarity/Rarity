local _, addonTable = ...

local GUID = {}

function Rarity:GetNPCIDFromGUID(guid)
	if guid then
		local unit_type, _, _, _, _, mob_id = strsplit("-", guid)
		if unit_type == "Pet" or unit_type == "Player" then
			return 0
		end
		return (guid and mob_id and tonumber(mob_id)) or 0
	end
	return 0
end

local GetBestMapForUnit = _G.C_Map.GetBestMapForUnit

local NPC = "NPC"

local lbz = LibStub("LibBabble-Zone-3.0"):GetUnstrictLookupTable()
local lbsz = LibStub("LibBabble-SubZone-3.0"):GetUnstrictLookupTable()
function Rarity:CheckNpcInterest(guid, zone, subzone, zone_t, subzone_t, curSpell, requiresPickpocket)
	if guid == nil then
		return
	end
	if type(guid) ~= "string" then
		return
	end
	if Rarity.guids[guid] ~= nil then
		return
	end -- Already seen this NPC

	local npcid = self:GetNPCIDFromGUID(guid)
	if npcs[npcid] == nil then -- Not an NPC we need, abort
		self:Debug("NPC ID not on the list of needed NPCs: " .. (npcid or "nil"))

		if
			Rarity.zones[tostring(GetBestMapForUnit("player"))] == nil
			and Rarity.zones[zone] == nil
			and Rarity.zones[lbz[zone] or "."] == nil
			and Rarity.zones[lbsz[subzone] or "."] == nil
			and Rarity.zones[zone_t] == nil
			and Rarity.zones[subzone_t] == nil
			and Rarity.zones[lbz[zone_t] or "."] == nil
			and Rarity.zones[lbsz[subzone_t] or "."] == nil
		then -- Not a zone we need, abort
			self:Debug("Map ID not on the list of needed zones: " .. tostring(GetBestMapForUnit("player")))
			return
		end
	else
		self:Debug("NPC ID is one we need: " .. (npcid or "nil"))
	end

	-- If the loot is the result of certain spell casts (mining, herbing, opening, pick lock, archaeology, disenchanting, etc), stop here -> This is to avoid multiple attempts, since those methods are handled separately!
	if Rarity.relevantSpells[curSpell] then
		self:Debug("Aborting because we were casting a disallowed spell: " .. curSpell)
		return
	end

	-- If the loot is not from an NPC (could be from yourself or a world object), we don't want to process this
	local unitType, _, _, _, _, mob_id = strsplit("-", guid)
	if unitType ~= "Creature" and unitType ~= "Vehicle" then
		self:Debug(
			"This loot isn't from an NPC; disregarding. Loot source identified as unit type: " .. (unitType or "nil")
		)
		return
	end

	Rarity.guids[guid] = true

	-- Increment attempt counter(s). One NPC might drop multiple things we want, so scan for them all.
	if Rarity.npcs_to_items[npcid] and type(Rarity.npcs_to_items[npcid]) == "table" then
		for k, v in pairs(Rarity.npcs_to_items[npcid]) do
			if v.enabled ~= false and (v.method == NPC or v.method == ZONE) then
				if self:IsAttemptAllowed(v) then
					-- Don't increment attempts if this NPC also has a statistic defined. This would result in two attempts counting instead of one.
					if not v.statisticId or type(v.statisticId) ~= "table" or #v.statisticId <= 0 then
						-- Don't increment attempts for unique items if you already have the item in your bags
						if not (v.unique == true and (Rarity.bagitems[v.itemId] or 0) > 0) then
							-- Don't increment attempts for non-pickpocketed items if this item isn't being pickpocketed
							if
								(requiresPickpocket and v.pickpocket)
								or (requiresPickpocket == false and not v.pickpocket)
							then
								if v.attempts == nil then
									v.attempts = 1
								else
									v.attempts = v.attempts + 1
								end
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
							if self:IsAttemptAllowed(vv) then
								if vv.attempts == nil then
									vv.attempts = 1
								else
									vv.attempts = vv.attempts + 1
								end
								self:OutputAttempts(vv)
							end
						end
					end
				end
			end
		end
	end
end

local match = string.match
local tonumber = tonumber
function GUID:GetWorldObject(guid)
	return tonumber(match(guid, "GameObject%-.-%-.-%-.-%-.-%-(.-)%-"))
end

function GUID:GetCreatureID(guid)
	return tonumber(match(guid, "Creature%-.-%-.-%-.-%-.-%-(.-)%-"))
end

return GUID