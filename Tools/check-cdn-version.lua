local BlizzardTOC = require("Tests.TOC.BlizzardTOC")
local CDN = require("Tests.TOC.CDN")

local transform = require("transform")
local bold = transform.bold

local cdnResponseTexts = {
	C_FileSystem.ReadFile(arg[1]),
	C_FileSystem.ReadFile(arg[2]),
	C_FileSystem.ReadFile(arg[3]),
}

assert(C_FileSystem.Delete(arg[1]))
assert(C_FileSystem.Delete(arg[2]))
assert(C_FileSystem.Delete(arg[3]))

local cdnResponses = {}

for index, cdnResponseText in ipairs(cdnResponseTexts) do
	printf("Parsing CDN response:\n%s", transform.cyan(cdnResponseText))
	local response = CDN:ParseResponseText(cdnResponseText)
	printf(transform.yellow("Sequence number: %d"), response.sequenceNumber)
	printf(transform.yellow("Region keys: %s"), dump(table.keys(response.productInfoByRegion), { silent = true }))

	print()

	for regionKey, productInfo in pairs(response.productInfoByRegion) do
		if regionKey == "us" then
			for key, value in pairs(productInfo) do
				printf(bold("%s") .. ": %s", key, value)
			end
		end
	end

	table.insert(cdnResponses, response)
end

print()

local tocFiles = {
	Core = "Rarity.toc",
	Options = "Modules/Options/Rarity_Options.toc",
}

for moduleName, tocFilePath in pairs(tocFiles) do
	local tocFileContents = C_FileSystem.ReadFile(tocFilePath)
	printf("Processing TOC file: %s -> %s", bold(moduleName), bold(tocFilePath))
	local toc = BlizzardTOC:DecodeFileContents(tocFileContents)
	assert(#toc["Interface"] == #cdnResponses, "Expected one TOC version per supported product line")

	for index, response in ipairs(cdnResponses) do
		local tocInterfaceVersion = toc["Interface"][index]
		printf(bold("Detected interface version: %s"), tocInterfaceVersion)

		-- Assumes the US CDN is authoritative (should be the earliest to update?)
		local usVersionName = response.productInfoByRegion.us.VersionsName
		local latestInterfaceVersion = assert(CDN:VersionNameToInterfaceVersion(usVersionName))

		if tocInterfaceVersion ~= latestInterfaceVersion then
			local errorMessage = format(
				"✗ Local TOC interface version %d does NOT match Blizzard CDN version %d",
				tocInterfaceVersion,
				latestInterfaceVersion
			)
			error(transform.red(errorMessage))
		else
			printf(
				transform.green("✓ Local TOC interface version %d matches Blizzard CDN version %d"),
				tocInterfaceVersion,
				latestInterfaceVersion
			)
		end
		print()
	end
end
