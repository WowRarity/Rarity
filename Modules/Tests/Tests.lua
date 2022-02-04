if not Rarity then
	return
end

local labels = {}

function _G.describe(labelText, specDefinitionFunction)
	labels[labelText] = labels[labelText] or {}
	table.insert(labels[labelText], specDefinitionFunction)
end

function _G.it(labelText, specToTexecute)
	local success = xpcall(specToTexecute, function(errorMessage)
		print("|n")
		print("|cFFFF0000 " .. errorMessage .. "|r")
		print("|n")
	end)

	local RESULT_STRING_PASS = "|TInterface\\RaidFrame\\ReadyCheck-Ready:14|t %s"
	local RESULT_STRING_FAIL = "|TInterface\\RaidFrame\\ReadyCheck-NotReady:14|t %s"
	print(format(success and RESULT_STRING_PASS or RESULT_STRING_FAIL, labelText))
	print(labelText, success)
	return success
end

function _G.assertTrue(condition)
	assert(condition, "Failed to assert that " .. tostring(condition) .. " is true")
end

function _G.assertFalse(condition)
	assert(not condition, "Failed to assert that " .. tostring(condition) .. " is false")
end

function _G.assertEquals(value1, value2)
	assert(value1 == value2, "Failed to assert that " .. tostring(value1) .. " is equal to " .. tostring(value2))
end

local describe = _G.describe
local it = _G.it

local assertFalse = _G.assertFalse
local assertTrue = _G.assertTrue
local assertEquals = _G.assertEquals

local function GetKeybindCategoryForCommand(uniqueCommandString)
	local numBindings = GetNumBindings()
	for index = 1, numBindings do
		local command, category, key1, key2 = GetBinding(index)
		if command == uniqueCommandString then
			return category
		end
	end
end

local function HasKeybindingCategory(categoryName)
	local numBindings = GetNumBindings()
	for index = 1, numBindings do
		local command, category, key1, key2 = GetBinding(index)
		if category == categoryName then
			return true
		end
	end

	return false
end

describe("OnPlayerLogin", function()
	it("should register a 'Toggle Main Window' key binding", function()
		assertEquals(GetKeybindCategoryForCommand("RARITY_TOGGLE_MAIN_WINDOW"), "ADDONS")
	end)
end)

function Rarity:RunTests()

	local results = { numTests = 0, numFailedTests = 0 }

	for labelText, specs in pairs(labels) do
		for index, specDefinitionFunction in ipairs(specs) do
			-- TODO This doesn't return the expected value (too much nesting)

			print(labelText)
			results.numTests = results.numTests + 1

			local success = specDefinitionFunction()
			if not success then
				results.numFailedTests = results.numFailedTests + 1
			end
		end
	end

	-- Output results (in the most basic form imaginable, for now)
	local numPassingTests = results.numTests - results.numFailedTests
	if numPassingTests > 0 then
		print(format("|cFF00FF00%d passing|r", numPassingTests))
	end

	if results.numFailedTests > 0 then
		print(format("|cFFFF0000%d failing|r", results.numFailedTests))
	end

	print("numTests", results.numTests)
	print("numFailedTests", results.numFailedTests)
end
