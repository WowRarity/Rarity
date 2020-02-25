local addonName, addonTable = ...

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
	print(
		"|c00C2C2C2[" ..
			format(
				date("%H:%M:%S", timestamp) .. "] " .. "|c000072CA" .. "%s: " .. "|c00E6CC80%s",
				addonName .. (source ~= "" and "_" .. source or ""),
				msg,
				...
			)
	)
end

function PP.Error(message, ...)
	message = message or ""
	local reportErrorText =
		"Oh no! Something went horribly wrong:\n" ..
		message .. "\nPlease report this error to the addon developer so it can be fixed :)"
	print(format("|c00CA0A00" .. "%s: " .. "|c00E6CC80%s", addonName, reportErrorText), ...)
end

--- Prints timestamps in a human-readable fashion?
-- TODO: LuaDoc
function PP:FormatTime(t)
	if not t then
		return "0:00"
	end
	if t == 0 then
		return "0:00"
	end

	local h = math.floor(t / (60 * 60))
	t = t - (60 * 60 * h)
	local m = math.floor(t / 60)
	t = t - (60 * m)
	local s = t

	if h > 0 then
		return format("%d:%02d:%02d", h, m, s)
	end

	if m > 0 then
		return format("%d:%02d", m, s)
	end

	return format("%d", s) .. "s"
end

Rarity.Utils.PrettyPrint = PP
return PP
