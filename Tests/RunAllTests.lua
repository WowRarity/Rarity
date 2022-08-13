LuaUnit = require("luaunit")

assertEquals = LuaUnit.assertEquals

-- Add test suites to luaunit queue
require("Tests/Core/DatabaseValidation/TestNothing")

print("Running all tests")

-- Run all tests that have been queued and output results as TestAnything-formatted report
local exitCode = LuaUnit.run("--output", "TAP")

print()
print("Test suite finished with exit code " .. exitCode)

return function()
	return exitCode
end
