local String = {}

-- Lua API
local string_format = string.format

function String:Colorize(floatColorRGB)
	-- Literal copy/paste from the legacy codebase; streamline later (as needed)
	local function colorize(s, color)
		if color and s then
			return string_format("|cff%02x%02x%02x%s|r", (color.r or 1) * 255, (color.g or 1) * 255, (color.b or 1) * 255, s)
		else
			return s
		end
	end

	-- The legacy code exclusively uses this call pattern: colorize(string, color)
	-- This means we can use self as the Lua string instead of the String table and it will still work (even if it's hacky)
	-- BUT! Beware, if more methods are added to the String table we can't access them via self.OtherFunction in here
	-- When this happens, it will be time to refactor all the calls to colorize... (Fun times, because they're everywhere)
	-- Some day this should definitely be done... but today is not that day :D
	return colorize(self, floatColorRGB)
end

Rarity.Utils.String = String
