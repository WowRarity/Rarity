local _, addonTable = ...

local Validation = {}

local L = addonTable.L

function Validation:ValidateItemDB()
	local DBH = Rarity.Utils.DatabaseMaintenanceHelper
	local ItemDB = self.db.profile.groups.items
	local PetDB = self.db.profile.groups.pets
	local MountDB = self.db.profile.groups.mounts
	local UserDB = self.db.profile.groups.user
	local DB = {ItemDB, PetDB, MountDB}

	self:Print(L["Verifying item database..."])

	local numErrors = 0

	for category, entry in pairs(DB) do
		for item, fields in pairs(entry) do
			if type(fields) == "table" then
				self:Debug(format(L["Verifying entry: %s ..."], item))
				local isEntryValid = DBH:VerifyEntry(fields)
				if not isEntryValid then -- Skip pseudo-groups... Another artifact that has to be worked around, I guess
					self:Print(format(L["Verification failed for entry: %s"], item))
					numErrors = numErrors + 1
				end
			end
		end
	end

	if numErrors == 0 then
		self:Print(L["Verification complete! Everything appears to be in order..."])
	else
		self:Print(format(L["Verfication failed with %d errors!"], numErrors))
	end
end

Rarity.Validation = Validation
return Validation
