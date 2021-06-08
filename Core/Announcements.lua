local _, addonTable = ...

local Announcements = {}

-- Externals
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Rarity API
local Output = Rarity.Output

-- Upvalues
local CONSTANTS = addonTable.constants

function Announcements:AnnounceAttemptForItem(item)
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
		itemSellPrice = GetItemInfo(item.itemId)
	if itemName or item.name then
		local displayedText
		local attempts = item.attempts or 1
		local total = item.attempts or 1

		if item.lastAttempts then
			attempts = attempts - item.lastAttempts
		end

		if total <= attempts then
			if attempts == 1 then
				displayedText = format(L["%s: %d attempt"], itemName or item.name, attempts)
			else
				displayedText = format(L["%s: %d attempts"], itemName or item.name, attempts)
			end
		else
			if attempts == 1 then
				displayedText = format(L["%s: %d attempt (%d total)"], itemName or item.name, attempts, total)
			else
				displayedText = format(L["%s: %d attempts (%d total)"], itemName or item.name, attempts, total)
			end
		end

		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			displayedText = format(L["%s: %d collected"], itemName or item.name, attempts)
		end
		Output:DisplayText(displayedText, itemTexture)
	end
end

Rarity.Announcements = Announcements
