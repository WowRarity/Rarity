local Table = {}

-- Extending Lua's table API would make more sense, but we don't want to modify the environment to avoid interoperability issues
function Table.Count(luaTable)
	local numEntries = 0

	for key, value in pairs(luaTable) do
		numEntries = numEntries + 1
	end

	return numEntries
end

Rarity.Utils.Table = Table
