local assert = assert
local ipairs = ipairs
local tonumber = tonumber

local string_explode = string.explode
local table_insert = table.insert

local CDN = {
	SEQUENCE_NUMBER_PATTERN = "## seqn = ",
	TRIM_WHITESPACE_PATTERN = "^%s*(.-)%s*$",
	errorStrings = {
		INVALID_VERSION_FORMAT = "Invalid CDN version string format (should be be MAJOR.MINOR.PATCH)",
		MALFORMED_RESPONSE_HEADER = "Malformed CDN response header (should be !-separated key-value pairs)",
	},
}

function CDN:VersionNameToInterfaceVersion(versionName)
	local tokens = string_explode(versionName, ".")

	if #tokens < 3 then
		return nil, CDN.errorStrings.INVALID_VERSION_FORMAT
	end

	local major = tokens[1]
	local minor = tokens[2]
	local patch = tokens[3]

	return tonumber(major) * 10000 + tonumber(minor) * 100 + tonumber(patch)
end

local function parseNextLine(response, line)
	line = line:match(CDN.TRIM_WHITESPACE_PATTERN)

	assert(line ~= nil)
	assert(line ~= "")

	-- Parse seqn (second line)
	if line:find(CDN.SEQUENCE_NUMBER_PATTERN) then
		local sequenceNumber = line:gsub(CDN.SEQUENCE_NUMBER_PATTERN, "")
		response.sequenceNumber = tonumber(sequenceNumber)
		return
	end

	line = line:gsub("||", "|nil|") -- It's not stupid if it works :3
	local tokens = string_explode(line, "|")

	-- Parse header (first line)
	if #response.csvFieldNames == 0 then
		for _, csvFieldName in ipairs(tokens) do
			local tokens = string_explode(csvFieldName, "!")
			if #tokens ~= 2 then
				error(CDN.errorStrings.MALFORMED_RESPONSE_HEADER, 0)
			end

			table_insert(response.csvFieldNames, tokens[1])
		end

		return
	end

	-- Parse the CSV data (subsequent lines)
	local regionKey = tokens[1]
	local csvEntry = {}

	for index, csvValue in ipairs(tokens) do
		local fieldName = response.csvFieldNames[index]
		assert(fieldName ~= nil)
		csvEntry[fieldName] = csvValue
	end

	assert(response.productInfoByRegion[regionKey] == nil)
	response.productInfoByRegion[regionKey] = csvEntry
end

function CDN:ParseResponseText(data)
	local response = {
		csvFieldNames = {},
		productInfoByRegion = {},
	}

	local lines = string_explode(data, "\n")
	for _, line in ipairs(lines) do
		-- Might be faster to use goto continue here, but it breaks the autoformatter (revisit later?)
		parseNextLine(response, line)
	end

	return response
end

return CDN
