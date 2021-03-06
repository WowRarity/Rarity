-- Upvalues
local date = date
local time = time

-- Locals
local Time = {}

function Time.GetDate(delta)
	local dt = date("*t", time() - (delta or 0))
	return dt.year * 10000 + dt.month * 100 + dt.day
end

Rarity.Utils.Time = Time
return Time
