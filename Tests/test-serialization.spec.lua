local ssl = require("openssl")

local Serialization = loadfile("Core/Serialization.lua")("Rarity", {})

local testImportString =
	"AzFkA/8CalRhm6TZlHITUfiFqLhNpZ1iL+xG5SeiyjBSvynVUAkxHKGDEuqY6pzSQolaiipaTFTLEfRQQnpKsgzpOZGJqEpTEZlMlOmKi4iSZ4TrCGxEVLVZIg5T8hlV8liCaSjOo0pdQ+kyxWiJNB5R6SSq6htVp6m4h6pYiShaiyg1TmocJChnjCuBhBwkKEMu0U44KEPZLGmKZ4xLHAnRUOO4BjkURyxIICFHvvpnEYp89V8Rgbx91RphkG8VoiIs8tXbAqnI23f1iEe+gmEE0sjb9wWyyLuyP3KNvGsvRX7kvV4wyCnyffuKXCBf9u2RM8hX/wEeOYu8K9MCeUXelV2K3CPver3IG3kvy3rki7zXCwahGvmepQxCj7wrFYtQiry3BYNQgXypYBiEMshXa78IZZF33bMIrcjbr/YI9ci7VtEIbeQrGIYidJG3Z3cRoZG3X92IOPL2VVNEUOTddQUiBPKurF5EMMh36TYiWORLhT8iKvKuvgUiPPIVVFBENPL27DYGqlBqcQWDXGsNRWiIxhpLbjOQQxnOktuMDGWo4U00UPwkssiAMpwlt5lijrMTcAXjGm4klKFk1hgJJIRqSk/1ggRlzRiXOBLiGQxCNRWa/iBBjeMa5FDWjHGJIyEUg4FyXKKdcCCHcjhpLK5g+DolJU6BwDaOkUBCNMoYqBI7ASeDHIqzXANFtW7WQ7lmSu0yqBQpCmXNGJc4EkKhSu02R2bx5mlch5MZQpShJCNJjp0DCcqaMS5xJOQYKGeMyy9DqNbNegwGSnJ4cdYQEBoonuTz0yJ8GR7k8SBThxte/FyBHLKL+fCBkhM4Nhni3xj/Ag=="

local testItemEntry = {
	build = 718,
	items = {
		{
			attempts = 2,
			chance = 1000,
			dates = {
				[20221209] = {
					attempts = 74,
				},
				[20230211] = {
					attempts = 2,
					time = 1,
				},
			},
			enableAnnouncements = true,
			enabled = true,
			export = true,
			found = false,
			holidayReminder = true,
			import = false,
			instanceDifficulties = {
				[0] = true,
			},
			itemId = 200857,
			lastAttempts = 0,
			method = "NPC",
			name = "200857",
			npcs = {
				190115,
				190116,
				187600,
				196336,
				190983,
				187867,
				193443,
				187813,
				186511,
				186892,
				189734,
				191876,
				195187,
				190117,
				186483,
				186592,
				186109,
				189557,
				189734,
				191524,
				186239,
				189834,
				192344,
				190079,
				186915,
				187907,
				186638,
				193442,
				187599,
				187908,
				187602,
				188693,
				186509,
				199298,
				192371,
				186783,
				193232,
				187598,
			},
			repeatable = false,
			session = {
				attempts = 1,
			},
			time = 1,
			type = "ITEM",
		},
	},
	signature = "RFI2PD4jOjJ0NntgInc/ZA==",
}

describe("Serialization", function()
	describe("DecodeBase64", function()
		it("should return the original input if a valid Base64-encoded string was passed", function()
			local decodedItemString = Serialization:DecodeBase64(testImportString)
			assertEquals(decodedItemString, ssl.base64(testImportString, false))
		end)
	end)

	describe("EncodeBase64", function()
		it("should return the Base64-encoded representation of the input string", function()
			local encodedString = Serialization:EncodeBase64("Hello world!")
			assertEquals(encodedString, ssl.base64("Hello world!", true))
		end)
	end)

	describe("DeserializeItemString", function()
		it("should return a complete item entry if a valid import string was passed", function()
			local actualResult = Serialization:DeserializeItemString(testImportString)
			assertEquals(actualResult, testItemEntry)
		end)
	end)
end)
