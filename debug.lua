-- Mocking AceLocale without any translations applied since they don't matter
L = {}
local metatable = {
	__index = function(t, key)
		return key
	end
}
setmetatable(L, metatable)

-- Mocking away LibStub to run this script outside of the WOW client
LibStub = function(addon)
	local result = {
		GetLocale = function(name)
			return L
		end
	}
	return result
end

-- WOW API (non-standard/not part of the basic Lua 5.1 API)
format = string.format

dofile("testOLD.lua")

-- Helpers
-- Source: https://www.lua.org/pil/19.3.html
local function pairsByKeys(t, f)
	local a = {}
	for n in pairs(t) do
		table.insert(a, n)
	end
	table.sort(a, f)
	local i = 0 -- iterator variable
	local iter = function()
		-- iterator function
		i = i + 1
		if a[i] == nil then
			return nil
		else
			return a[i], t[a[i]]
		end
	end
	return iter
end

local excludedFieldNames = {
	["name"] = true
}

local function writeFile(fileName, t)
	print("Generating file: " .. fileName)
	local file = io.open(fileName, "w")
	local m = {}
	for k, v in pairsByKeys(t) do
		if not excludedFieldNames[k] then
			-- print(k)
			file:write(k .. "\n")
		else
			print("\tExcluded irrelevant field: " .. k)
		end
	end
	file:close()
end

writeFile("mounts.txt", databaseBeforeRefactoring.mounts)
writeFile("pets.txt", databaseBeforeRefactoring.pets)
writeFile("items.txt", databaseBeforeRefactoring.items)
