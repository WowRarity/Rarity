local BlizzardTOC = {}

function BlizzardTOC:DecodeFileContents(fileContents)
	local toc = {
		Files = {},
	}

	local lines = string.explode(fileContents, "\n")
	for _, line in ipairs(lines) do
		line = line:gsub("\r", "") -- Avoids crossplatform headaches (autoformat doesn't modify TOC files)
		toc["Title"] = toc["Title"] or line:match("^## Title: (.+)")
		toc["Author"] = toc["Author"] or line:match("^## Author: (.+)")
		toc["Interface"] = toc["Interface"] or line:match("^## Interface: ([%d,%s]+)")
		toc["X-Min-Interface"] = toc["X-Min-Interface"] or line:match("^## X%-Min%-Interface: ([%d,%s]+)")
		toc["X-Curse-Project-ID"] = toc["X-Curse-Project-ID"]
			or tonumber(line:match("^## X%-Curse%-Project%-ID: (%d+)"))
		toc["Dependencies"] = toc["Dependencies"] or line:match("^## Dependencies: (.+)")
		toc["X-Part-Of"] = toc["X-Part-Of"] or line:match("^## X%-%Part%-Of: (.+)")

		table.insert(toc.Files, line:match("^(.+%.lua)$"))
	end

	toc["Interface"] = toc["Interface"]:gsub(",", "")
	toc["Interface"] = string.explode(toc["Interface"], " ")
	for index, version in ipairs(toc["Interface"]) do
		toc["Interface"][index] = tonumber(version)
	end

	toc["X-Min-Interface"] = toc["X-Min-Interface"]:gsub(",", "")
	toc["X-Min-Interface"] = string.explode(toc["X-Min-Interface"], " ")
	for index, version in ipairs(toc["X-Min-Interface"]) do
		toc["X-Min-Interface"][index] = tonumber(version)
	end

	return toc
end

return BlizzardTOC
