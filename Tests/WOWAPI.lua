local function createDummyFrame(...)
	local dummyFrame = {
		args = { ... }, -- For debugging purposes only
	}

	-- No actual UI testing should be needed, at least for the time being...
	function dummyFrame.SetScript(...)
		print("[SetScript] NYI", ...)
	end

	function dummyFrame.Show(...)
		print("[Show] NYI", ...)
	end

	function dummyFrame.Hide(...)
		print("[Hide] NYI", ...)
	end

	function dummyFrame.IsShown(...)
		print("[IsShown] NYI", ...)
	end

	function dummyFrame.RegisterEvent(...)
		print("[RegisterEvent] NYI", ...)
	end

	function dummyFrame.UnregisterAllEvents(...)
		print("[UnregisterAllEvents] NYI", ...)
	end

	return dummyFrame
end

_G.CreateFrame = function(...)
	print("[CreateFrame] NYI", ...)
	return createDummyFrame()
end

local C_AddOns = {}

function C_AddOns.EnableAddOn(...)
	print("[C_AddOns.EnableAddOn] NYI", ...)
end

function C_AddOns.IsAddOnLoaded(...)
	print("[C_AddOns.IsAddOnLoaded] NYI", ...)
end

_G.C_AddOns = C_AddOns

_G.GetChannelList = function(...)
	print("[GetChannelList] NYI", ...)
end

_G.GetLocale = function()
	return "enUS" -- For now...
end

-- Don't need a custom one; it just has to fail the tests when executed
_G.geterrorhandler = function()
	return error
end
