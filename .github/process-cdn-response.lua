-- TODO autoformat ignores this filel should move it to a different directory anyway?
-- TODO convert to proper tests, e.g,  toc/cdn modules. Can then use the test runner directly?
-- TODO sync version automatically (later)
-- TODO assert core and options version always match
-- TODO should also check X-Interface for CurseForge? Needs research (other X- fields, check BigWigs TOC etc?)
-- TODO clean up and refactor, this is just a throwaway POC (no tests...)
-- TODO delete shell script, or maybe keep for convenience?

local transform = require("transform")

local bold = transform.bold

local cdn = {}
function cdn.extractVersion(versionName)

end

local function extractVersion(version_name)
    -- Split the version name by '.' (e.g., '11.0.2.XXXXX')
    local parts = string.explode(version_name, ".")
    
    if #parts >= 3 then
        local major = parts[1]  -- '11'
        local minor = parts[2]  -- '0'
        local patch = parts[3]  -- '2'

        -- Convert to TOC format: major * 10000 + minor * 100 + patch
        local tocVersionNumber = tonumber(major) * 10000 + tonumber(minor) * 100 + tonumber(patch)
        return tocVersionNumber
    else
        return nil  -- Invalid version format
    end
end

local cdn = {}

function cdn.parse(responseText)

end

function cdn.parseResponse(responseText)
	local response = {}

	return response
end

local function parse(data)
    local response = {}
    local sequenceNumber = nil
    local index = {}

    local lines = string.explode(data, "\n")

    for _, line in ipairs(lines) do
        line = line:match("^%s*(.-)%s*$")  -- Trim whitespace
        if line == "" then
            goto continue  -- Skip empty lines
        end

        if line:find("## seqn = ") then
            sequenceNumber = line:gsub("## seqn = ", "")
        else
            local tokens = string.explode(line, "|")
            
            if #index == 0 then
                -- Parse the header line
                for _, indexKey in ipairs(tokens) do
                    local components = string.explode(indexKey, "!")
					assert(#components == 2, #components == 2 and "" or dump(components))
                    if #components == 2 then
                        table.insert(index, components[1])
                    end
                end
            else
                -- Parse the data line
                local indexKey = tokens[1]
                response[indexKey] = {}

                for i, entry in ipairs(tokens) do
                    response[indexKey][index[i]] = entry
                end

                if response[indexKey].VersionsName then
                    local tocVersionNumber = extractVersion(response[indexKey]["VersionsName"])
					assert(tocVersionNumber, "Invalid version format")
					response[indexKey].interfaceVersion = tocVersionNumber
				end
            end
        end

        ::continue::
    end

    return sequenceNumber, response
end

local cdnResponseText = C_FileSystem.ReadFile(arg[1])
C_FileSystem.Delete(arg[1])
local coreAddonVersion = arg[2]
local optionsAddonVersion = arg[3]

printf("Parsing CDN response:\n%s", transform.cyan(cdnResponseText))

local sequenceNumber, responses = parse(cdnResponseText)
printf(transform.yellow("Sequence number: %d"), sequenceNumber)
printf(transform.yellow("Region keys: %s"), dump(table.keys(responses), { silent = true}))
print()

for regionKey, values in pairs(responses) do
	if regionKey == "us" then
		for key, value in pairs(values) do
			printf(bold("%s") .. ": %s", key, value)
		end
	end
end

print()

local toc = {}

function toc.parse(fileContents)

end

-- or [[
	-- ## seqn = 123456
	-- BuildConfig!SomeValue|CDNConfig!SomeOtherValue|BuildId!AnotherValue|VersionsName!MoreValues
	-- abcdef1234|ghijkl5678|987654|11.0.2.45678
	-- ]] -- TODO unit test, proper cdn module

local tocFiles = {
	Core = "Rarity.toc",
	Options = "Modules/Options/Rarity_Options.toc",
}

local latestInterfaceVersion = response

-- toc.parse?
for moduleName, tocFilePath in pairs(tocFiles) do
	local tocFileContents = C_FileSystem.ReadFile(tocFilePath)
	printf("Processing TOC file: %s -> %s", bold(moduleName), bold(tocFilePath))
	local lines = string.explode(tocFileContents, "\n")
	for _, line in ipairs(lines) do
		line = line:gsub("\r\n", "\n") -- Avoids crossplatform headaches (autoformat doesn't modify TOC files)
			local tocInterfaceVersion = line:match("^## Interface: (%d+)")
			if tocInterfaceVersion then
				printf("Detected interface version: %s", bold(tocInterfaceVersion))

				-- Assumes the US CDN is authoritative (should be the earliest to update?)
				local latestInterfaceVersion = tostring(responses.us.interfaceVersion)
				if tocInterfaceVersion ~= latestInterfaceVersion then
					local errorMessage = format("✗ Local TOC interface version %s does NOT match Blizzard CDN version %s", tocInterfaceVersion,latestInterfaceVersion)
					error(transform.red(errorMessage))
				else
					printf(transform.green("✓ Local TOC interface version %s matches Blizzard CDN version %s"), tocInterfaceVersion, latestInterfaceVersion)
				end

	end
	end
end