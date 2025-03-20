local _, addonTable = ...

local Debugging = {}

-- Upvalues
local R = Rarity
local DebugCache = Rarity.Utils.DebugCache

-- Lua APIs
local format = format

-- WOW APIs
local debugprofilestop = debugprofilestop

-- Debug mode and profiling
function R:Debug(s, ...)
	if self.db.profile.debugMode then
		self:Print(format(s, ...))
	end
	DebugCache:AddMessage(format(s, ...))
end

local start1, stop1, start2, stop2
function R:ProfileDebug(s) -- TODO move
	if self.db.profile.enableProfiling then
		R:Print(s)
	end
end

Rarity.Debugging = Debugging
return Debugging
