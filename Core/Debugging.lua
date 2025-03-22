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

function R:ProfileDebug(s)
	if self.db.profile.enableProfiling and self.db.profile.debugMode then
		R:Print(s)
	end
end

Rarity.Debugging = Debugging
return Debugging
