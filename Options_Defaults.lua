local addonName, addonTable = ...

if not Rarity then
	return
end
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

local CONSTANTS = addonTable.constants

R.string_types = {
	[CONSTANTS.ITEM_TYPES.MOUNT] = L["Mount"],
	[CONSTANTS.ITEM_TYPES.PET] = L["Battle Pet"],
	[CONSTANTS.ITEM_TYPES.ITEM] = L["Toy or Item"],
}

R.string_methods = {
	[CONSTANTS.DETECTION_METHODS.NPC] = L["Drops from NPC(s)"],
	[CONSTANTS.DETECTION_METHODS.BOSS] = L["Drops from a boss requiring a group"],
	[CONSTANTS.DETECTION_METHODS.ZONE] = L["Drops from any mob in a zone"],
	[CONSTANTS.DETECTION_METHODS.USE] = L["Obtained by using an item or opening a container"],
	[CONSTANTS.DETECTION_METHODS.FISHING] = L["Obtained by fishing"],
	[CONSTANTS.DETECTION_METHODS.ARCH] = L["Obtained as an archaeology project"],
	[CONSTANTS.DETECTION_METHODS.SPECIAL] = L["Special case"],
	[CONSTANTS.DETECTION_METHODS.MINING] = L["Obtained by mining"],
	[CONSTANTS.DETECTION_METHODS.COLLECTION] = L["Obtained by collecting a number of items"],
}

-- Archaeology races
R.string_archraces = {
	[CONSTANTS.ARCHAEOLOGY_RACES.DRUST] = L["Drust"],
	[CONSTANTS.ARCHAEOLOGY_RACES.ZANDALARI] = L["Zandalari"],
	[CONSTANTS.ARCHAEOLOGY_RACES.DEMONIC] = L["Demonic"],
	[CONSTANTS.ARCHAEOLOGY_RACES.HIGHMOUNTAIN_TAUREN] = L["Highmountain Tauren"],
	[CONSTANTS.ARCHAEOLOGY_RACES.HIGHBORNE] = L["Highborne"],
	[CONSTANTS.ARCHAEOLOGY_RACES.OGRE] = L["Ogre"],
	[CONSTANTS.ARCHAEOLOGY_RACES.DRAENOR_CLANS] = L["Draenor Clans"],
	[CONSTANTS.ARCHAEOLOGY_RACES.ARAKKOA] = L["Arakkoa"],
	[CONSTANTS.ARCHAEOLOGY_RACES.MOGU] = L["Mogu"],
	[CONSTANTS.ARCHAEOLOGY_RACES.PANDAREN] = L["Pandaren"],
	[CONSTANTS.ARCHAEOLOGY_RACES.MANTID] = L["Mantid"],
	[CONSTANTS.ARCHAEOLOGY_RACES.VRYKUL] = L["Vrykul"],
	[CONSTANTS.ARCHAEOLOGY_RACES.TROLL] = L["Troll"],
	[CONSTANTS.ARCHAEOLOGY_RACES.TOL_VIR] = L["Tol'vir"],
	[CONSTANTS.ARCHAEOLOGY_RACES.ORC] = L["Orc"],
	[CONSTANTS.ARCHAEOLOGY_RACES.NERUBIAN] = L["Nerubian"],
	[CONSTANTS.ARCHAEOLOGY_RACES.NIGHT_ELF] = L["Night Elf"],
	[CONSTANTS.ARCHAEOLOGY_RACES.FOSSIL] = L["Fossil"],
	[CONSTANTS.ARCHAEOLOGY_RACES.DRAENEI] = L["Draenei"],
	[CONSTANTS.ARCHAEOLOGY_RACES.DWARF] = L["Dwarf"],
}

-- Categories
R.catIcons = {
	[CONSTANTS.ITEM_CATEGORIES.HOLIDAY] = "holiday",
	[CONSTANTS.ITEM_CATEGORIES.CLASSIC] = "classic",
	[CONSTANTS.ITEM_CATEGORIES.TBC] = "bc",
	[CONSTANTS.ITEM_CATEGORIES.WOTLK] = "wotlk",
	[CONSTANTS.ITEM_CATEGORIES.CATA] = "cata",
	[CONSTANTS.ITEM_CATEGORIES.MOP] = "mop",
	[CONSTANTS.ITEM_CATEGORIES.WOD] = "wod",
	[CONSTANTS.ITEM_CATEGORIES.LEGION] = "legion",
	[CONSTANTS.ITEM_CATEGORIES.BFA] = "bfa",
	[CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS] = "shadowlands",
}

function R:PrepareDefaults()
	self.defaults = {
		profile = {
			minimap = { hide = false },

			enableAnnouncements = true,
			feedText = CONSTANTS.LDB_TEXT_STYLES.FEED_NORMAL,
			statusTip = CONSTANTS.TOOLTIP_POSITIONS.TIP_LEFT,
			tooltipActivation = CONSTANTS.TOOLTIP.ACTIVATION_METHOD_HOVER,
			sortMode = CONSTANTS.SORT_METHODS.SORT_CATEGORY,
			hideHighChance = false,
			enableTooltipAdditions = true,
			blankLineBeforeTooltipAdditions = true,
			tooltipAttempts = true,
			hideKnownItemsInTooltip = false,
			takeScreenshot = true,
			hideUnavailable = true,
			hideDefeated = false,
			showTimeColumn = true,
			showLuckinessColumn = true,
			showZoneColumn = true,
			showTSMColumn = true,
			holidayReminder = true,
			showCategoryIcons = true,
			tooltipScale = GameTooltip:GetScale(),
			enableProfiling = false,
			tooltipHideDelay = 0.6,
			onlyAnnounceFound = false,
			onlyShowItemsWithAttempts = false,
			blankLineAfterRarity = false,
			hideOutsideZone = false,
			showAchievementToast = true,
			tooltipShowDelay = 0.1,

			trackedGroup = "pets",
			trackedItem = 8494,
			bar = {
				point = "TOPLEFT",
				relativePoint = "TOPLEFT",
				x = 100,
				y = -100,
				width = 150,
				height = 12,
				scale = 1.0,
				visible = false,
				anchor = true,
				locked = false,
				texture = nil,
				font = nil,
				fontSize = 8,
				growUp = false,
				rightAligned = false,
				showIcon = true,
				showText = true,
			},
			cats = {
				[CONSTANTS.ITEM_CATEGORIES.CLASSIC] = true,
				[CONSTANTS.ITEM_CATEGORIES.TBC] = true,
				[CONSTANTS.ITEM_CATEGORIES.WOTLK] = true,
				[CONSTANTS.ITEM_CATEGORIES.CATA] = true,
				[CONSTANTS.ITEM_CATEGORIES.MOP] = true,
				[CONSTANTS.ITEM_CATEGORIES.WOD] = true,
				[CONSTANTS.ITEM_CATEGORIES.LEGION] = true,
				[CONSTANTS.ITEM_CATEGORIES.HOLIDAY] = true,
				[CONSTANTS.ITEM_CATEGORIES.BFA] = true,
				[CONSTANTS.ITEM_CATEGORIES.SHADOWLANDS] = true,
			},
			collectionType = {
				[CONSTANTS.ITEM_TYPES.MOUNT] = true,
				[CONSTANTS.ITEM_TYPES.PET] = true,
				[CONSTANTS.ITEM_TYPES.ITEM] = true,
			},
			-- These are achievements with the names of rare NPCs as criteria to kill
			achNpcs = {
				-- Burning Crusade
				1312, -- Bloody Rare

				-- Wrath of the Lich King
				2257, -- Frostbitten

				-- Mists of Pandaria
				7439, -- Glorious!

				-- Warlords of Draenor
				9400, -- Gorgrond Monster Hunter
				10070, -- Jungle Stalker

				-- Legion
				11261, -- Adventurer of Azsuna
				11264, -- Adventurer of Highmountain
				11263, -- Adventurer of Stormheim
				11265, -- Adventurer of Suramar
				11262, -- Adventurer of Val'sharah
				12078, -- Adventurer of Argus > Commander of Argus

				-- Battle for Azeroth
				12939, -- Adventurer of Tiragarde Sound
				12940, -- Adventurer of Stormsong Valley
				12941, -- Adventurer of Drustvar
				12942, -- Adventurer of Nazmir
				12943, -- Adventurer of Vol'dun
				12944, -- Adventurer of Zuldazar
				13691, -- I Thought You Said They'd Be Rare? (Nazjatar)
				13470, -- Rest In Pistons (Mechagon)

				-- Shadowlands
				14307, -- Adventurer of Bastion
				14308, -- Adventurer of Maldraxxus
				14309, -- Adventurer of Ardenweald
				14310, -- Adventurer of Revendreth
				14744, -- Better to Be Lucky Than Dead (The Maw)

			},
			-- These are inventory items that may result in another CONSTANTS.ITEM_TYPES.ITEM that Rarity would like to make you aware of
			extraTooltips = {
				inventoryItems = {
					[94295] = { 94292, 94293, 94291 }, -- Primal Egg: Reins of the Black Primal Raptor, Reins of the Green Primal Raptor, Reins of the Red Primal Raptor
					[94288] = { 94290 }, -- Giant Dinosaur Bone: Reins of the Bone-White Primal Raptor
					[86547] = { 90655 }, -- Skyshard: Reins of the Thundering Ruby Cloud Serpent
					[86546] = { 90655 }, -- Sky Crystal: Reins of the Thundering Ruby Cloud Serpent
					[128025] = { 116658, 116669, 116780 }, -- Rattling Iron Cage: Tundra Icehoof, Armored Razorback, Warsong Direfang
					[53190] = { 152840, 152841, 152842, 152843, 153054, 153055 }, -- Fel-Spotted Egg: Scintillating Mana Ray, Felglow Mana Ray, Vibrant Mana Ray, Darkspore Mana Ray,  Docile Skyfin, Fel-Afflicted Skyfin

					-- [6948] = { 6948, }, -- Hearthstone: Hearthstone [this is for testing extraTooltips]
				},
			},
			-- These are items with a 100% drop rate from various mobs; many of them only drop the first time and include a tracking quest
			oneTimeItems = {
				-- [NPCID] = { questId = QUESTID, itemId = ITEMID }, -- CONSTANTS.DETECTION_METHODS.NPC Name

				-- Test CONSTANTS.ITEM_TYPES.ITEM(s)
				-- [65432] = { questId = 0--[[31676]], itemId = 102248   }, -- Kyparite Pulverizer (in The Dread Wastes)
				---------------------------------------------------------------------------------------
				-- WRATH OF THE LICH KING
				---------------------------------------------------------------------------------------
				[32491] = { itemId = 44168 }, -- Time-Lost Proto-Drake (Reins of the Time-Lost Proto-Drake, The Storm Peaks)
				---------------------------------------------------------------------------------------
				-- CATACLYSM
				---------------------------------------------------------------------------------------
				[50062] = { itemId = 63042 }, -- Aeonaxx (Reins of the Phosphorescent Stone Drake, Deepholm)
				[51236] = { itemId = 63042 }, -- Aeonaxx (Reins of the Phosphorescent Stone Drake, Deepholm)
				[50005] = { itemId = 67151 }, -- Poseidus (Reins of Poseidus, Shimmering Expanse)
				---------------------------------------------------------------------------------------
				-- MISTS OF PANDARIA
				---------------------------------------------------------------------------------------
				[64403] = { itemId = 90655 }, -- Alani <The Stormborn> (Reins of the Thundering Ruby Cloud Serpent, Vale of Eternal Blossoms)
				[59369] = { itemId = 88566 }, -- Doctor Theolen Krastinov <The Butcher> (Krastinov's Bag of Horrors, Scholomance)
				---------------------------------------------------------------------------------------
				-- WARLORDS OF DRAENOR
				---------------------------------------------------------------------------------------
				-- MOUNTS
				[50990] = { itemId = 116659 }, -- Bloodhoof Bull (Nakk the Thunderer, Nagrand)
				[50992] = { itemId = 116674 }, -- Great Greytusk (Gorok, Frostfire Ridge)
				[50981] = { itemId = 116661 }, -- Mottled Meadowstomper (Luk'hok, Nagrand)
				[51015] = { itemId = 116767 }, -- Sapphire Riverbeast (Silthide, Talador)
				[50985] = { itemId = 116792 }, -- Sunhide Gronnling (Poundfist, Gorgrond)
				[50883] = { itemId = 116773 }, -- Swift Breezestrider (Pathrunner, Shadowmoon Valley)
				-- REP ITEMS
				-- Nagrand
				[86774] = { itemId = 118654 }, -- Aogexon
				[86732] = { itemId = 118655 }, -- Bergruu
				[86743] = { itemId = 118656 }, -- Dekorhan
				[87650] = { itemId = 118657 }, -- Direhoof
				[86771] = { itemId = 118658 }, -- Gagrog the Brutal
				[87667] = { itemId = 118659 }, -- Mu'gra
				[86750] = { itemId = 118660 }, -- Thek'talon
				[86835] = { itemId = 118661 }, -- Xelganak
				[88951] = { itemId = 120172 }, -- Vileclaw
				-- OTHER ITEMS
				-- Frostfire Ridge
				[84378] = { questId = 37525, itemId = 119365 }, -- Ak'ox the Slaughterer
				[78867] = { questId = 34497, itemId = 111476 }, -- Breathless
				[74613] = { questId = 33843, itemId = 111533 }, -- Broodmother Reeg'ak
				[71721] = { questId = 32941, itemId = 101436 }, -- Canyon Icemother
				[80242] = { questId = 34843, itemId = 111953 }, -- Chillfang
				[72294] = { questId = 33014, itemId = 111490 }, -- Cindermaw
				[77513] = { questId = 34129, itemId = 112066 }, -- Coldstomp the Griever
				[76914] = { questId = 34131, itemId = 111484 }, -- Coldtusk
				[78621] = { questId = 34477, itemId = 112086 }, -- Cyclonic Fury
				[74971] = { questId = 33504, itemId = 107661 }, -- Firefury Giant
				[71665] = { questId = 32918, itemId = 111530 }, -- Giant-Slayer Kul
				[74585] = { questId = 33011, itemId = 106899 }, -- Grizzled Frostwolf Veteran
				[80312] = { questId = 34865, itemId = 112077 }, -- Grutush the Pillager
				[80190] = { questId = 34825, itemId = 111948 }, -- Gruuk
				[80235] = { questId = 34839, itemId = 111955 }, -- Gurun
				[87348] = { questId = 37382, itemId = 119415 }, -- Hoarfrost
				[82616] = { questId = 37386, itemId = 119390 }, -- Jabberjaw
				[79678] = { questId = 34708, itemId = 112078 }, -- Jehil the Climber
				[84374] = { questId = 37404, itemId = 119372 }, -- Kaga the Ironbender
				[78872] = { questId = 34498, itemId = 116125 }, -- Klikixx
				[87622] = { questId = 37402, itemId = 119366 }, -- Ogom the Mangler
				[78606] = { questId = 34470, itemId = 111666 }, -- Pale Fishmonger
				[76918] = { questId = 33938, itemId = 111576 }, -- Primalist Mur'og
				[84392] = { questId = 37401, itemId = 119359 }, -- Ragore Driftstalker
				[77526] = { questId = 34132, itemId = 112094 }, -- Scout Goreseeker
				[82620] = { questId = 37383, itemId = 119399 }, -- Son of Goramal
				[77527] = { questId = 34133, itemId = 111475 }, -- The Beater
				[78265] = { questId = 34361, itemId = 111534 }, -- The Bone Crawler
				[82618] = { questId = 37384, itemId = 119379 }, -- Tor'goroth
				[87357] = { questId = 37378, itemId = 119416 }, -- Valkor
				[87356] = { questId = 37379, itemId = 119416 }, -- Vrok the Ancient
				[79145] = { questId = 34559, itemId = 111477 }, -- Yaga the Scarred
				-- Gorgrond
				[82085] = { questId = 35335, itemId = 118222 }, -- Bashiok
				[86257] = { questId = 37369, itemId = 119432 }, -- Basten
				[85907] = { questId = 36597, itemId = 118232 }, -- Berthora
				[82311] = { questId = 35503, itemId = 118212 }, -- Char the Burning
				[85250] = { questId = 36387, itemId = 118221 }, -- Fossilwood the Petrified
				[81038] = { questId = 36391, itemId = 118230 }, -- Gelgor of the Blue Flame
				[80868] = { questId = 36204, itemId = 118229 }, -- Glut
				[84431] = { questId = 36186, itemId = 118210 }, -- Greldrok the Cunning
				[88583] = { questId = 37375, itemId = 119414 }, -- Grove Warden Yal
				[83522] = { questId = 35908, itemId = 118209 }, -- Hive Queen Skrikka
				[88672] = { questId = 37377, itemId = 119412 }, -- Hunter Bal'ra
				[84406] = { questId = 36178, itemId = 118709 }, -- Mandrakor
				[76473] = { questId = 34726, itemId = 118208 }, -- Mother Araneae
				[85970] = { questId = 36600, itemId = 118231 }, -- Riptar
				[85264] = { questId = 36393, itemId = 118211 }, -- Rolkor
				[86520] = { questId = 36837, itemId = 118228 }, -- Stompalupagus
				[79629] = { questId = 35910, itemId = 118224 }, -- Stomper Kreego
				[80725] = { questId = 36394, itemId = 114227 }, -- Sulfurious
				[86137] = { questId = 36656, itemId = 118223 }, -- Sunclaw
				[88582] = { questId = 37374, itemId = 119367 }, -- Swift Onyx Flayer
				[86410] = { questId = 36794, itemId = 118213 }, -- Sylldross
				-- Nagrand
				[82899] = { questId = 35778, itemId = 116832 }, -- Ancient Blademaster
				[82826] = { questId = 35735, itemId = 116823 }, -- Berserk T-300 Series Mark II
				[87234] = { questId = 37400, itemId = 119380 }, -- Brutag Grimblade
				[79725] = { questId = 34727, itemId = 118244 }, -- Captain Ironbeard
				[87788] = { questId = 37395, itemId = 119405 }, -- Durg Spinecrusher
				[82486] = { questId = 35623, itemId = 118679 }, -- Explorer Nozzand
				[82975] = { questId = 35836, itemId = 116836 }, -- Fangler
				[83483] = { questId = 35893, itemId = 116807 }, -- Flinthide
				[82764] = { questId = 35715, itemId = 118246 }, -- Gar'lua
				[80122] = { questId = 34725, itemId = 116798 }, -- Gaz'orda
				[82778] = { questId = 35717, itemId = 116824 }, -- Gnarlhoof the Rabid
				[83509] = { questId = 35898, itemId = 116916 }, -- Gorepetal
				[84263] = { questId = 36159, itemId = 118689 }, -- Graveltooth
				[82758] = { questId = 35714, itemId = 116795 }, -- Greatfeather
				[82912] = { questId = 35784, itemId = 118687 }, -- Grizzlemaw
				[83603] = { questId = 35923, itemId = 118245 }, -- Hunter Blacktooth
				[78161] = { questId = 34862, itemId = 116799 }, -- Hyperious
				[86959] = { questId = 37399, itemId = 119355 }, -- Karosh Blackwind
				[83643] = { questId = 35932, itemId = 116796 }, -- Malroc Stonesunder
				[84435] = { questId = 36229, itemId = 118690 }, -- Mr. Pinchy Sr.
				[83401] = { questId = 35865, itemId = 116815 }, -- Netherspawn
				[83409] = { questId = 35875, itemId = 116765 }, -- Ophiis
				[83680] = { questId = 35943, itemId = 116800 }, -- Outrider Duretha
				[88208] = { questId = 37637, itemId = 120317 }, -- Pit Beast
				[82755] = { questId = 35712, itemId = 118243 }, -- Redclaw the Feral
				[83526] = { questId = 35900, itemId = 118688 }, -- Ru'klaa
				[83634] = { questId = 35931, itemId = 116797 }, -- Scout Pokhar
				[83542] = { questId = 35912, itemId = 116834 }, -- Sean Whitesea
				[80057] = { questId = 36128, itemId = 116806 }, -- Soulfang
				[83591] = { questId = 35920, itemId = 116814 }, -- Tura'aka
				[81330] = { questId = 37546, itemId = 120276 }, -- Warleader Tome
				[79024] = { questId = 34645, itemId = 116805 }, -- Warmaster Blugthol
				[83428] = { questId = 35877, itemId = 116808 }, -- Windcaller Korast
				-- Shadowmoon Valley
				[77140] = { questId = 33061, itemId = 109060 }, -- Amaukwa
				[86213] = { questId = 37356, itemId = 119387 }, -- Aqualir
				[85568] = { questId = 37410, itemId = 119400 }, -- Avalanche
				[82326] = { questId = 35731, itemId = 113540 }, -- Ba'ruun
				[81406] = { questId = 35281, itemId = 111666 }, -- Bahameye
				[81639] = { questId = 33383, itemId = 117551 }, -- Brambleking Fili
				[77085] = { questId = 33064, itemId = 109075 }, -- Dark Emanation
				[82268] = { questId = 35448, itemId = 113548 }, -- Darkmaster Go'vid
				[82411] = { questId = 35555, itemId = 113541 }, -- Darktalon
				[84911] = { questId = 37351, itemId = 119377 }, -- Demidos
				[82676] = { questId = 35688, itemId = 113556 }, -- Enavra Varandi
				[82207] = { questId = 35725, itemId = 113557 }, -- Faebright
				[76380] = { questId = 33664, itemId = 113082 }, -- Gorum
				[79524] = { questId = 35558, itemId = 113631 }, -- Hypnocroak
				[83553] = { questId = 35909, itemId = 113571 }, -- Insha'tar
				[74206] = { questId = 33043, itemId = 109078 }, -- Killmaw
				[72362] = { questId = 33039, itemId = 109061 }, -- Ku'targ the Voidseer
				[85121] = { questId = 37355, itemId = 119360 }, -- Lady Temptessa
				[72537] = { questId = 33055, itemId = 108907 }, -- Leaf-Reader Kurri
				[77310] = { questId = 35906, itemId = 113561 }, -- Mad "King" Sporeon
				[85451] = { questId = 37357, itemId = 119369 }, -- Malgosh Shadowkeeper
				[85001] = { questId = 37353, itemId = 119368 }, -- Master Sergeant Milgra
				[82362] = { questId = 35523, itemId = 113559 }, -- Morva Soultwister
				[75071] = { questId = 33642, itemId = 113527 }, -- Mother Om'ra
				[84925] = { questId = 37352, itemId = 119382 }, -- Quartermaster Hershak
				[82374] = { questId = 35553, itemId = 113542 }, -- Rai'vosh
				[72606] = { questId = 34068, itemId = 109077 }, -- Rockhoof
				[85029] = { questId = 37354, itemId = 119396 }, -- Shadowspeaker Niir
				[82415] = { questId = 35732, itemId = 113543 }, -- Shinri
				[86689] = { questId = 36880, itemId = 118734 }, -- Sneevel
				[85026] = { questId = 37358, itemId = 119178 }, -- Soul-Twister Torek
				[75482] = { questId = 33640, itemId = 108906 }, -- Veloss
				[75492] = { questId = 33643, itemId = 108957 }, -- Venomshade
				[85078] = { questId = 37359, itemId = 119392 }, -- Voidreaver Urnae
				[83385] = { questId = 35847, itemId = 109074 }, -- Voidseer Kalurg
				[75434] = { questId = 33038, itemId = 113553 }, -- Windfang Matriarch
				[75435] = { questId = 33389, itemId = 113570 }, -- Yggdrel
				-- Spires of Arak
				[84887] = { questId = 36291, itemId = 116907 }, -- Betsi Boombasket
				[80614] = { questId = 35599, itemId = 116839 }, -- Blade-Dancer Aeryx
				[84856] = { questId = 36283, itemId = 118205 }, -- Blightglow
				[84807] = { questId = 36267, itemId = 118198 }, -- Durkath Steelmaw
				[84890] = { questId = 36297, itemId = 118200 }, -- Festerbloom
				[86978] = { questId = 36943, itemId = 118696 }, -- Gaze
				[84951] = { questId = 36305, itemId = 116836 }, -- Gobblefin
				[86724] = { questId = 36887, itemId = 118279 }, -- Hermit Palefur
				[84955] = { questId = 36306, itemId = 118202 }, -- Jiasska the Sporegorger
				[84810] = { questId = 36268, itemId = 118735 }, -- Kalos the Bloodbathed
				[84417] = { questId = 36396, itemId = 118206 }, -- Mutafen
				[82247] = { questId = 36129, itemId = 116837 }, -- Nas Dunberlin
				[84872] = { questId = 36288, itemId = 118204 }, -- Oskiira the Vengeful
				[84838] = { questId = 36279, itemId = 118199 }, -- Poisonmaster Bortusk
				[85504] = { questId = 36470, itemId = 118107 }, -- Rotcap
				[84833] = { questId = 36276, itemId = 118203 }, -- Sangrikass
				[79938] = { questId = 36478, itemId = 118201 }, -- Shadowbark
				[84805] = { questId = 36265, itemId = 116858 }, -- Stonespite
				[84912] = { questId = 36298, itemId = 116855 }, -- Sunderthorn
				[85520] = { questId = 36472, itemId = 116857 }, -- Swarmleaf
				[84836] = { questId = 36278, itemId = 116838 }, -- Talonbreaker
				[84775] = { questId = 36254, itemId = 116852 }, -- Tesska the Broken
				[82050] = { questId = 35334, itemId = 118207 }, -- Varasha
				-- Talador
				[88072] = { questId = 37343, itemId = 119371 }, -- Archmagus Tekar <Sargerei War Council>
				[88043] = { questId = 37338, itemId = 119378 }, -- Avatar of Socrethar
				[77620] = { questId = 34165, itemId = 116123 }, -- Cro Fleshrender
				[77561] = { questId = 34142, itemId = 112499 }, -- Dr. Gloom
				[77795] = { questId = 34221, itemId = 113670 }, -- Echo of Murmur
				[80204] = { questId = 35018, itemId = 112373 }, -- Felbark
				[82992] = { questId = 37341, itemId = 119386 }, -- Felfire Consort
				[77614] = { questId = 34145, itemId = 113288 }, -- Frenzied Golem
				[78713] = { questId = 34483, itemId = 116122 }, -- Galzomar
				[80471] = { questId = 34929, itemId = 116075 }, -- Gennadian
				[77719] = { questId = 34189, itemId = 116113 }, -- Glimmerwing
				[85572] = { questId = 36919, itemId = 120436 }, -- Grrbrrgle
				[83019] = { questId = 37340, itemId = 119402 }, -- Gug'tol
				[83008] = { questId = 37312, itemId = 119403 }, -- Haakun the All-Consuming
				[77715] = { questId = 34185, itemId = 116124 }, -- Hammertooth
				[77626] = { questId = 34167, itemId = 112369 }, -- Hen-Mother Hami
				[77453] = { questId = 34134, itemId = 117563 }, -- Isaari
				[78710] = { questId = 35219, itemId = 116122 }, -- Kharazos the Triumphant
				[88494] = { questId = 37342, itemId = 119385 }, -- Legion Vanguard
				[77784] = { questId = 34208, itemId = 116070 }, -- Lo'marg Jawcrusher
				[82998] = { questId = 37349, itemId = 119353 }, -- Matron of Sin
				[79334] = { questId = 34859, itemId = 116077 }, -- No'losh
				[77741] = { questId = 34196, itemId = 116112 }, -- Ra'kahn
				[79543] = { questId = 34671, itemId = 112370 }, -- Shirzir
				[78715] = { questId = 35219, itemId = 116122 }, -- Sikthiss, Maiden of Slaughter
				[88083] = { questId = 37343, itemId = 119350 }, -- Soulbinder Naylana <Sargerei War Council>
				[86549] = { questId = 36858, itemId = 117562 }, -- Steeltusk
				[88071] = { questId = 37337, itemId = 119350 }, -- Strategist Ankor <Sargerei War Council>
				[77634] = { questId = 34171, itemId = 116126 }, -- Taladorantula
				[79485] = { questId = 34668, itemId = 116110 }, -- Talonpriest Zorkra
				[80524] = { questId = 34945, itemId = 112475 }, -- Underseer Bloodmane
				[77564] = { questId = 34148, itemId = 112371 }, -- Viperlash
				[77776] = { questId = 34205, itemId = 112261 }, -- Wandering Vindicator
				[82922] = { questId = 37343, itemId = 119435 }, -- Xothear, the Destroyer
				[77529] = { questId = 34135, itemId = 112263 }, -- Yazheera the Incinerator
				-- Tanaan Jungle (Hellbane achievement)
				[95053] = { questId = 39287, itemId = 128315 }, -- Deathtalon <Avatar of Iskar>
				[95056] = { questId = 39289, itemId = 128315 }, -- Doomroller <Mar'tak's Creation>
				[95044] = { questId = 39288, itemId = 128315 }, -- Terrorfist <Son of Kormrok>
				[95054] = { questId = 39290, itemId = 128315 }, -- Vengeance <Avatar of Velhari>
				-- Tanaan Jungle (Jungle Stalker achievement)
				[91871] = { questId = 38430, itemId = 127326 }, -- Argosh the Destroyer
				[92552] = { questId = 38609, itemId = 127650 }, -- Belgork <Grom'kar Strikeleader>
				[90884] = { questId = 38262, itemId = 127307 }, -- Bilkor the Thrower <Bleeding Hollow Spearmaster>
				[92657] = { questId = 38696, itemId = 127654 }, -- Bleeding Hollow Horror
				[90936] = { questId = 38266, itemId = 127303 }, -- Bloodhunter Zulk <Bleeding Hollow Assassin>
				[91093] = { questId = 38209, itemId = 127652 }, -- Bramblefell
				[92429] = { questId = 38589, itemId = 127349 }, -- Broodlord Ixkor
				[93264] = { questId = 38820, itemId = 127664 }, -- Captain Grok'mar
				[93076] = { questId = 38756, itemId = 127659 }, -- Captain Ironbeard <The True Scourge of the Iron Seas>
				[90519] = { questId = 37990, itemId = 127660 }, -- Cindral the Wildfire
				[91232] = { questId = 38746, itemId = 127319 }, -- Commander Krag'goth
				[89675] = { questId = 38749, itemId = 127313 }, -- Commander Org'mok
				[90887] = { questId = 38265, itemId = 127301 }, -- Dorg the Bloody <Bleeding Hollow Aberration>
				[93028] = { questId = 38736, itemId = 127331 }, -- Driss Vile <Iron Horde Master Sniper>
				[90888] = { questId = 38264, itemId = 127298 }, -- Drivnul <Master of Rituals>
				[91727] = { questId = 38411, itemId = 127323 }, -- Executor Riloth
				[93168] = { questId = 38775, itemId = 127350 }, -- Felbore
				[92647] = { questId = 38634, itemId = 127302 }, -- Felsmith Damorka
				[91098] = { questId = 38211, itemId = 127656 }, -- Felspark
				[92508] = { questId = 38604, itemId = 127306 }, -- Gloomtalon <Clawshaper of the Blackfang>
				[93125] = { questId = 38764, itemId = 127317 }, -- Glub'glok
				[92941] = { questId = 38709, itemId = 127304 }, -- Gorabosh <Keeper of the Cave>
				[91695] = { questId = 38400, itemId = 127299 }, -- Grand Warlock Nethekurse
				[93057] = { questId = 38750, itemId = 127649 }, -- Grannok
				[90094] = { questId = 39046, itemId = 127309 }, -- Harbormaster Korak
				[90777] = { questId = 38028, itemId = 122117 }, -- High Priest Ikzan <Shadow Council>
				[90429] = { questId = 38026, itemId = 127655 }, -- Imp-Master Valessa
				[90437] = { questId = 38030, itemId = 127322 }, -- Jax'zor
				[92517] = { questId = 38605, itemId = 127418 }, -- Krell the Serene <Blademaster of the Blackfang>
				[93279] = { questId = 38825, itemId = 127653 }, -- Kris'kar the Unredeemed <Crusader of Rukhmar>
				[90438] = { questId = 38029, itemId = 127316 }, -- Lady Oran
				[93002] = { questId = 38726, itemId = 127332 }, -- Magwia
				[90442] = { questId = 38032, itemId = 127300 }, -- Mistress Thavra
				[92411] = { questId = 38580, itemId = 127320 }, -- Overlord Ma'gruth <Shadow Council>
				[92274] = { questId = 38557, itemId = 127297 }, -- Painmistress Selora
				[91374] = { questId = 38609, itemId = 127336 }, -- Podlord Wakkawam
				[91009] = { questId = 38457, itemId = 127657 }, -- Putre'thar
				[90782] = { questId = 38034, itemId = 127661 }, -- Rasthe <Son of Sethe>
				[92197] = { questId = 38496, itemId = 127335 }, -- Relgor <Bleeding Hollow Master Scout>
				[91227] = { questId = 39159, itemId = 127666 }, -- Remnant of the Blood Moon
				[92627] = { questId = 38631, itemId = 127356 }, -- Rendrak <Direwing Alpha>
				[90885] = { questId = 38263, itemId = 127314 }, -- Rogond the Tracker <Bleeding Hollow Huntmaster>
				[90024] = { questId = 37953, itemId = 127318 }, -- Sergeant Mor'grak
				[93236] = { questId = 38812, itemId = 127665 }, -- Shadowthrash
				[92495] = { questId = 38600, itemId = 127315 }, -- Soulslicer <Corrupted Shaman>
				[92887] = { questId = 38700, itemId = 127357 }, -- Steelsnout
				[92606] = { questId = 38628, itemId = 127311 }, -- Sylissa <Marshwater Queen>
				[93001] = { questId = 38752, itemId = 127296 }, -- Szirek the Twisted
				[92465] = { questId = 38597, itemId = 127330 }, -- The Blackfang <Warboss of the Blackfang>
				[92694] = { questId = 38654, itemId = 127305 }, -- The Goreclaw
				[92977] = { questId = 38751, itemId = 127321 }, -- The Iron Houndmaster
				[92636] = { questId = 38632, itemId = 127355 }, -- The Night Haunter
				[92645] = { questId = 38632, itemId = 127355 }, -- The Night Haunter (pre-challenge version)
				[91243] = { questId = 38747, itemId = 127310 }, -- Tho'gar Gorefist
				[92574] = { questId = 38620, itemId = 127327 }, -- Thromma the Gutslicer
				[92451] = { questId = 37937, itemId = 127351 }, -- Varyx the Damned
				[92408] = { questId = 38579, itemId = 127658 }, -- Xanzith the Everlasting
				[91087] = { questId = 38207, itemId = 127340 }, -- Zeter'el
				[90122] = { questId = 39045, itemId = 127308 }, -- Zoug the Heavy
			},
			-- For instanceDifficulties, see: http://wowprogramming.com/docs/api/GetInstanceInfo
			groups = {
				mounts = Rarity.ItemDB.mounts,
				pets = Rarity.ItemDB.pets,
				items = Rarity.ItemDB.toys,
				user = {
					name = L["Custom"],
					-- ["Test 1"] =      { type = CONSTANTS.ITEM_TYPES.PET, method = CONSTANTS.DETECTION_METHODS.NPC, name = "Test 1", spellId = 10682, itemId = 25467, npcs = { 16520, 16516 }, chance = 100,  },
				},
			}, -- groups
		}, -- profile
	} -- self.defaults

	self.PrepareDefaults = nil -- Why?
end

--[[

   NEW EXPANSION PACK
   TO-DO LIST CHEAT SHEET

			Items:
			**- Reevaluate group sizes for all items (items from 2 expansions ago become soloable; items from last expansion become groups of 3)
			**- New mounts
			**- Guaranteed mounts from bosses convert to non-guaranteed (don't forget to set wasGuaranteed = true)
			- New pets
			- New toys
			**- Toy conversions
			**- New rare killing achievements (under the Exploration achievement tab, like: http://www.wowhead.com/achievements/character-achievements/exploration/15257-legion)
			- New 100% drop items

			Nodes and zones:
			**- CONSTANTS.DETECTION_METHODS.FISHING nodes (GatherMate2/Constants.lua)
			**- CONSTANTS.DETECTION_METHODS.MINING nodes
			XX- NO LONGER: New zones for Sea Turtle (http://wowpedia.org/MapID) (they stopped putting it in new expansions starting with Warlords of Draenor)

			APIs:
			**- Check if CONSTANTS.DETECTION_METHODS.NPC ID format changed
			**- Check if instance difficulty API or IDs changed
			**- Check if COMBAT_LOG_EVENT_UNFILTERED changed
			**- Check for other API changes (i.e. http://wowpedia.org/Patch_6.0.1/API_changes)

			Other:
			**- Good-luck coins
			**- New Archaeology races: /run for race_id = 1, GetNumArchaeologyRaces() do Rarity:Print("race_id: "..race_id.." | "..GetArchaeologyRaceInfo(race_id)) end
			**- Add a new category icon for the expansion
			**- If a new class was added, add it to the list at the top of Options.lua in the Options module

]] --
