local addonTable = select(2, ...)
local CONSTANTS = addonTable.constants

-- WOW API
local GetItemInfo = _G.C_Item.GetItemInfo
local TextureKitConstants = _G.TextureKitConstants

-- Rarity API
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

-- Fake achievement popup setup function - modernized for retail
local function RarityAchievementAlertFrame_SetUp(frame, itemId, attempts)
	local itemInfo = { GetItemInfo(itemId) }
	local itemName, itemTexture = itemInfo[1], itemInfo[10]

	if itemName == nil then
		return
	end
	if itemTexture == nil then
		itemTexture = [[Interface\Icons\INV_Misc_PheonixPet_01]]
	end

	-- Modernized setup based on current retail AlertFrameSystems.lua AchievementAlertFrame_SetUp
	local displayName = frame.Name
	local shieldPoints = frame.Shield.Points
	local shieldIcon = frame.Shield.Icon
	local unlocked = frame.Unlocked
	local background = frame.Background
	local iconBorder = frame.Icon.Overlay

	-- Set basic frame properties
	displayName:SetText(itemName)
	unlocked:SetPoint("TOP", 7, -23)

	-- Configure shield (no points for item achievements)
	AchievementShield_SetPoints(0, shieldPoints, GameFontNormal, GameFontNormalSmall)
	shieldPoints:Show()
	shieldIcon:Show()
	shieldIcon:SetAtlas("UI-Achievement-Shield-NoPoints", TextureKitConstants.UseAtlasSize)

	-- Set up as non-guild achievement (standard item achievement)
	frame:SetHeight(101)
	background:SetAtlas("ui-achievement-alert-background", TextureKitConstants.UseAtlasSize)
	iconBorder:SetAtlas("ui-achievement-iconframe", TextureKitConstants.UseAtlasSize)
	iconBorder:SetPoint("CENTER", -1, 1)
	frame.Icon:SetPoint("TOPLEFT", -4, -15)
	frame.Shield:SetPoint("TOPRIGHT", -8, -15)
	shieldPoints:SetPoint("CENTER", 2, -2)
	shieldPoints:SetVertexColor(1, 1, 1)
	unlocked:SetText(ACHIEVEMENT_UNLOCKED)

	-- Hide guild-specific elements
	frame.GuildName:Hide()
	frame.GuildBorder:Hide()
	frame.GuildBanner:Hide()

	-- Set up glow and shine effects
	frame.glow:SetAtlas("ui-achievement-glow-glow", TextureKitConstants.UseAtlasSize)
	frame.shine:SetAtlas("ui-achievement-glow-shine", TextureKitConstants.UseAtlasSize)
	frame.shine:SetPoint("BOTTOMLEFT", 0, 8)

	-- Set the item texture
	frame.Icon.Texture:SetTexture(itemTexture)
	frame:EnableMouse(false) -- Make achievement toast unclickable

	-- Set up attempt-specific text
	if attempts == nil or attempts <= 0 then
		attempts = 1
	end

	-- Look up the item to check if it's a collection-type item
	local item = Rarity.db.profile.groups.mounts[itemName]
		or Rarity.db.profile.groups.pets[itemName]
		or Rarity.db.profile.groups.items[itemName]
		or Rarity.db.profile.groups.user[itemName]

	if item and item.method and item.method == CONSTANTS.DETECTION_METHODS.COLLECTION then
		unlocked:SetText(L["Collection Complete"])
	else
		if attempts == 1 then
			unlocked:SetText(L["Obtained On Your First Attempt"])
		else
			unlocked:SetText(format(L["Obtained After %d Attempts"], attempts))
		end
	end

	-- Schedule frame reset after display time
	Rarity:ScheduleTimer(
		function()
			-- Put the achievement frame back to normal when we're done
			unlocked:SetText(ACHIEVEMENT_UNLOCKED)
			frame:EnableMouse(true)
		end,
		10 -- Reduced from 10000ms to 10s - the original was likely a typo
	)

	frame.id = itemId
	return true
end

-- Modern pet battle detection
local FUNCTION_NEVER = function()
	return false
end
local IsInPetBattle = C_PetBattles and C_PetBattles.IsInBattle or FUNCTION_NEVER

-- Set up the alert system using modern patterns
local RarityAchievementAlertSystem =
	AlertFrame:AddQueuedAlertFrameSubSystem("AchievementAlertFrameTemplate", RarityAchievementAlertFrame_SetUp, 2, 6)
RarityAchievementAlertSystem:SetCanShowMoreConditionFunc(function()
	return not IsInPetBattle()
end)

local Output = Rarity.Output

-- test with: /run Rarity:ShowFoundAlert(32458, 5)
function R:ShowFoundAlert(itemId, attempts, item)
	local trackedItem = Rarity.Tracking:GetTrackedItem()
	if item == nil then
		item = trackedItem
	end

	local itemInfo = { GetItemInfo(itemId) }
	local itemName, itemTexture = itemInfo[1], itemInfo[10]
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

	-- Load achievement frame UI if needed
	if not AchievementFrame then
		AchievementFrame_LoadUI()
	end

	-- Generate achievement toast if enabled
	if Rarity.db.profile.showAchievementToast then
		RarityAchievementAlertSystem:AddAlert(itemId, attempts)
		PlaySound(12891) -- UI_Alert_AchievementGained
	end

	-- Schedule screenshot if enabled
	self:ScheduleTimer(function()
		if Rarity.db.profile.takeScreenshot then
			if ActionStatus:IsShown() then
				ActionStatus:Hide()
			end
			Screenshot()
		end
	end, 2)
end
