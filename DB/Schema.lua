local schema = {
	-- Specific fields for each item type
	PET = {
		spellId = true,
		creatureId = true
	},
	MOUNT = {
		spellId = true
	},
	ITEM = {
		-- TODO: Internally, the item type TOY doesn't exist...
		isToy = false
	},
	-- Fields that are valid for all types of items
	ANY = {
		-- index = true, -- always defaults to the displayed name, for now

		-- Required ItemDB fields
		name = true,
		cat = true,
		type = true,
		method = true,
		chance = true,
		itemId = true,
		--	arbitraryRequiredTestField = true,

		-- Optional ItemDB fields
		questId = false,
		groupSize = false,
		equalOdds = false,
		coords = false,
		sourceText = false,
		tooltipNpcs = false,
		tooltipModifier = false,
		statisticId = false,
		lockoutDetails = false,
		instanceDifficulties = false,
		unique = false,
		worldQuestId = false,
		-- Populated fields (SavedVariables)
		attempts = false,
		lastAttempts = false,
		realAttempts = false,
		enabled = false,
		dates = false,
		holidayTexture = false,
		known = false,
		finds = false,
		found = false,
		totalFinds = false,
		time = false,
		lastTime = false,
		items = false,
		excludedMaps = false,
		npcs = false,
		christmasOnly = false,
		requiresPool = false,
		creatureId = false,
		zones = false,
		repeatable = false,
		spellId = false,
		lockDungeonId = false,
		lockBossName = false,
		defeatSteps = false,
		bonusSatchel = false,
		wasGuaranteed = false,
		requiresAlliance = false,
		requiresHorde = false,
		worldBossFactionless = false,
		blackMarket = false,
		obtain = false,
		raceId = false,
		defeatAllQuests = false,
		announce = false,
		enableCoin = false,
		collectedItemId = false,
		doNotUpdateToHighestStat = false,
		disableForClass = false,
		holidayReminder = false,
		achievementId = false,
		showTooltipCondition = false
		-- TODO: These fields seem to be all over the place. They should adhere to the structure defined above for each item type... Sigh.
	}
}

-- TODO Should probably move this to the Database API, but that's for another time
Rarity.DatabaseSchema = schema