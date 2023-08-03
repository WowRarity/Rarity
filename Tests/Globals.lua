_G.strmatch = string.match

function _G.table.wipe(t)
	for k, _ in pairs(t) do
		t[k] = nil
	end
end
