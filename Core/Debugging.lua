local _, addonTable = ...

local Debugging = {}

-- Upvalues
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local R = Rarity
local DebugCache = Rarity.Utils.DebugCache

-- Lua APIs
local format = format

-- Debug mode and profiling
function R:Debug(s, ...)
	if self.db.profile.debugMode then
		self:Print(format(s, ...))
	end
	DebugCache:AddMessage(format(s, ...))
end

function R:ProfileDebug(s)
	if self.db.profile.enableProfiling and self.db.profile.debugMode then
		R:Print(s)
	end
end

function Debugging:EnterDebugMode()
	R.db.profile.debugMode = true
	R:Print(L["Debug mode ON"])
	Rarity.GUI.DebugMenu:Show()
end

function Debugging:ExitDebugMode()
	R.db.profile.debugMode = false
	R:Print(L["Debug mode OFF"])
	Rarity.GUI.DebugMenu:Hide()
end

Rarity.Debugging = Debugging
return Debugging
