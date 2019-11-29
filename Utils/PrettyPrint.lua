local addonName, addon = ...

-- Upvalues
local print = print
local format = format
local date = date

-- Locals
local PP = {}

-- Prettified print
function PP.Print(msg, ...)
	print(format("|c00CC5500" .. "%s: " .. "|c00E6CC80%s", addonName, msg), ...)
end

-- Prints a prettier debug message, with source (module, category, etc.) if one was given
function PP.DebugMsg(msg, timestamp, source, ...)

	source = source or ""
	timestamp = timestamp or date()
	print("|c00C2C2C2[" .. format(date("%H:%M:%S", timestamp) .. "] " .. "|c000072CA" .. "%s: " .. "|c00E6CC80%s", addonName .. (source ~= "" and "_" .. source or ""), msg, ...))

end

addon.PrettyPrint = PP