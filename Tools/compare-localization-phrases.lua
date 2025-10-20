local inputFile = arg[1]
assert(inputFile, "No input file provided")

local transform = require("transform")
local cyan = transform.cyan
local green = transform.green
local red = transform.red

-- Doing all this setup seems like a bit much... should figure out a better way eventually?
require("Tests.Globals")
require("Tests.WOWAPI")
local addonName, addonTable = unpack(require("Tests.RarityCoreSetup"))

local function formatDictionaryEntry(key, value)
	-- Using WowAce-style shorthands improves readability
	local displayKey = format('["%s"]', cyan(key))
	local displayValue = (key == value) and tostring(true) or format('"%s"', value)
	local displayString = format("%s = %s,", displayKey, displayValue)
	return displayString
end

print()
printf("Processing localization phrases for input file %s...", cyan(inputFile))
local clientLocale = "enUS"
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity", clientLocale, true)
local englishPhrases = L

local source = "Locales.lua"
local numSourcePhrases = table.count(L)
printf("  %s: Contains %d phrases (%s)", cyan(source), numSourcePhrases, clientLocale)

local source = inputFile
dofile(inputFile)
local exportedPhrases = _G.L
local numExportedPhrases = table.count(exportedPhrases)
printf("  %s: Contains %d phrases", cyan(source), numExportedPhrases)

print()
local missingPhrases = {}
-- For enUS, these should always be the same; other locales will be absent from the source code itself
-- However, checking doesn't cost much and it might help detect desyncs once phrases can be imported
for englishPhrase, translation in pairs(englishPhrases) do
	assert(
		englishPhrase == translation,
		format("Inconsistent enUS localization entry (%s -> %s)", englishPhrase, translation)
	)
	local exportedPhrase = exportedPhrases[englishPhrase]
	if not exportedPhrase then
		table.insert(missingPhrases, formatDictionaryEntry(englishPhrase, translation))
	end
end

if #missingPhrases > 0 then
	printf(
		red("There are %s missing localization phrases! Someone should probably go and update them:"),
		#missingPhrases
	)
	print()
	print("  " .. table.concat(missingPhrases, "\n  "))
else
	printf(green("There are no missing localization phrases. Phew!"))
end

print()
local unusedPhrases = {}
for englishPhrase, translation in pairs(exportedPhrases) do
	-- The rawget avoids AceLocale metatable lookup errors in case of missing entries
	if not rawget(englishPhrases, englishPhrase) then
		table.insert(unusedPhrases, formatDictionaryEntry(englishPhrase, translation))
	end
end

if #unusedPhrases > 0 then
	printf(red("There are %s unused localization phrases! Someone should probably go and delete them:"), #unusedPhrases)
	print()
	print("  " .. table.concat(unusedPhrases, "\n  "))
else
	printf(green("There are no unused localization phrases. Phew!"))
end

print()
printf("Finished checking %d localization phrases (%s)", table.count(englishPhrases), clientLocale)

os.exit(#missingPhrases + #unusedPhrases)
