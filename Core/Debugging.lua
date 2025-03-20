local _, addonTable = ...

local Debugging = {}

-- Upvalues
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

	if self.db.profile.enableProfiling then
function R:ProfileDebug(s)
		R:Print(s)
	end
end

Rarity.Debugging = Debugging
return Debugging
