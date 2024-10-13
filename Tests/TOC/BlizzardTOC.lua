local BlizzardTOC = {}

function BlizzardTOC:DecodeFileContents(fileContents)
	local toc = {}

	local lines = string.explode(fileContents, "\n")
	for _, line in ipairs(lines) do
		line = line:gsub("\r", "") -- Avoids crossplatform headaches (autoformat doesn't modify TOC files)
		toc["Title"] = toc["Title"] or line:match("^## Title: (.+)")
		toc["Author"] = toc["Author"] or line:match("^## Author: (.+)")
		toc["Interface"] = toc["Interface"] or tonumber(line:match("^## Interface: (%d+)"))
		toc["X-Min-Interface"] = toc["X-Min-Interface"] or tonumber(line:match("^## X%-Min%-Interface: (%d+)"))
		toc["X-Curse-Project-ID"] = toc["X-Curse-Project-ID"]
			or tonumber(line:match("^## X%-Curse%-Project%-ID: (%d+)"))
		toc["Dependencies"] = toc["Dependencies"] or line:match("^## Dependencies: (.+)")
		toc["X-Part-Of"] = toc["X-Part-Of"] or line:match("^## X%-%Part%-Of: (.+)")
	end

	return toc
end

return BlizzardTOC
