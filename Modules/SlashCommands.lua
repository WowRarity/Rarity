local _, addonTable = ...

local R = Rarity

local AceConsole = LibStub("AceConsole-3.0")

local function ClearCacheHandler(input)
	R.TooltipCache:ClearAll()
	R:Print("Tooltip cache cleared.")
end

function R:SetupSlashCommands()
	AceConsole:RegisterChatCommand("rarity", {
		type = "group",
		name = "Rarity",
		args = {
			cache = {
				type = "group",
				name = "Cache",
				args = {
					clear = {
						type = "execute",
						name = "Clear",
						desc = "Clears the tooltip cache.",
						func = ClearCacheHandler,
					},
				},
			},
		},
	})
end
