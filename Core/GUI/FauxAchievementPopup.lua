local _, addonTable = ...
local CONSTANTS = addonTable.constants

local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Fake achievement popup stuff
local function RarityAchievementAlertFrame_SetUp(frame, itemId, attempts)
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
		itemSellPrice = GetItemInfo(itemId)
	if itemName == nil then
		return
	end
	if itemTexture == nil then
		itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]]
	end

	-- The following code is adapted from Blizzard's AchievementAlertFrame_SetUp function found in FrameXML\AlertFrameSystems.lua [introduced in 7.0]

	local displayName = frame.Name
	local shieldPoints = frame.Shield.Points
	local shieldIcon = frame.Shield.Icon
	local unlocked = frame.Unlocked
	local oldCheevo = frame.OldAchievement

	displayName:SetText(itemName)

	AchievementShield_SetPoints(0, shieldPoints, GameFontNormal, GameFontNormalSmall)

	if (frame.guildDisplay or frame.oldCheevo) then
		frame.oldCheevo = nil
		shieldPoints:Show()
		shieldIcon:Show()
		oldCheevo:Hide()
		frame.guildDisplay = nil
		frame:SetHeight(88)
		local background = frame.Background
		background:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Background")
		background:SetTexCoord(0, 0.605, 0, 0.703)
		background:SetPoint("TOPLEFT", 0, 0)
		background:SetPoint("BOTTOMRIGHT", 0, 0)
		local iconBorder = frame.Icon.Overlay
		iconBorder:SetTexture("Interface\\AchievementFrame\\UI-Achievement-IconFrame")
		iconBorder:SetTexCoord(0, 0.5625, 0, 0.5625)
		iconBorder:SetPoint("CENTER", -1, 2)
		frame.Icon:SetPoint("TOPLEFT", -26, 16)
		displayName:SetPoint("BOTTOMLEFT", 72, 36)
		displayName:SetPoint("BOTTOMRIGHT", -60, 36)
		frame.Shield:SetPoint("TOPRIGHT", -10, -13)
		shieldPoints:SetPoint("CENTER", 7, 2)
		shieldPoints:SetVertexColor(1, 1, 1)
		shieldIcon:SetTexCoord(0, 0.5, 0, 0.45)
		unlocked:SetPoint("TOP", 7, -23)
		frame.GuildName:Hide()
		frame.GuildBorder:Hide()
		frame.GuildBanner:Hide()
		frame.glow:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
		frame.glow:SetTexCoord(0, 0.78125, 0, 0.66796875)
		frame.shine:SetTexture("Interface\\AchievementFrame\\UI-Achievement-Alert-Glow")
		frame.shine:SetTexCoord(0.78125, 0.912109375, 0, 0.28125)
		frame.shine:SetPoint("BOTTOMLEFT", 0, 8)
	end

	shieldIcon:SetTexture([[Interface\AchievementFrame\UI-Achievement-Shields-NoPoints]])

	frame.Icon.Texture:SetTexture(itemTexture)
	frame:EnableMouse(false) -- Make achievement toast unclickable

	if attempts == nil or attempts <= 0 then
		attempts = 1
	end
	if item and item.method and item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		unlocked:SetText(L["Collection Complete"])
	else
		if attempts == 1 then
			unlocked:SetText(L["Obtained On Your First Attempt"])
		else
			unlocked:SetText(format(L["Obtained After %d Attempts"], attempts))
		end
	end
	Rarity:ScheduleTimer(
		function()
			-- Put the achievement frame back to normal when we're done
			unlocked:SetText(ACHIEVEMENT_UNLOCKED)
			frame:EnableMouse(true)
		end,
		10
	)

	frame.id = itemId
	return true
end

local RarityAchievementAlertSystem =
	AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", RarityAchievementAlertFrame_SetUp, 2, 6)
RarityAchievementAlertSystem:SetCanShowMoreConditionFunc(
	function()
		return not C_PetBattles.IsInBattle()
	end
)

local Output = Rarity.Output

-- test with: /run Rarity:ShowFoundAlert(32458, 5)
function R:ShowFoundAlert(itemId, attempts, item)
	local trackedItem = Rarity.Tracking:GetTrackedItem()
	if item == nil then
		item = trackedItem
	end

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
		itemSellPrice = GetItemInfo(itemId)
	if itemName == nil then
		return
	end -- Server doesn't know this item, we can't award it
	if itemTexture == nil then
		itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]]
	end

	-- Output to the sink
	if self.db.profile.enableAnnouncements ~= false and item.announce ~= false then
		local s
		if item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
			s = format(L["%s: collection completed!"], itemName)
		else
			if attempts <= 1 then
				s = format(L["%s: Found on the first attempt!"], itemName)
			else
				s = format(L["%s: Found after %d attempts!"], itemName, attempts)
			end
		end
		Output:DisplayText(s, itemTexture)
	end

	-- The following code is adapted from Blizzard's AlertFrameMixin:OnEvent function found in FrameXML\AlertFrames.lua [heavily updated in 7.0]
	-- Presumably, this is now outdated (as of 9.0) so maybe copy/pasting it wasn't the best idea? :P

	if (not AchievementFrame) then
		AchievementFrame_LoadUI()
	end

	-- If option to generate achievement toast on item found is enabled, then generate the toast.
	if Rarity.db.profile.showAchievementToast then
		RarityAchievementAlertSystem:AddAlert(itemId, attempts)
		PlaySound(12891) -- UI_Alert_AchievementGained
	end

	self:ScheduleTimer(
		function()
			-- Take a screenshot
			if Rarity.db.profile.takeScreenshot then
				if (ActionStatus:IsShown()) then
					ActionStatus:Hide()
				end
				Screenshot()
			end
		end,
		2
	)
end
