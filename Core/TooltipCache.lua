local _, addonTable = ...

local R = Rarity

-- Upvalues
--- WoW API
local GetTime = _G.GetTime

local TooltipCache = {}
local tooltipCache = {}
local cacheSize = 0

-- Cache data should be invalidated after 5 minutes
local EXPIRATION_TIME = 5 * 60
local MAX_CACHE_SIZE = 100

function TooltipCache:Get(guid)
	local data = tooltipCache[guid]
	if data and (GetTime() - data.timestamp) < EXPIRATION_TIME then
		return data.payload
	end
	return nil
end

local function EvictOldest()
	local oldestGuid = nil
	local oldestTimestamp = GetTime()
	for guid, data in pairs(tooltipCache) do
		if data.timestamp < oldestTimestamp then
			oldestTimestamp = data.timestamp
			oldestGuid = guid
		end
	end
	if oldestGuid then
		tooltipCache[oldestGuid] = nil
		cacheSize = cacheSize - 1
	end
end

function TooltipCache:Set(guid, data)
	if not tooltipCache[guid] then
		if cacheSize >= MAX_CACHE_SIZE then
			EvictOldest()
		end
		cacheSize = cacheSize + 1
	end
	tooltipCache[guid] = {
		payload = data,
		timestamp = GetTime(),
	}
end

function TooltipCache:Clear(guid)
	tooltipCache[guid] = nil
end

function TooltipCache:ClearAll()
	wipe(tooltipCache)
end

Rarity.TooltipCache = TooltipCache
return TooltipCache
