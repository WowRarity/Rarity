local _, addonTable = ...

local R = Rarity

local TooltipCache = {}
local tooltipCache = {}

function TooltipCache:Get(guid)
  return tooltipCache[guid]
end

function TooltipCache:Set(guid, data)
  tooltipCache[guid] = data
end

function TooltipCache:Clear(guid)
  tooltipCache[guid] = nil
end

Rarity.TooltipCache = TooltipCache
return TooltipCache
