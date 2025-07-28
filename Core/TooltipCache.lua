local _, addonTable = ...

local R = Rarity

-- Upvalues
--- WoW API
local GetTime = _G.GetTime

local TooltipCache = {}
local tooltipCache = {}

-- Cache data should be invalidated after 5 minutes
local EXPIRATION_TIME = 5 * 60

function TooltipCache:Get(guid)
	local data = tooltipCache[guid]
	if data and (GetTime() - data.timestamp) < EXPIRATION_TIME then
		return data.payload
	end
	return nil
end

function TooltipCache:Set(guid, data)
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
