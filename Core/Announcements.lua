local _, addonTable = ...

local Announcements = {}

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Rarity API
local Output = Rarity.Output

-- Upvalues
local CONSTANTS = addonTable.constants

--- WoW API
local GetItemInfo = _G.C_Item.GetItemInfo

function Announcements:AnnounceAttemptForItem(item)
	local itemName, itemLink, itemRarity, itemLevel, itemMinLevel, itemType, itemSubType, itemStackCount, itemEquipLoc, itemTexture, itemSellPrice =
		GetItemInfo(item.itemId)
	if itemName or item.name then
		local displayedText
		local attempts = item.attempts or 1
		local total = item.attempts or 1
		local chance
		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			chance = (item.attempts or 0) / (item.chance or 100)
			if chance < 0 then
				chance = 0
			end
			if chance > 1 then
				chance = 1
			end
			chance = chance * 100
		else
			local dropChance = Rarity.Statistics.GetRealDropPercentage(item)
			chance = 100 * (1 - math.pow(1 - dropChance, attempts))
		end

		if item.lastAttempts then
			attempts = attempts - item.lastAttempts
		end

		if total <= attempts then
			if attempts == 1 then
				displayedText = format(L["%s: %d attempt - %.2f%%"], itemName or item.name, attempts, chance)
			else
				displayedText = format(L["%s: %d attempts - %.2f%%"], itemName or item.name, attempts, chance)
			end
		else
			if attempts == 1 then
				displayedText =
					format(L["%s: %d attempt (%d total) - %.2f%%"], itemName or item.name, attempts, total, chance)
			else
				displayedText =
					format(L["%s: %d attempts (%d total) - %.2f%%"], itemName or item.name, attempts, total, chance)
			end
		end

		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			displayedText = format(L["%s: %d collected - %.2f%%"], itemName or item.name, attempts, chance)
		end
		Output:DisplayText(displayedText, itemTexture)
	end
end

Rarity.Announcements = Announcements
