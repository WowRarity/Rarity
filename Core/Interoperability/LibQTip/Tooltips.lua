local Tooltips = {}

-- Since LibQTip is embedded into release versions as a mandatory dependency, we can rely on it being available
-- This means we don't need to perform additional checks like we do before using the TSM_API inside this module

-- Dependencies are loaded before any of our own files, so it should be safe to cache it on load
local LibQTip = LibStub("LibQTip-1.0")

function Tooltips:IsTooltipAcquired(tooltipName)
	return LibQTip:IsAcquired(tooltipName)
end

-- TODO Separate acquire from create and don't forward varargs here
function Tooltips:AcquireTooltip(tooltipName, ...)
	return LibQTip:Acquire(tooltipName, ...)
end

function Tooltips:ReleaseTooltip(tooltipName)
	return LibQTip:Release(tooltipName)
end

-- No idea why this is used directly, but let's worry about that later
function Tooltips:GetLabelProvider()
	return LibQTip.LabelProvider
end

Rarity.Tooltips = Tooltips
