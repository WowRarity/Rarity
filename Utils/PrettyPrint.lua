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
	timestamp = timestamp or time()
	print(
		"|c00C2C2C2["
			.. format(
				date("%H:%M:%S", timestamp) .. "] " .. "|c000072CA" .. "%s: " .. "|c00E6CC80%s",
				addonName .. (source ~= "" and "_" .. source or ""),
				msg,
				...
			)
	)
end

local wasErrorDisplayed = false -- Displaying them more than once per session is sure to be annoying

function PP.Error(message, ...)
	if wasErrorDisplayed then
		return
	end

	message = message or ""
	local reportErrorText = format("Oh no! Something went horribly wrong. This is what happened:\n%s\n", message)
	reportErrorText = reportErrorText
		.. "If you didn't change anything that might've caused this, please report the error to the addon developer so it can be fixed :)"

	print(format("|c00CA0A00" .. "%s: " .. "|c00E6CC80%s", addonName, reportErrorText), ...)
	wasErrorDisplayed = true
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
