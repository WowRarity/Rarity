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

function R:ProfileStart()
	if self.db.profile.enableProfiling then
		start1 = debugprofilestop()
	end
end

function R:ProfileStart2()
	if self.db.profile.enableProfiling then
		start2 = debugprofilestop()
	end
end

function R:ProfileStop(s)
	if self.db.profile.enableProfiling then
		stop1 = debugprofilestop()
		R:Print(format(s, stop1 - start1))
	end
end

function R:ProfileStop2(s)
	if self.db.profile.enableProfiling then
		stop2 = debugprofilestop()
		R:Print(format(s, stop2 - start2))
	end
end

function R:ProfileDebug(s)
	if self.db.profile.enableProfiling then
		R:Print(s)
	end
end

Rarity.Debugging = Debugging
return Debugging
