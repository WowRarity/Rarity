if not Rarity then return end
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

local GetItemInfo = function(id) return nil end

-- Types of items
local MOUNT = "MOUNT"
local PET = "PET"
local ITEM = "ITEM"

R.string_types = {
 [MOUNT] = L["Mount"],
 [PET] = L["Battle Pet"],
 [ITEM] = L["Toy or Item"],
}

-- Categories of origin
local BASE = "BASE"
local TBC = "TBC"
local WOTLK = "WOTLK"
local CATA = "CATA"
local MOP = "MOP"
local WOD = "WOD"
local LEGION = "LEGION"
local HOLIDAY = "HOLIDAY"

-- Holiday calendar textures
local CALENDAR_WINTERVEIL = "Calendar_WinterVeil"
local CALENDAR_DARKMOONFAIRE = "calendar_darkmoonfaireterokkar"
local CALENDAR_DAYOFTHEDEAD = "Calendar_DayOfTheDead"
local CALENDAR_BREWFEST = "Calendar_Brewfest"
local CALENDAR_HALLOWSEND = "Calendar_HallowsEnd"
local CALENDAR_PILGRIMSBOUNTY = "Calendar_HarvestFestival"
local CALENDAR_ANNIVERSARY = "calendar_anniversary"
local CALENDAR_LOVEISINTHEAIR = "Calendar_LoveInTheAir"
local CALENDAR_LUNARFESTIVAL = "Calendar_LunarFestival"
local CALENDAR_NOBLEGARDEN = "Calendar_Noblegarden"
local CALENDAR_CHILDRENSWEEK = "Calendar_ChildrensWeek"
local CALENDAR_MIDSUMMER = "Calendar_Midsummer"
local CALENDAR_FIREWORKS = "calendar_fireworks"
local CALENDAR_PIRATESDAY = "Calendar_PiratesDay"

-- Methods of obtaining
local NPC = "NPC"
local BOSS = "BOSS"
local ZONE = "ZONE"
local USE = "USE"
local FISHING = "FISHING"
local ARCH = "ARCH"
local SPECIAL = "SPECIAL"
local MINING = "MINING"
local COLLECTION = "COLLECTION"

R.string_methods = {
 [NPC] = L["Drops from NPC(s)"],
 [BOSS] = L["Drops from a boss requiring a group"],
 [ZONE] = L["Drops from any mob in a zone"],
 [USE] = L["Obtained by using an item or opening a container"],
 [FISHING] = L["Obtained by fishing"],
 [ARCH] = L["Obtained as an archaeology project"],
 [SPECIAL] = L["Special case"],
 [MINING] = L["Obtained by mining"],
	[COLLECTION] = L["Obtained by collecting a number of items"],
}

-- Sort modes
local SORT_NAME = "SORT_NAME"
local SORT_DIFFICULTY = "SORT_DIFFICULTY"
local SORT_PROGRESS = "SORT_PROGRESS"
local SORT_CATEGORY = "SORT_CATEGORY"
local SORT_ZONE = "SORT_ZONE"

-- Archaeology races
R.string_archraces = {
 [1] = L["Demonic"],
	[2] = L["Highmountain Tauren"],
	[3] = L["Highborne"],
	[4] = L["Ogre"],
	[5] = L["Draenor Clans"],
	[6] = L["Arakkoa"],
	[7] = L["Mogu"],
	[8] = L["Pandaren"],
 [9] = L["Mantid"],
 [10] = L["Vrykul"],
 [11] = L["Troll"],
 [12] = L["Tol'vir"],
 [13] = L["Orc"],
 [14] = L["Nerubian"],
 [15] = L["Night Elf"],
 [16] = L["Fossil"],
 [17] = L["Draenei"],	
 [18] = L["Dwarf"],
}

-- Feed text
local FEED_MINIMAL = "FEED_MINIMAL"
local FEED_NORMAL = "FEED_NORMAL"
local FEED_VERBOSE = "FEED_VERBOSE"

-- Tooltip position
local TIP_LEFT = "TIP_LEFT"
local TIP_RIGHT = "TIP_RIGHT"
local TIP_HIDDEN = "TIP_HIDDEN"

-- Categories
R.catIcons = {
 [HOLIDAY] = "holiday",
 [BASE] = "classic",
 [TBC] = "bc",
 [WOTLK] = "wotlk",
 [CATA] = "cata",
 [MOP] = "mop",
 [WOD] = "wod",
 [LEGION] = "legion",
}
R.catOrder = {
 [HOLIDAY] = 0,
 [BASE] = 1,
 [TBC] = 2,
 [WOTLK] = 3,
 [CATA] = 4,
 [MOP] = 5,
 [WOD] = 6,
 [LEGION] = 7,
}



function R:PrepareDefaults()
	self.defaults = {
		profile = {
			minimap = { hide = true },

   enableAnnouncements = true,
   feedText = FEED_NORMAL,
   statusTip = TIP_LEFT,
   sortMode = SORT_CATEGORY,
			hideHighChance = false,
			enableTooltipAdditions = true,
			blankLineBeforeTooltipAdditions = true,
			tooltipAttempts = true,
			takeScreenshot = true,
			hideUnavailable = true,
			hideDefeated = false,
			showTimeColumn = true,
			showLuckinessColumn = true,
			showZoneColumn = true,
			holidayReminder = true,
			showCategoryIcons = true,
			tooltipScale = GameTooltip:GetScale(),
			enableProfiling = false,
			showGroupFinderAutoRefresh = false,
			enableGroupFinderAlert = false,
			tooltipHideDelay = 0.6,
			onlyAnnounceFound = false,
			onlyShowItemsWithAttempts = false,
			blankLineAfterRarity = false,
			hideOutsideZone = false,

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
				[BASE] = true,
				[TBC] = true,
				[WOTLK] = true,
				[CATA] = true,
				[MOP] = true,
				[WOD] = true,
				[LEGION] = true,
				[HOLIDAY] = true,
			},

			-- These are achievements with the names of rare NPCs as criteria to kill
			achNpcs = {
				-- Burning Crusade
				1312,  -- Bloody Rare

				-- Wrath of the Lich King
				2257,  -- Frostbitten

				-- Mists of Pandaria
				7439,  -- Glorious!

				-- Warlords of Draenor
				9400,  -- Gorgrond Monster Hunter
				10070, -- Jungle Stalker

				-- Legion
				11261, -- Adventurer of Azsuna
				11264, -- Adventurer of Highmountain
				11263, -- Adventurer of Stormheim
				11265, -- Adventurer of Suramar
				11262, -- Adventurer of Val'sharah
			},

			-- These are inventory items that may result in another item that Rarity would like to make you aware of
			extraTooltips = {
				inventoryItems = {
					[94295] = { 94292, 94293, 94291, }, -- Primal Egg: Reins of the Black Primal Raptor, Reins of the Green Primal Raptor, Reins of the Red Primal Raptor
					[94288] = { 94290, }, -- Giant Dinosaur Bone: Reins of the Bone-White Primal Raptor
					[86547] = { 90655, }, -- Skyshard: Reins of the Thundering Ruby Cloud Serpent
					[86546] = { 90655, }, -- Sky Crystal: Reins of the Thundering Ruby Cloud Serpent
					[128025] = { 116658, 116669, 116780, }, -- Rattling Iron Cage: Tundra Icehoof, Armored Razorback, Warsong Direfang

					--[6948] = { 6948, }, -- Hearthstone: Hearthstone [this is for testing extraTooltips]
				},
			},

			-- These are items with a 100% drop rate from various mobs; many of them only drop the first time and include a tracking quest
			oneTimeItems = {
	   -- [NPCID] = { questId = QUESTID, itemId = ITEMID }, -- NPC Name

				-- Test item(s)
				--[65432] = { questId = 0--[[31676]], itemId = 102248   }, -- Kyparite Pulverizer (in The Dread Wastes)




				---------------------------------------------------------------------------------------
				-- WRATH OF THE LICH KING
				---------------------------------------------------------------------------------------

				[32491] = { itemId = 44168  }, -- Time-Lost Proto-Drake (Reins of the Time-Lost Proto-Drake, The Storm Peaks)



				---------------------------------------------------------------------------------------
				-- CATACLYSM
				---------------------------------------------------------------------------------------

				[50062] = { itemId = 63042  }, -- Aeonaxx (Reins of the Phosphorescent Stone Drake, Deepholm)
				[51236] = { itemId = 63042  }, -- Aeonaxx (Reins of the Phosphorescent Stone Drake, Deepholm)
				[50005] = { itemId = 67151  }, -- Poseidus (Reins of Poseidus, Shimmering Expanse)



				---------------------------------------------------------------------------------------
				-- MISTS OF PANDARIA
				---------------------------------------------------------------------------------------

				[64403] = { itemId = 90655  }, -- Alani <The Stormborn> (Reins of the Thundering Ruby Cloud Serpent, Vale of Eternal Blossoms)
				[59369] = { itemId = 88566  }, -- Doctor Theolen Krastinov <The Butcher> (Krastinov's Bag of Horrors, Scholomance)



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
				[86732] = { itemId = 118654 }, -- Aogexon
				[86732] = { itemId = 118655 }, -- Bergruu
				[86732] = { itemId = 118656 }, -- Dekorhan
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
				[82922] = { questId = 37343, itemId = 119371 }, -- Archmagus Tekar <Sargerei War Council>
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

    mounts = {
     name = L["Mounts"],

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     -- MOUNTS: Soloable (some of these may be challenging to solo for certain classes, but in general they should be soloable)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					-- Holiday                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Minion of Grumpus"] =                             { cat = HOLIDAY, type = MOUNT, method = USE, name = L["Minion of Grumpus"], spellId = 191314, itemId = 128671, items = { 128670 }, chance = 100, holidayTexture = CALENDAR_WINTERVEIL, },

					-- 1.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Deathcharger's Reins"] =                          { cat = BASE, type = MOUNT, method = NPC, name = L["Deathcharger's Reins"], spellId = 17481, itemId = 13335, npcs = { 99999 }, tooltipNpcs = { 45412 }, chance = 100, statisticId = { 1097 }, bonusSatchel = true, blackMarket = true, coords = { {m=765,f=1,x=38.6,y=20,i=true} }, },
     ["Red Qiraji Resonating Crystal"] =                 { cat = BASE, type = MOUNT, method = NPC, name = L["Red Qiraji Resonating Crystal"], spellId = 26054, itemId = 21321, npcs = { 15311, 15250, 15247, 15246, 15264, 15262, 15277, 15312, 15252, 15249 }, chance = 100, coords = {{m=766,i=true}}, },
					-- 2.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ashes of Al'ar"] =                                { cat = TBC, type = MOUNT, method = BOSS, name = L["Ashes of Al'ar"], spellId = 40192, itemId = 32458, npcs = { 99999 }, tooltipNpcs = { 19622 }, chance = 100, statisticId = { 1088 }, blackMarket = true, coords = { {m=782,x=50.6,y=15.2,i=true} }, },
     ["Fiery Warhorse's Reins"] =                        { cat = TBC, type = MOUNT, method = NPC, name = L["Fiery Warhorse's Reins"], spellId = 36702, itemId = 30480, npcs = { 16152 }, chance = 100, blackMarket = true, lockBossName = "Attumen the Huntsman", coords = { {m=799,f=0,x=46.6,y=82.6,i=true} }, },
     ["Reins of the Raven Lord"] =                       { cat = TBC, type = MOUNT, method = NPC, name = L["Reins of the Raven Lord"], spellId = 41252, itemId = 32768, npcs = { 23035 }, chance = 67, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, --[[ Timewalker ]] [24] = true, }, bonusSatchel = true, blackMarket = true, lockBossName = "Anzu", coords = { {m=723,f=1,x=32.6,y=54.5,i=true} }, },
     ["Swift White Hawkstrider"] =                       { cat = TBC, type = MOUNT, method = NPC, name = L["Swift White Hawkstrider"], spellId = 46628, itemId = 35513, npcs = { 24664 }, chance = 33, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, --[[ Timewalker ]] [24] = true, }, sourceText = L["Heroic difficulty"], bonusSatchel = true, blackMarket = true, coords = { {m=798,f=0,x=8.6,y=50.2,i=true} }, },
					-- 3.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Invincible's Reins"] =                            { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Invincible's Reins"], spellId = 72286, itemId = 50818, npcs = { 99999 }, tooltipNpcs = { 36597 }, chance = 100, instanceDifficulties = { --[[ Heroic 25-man (legacy) ]] [6] = true, }, statisticId = { 4688 }, sourceText = L["25-player heroic"], blackMarket = true, wasGuaranteed = true, lockBossName = "The Lich King", coords = { {m=604,f=6,x=49.8,y=52.8,i=true} }, },
     ["Mimiron's Head"] =                                { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Mimiron's Head"], spellId = 63796, itemId = 45693, npcs = { 33288 }, chance = 100, instanceDifficulties = { --[[ 25-man (legacy) ]] [4] = true, }, sourceText = L["Dropped by Yogg-Saron in Ulduar (25-player) with no Keepers assisting"], wasGuaranteed = true, blackMarket = true, lockBossName = "Yogg-Saron", coords = { {m=529,f=3,x=68,y=40.8,i=true} }, },
     ["Reins of the Azure Drake"] =                      { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Reins of the Azure Drake"], spellId = 59567, itemId = 43952, npcs = { 99999 }, tooltipNpcs = { 28859 }, chance = 100, statisticId = { 1391, 1394 }, sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"], blackMarket = true, lockBossName = "Malygos", coords = { {m=527,f=0,x=39,y=51.8,i=true} }, },
     ["Reins of the Blue Drake"] =                       { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Reins of the Blue Drake"], spellId = 59568, itemId = 43953, npcs = { 99999 }, tooltipNpcs = { 28859 }, chance = 100, statisticId = { 1391, 1394 }, sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"], bonusSatchel = true, blackMarket = true, lockBossName = "Malygos", coords = { {m=527,f=0,x=39,y=51.8,i=true} }, },
     ["Reins of the Blue Proto-Drake"] =                 { cat = WOTLK, type = MOUNT, method = NPC, name = L["Reins of the Blue Proto-Drake"], spellId = 59996, itemId = 44151, npcs = { 26693 }, chance = 77, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, --[[ Timewalker ]] [24] = true, }, sourceText = L["Heroic difficulty"], bonusSatchel = true, blackMarket = true, lockBossName = "Skadi the Ruthless", coords = { {m=524,f=1,x=68.4,y=36.2,i=true} }, },
     ["Reins of the Grand Black War Mammoth Alliance"] = { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Reins of the Grand Black War Mammoth"], spellId = 61465, itemId = 43959, npcs = { 99999 }, tooltipNpcs = { 35013, 33993, 31125, 38433 }, chance = 100, requiresAlliance = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, sourceText = L["Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."], lockBossName = "Archavon the Stone Watcher", coords = { {m=532,f=0,x=36,y=55.4,i=true},{m=532,f=0,x=62.6,y=55.4,i=true},{m=532,f=0,x=49.2,y=17,i=true},{m=532,f=0,x=62.6,y=36.8,i=true}, }, },
     ["Reins of the Grand Black War Mammoth Horde"] =    { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Reins of the Grand Black War Mammoth"], spellId = 61467, itemId = 44083, npcs = { 99999 }, tooltipNpcs = { 35013, 33993, 31125, 38433 }, chance = 100, requiresHorde = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, sourceText = L["Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."], lockBossName = "Archavon the Stone Watcher", coords = { {m=532,f=0,x=36,y=55.4,i=true},{m=532,f=0,x=62.6,y=55.4,i=true},{m=532,f=0,x=49.2,y=17,i=true},{m=532,f=0,x=62.6,y=36.8,i=true}, }, },
     ["Reins of the Green Proto-Drake"] =                { cat = WOTLK, type = MOUNT, method = USE, name = L["Reins of the Green Proto-Drake"], spellId = 61294, itemId = 44707, items = { 39883 }, chance = 20, sourceText = L["Contained in Cracked Egg, which is obtained by becoming Revered with The Oracles, purchasing a Mysterious Egg from their reputation vendor, and waiting three days. The mount has a 5% chance to appear in the Cracked Egg."], bonusSatchel = true, blackMarket = true, coords = { {m=493,x=54.6,y=56.2} }, },
     ["Reins of the Onyxian Drake"] =                    { cat = WOTLK, type = MOUNT, method = BOSS, name = L["Reins of the Onyxian Drake"], spellId = 69395, itemId = 49636, npcs = { 99999 }, tooltipNpcs = { 10184 }, chance = 100, statisticId = { 1098 }, sourceText = L["Any raid size"], blackMarket = true, lockBossName = "Onyxia", coords = { {m=718,f=0,x=68,y=31.4,i=true} }, },
     ["Reins of the White Polar Bear"] =                 { cat = WOTLK, type = MOUNT, method = USE, name = L["Reins of the White Polar Bear"], spellId = 54753, itemId = 43962, items = { 44751, 69903 }, chance = 33, sourceText = L["Contained in Hyldnir Spoils, which is rewarded for completing daily quests given by Gretta the Arbiter in Brunnhildar Village, Storm Peaks. The mount has a 3% chance to appear in Hyldnir Spoils."], bonusSatchel = true, blackMarket = true, coords = { {m=495,x=50.8,y=65.6} }, },
     ["Sea Turtle"] =                                    { cat = WOTLK, type = MOUNT, method = FISHING, name = L["Sea Turtle"], spellId = 64731, itemId = 46109, zones = { "490", "510", "488", "491", "486", "493", "709", "700", "720", "640", "606", "857", "806", "807", "809", "811", "858", "810", "823", "951", "929", "928", "873", --[[ WoD ]] --[["962", "978", "941", "976", "949", "971", "950", "947", "948", "1009", "946", "945", "970", "1011", "945",]] }, chance = 10000, requiresPool = true, sourceText = L["Obtained very rarely by fishing in pools located in any expansion zone (not Classic zones)"], coords = { {m=490},{m=510},{m=488},{m=491},{m=486},{m=493},{m=709},{m=700},{m=720},{m=640},{m=606},{m=857},{m=806},{m=807},{m=809},{m=811},{m=858},{m=810},{m=823},{m=951},{m=929},{m=928},{m=873}, }, },
					-- 4.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Armored Razzashi Raptor"] =                       { cat = CATA, type = MOUNT, method = BOSS, name = L["Armored Razzashi Raptor"], spellId = 96491, itemId = 68823, npcs = { 52151 }, chance = 100, sourceText = L["Heroic difficulty"], lockBossName = "Bloodlord Mandokir", coords = { {m=793,x=60.4,y=79.9,i=true} }, },
     ["Experiment 12-B"] =                               { cat = CATA, type = MOUNT, method = BOSS, name = L["Experiment 12-B"], spellId = 110039, itemId = 78919, npcs = { 99999 }, tooltipNpcs = { 55294 }, chance = 100, statisticId = { 6161, 6162 }, sourceText = L["Dropped by Ultraxion in Dragon Soul (any raid size or difficulty)"], lockBossName = "Ultraxion", coords = { {m=824,x=49.6,y=57.6,i=true} }, },
     ["Flametalon of Alysrazor"] =                       { cat = CATA, type = MOUNT, method = BOSS, name = L["Flametalon of Alysrazor"], spellId = 101542, itemId = 71665, npcs = { 99999 }, tooltipNpcs = { 52530 }, chance = 100, statisticId = { 5970, 5971 }, sourceText = L["Any raid size or difficulty"], blackMarket = true, lockBossName = "Alysrazor", coords = { {m=800,f=0,x=64.3,y=38,i=true} }, },
     ["Fossilized Raptor"] =                             { cat = CATA, type = MOUNT, method = ARCH, name = L["Fossilized Raptor"], spellId = 84751, itemId = 60954, raceId = 16, chance = 30, sourceText = L["Obtained as a rare project for the Fossil branch of archaeology"], coords = { {m=4},{m=9},{m=11},{m=13},{m=14},{m=16},{m=17},{m=19},{m=20},{m=21},{m=22},{m=23},{m=24},{m=26},{m=27},{m=28},{m=29},{m=30},{m=32},{m=34},{m=35},{m=36},{m=37},{m=38},{m=39},{m=40},{m=41},{m=42},{m=43},{m=61},{m=81},{m=101},{m=121},{m=141},{m=161},{m=181},{m=182},{m=201},{m=241},{m=261},{m=281},{m=301},{m=321},{m=341},{m=362},{m=381},{m=382},{m=462},{m=463},{m=464},{m=471},{m=476},{m=480},{m=499},{m=502},{m=545},{m=606},{m=607},{m=610},{m=611},{m=613},{m=614},{m=615},{m=673},{m=684},{m=685},{m=689},{m=700},{m=708},{m=709},{m=720},{m=772},{m=795},{m=864},{m=866},{m=888},{m=889},{m=890},{m=891},{m=892},{m=893},{m=894},{m=895}, }, },
     ["Life-Binder's Handmaiden"] =                      { cat = CATA, type = MOUNT, method = BOSS, name = L["Life-Binder's Handmaiden"], spellId = 107845, itemId = 77069, npcs = { 99999 }, chance = 100, statisticId = { 6168 }, sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (heroic, any raid size)"], wasGuaranteed = true, blackMarket = true, lockBossName = "Madness of Deathwing", coords = { {m=824,i=true} }, },
     ["Reins of the Blazing Drake"] =                    { cat = CATA, type = MOUNT, method = BOSS, name = L["Reins of the Blazing Drake"], spellId = 107842, itemId = 77067, npcs = { 99999 }, chance = 100, statisticId = { 6167, 6168 }, sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (any raid size or difficulty)"], blackMarket = true, lockBossName = "Madness of Deathwing", coords = { {m=824,i=true} }, },
     ["Reins of the Drake of the North Wind"] =          { cat = CATA, type = MOUNT, method = NPC, name = L["Reins of the Drake of the North Wind"], spellId = 88742, itemId = 63040, npcs = { 43873 }, chance = 100, sourceText = L["Any difficulty"], blackMarket = true, coords = { {m=769,x=51.9,y=82.1,i=true} }, },
     ["Reins of the Drake of the South Wind"] =          { cat = CATA, type = MOUNT, method = BOSS, name = L["Reins of the Drake of the South Wind"], spellId = 88744, itemId = 63041, npcs = { 99999 }, tooltipNpcs = { 46753 }, chance = 100, statisticId = { 5576, 5577 }, sourceText = L["Any raid size or difficulty"], blackMarket = true, lockBossName = "Al'Akir", coords = { {m=773,x=47.5,y=50.1,i=true} }, },
     ["Reins of the Grey Riding Camel"] =                { cat = CATA, type = MOUNT, method = SPECIAL, name = L["Reins of the Grey Riding Camel"], spellId = 88750, itemId = 63046, chance = 20, sourceText = L["Guaranteed drop from Dormus the Camel-Hoarder. Accessing this encounter requires finding a rare Mysterious Camel Figurine in Uldum. These are difficult to spot and, when clicked, have a small chance to grant you access to the Dormus encounter. Rarity will count how many Figurines you've found if you mouseover them."], coords = { {m=720} }, },
     ["Reins of the Vitreous Stone Drake"] =             { cat = CATA, type = MOUNT, method = NPC, name = L["Reins of the Vitreous Stone Drake"], spellId = 88746, itemId = 63043, npcs = { 43214 }, chance = 100, sourceText = L["Any difficulty"], blackMarket = true, coords = { {m=768,x=37,y=44.7,i=true} }, },
     ["Scepter of Azj'Aqir"] =                           { cat = CATA, type = MOUNT, method = ARCH, name = L["Scepter of Azj'Aqir"], spellId = 92155, itemId = 64883, raceId = 12, chance = 500, sourceText = L["Obtained as a very rare project for the Tol'vir branch of archaeology"], coords = { {m=720} }, },
     ["Smoldering Egg of Millagazor"] =                  { cat = CATA, type = MOUNT, method = BOSS, name = L["Smoldering Egg of Millagazor"], spellId = 97493, itemId = 69224, npcs = { 99999 }, tooltipNpcs = { 52409 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 100, statisticId = { 5976, 5977 }, wasGuaranteed = true, blackMarket = true, coords = { {m=800,f=2,x=50.7,y=15.3,i=true} }, },
     ["Swift Zulian Panther"] =                          { cat = CATA, type = MOUNT, method = BOSS, name = L["Swift Zulian Panther"], spellId = 96499, itemId = 68824, npcs = { 52059 }, chance = 100, sourceText = L["Heroic difficulty"], lockBossName = "High Priestess Kilnara", coords = { {m=793,x=48,y=20,i=true} }, },
					-- 5.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Clutch of Ji-Kun"] =                              { cat = MOP, type = MOUNT, method = BOSS, name = L["Clutch of Ji-Kun"], spellId = 139448, itemId = 95059, npcs = { 99999 }, tooltipNpcs = { 69712 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 50, statisticId = { 8171, 8169, 8172, 8170 }, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Ji-Kun", coords = { {m=930,f=3,x=49.7,y=41.6,i=true} }, },
     ["Kor'kron Juggernaut"] =                           { cat = MOP, type = MOUNT, method = BOSS, name = L["Kor'kron Juggernaut"], spellId = 148417, itemId = 104253, npcs = { 99999 }, tooltipNpcs = { 71865 }, instanceDifficulties = { --[[ Mythic ]] [16] = true, }, chance = 100, statisticId = { 8638, 8637, }, sourceText = L["Mythic difficulty"], wasGuaranteed = true, lockBossName = "Garrosh Hellscream", coords = { {m=953,f=11,x=49.4,y=71.3,i=true} }, },
					["Reins of the Amber Primordial Direhorn"] =        { cat = MOP, type = MOUNT, method = NPC, name = L["Reins of the Amber Primordial Direhorn"], spellId = 138424, itemId = 94230, npcs = { 69841 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], coords = { {m=857,x=39.08,y=67.13},{m=858,x=47.47,y=61.32},{m=810,x=36.53,y=85.67},{m=809,x=75.09,y=67.65},{m=806,x=52.73,y=18.99}, }, },
     ["Reins of the Astral Cloud Serpent"] =             { cat = MOP, type = MOUNT, method = BOSS, name = L["Reins of the Astral Cloud Serpent"], spellId = 127170, itemId = 87777, npcs = { 99999 }, tooltipNpcs = { 60410 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 100, statisticId = { 6797, 6798, 7924, 7923, }, sourceText = L["Dropped by Elegon in Mogu'shan Vaults (all raid formats except Raid Finder)"], blackMarket = true, lockBossName = "Elegon", coords = { {m=896,x=21.7,y=51.1,i=true} }, },
     ["Reins of the Bone-White Primal Raptor"] =         { cat = MOP, type = MOUNT, method = COLLECTION, name = L["Reins of the Bone-White Primal Raptor"], spellId = 138640, itemId = 94290, collectedItemId = 94288, chance = 9999, obtain = L["Dropped from dinosaurs on Isle of Giants"], tooltipNpcs = { 69992, 70013, 70012, 70015, 70014, 70006, 69925, 69993, 70004, 70005, 70007, 70020, 70016, 69983, 70017, 70019, 70018, 70011, 70009, 69991, 70021, 70010, 70008, }, sourceText = L["Earned by giving 9999 Giant Dinosaur Bones to Ku'ma on Isle of Giants. Giant Dinosaur bones drop from all dinosaurs and Zandalari Dinomancers on Isle of Giants."], coords = { {m=929} }, },
     ["Reins of the Cobalt Primordial Direhorn"] =       { cat = MOP, type = MOUNT, method = BOSS, name = L["Reins of the Cobalt Primordial Direhorn"], spellId = 138423, itemId = 94228, npcs = { 99999 }, tooltipNpcs = { 69161 }, questId = 32519, chance = 2000, equalOdds = true, statisticId = { 8147 }, enableCoin = true, worldBossFactionless = true, coords = { {m=929,x=50.6,y=54.4} }, },
     ["Reins of the Heavenly Onyx Cloud Serpent"] =      { cat = MOP, type = MOUNT, method = BOSS, name = L["Reins of the Heavenly Onyx Cloud Serpent"], spellId = 127158, itemId = 87771, npcs = { 99999 }, tooltipNpcs = { 60491 }, questId = 32099, chance = 2000, equalOdds = true, statisticId = { 6989 }, enableCoin = true, worldBossFactionless = true, blackMarket = true, coords = { {m=809} }, },
     ["Reins of the Jade Primordial Direhorn"] =         { cat = MOP, type = MOUNT, method = NPC, name = L["Reins of the Jade Primordial Direhorn"], spellId = 138426, itemId = 94231, npcs = { 69842 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], coords = { {m=857,x=39.08,y=67.13},{m=858,x=47.47,y=61.32},{m=810,x=36.53,y=85.67},{m=809,x=75.09,y=67.65},{m=806,x=52.73,y=18.99}, }, },
     ["Reins of the Slate Primordial Direhorn"] =        { cat = MOP, type = MOUNT, method = NPC, name = L["Reins of the Slate Primordial Direhorn"], spellId = 138425, itemId = 94229, npcs = { 69769 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], coords = { {m=857,x=39.08,y=67.13},{m=858,x=47.47,y=61.32},{m=810,x=36.53,y=85.67},{m=809,x=75.09,y=67.65},{m=806,x=52.73,y=18.99}, }, },
     ["Reins of the Thundering Cobalt Cloud Serpent"] =  { cat = MOP, type = MOUNT, method = BOSS, name = L["Reins of the Thundering Cobalt Cloud Serpent"], spellId = 139442, itemId = 95057, npcs = { 99999 }, tooltipNpcs = { 69099 }, questId = 32518, chance = 2000, equalOdds = true, statisticId = { 8146 }, enableCoin = true, worldBossFactionless = true, blackMarket = true, coords = { {m=928,x=60.5,y=37.3} }, },
     ["Reins of the Thundering Onyx Cloud Serpent"] =    { cat = MOP, type = MOUNT, method = NPC, name = L["Reins of the Thundering Onyx Cloud Serpent"], spellId = 148476, itemId = 104269, npcs = { 73167 }, chance = 100, sourceText = L["Players have a personal loot chance to obtain this item."], coords = { {m=951,x=67.8,y=59} }, },
					["Son of Galleon's Saddle"] =                       { cat = MOP, type = MOUNT, method = BOSS, name = L["Son of Galleon's Saddle"], spellId = 130965, itemId = 89783, npcs = { 99999 }, tooltipNpcs = { 62346 }, questId = 32098, chance = 2000, equalOdds = true, statisticId = { 6990 }, enableCoin = true, worldBossFactionless = true, coords = { {m=807,x=71.6,y=64.4} }, },
     ["Spawn of Horridon"] =                             { cat = MOP, type = MOUNT, method = BOSS, name = L["Spawn of Horridon"], spellId = 136471, itemId = 93666, npcs = { 99999 }, tooltipNpcs = { 68476 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 66, statisticId = { 8151, 8149, 8152, 8150 }, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Horridon", coords = { {m=930,f=1,x=26.8,y=78.7,i=true} }, },
					-- 6.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Armored Razorback"] =                             { cat = WOD, type = MOUNT, method = NPC, name = L["Armored Razorback"], spellId = 171630, itemId = 116669, npcs = { 95044, 95054, 95053, 95056, }, chance = 30, sourceText = L["Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount \"defeated\" for the day when you kill any of the four."], questId = { 39287, 39288, 39289, 39290, }, defeatAllQuests = true, coords = { {m=945,x=32.6,y=73.8,q=39290,n=L["Vengeance"]}, {m=945,x=47,y=52.6,q=39289,n=L["Doomroller"]}, {m=945,x=23.2,y=40.4,q=39287,n=L["Deathtalon"]}, {m=945,x=14.6,y=63,q=39288,n=L["Terrorfist"]}, }, defeatSteps = { [39290] = L["Vengeance"], [39287] = L["Deathtalon"], [39288] = L["Terrorfist"], [39289] = L["Doomroller"], }, },
     ["Bristling Hellboar"] =                            { cat = WOD, type = MOUNT, method = COLLECTION, name = L["Bristling Hellboar"], spellId = 190690, itemId = 128481, collectedItemId = 124099, chance = 5000, obtain = L["Dropped from monsters in Fang'rila"], tooltipNpcs = { 92922, 92466, 89747, 89695, 89746, 92481, }, sourceText = L["Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."], coords = { {m=945,x=55.2,y=74.8} }, },
     ["Garn Steelmaw"] =                                 { cat = WOD, type = MOUNT, method = USE, name = L["Garn Steelmaw"], spellId = 171836, itemId = 116779, items = { 116980, 122163 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."], questId = { 37640, 38482 }, defeatAllQuests = true, coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, defeatSteps = { [37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"], }, },
     ["Giant Coldsnout"] =                               { cat = WOD, type = MOUNT, method = USE, name = L["Giant Coldsnout"], spellId = 171635, itemId = 116673, items = { 116980, 122163 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."], questId = { 37640, 38482 }, defeatAllQuests = true, coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, defeatSteps = { [37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"], }, },
     ["Reins of the Crimson Water Strider"] =            { cat = WOD, type = MOUNT, method = COLLECTION, name = L["Reins of the Crimson Water Strider"], spellId = 127271, itemId = 87791, collectedItemId = { 117397, 127994, 116820, 116818, 116819, 116821, 122696, 116817, 116822, }, chance = 100, obtain = L["Fished anywhere in Draenor (except your garrison) with the help of Nat Pagle"], sourceText = L["Lunkers can be fished anywhere in Draenor (except in your garrison) after you've obtained a level 3 Fishing Shack and acquired Nat Pagle as a follower."], coords = { {m=962},{m=978},{m=941},{m=949},{m=950},{m=947},{m=948},{m=1009},{m=946},{m=945},{m=1011}, }, },
     ["Riding Turtle"] =                                 { cat = WOD, type = MOUNT, method = NPC, name = L["Riding Turtle"], spellId = 30174, itemId = 23720, npcs = { 81171, 85715, }, chance = 200, sourceText = L["After upgrading your garrison's Fishing Shack to level 3, fish up 5 minnows to summon a Cavedweller which can drop this mount."], coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, },
     ["Shadowhide Pearltusk"] =                          { cat = WOD, type = MOUNT, method = USE, name = L["Shadowhide Pearltusk"], spellId = 171624, itemId = 116663, items = { 116980, 122163 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."], questId = { 37640, 38482 }, defeatAllQuests = true, coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, defeatSteps = { [37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"], }, },
     ["Smoky Direwolf"] =                                { cat = WOD, type = MOUNT, method = USE, name = L["Smoky Direwolf"], spellId = 171843, itemId = 116786, items = { 116980, 122163 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."], questId = { 37640, 38482 }, defeatAllQuests = true, coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, defeatSteps = { [37640] = L["Garrison Invasion Gold Victory"], [38482] = L["Garrison Invasion Platinum Victory"], }, },
     ["Tundra Icehoof"] =                                { cat = WOD, type = MOUNT, method = NPC, name = L["Tundra Icehoof"], spellId = 171619, itemId = 116658, npcs = { 95044, 95054, 95053, 95056, }, chance = 30, sourceText = L["Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount \"defeated\" for the day when you kill any of the four."], questId = { 39287, 39288, 39289, 39290, }, defeatAllQuests = true, coords = { {m=945,x=32.6,y=73.8,q=39290,n=L["Vengeance"]}, {m=945,x=47,y=52.6,q=39289,n=L["Doomroller"]}, {m=945,x=23.2,y=40.4,q=39287,n=L["Deathtalon"]}, {m=945,x=14.6,y=63,q=39288,n=L["Terrorfist"]}, }, defeatSteps = { [39290] = L["Vengeance"], [39287] = L["Deathtalon"], [39288] = L["Terrorfist"], [39289] = L["Doomroller"], }, },
     ["Warsong Direfang"] =                              { cat = WOD, type = MOUNT, method = NPC, name = L["Warsong Direfang"], spellId = 171837, itemId = 116780, npcs = { 95044, 95054, 95053, 95056, }, chance = 30, sourceText = L["Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount \"defeated\" for the day when you kill any of the four."], questId = { 39287, 39288, 39289, 39290, }, defeatAllQuests = true, coords = { {m=945,x=32.6,y=73.8,q=39290,n=L["Vengeance"]}, {m=945,x=47,y=52.6,q=39289,n=L["Doomroller"]}, {m=945,x=23.2,y=40.4,q=39287,n=L["Deathtalon"]}, {m=945,x=14.6,y=63,q=39288,n=L["Terrorfist"]}, }, defeatSteps = { [39290] = L["Vengeance"], [39287] = L["Deathtalon"], [39288] = L["Terrorfist"], [39289] = L["Doomroller"], }, },
     ["Wild Goretusk"] =                                 { cat = WOD, type = MOUNT, method = COLLECTION, name = L["Wild Goretusk"], spellId = 171633, itemId = 116671, collectedItemId = 124099, chance = 1000, obtain = L["Dropped from monsters in Fang'rila"], tooltipNpcs = { 92922, 92466, 89747, 89695, 89746, 92481, }, sourceText = L["Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."], coords = { {m=945,x=55.2,y=74.8} }, },
					-- 7.0
     --["Brinedeep Bottom-Feeder"] =                       { cat = LEGION, type = MOUNT, method = COLLECTION, name = L["Brinedeep Bottom-Feeder"], spellId = 214791, itemId = 138811, collectedItemId = { 138777, }, chance = 100, },
     ["Cloudwing Hippogryph"] =                          { cat = LEGION, type = MOUNT, method = USE, name = L["Cloudwing Hippogryph"], spellId = 242881, itemId = 147806, items = { 152102, }, chance = 20, },
     ["Highmountain Elderhorn"] =                        { cat = LEGION, type = MOUNT, method = USE, name = L["Highmountain Elderhorn"], spellId = 242874, itemId = 147807, items = { 152104, }, chance = 20, },
     ["Leywoven Flying Carpet"] =                        { cat = LEGION, type = MOUNT, method = USE, name = L["Leywoven Flying Carpet"], spellId = 233364, itemId = 143764, items = { 152105, }, chance = 20, },
     ["Torn Invitation"] =                               { cat = LEGION, type = MOUNT, method = SPECIAL, name = L["Torn Invitation"], spellId = 171850, itemId = 140495, chance = 200, questId = 43943,  sourceText = L["The quest starter item for Reins of the Llothien Prowler"], coords = {{m=1033}} },
     ["Valarjar Stormwing"] =                            { cat = LEGION, type = MOUNT, method = USE, name = L["Valarjar Stormwing"], spellId = 242882, itemId = 147805, items = { 152106, }, chance = 20, },
     ["Wild Dreamrunner"] =                              { cat = LEGION, type = MOUNT, method = USE, name = L["Wild Dreamrunner"], spellId = 242875, itemId = 147804, items = { 152103, }, chance = 20, },

                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- MOUNTS: Requires a group (some of these may be soloable by certain classes, but not in general)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					-- Holiday                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Big Love Rocket"] =                               { cat = HOLIDAY, type = MOUNT, method = USE, name = L["Big Love Rocket"], spellId = 71342, itemId = 50250, items = { 54537 }, chance = 3333, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."], lockDungeonId = 288, coords = {{m=764,x=40.8,y=52.6,f=1,i=true}}, },
     ["Great Brewfest Kodo"] =                           { cat = HOLIDAY, type = MOUNT, method = USE, name = L["Great Brewfest Kodo"], spellId = 49379, itemId = 37828, items = { 54535, 117393, }, chance = 25, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."], lockDungeonId = 287, coords = {{m=704,x=46.6,y=60,f=2,i=true}}, },
     ["Swift Brewfest Ram"] =                            { cat = HOLIDAY, type = MOUNT, method = USE, name = L["Swift Brewfest Ram"], spellId = 43900, itemId = 33977, items = { 54535, 117393, }, chance = 25, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."], lockDungeonId = 287, coords = {{m=704,x=46.6,y=60,f=2,i=true}}, },
     ["The Horseman's Reins"] =                          { cat = HOLIDAY, type = MOUNT, method = USE, name = L["The Horseman's Reins"], spellId = 48025, itemId = 37012, items = { 117392 }, chance = 200, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."], lockDungeonId = 285, coords = { {m=874,i=true} }, },
					-- 6.x
     ["Felsteel Annihilator"] =                          { cat = WOD, type = MOUNT, method = BOSS, name = L["Felsteel Annihilator"], spellId = 182912, itemId = 123890, npcs = { 99999 }, tooltipNpcs = { 91331 }, chance = 100, wasGuaranteed = true, groupSize = 3, statisticId = { 10252 }, lockBossName = "Archimonde", coords = { {m=1026,f=10,x=58.4,y=53.3,i=true} }, },
     ["Garn Nighthowl"] =                                { cat = WOD, type = MOUNT, method = BOSS, name = L["Garn Nighthowl"], spellId = 171851, itemId = 116794, npcs = { 81001 }, chance = 1, groupSize = 25, coords = { {m=941,x=16,y=53.2} }, },
     ["Ironhoof Destroyer"] =                            { cat = WOD, type = MOUNT, method = BOSS, name = L["Ironhoof Destroyer"], spellId = 171621, itemId = 116660, npcs = { 99999 }, tooltipNpcs = { 77325 }, chance = 100, wasGuaranteed = true, groupSize = 3, statisticId = { 9365 }, lockBossName = "Blackhand", coords = { {m=988,f=5,x=48.4,y=34.5,i=true} }, },
     ["Solar Spirehawk"] =                               { cat = WOD, type = MOUNT, method = BOSS, name = L["Solar Spirehawk"], spellId = 171828, itemId = 116771, npcs = { 99999 }, tooltipNpcs = { 87493, 83746 }, chance = 2000, groupSize = 40, equalOdds = true, statisticId = { 9279 }, worldBossFactionless = true, questId = 37464, coords = { {m=948,x=47.1,y=78.4} }, },
					["Reins of the Infinite Timereaver"] =              { cat = WOD, type = MOUNT, method = BOSS, name = L["Reins of the Infinite Timereaver"], spellId = 201098, itemId = 133543, npcs = { 24723, 24744, 24560, 24664, 17941, 17991, 17942, 16807, 20923, 16809, 16808, 18341, 18343, 18344, 22930, 17879, 17880, 17881, 20870, 20885, 20886, 20912, 36494, 36476, 36658, 26668, 26687, 26693, 26861, 26731, 26763, 26794, 26723, 26796, 26798, 28586, 28587, 28546, 28923, 29304, 29573, 29305, 29306, 29932, 29309, 29308, 29310, 29311, 30258, 40586, 40765, 40788, 44566, 43878, 43873, 43875, 43438, 43214, 42188, 42333, 44577, 43612, 44819, 49045, 39625, 40177, 40319, 40484, 54431, 54445, 54123, 54544, 54432, 22930, 56906, 56589, 56636, 56877, 56448, 56843, 56732, 56439, 56637, 56717, 59479, 61567, 61634, 61485, 62205, 56747, 56541, 56719, 56884, 61444, 61243, 61398, }, chance = 4000, groupSize = 5, equalOdds = true, instanceDifficulties = { --[[ Timewalking 5-player dungeon ]] [24] = true, }, coords = {{m=798,i=true},{m=728,i=true},{m=710,i=true},{m=732,i=true},{m=733,i=true},{m=731,i=true},{m=602,i=true},{m=524,i=true},{m=520,i=true},{m=525,i=true},{m=530,i=true},{m=522,i=true},{m=767,i=true},{m=769,i=true},{m=768,i=true},{m=747,i=true},{m=757,i=true},{m=820,i=true},{m=875,i=true},{m=867,i=true},{m=876,i=true},{m=887,i=true},{m=877,i=true},{m=885,i=true}}, },
					-- 7.x
					["Abyss Worm"] =                                    { cat = LEGION, type = MOUNT, method = BOSS, name = L["Abyss Worm"], spellId = 232519, itemId = 143643, npcs = { 99999 }, tooltipNpcs = { 115767 }, chance = 100, groupSize = 10, equalOdds = true, statisticId = { 11893, 11894, 11895, 11896, }, coords = { {m=1147,f=2,i=true} }, },
     ["Living Infernal Core"] =                          { cat = LEGION, type = MOUNT, method = BOSS, name = L["Living Infernal Core"], spellId = 213134, itemId = 137574, npcs = { 99999 }, tooltipNpcs = { 105503 }, chance = 100, groupSize = 10, statisticId = { 10979, 10980, 10978 }, coords = { {m=1088,f=9,i=true} }, },
					["Midnight's Eternal Reins"] =                      { cat = LEGION, type = MOUNT, method = BOSS, name = L["Midnight's Eternal Reins"], spellId = 229499, itemId = 142236, npcs = { 114262, }, chance = 100, groupSize = 5, instanceDifficulties = { --[[ Mythic 5-player instance ]] [23] = true, }, coords = {{m=1100,i=true}}, },

    },




				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- BATTLE PETS
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

    pets = {
     name = L["Battle Pets"],

					-- Holiday                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    					
					["Clockwork Rocket Bot"] =                          { cat = HOLIDAY, type = PET, method = USE, name = L["Clockwork Rocket Bot"], spellId = 54187, itemId = 34425, items = { 116762 }, chance = 50, creatureId = 24968, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=341,x=33.2,y=67.8}, {m=24,x=42.4,y=41}, {m=321,x=54.4,y=77,f=1} }, },
     ["Darkmoon Eye"] =                                  { cat = HOLIDAY, type = PET, method = USE, name = L["Darkmoon Eye"], spellId = 132789, itemId = 91040, items = { 91086 }, chance = 50, creatureId = 67332, sourceText = L["This bag is rewarded for completing the pet battle daily offered by Jeremy Feasel at the Darkmoon Faire."], holidayTexture = CALENDAR_DARKMOONFAIRE, questId = 32175, coords = {{m=823,x=47.8,y=62.6,n=L["Jeremy Feasel"]}}, },
					["Frightened Bush Chicken"] =                       { cat = HOLIDAY, type = PET, method = USE, name = L["Frightened Bush Chicken"], spellId = 171500, itemId = 116403, items = { 116404 }, chance = 33, creatureId = 85846, holidayTexture = CALENDAR_PILGRIMSBOUNTY, coords = { {m=939,x=60,y=34.2},{m=4,x=46.4,y=13.8},{m=381,x=61.8,y=46.4},{m=362,x=31,y=69.6},{m=30,x=33.8,y=50.8},{m=382,x=65.2,y=13.8},{m=30,x=33.6,y=50.6},{m=382,x=63.4,y=9}, }, },
					["Green Helper Box"] =                              { cat = HOLIDAY, type = PET, method = USE, name = L["Green Helper Box"], spellId = 26533, itemId = 21301, items = { 21310 }, chance = 4, creatureId = 15698, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, coords = { zoneOverride = L["Greatfather Winter's Tree"], {m=341,x=33.5,y=66},{m=321,x=49.3,y=78.4,f=1}}, christmasOnly = true, },
     ["Grumpling"] =                                     { cat = HOLIDAY, type = PET, method = SPECIAL, name = L["Grumpling"], spellId = 191967, itemId = 128770, obtain = L["Obtained by opening Snow Mound in Frostfire Ridge"], chance = 20, creatureId = 97229, holidayTexture = CALENDAR_WINTERVEIL, coords = {{m=941,x=45.8,y=26.6,n=L["Snow Mound"]}}, },
     ["Ice Chip"] =                                      { cat = HOLIDAY, type = PET, method = USE, name = L["Ice Chip"], spellId = 74932, itemId = 53641, items = { 54536 }, chance = 25, groupSize = 5, equalOdds = true, creatureId = 40198, lockDungeonId = 286, coords = {{m=728,x=31.2,y=50.8,i=true,n=L["Ahune"]}}, },
					["Jingling Bell"] =                                 { cat = HOLIDAY, type = PET, method = USE, name = L["Jingling Bell"], spellId = 26529, itemId = 21308, items = { 21310 }, chance = 4, creatureId = 15706, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, coords = { zoneOverride = L["Greatfather Winter's Tree"], {m=341,x=33.5,y=66},{m=321,x=49.3,y=78.4,f=1}}, questId = { 8768 }, christmasOnly = true, },
					["Lump of Coal"] =                                  { cat = HOLIDAY, type = PET, method = USE, name = L["Lump of Coal"], spellId = 103125, itemId = 73797, items = { 116762 }, chance = 50, creatureId = 55215, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=341,x=33.2,y=67.8}, {m=24,x=42.4,y=41}, {m=321,x=54.4,y=77,f=1} }, },
					["Rotten Helper Box"] =                             { cat = HOLIDAY, type = PET, method = USE, name = L["Rotten Helper Box"], spellId = 148567, itemId = 104317, items = { 116762 }, chance = 100, creatureId = 73741, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=341,x=33.2,y=67.8}, {m=24,x=42.4,y=41}, {m=321,x=54.4,y=77,f=1} }, },
					["Moon Moon"] =                                     { cat = HOLIDAY, type = PET, method = NPC, name = L["Moon Moon"], spellId = 144761, itemId = 101570, npcs = { 71992 }, chance = 17, repeatable = true, creatureId = 72160, holidayTexture = CALENDAR_DARKMOONFAIRE, coords = {{m=823,x=39.8,y=44.4,n=L["Moonfang"]}}, },
					["Red Helper Box"] =                                { cat = HOLIDAY, type = PET, method = USE, name = L["Red Helper Box"], spellId = 26541, itemId = 21305, items = { 21310 }, chance = 4, creatureId = 15705, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, coords = { zoneOverride = L["Greatfather Winter's Tree"], {m=341,x=33.5,y=66},{m=321,x=49.3,y=78.4,f=1}}, christmasOnly = true, },
     ["Sea Pony"] =                                      { cat = HOLIDAY, type = PET, method = FISHING, name = L["Sea Pony"], spellId = 103588, itemId = 73953, zones = { "823" }, chance = 1000, requiresPool = false, creatureId = 55386, holidayTexture = CALENDAR_DARKMOONFAIRE, coords = {{m=823}}, },
					["Snowman Kit"] =                                   { cat = HOLIDAY, type = PET, method = USE, name = L["Snowman Kit"], spellId = 26045, itemId = 21309, items = { 21310 }, chance = 4, creatureId = 15710, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, coords = { zoneOverride = L["Greatfather Winter's Tree"], {m=341,x=33.5,y=66},{m=321,x=49.3,y=78.4,f=1}}, christmasOnly = true, },
     ["Syd the Squid"] =                                 { cat = HOLIDAY, type = PET, method = USE, name = L["Syd the Squid"], spellId = 170774, itemId = 116064, items = { 116062 }, chance = 50, creatureId = 85527, sourceText = L["This bag is rewarded for completing the pet battle daily offered by Christoph VonFeasel at the Darkmoon Faire."], holidayTexture = CALENDAR_DARKMOONFAIRE, questId = 36471, coords = {{m=823,x=47.4,y=62.2,n=L["Christoph VonFeasel"]}}, },
     ["Toxic Wasteling"] =                               { cat = HOLIDAY, type = PET, method = USE, name = L["Toxic Wasteling"], spellId = 71840, itemId = 50446, items = { 54537 }, chance = 14, groupSize = 5, equalOdds = true, creatureId = 38374, lockDungeonId = 288, coords = {{m=764,x=40.8,y=52.6,f=1,i=true}}, },
					-- 1.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Cat Carrier (Black Tabby)"] =                     { cat = BASE, type = PET, method = NPC, name = L["Cat Carrier (Black Tabby)"], spellId = 10675, itemId = 8491, npcs = { 2372, 49116, 2385, 48741, 2248, 48184, 49269, 48628, 48017, 47204, 48260, 49245, 47861, 2373, }, chance = 10000, repeatable = true, creatureId = 7383, coords = {{m=24}}, },
     ["Dark Whelpling"] =                                { cat = BASE, type = PET, method = NPC, name = L["Dark Whelpling"], spellId = 10695, itemId = 10822, npcs = { 4324, 42042, 2725, 46916, 7049, 4323, 46914 }, chance = 1000, repeatable = true, creatureId = 7543, coords = {{m=17,x=29.6,y=44.2}, {m=17,x=71.8,y=47.6}, {m=17,x=11.2,y=41.0}, {m=29,x=16.8,y=64.8}, {m=29,x=23.8,y=64.4}, {m=40,x=63.8,y=50.6}, {m=141,x=47.6,y=69.8}}, },
     ["Disgusting Oozeling"] =                           { cat = BASE, type = PET, method = USE, name = L["Disgusting Oozeling"], spellId = 25162, itemId = 20769, items = { 20768 }, chance = 85, repeatable = true, creatureId = 15429, tooltipNpcs = { 1806, 1808, 12387, 3928, 43158, 43123, 44988, 44967, 4394, 4393, 7092, 48315, 7093, 7086, 48136, 48319, 48322, 3295, 8607, 8606, 15335, 41573, 47397, 11741, 11740, 14477, 46997, 42952, 2656, 2655, 6559, 9477, 6557, 42669, 41145, 1032, 41147, 41453, 51028, 49347, 50319, 48768, }, coords = { {m=43},{m=1060},{m=851},{m=182},{m=24},{m=11},{m=502},{m=717},{m=615},{m=261},{m=37},{m=26},{m=201},{m=39},{m=40},{m=281}, }, },
     ["Parrot Cage (Green Wing Macaw)"] =                { cat = BASE, type = PET, method = NPC, name = L["Parrot Cage (Green Wing Macaw)"], spellId = 10683, itemId = 8492, npcs = { 48522 }, chance = 33, repeatable = true, creatureId = 7387, coords = {{m=756,f=1,x=55,y=39.6,i=true}}, },
     ["Parrot Cage (Hyacinth Macaw)"] =                  { cat = BASE, type = PET, method = ZONE, name = L["Parrot Cage (Hyacinth Macaw)"], spellId = 10682, itemId = 8494, zones = { "689", "37", "673" }, chance = 10000, repeatable = true, creatureId = 7391, coords = {{m=37}, {m=673}}, },
     ["Sprite Darter Egg"] =                             { cat = BASE, type = PET, method = ZONE, name = L["Sprite Darter Egg"], spellId = 15067, itemId = 11474, zones = { "121" }, chance = 10000, creatureId = 9662, coords = {{m=121}}, },
     ["Tiny Crimson Whelpling"] =                        { cat = BASE, type = PET, method = ZONE, name = L["Tiny Crimson Whelpling"], spellId = 10697, itemId = 8499, zones = { "40" }, chance = 10000, repeatable = true, creatureId = 7544, coords = {{m=40}}, },
     ["Tiny Emerald Whelpling"] =                        { cat = BASE, type = PET, method = NPC, name = L["Tiny Emerald Whelpling"], spellId = 10698, itemId = 8498, npcs = { 740, 741, 39384 }, chance = 1000, repeatable = true, creatureId = 7545, coords = {{m=121,x=49.6,y=8.6}}, },
					-- 2.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Azure Whelpling"] =                               { cat = TBC, type = PET, method = ZONE, name = L["Azure Whelpling"], spellId = 10696, itemId = 34535, zones = { "281" }, chance = 10000, repeatable = true, creatureId = 7547, coords = {{m=281}}, },
     ["Captured Firefly"] =                              { cat = TBC, type = PET, method = NPC, name = L["Captured Firefly"], spellId = 36034, itemId = 29960, npcs = { 20197 }, chance = 1000, repeatable = true, creatureId = 21076, coords = {{m=467,x=47.6,y=32.6}}, },
     ["Mojo"] =                                          { cat = TBC, type = PET, method = USE, name = L["Mojo"], spellId = 43918, itemId = 33993, items = { 33865 }, chance = 10, creatureId = 24480, coords = {{m=781,x=42,y=52.9,i=true}}, },
     ["Phoenix Hatchling"] =                             { cat = TBC, type = PET, method = NPC, name = L["Phoenix Hatchling"], spellId = 46599, itemId = 35504, npcs = { 24664 }, chance = 11, creatureId = 26119, coords = {{m=798,f=0,x=8.6,y=50.2,i=true,n=L["Kael'thas Sunstrider"]}}, },
     ["Chuck's Bucket"] =                                { cat = TBC, type = PET, method = USE, name = L["Chuck's Bucket"], spellId = 46426, itemId = 35350, items = { 35348 }, chance = 10, creatureId = 26056, coords = {{m=481,x=54.6,y=39.6,n=L["Cupri"]}, {m=478,x=38.6,y=12.8,n=L["Old Man Barlo"]}}, },
     ["Muckbreaths's Bucket"] =                          { cat = TBC, type = PET, method = USE, name = L["Muckbreaths's Bucket"], spellId = 43698, itemId = 33818, items = { 35348 }, chance = 10, creatureId = 24389, coords = {{m=481,x=54.6,y=39.6,n=L["Cupri"]}, {m=478,x=38.6,y=12.8,n=L["Old Man Barlo"]}}, },
     ["Snarly's Bucket"] =                               { cat = TBC, type = PET, method = USE, name = L["Snarly's Bucket"], spellId = 46425, itemId = 35349, items = { 35348 }, chance = 10, creatureId = 26050, coords = {{m=481,x=54.6,y=39.6,n=L["Cupri"]}, {m=478,x=38.6,y=12.8,n=L["Old Man Barlo"]}}, },
     ["Toothy's Bucket"] =                               { cat = TBC, type = PET, method = USE, name = L["Toothy's Bucket"], spellId = 43697, itemId = 33816, items = { 35348 }, chance = 10, creatureId = 24388, coords = {{m=481,x=54.6,y=39.6,n=L["Cupri"]}, {m=478,x=38.6,y=12.8,n=L["Old Man Barlo"]}}, },
					-- 3.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Deviate Hatchling"] =                             { cat = WOTLK, type = PET, method = NPC, name = L["Deviate Hatchling"], spellId = 67414, itemId = 48114, npcs = { 3636, 3637 }, chance = 500, repeatable = true, creatureId = 35395, coords = {{m=749}}, },
     ["Giant Sewer Rat"] =                               { cat = WOTLK, type = PET, method = FISHING, name = L["Giant Sewer Rat"], spellId = 59250, itemId = 43698, zones = { "Cantrips & Crows", "Circle of Wills", "The Underbelly", "The Black Market" }, chance = 1000, requiresPool = false, creatureId = 31575, coords = {{m=504}}, },
     ["Gundrak Hatchling"] =                             { cat = WOTLK, type = PET, method = NPC, name = L["Gundrak Hatchling"], spellId = 67415, itemId = 48116, npcs = { 29334 }, chance = 1000, repeatable = true, creatureId = 35400, coords = {{m=496}}, },
     ["Razzashi Hatchling"] =                            { cat = WOTLK, type = PET, method = ZONE, name = L["Razzashi Hatchling"], spellId = 67420, itemId = 48126, zones = { "689", "37", "673" }, chance = 5000, repeatable = true, creatureId = 35394, coords = {{m=689},{m=37},{m=673}}, },
					-- 4.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Elementium Geode"] =                              { cat = CATA, type = PET, method = SPECIAL, name = L["Elementium Geode"], spellId = 93838, itemId = 67282, obtain = L["Obtained by mining Elementium Vein"], chance = 2000, creatureId = 50722, coords = {{m=1060},{m=770},{m=720},{m=709},{m=708}}, },
     ["Fox Kit"] =                                       { cat = CATA, type = PET, method = NPC, name = L["Fox Kit"], spellId = 90637, itemId = 64403, npcs = { 47676 }, chance = 1000, creatureId = 48641, coords = {{m=709}}, },
     ["Mr. Grubbs"] =                                    { cat = CATA, type = PET, method = USE, name = L["Mr. Grubbs"], spellId = 93739, itemId = 66076, items = { 61387 }, chance = 50, creatureId = 50586, coords = {{m=23}}, },
     ["Scorched Stone"] =                                { cat = CATA, type = PET, method = USE, name = L["Scorched Stone"], spellId = 45890, itemId = 34955, items = { 71631 }, chance = 20, creatureId = 25706, coords = {{m=795,x=47,y=90.6}}, },
					-- 5.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Hollow Reed"] =                                   { cat = MOP, type = PET, method = NPC, name = L["Hollow Reed"], spellId = 126249, itemId = 86563, npcs = { 50776 }, chance = 10, creatureId = 64633, coords = {{m=858,x=64.2,y=58.6}}, },
     ["Imbued Jade Fragment"] =                          { cat = MOP, type = PET, method = NPC, name = L["Imbued Jade Fragment"], spellId = 126251, itemId = 86564, npcs = { 50347 }, chance = 10, creatureId = 64634, coords = {{m=858,x=71.8,y=37.6}}, },
     ["Porcupette"] =                                    { cat = MOP, type = PET, method = USE, name = L["Porcupette"], spellId = 118414, itemId = 89587, items = { 89125 }, chance = 250, creatureId = 61086, },
					-- 5.1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Anubisath Idol"] =                                { cat = MOP, type = PET, method = NPC, name = L["Anubisath Idol"], spellId = 135267, itemId = 93040, npcs = { 15276 }, chance = 10, creatureId = 68659, coords = {{m=766,x=60.6,y=69.7,f=1,i=true}}, },
     ["Blackwing Banner"] =                              { cat = MOP, type = PET, method = NPC, name = L["Blackwing Banner"], spellId = 135265, itemId = 93037, npcs = { 12017 }, chance = 10, creatureId = 68663, coords = {{m=755,x=50.5,y=61.7,f=1,i=true}}, },
     ["Blazing Rune"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Blazing Rune"], spellId = 135259, itemId = 93034, npcs = { 11982 }, chance = 10, creatureId = 68664, coords = {{m=696,x=69.4,y=23.6,i=true}}, },
     ["Blighted Spore"] =                                { cat = MOP, type = PET, method = NPC, name = L["Blighted Spore"], spellId = 135255, itemId = 93032, npcs = { 16011 }, chance = 10, creatureId = 68657, coords = {{m=535,x=76,y=28.3,i=true}}, },
     ["Core of Hardened Ash"] =                          { cat = MOP, type = PET, method = NPC, name = L["Core of Hardened Ash"], spellId = 135261, itemId = 93035, npcs = { 11988 }, chance = 10, creatureId = 68666, coords = {{m=696,x=68.8,y=57.6,i=true}}, },
     ["Dusty Clutch of Eggs"] =                          { cat = MOP, type = PET, method = NPC, name = L["Dusty Clutch of Eggs"], spellId = 135254, itemId = 93030, npcs = { 15952 }, chance = 10, creatureId = 68656, coords = {{m=535,x=68.6,y=15.2,i=true}}, },
     ["Gluth's Bone"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Gluth's Bone"], spellId = 135257, itemId = 93029, npcs = { 15932 }, chance = 10, creatureId = 68654, coords = {{m=535,x=46.2,y=43.8,i=true}}, },
					["Imperial Moth"] =                                 { cat = MOP, type = PET, method = USE, name = L["Imperial Moth"], spellId = 132574, itemId = 90900, items = { 92960 }, chance = 50, creatureId = 67230, },
					["Imperial Silkworm"] =                             { cat = MOP, type = PET, method = USE, name = L["Imperial Silkworm"], spellId = 132580, itemId = 90902, items = { 92960 }, chance = 10, creatureId = 67233, },
     ["Jewel of Maddening Whispers"] =                   { cat = MOP, type = PET, method = NPC, name = L["Jewel of Maddening Whispers"], spellId = 135268, itemId = 93041, npcs = { 15263 }, chance = 10, creatureId = 68658, coords = {{m=766,x=45.7,y=52.2,i=true}}, },
     ["Mark of Flame"] =                                 { cat = MOP, type = PET, method = NPC, name = L["Mark of Flame"], spellId = 135258, itemId = 93033, npcs = { 12098 }, chance = 10, creatureId = 68665, coords = {{m=696,x=82.8,y=82.5,i=true}}, },
     ["Unscathed Egg"] =                                 { cat = MOP, type = PET, method = NPC, name = L["Unscathed Egg"], spellId = 135263, itemId = 93036, npcs = { 12435 }, chance = 10, creatureId = 68661, coords = {{m=755,x=41.9,y=60.2,i=true}}, },
     ["Viscidus Globule"] =                              { cat = MOP, type = PET, method = NPC, name = L["Viscidus Globule"], spellId = 135266, itemId = 93039, npcs = { 15299 }, chance = 10, creatureId = 68660, coords = {{m=766,x=72.1,y=17.8,i=true}}, },
     ["Whistle of Chromatic Bone"] =                     { cat = MOP, type = PET, method = NPC, name = L["Whistle of Chromatic Bone"], spellId = 135264, itemId = 93038, npcs = { 14020 }, chance = 10, creatureId = 68662, coords = {{m=755,x=39.4,y=72.6,i=true}}, },
					-- 5.2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ji-Kun Hatchling"] =                              { cat = MOP, type = PET, method = BOSS, name = L["Ji-Kun Hatchling"], spellId = 139148, itemId = 94835, npcs = { 99999 }, tooltipNpcs = { 69712 }, chance = 200, statisticId = { 8171, 8169, 8172, 8170, 8168 }, creatureId = 70144, enableCoin = true, lockBossName = "Ji-Kun", coords = {{m=767,x=49.3,y=41.5,f=3,i=true}}, },
     ["Living Sandling"] =                               { cat = MOP, type = PET, method = BOSS, name = L["Living Sandling"], spellId = 137977, itemId = 94125, npcs = { 69944 }, chance = 200, statisticId = { 8153 }, doNotUpdateToHighestStat = true, creatureId = 69748, enableCoin = true, coords = {{m=767,i=true}}, },
     ["Mountain Panda"] =                                { cat = MOP, type = PET, method = USE, name = L["Mountain Panda"], spellId = 138382, itemId = 94210, items = { 94207 }, chance = 7, creatureId = 69892, },
     ["Snowy Panda"] =                                   { cat = MOP, type = PET, method = USE, name = L["Snowy Panda"], spellId = 138381, itemId = 94209, items = { 94207 }, chance = 7, creatureId = 69893, },
     ["Son of Animus"] =                                 { cat = MOP, type = PET, method = BOSS, name = L["Son of Animus"], spellId = 138161, itemId = 94152, npcs = { 99999 }, tooltipNpcs = { 69427 }, chance = 200, statisticId = { 8186, 8184, 8187, 8185, 8183 }, creatureId = 69820, enableCoin = true, lockBossName = "Dark Animus", coords = {{m=767,x=42.6,y=57.6,f=5,i=true}}, },
     ["Sunfur Panda"] =                                  { cat = MOP, type = PET, method = USE, name = L["Sunfur Panda"], spellId = 138380, itemId = 94208, items = { 94207 }, chance = 7, creatureId = 69891, },
     ["Direhorn Runt"] =                                 { cat = MOP, type = PET, method = NPC, name = L["Direhorn Runt"], spellId = 139153, itemId = 94573, npcs = { 70019, 69983, 70016, 70017, 70018, 69992, 70015, 70012, 70013, 70014 }, chance = 250, creatureId = 70154, coords = {{m=929}}, },
					["Zandalari Anklerender"] =                         { cat = MOP, type = PET, method = NPC, name = L["Zandalari Anklerender"], spellId = 139932, itemId = 95422, npcs = { 69925 }, chance = 50, creatureId = 70451, coords = {{m=929}}, },
					["Zandalari Footslasher"] =                         { cat = MOP, type = PET, method = NPC, name = L["Zandalari Footslasher"], spellId = 139933, itemId = 95423, npcs = { 69925 }, chance = 50, creatureId = 70452, coords = {{m=929}}, },
					["Zandalari Kneebiter"] =                           { cat = MOP, type = PET, method = NPC, name = L["Zandalari Kneebiter"], spellId = 138087, itemId = 94126, npcs = { 69925 }, chance = 50, creatureId = 69796, coords = {{m=929}}, },
					["Zandalari Toenibbler"] =                          { cat = MOP, type = PET, method = NPC, name = L["Zandalari Toenibbler"], spellId = 139934, itemId = 95424, npcs = { 69925 }, chance = 50, creatureId = 70453, coords = {{m=929}}, },
					-- 5.3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Brilliant Phoenix Hawk Feather"] =                { cat = MOP, type = PET, method = NPC, name = L["Brilliant Phoenix Hawk Feather"], spellId = 141449, itemId = 97557, npcs = { 19514 }, chance = 33, creatureId = 71022, coords = {{m=782,x=50.1,y=58.7,i=true}}, },
     ["Crystal of the Void"] =                           { cat = MOP, type = PET, method = BOSS, name = L["Crystal of the Void"], spellId = 141448, itemId = 97556, npcs = { 18805 }, chance = 20, creatureId = 71021, {{m=782,x=74,y=48.9,i=true}}, },
     ["Dark Quivering Blob"] =                           { cat = MOP, type = PET, method = BOSS, name = L["Dark Quivering Blob"], spellId = 142029, itemId = 97960, npcs = { 99999 }, tooltipNpcs = { 69017 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 50, statisticId = { 8181, 8179, 8180, 8182 }, creatureId = 71200, enableCoin = true, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Primordius", coords = {{m=930,f=5,i=true,x=57.2,y=78.2}}, },
     ["Dripping Strider Egg"] =                          { cat = MOP, type = PET, method = NPC, name = L["Dripping Strider Egg"], spellId = 141446, itemId = 97554, npcs = { 21212 }, chance = 250, creatureId = 71019, coords = {{m=780,x=72.2,y=58.9,i=true}}, },
     ["Gahz'rooki's Summoning Stone"] =                  { cat = MOP, type = PET, method = NPC, name = L["Gahz'rooki's Summoning Stone"], spellId = 141789, itemId = 97821, npcs = { 70997, 70999, 71000, }, chance = 1000, creatureId = 141789, coords = {{m=11}}, },
     ["Half-Empty Food Container"] =                     { cat = MOP, type = PET, method = NPC, name = L["Half-Empty Food Container"], spellId = 142030, itemId = 97961, npcs = { 69251 }, chance = 750, creatureId = 71201, coords = {{m=928,x=51.8,y=80.6}}, },
     ["Instant Arcane Sanctum Security Kit"] =           { cat = MOP, type = PET, method = NPC, name = L["Instant Arcane Sanctum Security Kit"], spellId = 141434, itemId = 97549, npcs = { 15691 }, chance = 33, creatureId = 71015, coords = {{m=1100,i=true,f=1,x=49.4,y=36.6}}, },
     ["Netherspace Portal-Stone"] =                      { cat = MOP, type = PET, method = NPC, name = L["Netherspace Portal-Stone"], spellId = 141435, itemId = 97550, npcs = { 15690 }, chance = 33, creatureId = 71016, coords = {{m=799,x=51.4,y=30.9,i=true}}, },
     ["Pygmy Direhorn"] =                                { cat = MOP, type = PET, method = BOSS, name = L["Pygmy Direhorn"], spellId = 138825, itemId = 94574, npcs = { 99999 }, tooltipNpcs = { 68476 }, chance = 50, statisticId = { 8151, 8149, 8152, 8150, 8148 }, creatureId = 70083, enableCoin = true, lockBossName = "Horridon", coords = {{m=930,26.8,y=78.7,i=true}}, },
     ["Quivering Blob"] =                                { cat = MOP, type = PET, method = BOSS, name = L["Quivering Blob"], spellId = 142028, itemId = 97959, npcs = { 99999 }, tooltipNpcs = { 69017 }, instanceDifficulties = { --[[ LFR ]] [7] = true, }, chance = 50, statisticId = { 8178 }, creatureId = 71199, enableCoin = true, sourceText = L["Only Raid Finder difficulty"], lockBossName = "Primordius", coords = {{m=930,x=57.2,y=78.2,i=true,f=5}}, },
     ["Satyr Charm"] =                                   { cat = MOP, type = PET, method = NPC, name = L["Satyr Charm"], spellId = 141451, itemId = 97551, npcs = { 15688 }, chance = 33, creatureId = 71033, coords = {{m=1100,x=52.5,y=69.6,i=true}}, },
     ["Shell of Tide-Calling"] =                         { cat = MOP, type = PET, method = NPC, name = L["Shell of Tide-Calling"], spellId = 141436, itemId = 97552, npcs = { 21213 }, chance = 20, creatureId = 71017, coords = {{m=780,x=59.6,y=26,i=true}}, },
     ["Spiky Collar"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Spiky Collar"], spellId = 141433, itemId = 97548, npcs = { 17521 }, chance = 14, creatureId = 71014, coords = {{m=799,x=18.1,y=35,i=true}}, },
     ["Tainted Core"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Tainted Core"], spellId = 141437, itemId = 97553, npcs = { 21216 }, chance = 25, creatureId = 71018, coords = {{m=780,x=36.3,y=84.7,i=true}}, },
     ["Tiny Fel Engine Key"] =                           { cat = MOP, type = PET, method = NPC, name = L["Tiny Fel Engine Key"], spellId = 141447, itemId = 97555, npcs = { 19516 }, chance = 25, creatureId = 71020, coords = {{m=782,x=26.4,y=49,i=true}}, },
					-- 5.4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ashleaf Spriteling"] =                            { cat = MOP, type = PET, method = NPC, name = L["Ashleaf Spriteling"], spellId = 148046, itemId = 104156, npcs = { 73277 }, chance = 66, creatureId = 73533, coords = {{m=951,x=67.6,y=44}}, },
     ["Azure Crane Chick"] =                             { cat = MOP, type = PET, method = SPECIAL, name = L["Azure Crane Chick"], spellId = 148047, itemId = 104157, obtain = L["Obtained by opening Crane Nests on the Timeless Isle"], chance = 50, creatureId = 73534, coords = {{m=951}}, },
     ["Blackfuse Bombling"] =                            { cat = MOP, type = PET, method = NPC, name = L["Blackfuse Bombling"], spellId = 148049, itemId = 104158, npcs = { 99999 }, tooltipNpcs = { 71504 }, chance = 100, statisticId = { 8624, 8622, 8625, 8623, 8621, 8620, }, creatureId = 73352, lockBossName = "Siegecrafter Blackfuse", coords = {{m=953,x=58.7,y=46.5,i=true}}, },
     ["Bonkers"] =                                       { cat = MOP, type = PET, method = SPECIAL, name = L["Bonkers"], spellId = 148373, itemId = 104202, obtain = L["Obtained by opening Timeless Chests on the Timeless Isle"], chance = 70, creatureId = 73668, coords = {{m=951}}, },
     ["Death Adder Hatchling"] =                         { cat = MOP, type = PET, method = NPC, name = L["Death Adder Hatchling"], spellId = 148052, itemId = 104161, npcs = { 73163 }, chance = 50, creatureId = 73364, coords = {{m=951}}, },
					["Dandelion Frolicker"] =                           { cat = MOP, type = PET, method = NPC, name = L["Dandelion Frolicker"], spellId = 148051, itemId = 104160, npcs = { 71826, 71823 }, chance = 1250, creatureId = 73532, coords = {{m=951,x=45.6,y=74.6}}, },
     ["Droplet of Y'Shaarj"] =                           { cat = MOP, type = PET, method = BOSS, name = L["Droplet of Y'Shaarj"], spellId = 148058, itemId = 104162, npcs = { 99999 }, tooltipNpcs = { 71734 }, instanceDifficulties = { --[[ 10/25 Flex/Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, [14] = true, }, chance = 100, statisticId = { 8569, 8571, 8573, 8570, 8568, }, creatureId = 73350, enableCoin = true, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Sha of Pride", coords = {{m=953,x=22.5,y=69.5,i=true}}, }, -- SHA OF PRIDE (flex/normal/heroic)
     ["Gooey Sha-ling"] =                                { cat = MOP, type = PET, method = BOSS, name = L["Gooey Sha-ling"], spellId = 148059, itemId = 104163, npcs = { 99999 }, tooltipNpcs = { 71734 }, instanceDifficulties = { --[[ LFR/Flex ]] [7] = true, [14] = true, }, chance = 100, equalOdds = true, statisticId = { 8568, 8567, }, creatureId = 73351, enableCoin = true, sourceText = L["Raid Finder or Flexible difficulty"], lockBossName = "Sha of Pride", coords = {{m=953,x=22.5,y=69.5,i=true}}, }, -- SHA OF PRIDE (lfr/flex)
     ["Gu'chi Swarmling"] =                              { cat = MOP, type = PET, method = NPC, name = L["Gu'chi Swarmling"], spellId = 148527, itemId = 104291, npcs = { 72909 }, chance = 50, creatureId = 73730, coords = {{m=951,x=42.6,y=75.6}}, },
     ["Gulp Froglet"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Gulp Froglet"], spellId = 148067, itemId = 104169, npcs = { 72775 }, chance = 33, creatureId = 73359, coords = {{m=951,x=63.8,y=73}}, },
     ["Jadefire Spirit"] =                               { cat = MOP, type = PET, method = NPC, name = L["Jadefire Spirit"], spellId = 148552, itemId = 104307, npcs = { 72769 }, chance = 50, creatureId = 73738, coords = {{m=951,x=47.8,y=36.8}}, },
     ["Jademist Dancer"] =                               { cat = MOP, type = PET, method = NPC, name = L["Jademist Dancer"], spellId = 148060, itemId = 104164, npcs = { 72767 }, chance = 200, creatureId = 72767, coords = {{m=951,x=26.4,y=29.2}}, },
     ["Kovok"] =                                         { cat = MOP, type = PET, method = BOSS, name = L["Kovok"], spellId = 148061, itemId = 104165, npcs = { 99999 }, tooltipNpcs = { 71161, 71153, 71160, 71154, 71156, 71155, 71158, 71152, 71157 }, chance = 100, statisticId = { 8630, 8628, 8631, 8629, 8627, 8626, }, creatureId = 73354, enableCoin = true, lockBossName = "Paragons of the Klaxxi", coords = {{m=953,x=68.3,y=35.3,i=true}}, }, -- PARAGONS OF THE KLAXXI (all modes)
     ["Lil' Bling"] =                                    { cat = MOP, type = PET, method = USE, name = L["Lil' Bling"], spellId = 147124, itemId = 103670, items = { 86623, 113258, }, chance = 200, creatureId = 73011, questId = { 31752, 34774 }, tooltipNpcs = { 77789, 43929 }, },
     ["Ominous Flame"] =                                 { cat = MOP, type = PET, method = NPC, name = L["Ominous Flame"], spellId = 148062, itemId = 104166, npcs = { 73162 }, chance = 200, creatureId = 73357, coords = {{m=951,x=47.2,y=35.6}}, },
     ["Ruby Droplet"] =                                  { cat = MOP, type = PET, method = NPC, name = L["Ruby Droplet"], spellId = 148050, itemId = 104159, npcs = { 73282 }, chance = 25, creatureId = 73356, coords = {{m=951,x=64.6,y=28.6}}, },
     ["Skunky Alemental"] =                              { cat = MOP, type = PET, method = NPC, name = L["Skunky Alemental"], spellId = 148063, itemId = 104167, npcs = { 71919 }, chance = 33, creatureId = 73367, coords = {{m=951,x=37.8,y=77.2}}, },
     ["Spineclaw Crab"] =                                { cat = MOP, type = PET, method = NPC, name = L["Spineclaw Crab"], spellId = 148066, itemId = 104168, npcs = { 73166 }, chance = 60, creatureId = 73366, coords = {{m=951}}, },
					-- 6.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
					["Albino Chimaeraling"] =                           { cat = WOD, type = PET, method = USE, name = L["Albino Chimaeraling"], spellId = 177212, itemId = 119434, items = { 118697 }, chance = 15, creatureId = 77021, questId = { 37644, 37645 }, },
					["Firewing"] =                                      { cat = WOD, type = PET, method = USE, name = L["Firewing"], spellId = 170291, itemId = 118578, items = { 118697 }, chance = 15, creatureId = 87704, questId = { 37644, 37645 }, },
     ["Land Shark"] =                                    { cat = WOD, type = PET, method = COLLECTION, name = L["Land Shark"], spellId = 172695, itemId = 117404, creatureId = 86445, collectedItemId = { 117397, 127994, 116820, 116818, 116819, 116821, 122696, 116817, 116822, }, chance = 50, obtain = L["Fished anywhere in Draenor (except your garrison) with the help of Nat Pagle"], sourceText = L["Lunkers can be fished anywhere in Draenor (except in your garrison) after you've obtained a level 3 Fishing Shack and acquired Nat Pagle as a follower."], coords = { {m=962},{m=978},{m=941},{m=949},{m=950},{m=947},{m=948},{m=1009},{m=946},{m=945},{m=1011}, }, },
     ["Nightshade Sproutling"] =                         { cat = WOD, type = PET, method = NPC, name = L["Nightshade Sproutling"], spellId = 167394, itemId = 118595, npcs = { 85407, 85408, 85409, 85410, 85411, 85412, 95132, }, chance = 1000, creatureId = 83594, sourceText = L["Dropped by Disturbed Podling, which has a chance to spawn when picking herbs in Draenor."], coords = {{m=951}}, },
					["Puddle Terror"] =                                 { cat = WOD, type = PET, method = USE, name = L["Puddle Terror"], spellId = 119467, itemId = 119467, items = { 118697 }, chance = 15, creatureId = 88300, questId = { 37644, 37645 }, },                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Red Goren Egg"] =                                 { cat = WOD, type = PET, method = NPC, name = L["Red Goren Egg"], spellId = 170280, itemId = 118919, npcs = { 85294 }, chance = 1000, creatureId = 85667, sourceText = L["Dropped by Goren Protector, which has a chance to spawn when mining ore in Draenor."], coords = {{m=973},{m=976},{m=951},{m=473},{m=946},{m=941},{m=950},{m=948},{m=949}}, },
     ["Sea Calf"] =                                      { cat = WOD, type = PET, method = COLLECTION, name = L["Sea Calf"], spellId = 168977, itemId = 114919, creatureId = 84441, collectedItemId = { 117397, 127994, 116820, 116818, 116819, 116821, 122696, 116817, 116822, }, chance = 50, obtain = L["Fished anywhere in Draenor (except your garrison) with the help of Nat Pagle"], sourceText = L["Lunkers can be fished anywhere in Draenor (except in your garrison) after you've obtained a level 3 Fishing Shack and acquired Nat Pagle as a follower."], coords = { {m=962},{m=978},{m=941},{m=949},{m=950},{m=947},{m=948},{m=1009},{m=946},{m=945},{m=1011}, }, },
     ["Servant of Demidos"] =                            { cat = WOD, type = PET, method = NPC, name = L["Servant of Demidos"], spellId = 170278, itemId = 119431, npcs = { 84911, }, chance = 7, creatureId = 88692, coords = {{m=473,x=46,y=71.8}}, },
     ["Sky-Bo"] =                                        { cat = WOD, type = PET, method = USE, name = L["Sky-Bo"], spellId = 170292, itemId = 115483, items = { 86623, 113258, }, chance = 200, creatureId = 85284, questId = { 31752, 34774 }, tooltipNpcs = { 77789, }, },
					["Spectral Bell"] =                                 { cat = WOD, type = PET, method = USE, name = L["Spectral Bell"], spellId = 167731, itemId = 113623, items = { 118697 }, chance = 15, creatureId = 83817, questId = { 37644, 37645 }, },
					["Sun Sproutling"] =                                { cat = WOD, type = PET, method = USE, name = L["Sun Sproutling"], spellId = 167397, itemId = 118598, items = { 118697 }, chance = 15, creatureId = 83588, questId = { 37644, 37645 }, },
					["Sunfire Kaliri"] =                                { cat = WOD, type = PET, method = USE, name = L["Sunfire Kaliri"], spellId = 177227, itemId = 119468, items = { 118697 }, chance = 15, creatureId = 88367, questId = { 37644, 37645 }, },
     ["Time-Locked Box"] =                               { cat = WOD, type = PET, method = NPC, name = L["Time-Locked Box"], spellId = 10699, itemId = 118675, repeatable = true, npcs = { 82458, 77653, 78193, 76886, 77767, 77790, 78921, 77090, 76556, 78345, 82774, 78348, 78670, 76673, 77771, 76189, 77640, 77101, 78695, 77724, 78488, 77643, 78696, 77723, 77644, 78667, 73458, 76672, 82918, 73446, 77721, 82451, 73459, 78674, 76651, }, chance = 500, creatureId = 7546, coords = {{m=992}}, },
					["Weebomination"] =                                 { cat = WOD, type = PET, method = USE, name = L["Weebomination"], spellId = 158261, itemId = 113558, items = { 118697 }, chance = 15, creatureId = 78421, questId = { 37644, 37645 }, },
     ["Zomstrok"] =                                      { cat = WOD, type = PET, method = NPC, name = L["Zomstrok"], spellId = 167336, itemId = 113554, npcs = { 82262, 82261, 84921, }, chance = 100, creatureId = 83562, coords = {{m=473,x=41,y=80}}, },
					-- 6.1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
					["Bone Serpent"] =                                  { cat = WOD, type = PET, method = USE, name = L["Bone Serpent"], spellId = 177238, itemId = 122532, items = { 122535 }, chance = 33, creatureId = 88577, questId = { 382994, 38300 }, },
					["Fragment of Anger"] =                             { cat = WOD, type = PET, method = NPC, name = L["Fragment of Anger"], spellId = 179832, itemId = 122107, npcs = { 23420 }, chance = 10, creatureId = 90203, coords = {{m=1085,x=61.3,y=85,i=true}}, },
					["Fragment of Desire"] =                            { cat = WOD, type = PET, method = NPC, name = L["Fragment of Desire"], spellId = 179834, itemId = 122109, npcs = { 23420 }, chance = 10, creatureId = 90205, coords = {{m=1085,x=61.3,y=85,i=true}}, },
					["Fragment of Suffering"] =                         { cat = WOD, type = PET, method = NPC, name = L["Fragment of Suffering"], spellId = 179833, itemId = 122108, npcs = { 23420 }, chance = 10, creatureId = 90204, coords = {{m=1085,x=61.3,y=85,i=true}}, },
					["Grotesque Statue"] =                              { cat = WOD, type = PET, method = NPC, name = L["Grotesque Statue"], spellId = 179811, itemId = 122105, npcs = { 17842 }, chance = 10, creatureId = 90200, coords = {{m=775,x=35.7,y=37.8,i=true}}, },
					["Hyjal Wisp"] =                                    { cat = WOD, type = PET, method = NPC, name = L["Hyjal Wisp"], spellId = 179837, itemId = 122112, npcs = { 17968 }, chance = 10, creatureId = 90208, coords = {{m=775,x=77.3,y=28.3,i=true}}, },
					["Leviathan Egg"] =                                 { cat = WOD, type = PET, method = NPC, name = L["Leviathan Egg"], spellId = 179830, itemId = 122104, npcs = { 22887 }, chance = 10, creatureId = 90201, coords = {{m=919,x=43.9,y=18.7,i=true}}, },
					["Servant's Bell"] =                                { cat = WOD, type = PET, method = NPC, name = L["Servant's Bell"], spellId = 179840, itemId = 122115, npcs = { 25165, 25166 }, chance = 10, creatureId = 90214, coords = {{m=789,x=64.1,y=32.1,i=true}}, },
					["Shard of Supremus"] =                             { cat = WOD, type = PET, method = NPC, name = L["Shard of Supremus"], spellId = 179831, itemId = 122106, npcs = { 22898 }, chance = 10, creatureId = 90202, coords = {{m=919,x=66.3,y=47.3,i=true}}, },
					["Slithershock Elver"] =                            { cat = WOD, type = PET, method = USE, name = L["Slithershock Elver"], spellId = 177223, itemId = 122534, items = { 122535 }, chance = 33, creatureId = 91407, questId = { 382994, 38300 }, },
					["Smelly Gravestone"] =                             { cat = WOD, type = PET, method = NPC, name = L["Smelly Gravestone"], spellId = 179836, itemId = 122111, npcs = { 17808 }, chance = 10, creatureId = 90207, coords = {{m=775,x=8.5,y=68.1,i=true}}, },
					["Sultry Grimoire"] =                               { cat = WOD, type = PET, method = NPC, name = L["Sultry Grimoire"], spellId = 179835, itemId = 122110, npcs = { 22947 }, chance = 10, creatureId = 90206, coords = {{m=919,x=67.5,y=36.7,i=true}}, },
					["Sunblade Rune of Activation"] =                   { cat = WOD, type = PET, method = NPC, name = L["Sunblade Rune of Activation"], spellId = 179838, itemId = 122113, npcs = { 24882 }, chance = 10, creatureId = 90212, coords = {{m=789,x=65.8,y=86.4,i=true}}, },
					["Void Collar"] =                                   { cat = WOD, type = PET, method = NPC, name = L["Void Collar"], spellId = 179839, itemId = 122114, npcs = { 25840 }, chance = 10, creatureId = 90213, coords = {{m=789,x=46.7,y=23.8,i=true}}, },
					["Young Talbuk"] =                                  { cat = WOD, type = PET, method = USE, name = L["Young Talbuk"], spellId = 177218, itemId = 122533, items = { 122535 }, chance = 33, creatureId = 91408, questId = { 382994, 38300 }, },
					-- 6.2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                          
     ["Corrupted Nest Guardian"] =                       { cat = WOD, type = PET, method = BOSS, name = L["Corrupted Nest Guardian"], spellId = 187532, itemId = 127749, npcs = { 99999 }, tooltipNpcs = { 95067 }, chance = 100, statisticId = { 10228, 10227, 10226, 10225 }, creatureId = 94623, enableCoin = true, lockBossName = "Shadow-Lord Iskar", groupSize = 3,  equalOdds = true, coords = {{m=1026,x=40.1,y=76.1,i=true}}, },                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
					["Glittering Arcane Crystal"] =                     { cat = WOD, type = PET, method = NPC, name = L["Glittering Arcane Crystal"], spellId = 193589, itemId = 129218, npcs = { 98200, }, chance = 10, creatureId = 98238, questId = 40074, coords = { {m=950,x=23.8,y=37.9,n=L["Guk"]} }},
					["Nightmare Bell"] =                                { cat = WOD, type = PET, method = USE, name = L["Nightmare Bell"], spellId = 185055, itemId = 127753, items = { 127751 }, chance = 33, creatureId = 93483, sourceText = L["Can drop from Fel-Touched Pet Supplies, which is obtained by defeating the Fel-corrupted legendary pets in Tanaan Jungle."], questId = { 39157, 39160, 39161, 39162, 39163, 39164, 39165, 39166, 39167, 39168, 39169, 39170, 39171, 39172, 39173, }, defeatAllQuests = true, defeatSteps = { [39168] = L["Bleakclaw"], [39161] = L["Chaos Pup"], [39160] = L["Corrupted Thundertail"], [39162] = L["Cursed Spirit"], [39167] = L["Dark Gazer"], [39173] = L["Defiled Earth"], [39170] = L["Dreadwalker"], [39165] = L["Direflame"], [39163] = L["Felfly"], [39157] = L["Felsworn Sentry"], [39166] = L["Mirecroak"], [39171] = L["Netherfist"], [39172] = L["Skrillix"], [39164] = L["Tainted Maulclaw"], [39169] = L["Vile Blood of Draenor"], }, coords = { {m=945,x=15.8,y=44.6,q=39168,n=L["Bleakclaw"]},{m=945,x=25,y=76.2,q=39161,n=L["Chaos Pup"]},{m=945,x=53,y=65.2,q=39160,n=L["Corrupted Thundertail"]},{m=945,x=31.4,y=38,q=39162,n=L["Cursed Spirit"]},{m=945,x=54,y=29.8,q=39167,n=L["Dark Gazer"]},{m=945,x=75.4,y=37.4,q=39173,n=L["Defiled Earth"]},{m=945,x=47.2,y=52.6,q=39170,n=L["Dreadwalker"]},{m=945,x=57.8,y=37.2,q=39165,n=L["Direflame"]},{m=945,x=55.8,y=80.8,q=39163,n=L["Felfly"]},{m=945,x=26,y=31.6,q=39157,n=L["Felsworn Sentry"]},{m=945,x=42.2,y=71.6,q=39166,n=L["Mirecroak"]},{m=945,x=48.4,y=35.6,q=39171,n=L["Netherfist"]},{m=945,x=48.4,y=31.2,q=39172,n=L["Skrillix"]},{m=945,x=43.4,y=84.6,q=39164,n=L["Tainted Maulclaw"]},{m=945,x=44,y=45.8,q=39169,n=L["Vile Blood of Draenor"]}, }, },
					["Periwinkle Calf"] =                               { cat = WOD, type = PET, method = USE, name = L["Periwinkle Calf"], spellId = 187555, itemId = 127754, items = { 127751 }, chance = 33, creatureId = 93352, sourceText = L["Can drop from Fel-Touched Pet Supplies, which is obtained by defeating the Fel-corrupted legendary pets in Tanaan Jungle."], questId = { 39157, 39160, 39161, 39162, 39163, 39164, 39165, 39166, 39167, 39168, 39169, 39170, 39171, 39172, 39173, }, defeatAllQuests = true, defeatSteps = { [39168] = L["Bleakclaw"], [39161] = L["Chaos Pup"], [39160] = L["Corrupted Thundertail"], [39162] = L["Cursed Spirit"], [39167] = L["Dark Gazer"], [39173] = L["Defiled Earth"], [39170] = L["Dreadwalker"], [39165] = L["Direflame"], [39163] = L["Felfly"], [39157] = L["Felsworn Sentry"], [39166] = L["Mirecroak"], [39171] = L["Netherfist"], [39172] = L["Skrillix"], [39164] = L["Tainted Maulclaw"], [39169] = L["Vile Blood of Draenor"], }, coords = { {m=945,x=15.8,y=44.6,q=39168,n=L["Bleakclaw"]},{m=945,x=25,y=76.2,q=39161,n=L["Chaos Pup"]},{m=945,x=53,y=65.2,q=39160,n=L["Corrupted Thundertail"]},{m=945,x=31.4,y=38,q=39162,n=L["Cursed Spirit"]},{m=945,x=54,y=29.8,q=39167,n=L["Dark Gazer"]},{m=945,x=75.4,y=37.4,q=39173,n=L["Defiled Earth"]},{m=945,x=47.2,y=52.6,q=39170,n=L["Dreadwalker"]},{m=945,x=57.8,y=37.2,q=39165,n=L["Direflame"]},{m=945,x=55.8,y=80.8,q=39163,n=L["Felfly"]},{m=945,x=26,y=31.6,q=39157,n=L["Felsworn Sentry"]},{m=945,x=42.2,y=71.6,q=39166,n=L["Mirecroak"]},{m=945,x=48.4,y=35.6,q=39171,n=L["Netherfist"]},{m=945,x=48.4,y=31.2,q=39172,n=L["Skrillix"]},{m=945,x=43.4,y=84.6,q=39164,n=L["Tainted Maulclaw"]},{m=945,x=44,y=45.8,q=39169,n=L["Vile Blood of Draenor"]}, }, },
					["Savage Cub"] =                                    { cat = WOD, type = PET, method = COLLECTION, name = L["Savage Cub"], spellId = 190682, itemId = 128477, collectedItemId = 124099, chance = 1500, creatureId = 96126, obtain = L["Dropped from monsters in Fang'rila"], tooltipNpcs = { 92922, 92466, 89747, 89695, 89746, 92481, }, sourceText = L["Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."], coords = { {m=945,x=55.2,y=74.8} }, },
					["Seaborne Spore"] =                                { cat = WOD, type = PET, method = USE, name = L["Seaborne Spore"], spellId = 173544, itemId = 118105, items = { 127751 }, chance = 33, creatureId = 86718, sourceText = L["Can drop from Fel-Touched Pet Supplies, which is obtained by defeating the Fel-corrupted legendary pets in Tanaan Jungle."], questId = { 39157, 39160, 39161, 39162, 39163, 39164, 39165, 39166, 39167, 39168, 39169, 39170, 39171, 39172, 39173, }, defeatAllQuests = true, defeatSteps = { [39168] = L["Bleakclaw"], [39161] = L["Chaos Pup"], [39160] = L["Corrupted Thundertail"], [39162] = L["Cursed Spirit"], [39167] = L["Dark Gazer"], [39173] = L["Defiled Earth"], [39170] = L["Dreadwalker"], [39165] = L["Direflame"], [39163] = L["Felfly"], [39157] = L["Felsworn Sentry"], [39166] = L["Mirecroak"], [39171] = L["Netherfist"], [39172] = L["Skrillix"], [39164] = L["Tainted Maulclaw"], [39169] = L["Vile Blood of Draenor"], }, coords = { {m=945,x=15.8,y=44.6,q=39168,n=L["Bleakclaw"]},{m=945,x=25,y=76.2,q=39161,n=L["Chaos Pup"]},{m=945,x=53,y=65.2,q=39160,n=L["Corrupted Thundertail"]},{m=945,x=31.4,y=38,q=39162,n=L["Cursed Spirit"]},{m=945,x=54,y=29.8,q=39167,n=L["Dark Gazer"]},{m=945,x=75.4,y=37.4,q=39173,n=L["Defiled Earth"]},{m=945,x=47.2,y=52.6,q=39170,n=L["Dreadwalker"]},{m=945,x=57.8,y=37.2,q=39165,n=L["Direflame"]},{m=945,x=55.8,y=80.8,q=39163,n=L["Felfly"]},{m=945,x=26,y=31.6,q=39157,n=L["Felsworn Sentry"]},{m=945,x=42.2,y=71.6,q=39166,n=L["Mirecroak"]},{m=945,x=48.4,y=35.6,q=39171,n=L["Netherfist"]},{m=945,x=48.4,y=31.2,q=39172,n=L["Skrillix"]},{m=945,x=43.4,y=84.6,q=39164,n=L["Tainted Maulclaw"]},{m=945,x=44,y=45.8,q=39169,n=L["Vile Blood of Draenor"]}, }, },
					["Vibrating Arcane Crystal"] =                      { cat = WOD, type = PET, method = NPC, name = L["Vibrating Arcane Crystal"], spellId = 193572, itemId = 129216, npcs = { 98198, }, chance = 10, creatureId = 98236, questId = 40075, coords = { {m=950,x=26.2,y=34.2,n=L["Rukdug"]} }},
					["Warm Arcane Crystal"] =                           { cat = WOD, type = PET, method = NPC, name = L["Warm Arcane Crystal"], spellId = 193588, itemId = 129217, npcs = { 98199, }, chance = 10, creatureId = 98237, questId = 40073, coords = { {m=950,x=28.5,y=30.3,n=L["Pugg"]} }},
					["Zangar Spore"] =                                  { cat = WOD, type = PET, method = USE, name = L["Zangar Spore"], spellId = 173532, itemId = 118101, items = { 127751 }, chance = 33, creatureId = 86715, sourceText = L["Can drop from Fel-Touched Pet Supplies, which is obtained by defeating the Fel-corrupted legendary pets in Tanaan Jungle."], questId = { 39157, 39160, 39161, 39162, 39163, 39164, 39165, 39166, 39167, 39168, 39169, 39170, 39171, 39172, 39173, }, defeatAllQuests = true, defeatSteps = { [39168] = L["Bleakclaw"], [39161] = L["Chaos Pup"], [39160] = L["Corrupted Thundertail"], [39162] = L["Cursed Spirit"], [39167] = L["Dark Gazer"], [39173] = L["Defiled Earth"], [39170] = L["Dreadwalker"], [39165] = L["Direflame"], [39163] = L["Felfly"], [39157] = L["Felsworn Sentry"], [39166] = L["Mirecroak"], [39171] = L["Netherfist"], [39172] = L["Skrillix"], [39164] = L["Tainted Maulclaw"], [39169] = L["Vile Blood of Draenor"], }, coords = { {m=945,x=15.8,y=44.6,q=39168,n=L["Bleakclaw"]},{m=945,x=25,y=76.2,q=39161,n=L["Chaos Pup"]},{m=945,x=53,y=65.2,q=39160,n=L["Corrupted Thundertail"]},{m=945,x=31.4,y=38,q=39162,n=L["Cursed Spirit"]},{m=945,x=54,y=29.8,q=39167,n=L["Dark Gazer"]},{m=945,x=75.4,y=37.4,q=39173,n=L["Defiled Earth"]},{m=945,x=47.2,y=52.6,q=39170,n=L["Dreadwalker"]},{m=945,x=57.8,y=37.2,q=39165,n=L["Direflame"]},{m=945,x=55.8,y=80.8,q=39163,n=L["Felfly"]},{m=945,x=26,y=31.6,q=39157,n=L["Felsworn Sentry"]},{m=945,x=42.2,y=71.6,q=39166,n=L["Mirecroak"]},{m=945,x=48.4,y=35.6,q=39171,n=L["Netherfist"]},{m=945,x=48.4,y=31.2,q=39172,n=L["Skrillix"]},{m=945,x=43.4,y=84.6,q=39164,n=L["Tainted Maulclaw"]},{m=945,x=44,y=45.8,q=39169,n=L["Vile Blood of Draenor"]}, }, },     
					-- 7.0
					["Eye of Inquisition"] =                            { cat = LEGION, type = PET, method = NPC, name = L["Eye of Inquisition"], spellId = 210673, itemId = 136901, npcs = { 101878, }, chance = 100, creatureId = 97179, coords = { {m=1055,x=27.8,y=85.2} }},
     ["Knockoff Blingtron"] =                            { cat = LEGION, type = PET, method = USE, name = L["Knockoff Blingtron"], spellId = 210683, itemId = 136911, items = { 132892, }, chance = 200, creatureId = 99505, },
     --["Sting Ray Pup"] =                                 { cat = LEGION, type = PET, method = COLLECTION, name = L["Sting Ray Pup"], spellId = 217218, itemId = 138810, creatureId = 109216, collectedItemId = { 138777 }, chance = 50, },
					-- 7.1
					["Blessed Seed"] =																															   { cat = LEGION, type = PET, method = NPC, name = L["Blessed Seed"], itemId = 142091, spellId = 229098, creatureId = 115143, npcs = { 32906 }, chance = 10, statisticId = {2864, 3258}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=529,x=53.2,y=22.3,i=true}},},
					["Call of the Frozen Blade"] =										            { cat = LEGION, type = PET, method = NPC, name = L["Call of the Frozen Blade"], itemId = 142099, spellId = 229106, creatureId = 115152, npcs = { 36597 }, chance = 10,  statisticId = {4653, 4686, 4687, 4688}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=604,x=49.6,y=52.5,i=true}},},
					["Drudge Remains"] =																														  { cat = LEGION, type = PET, method = NPC, name = L["Drudge Remains"], itemId = 142098, spellId = 229105, creatureId = 115150, npcs = { 36597 }, chance = 10,  statisticId = {4653, 4686, 4687, 4688}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=604,x=49.6,y=52.5,i=true}},},
					["Fragment of Frozen Bone"] =															        { cat = LEGION, type = PET, method = NPC, name = L["Fragment of Frozen Bone"], itemId = 142094, spellId = 229101, creatureId = 115146, npcs = { 36612 }, chance = 10, repeatable = true, coords = {{m=604,x=38.9,y=59.4,i=true}},},
					["Giant Worm Egg"] =																													   { cat = LEGION, type = PET, method = NPC, name = L["Giant Worm Egg"], itemId = 142083, spellId = 229090, creatureId = 115135, npcs = { 34797 }, chance = 10, repeatable = true, coords = {{m=543,x=51.3,y=52.5,i=true}},},
					["Glittering Ball of Yarn"] =										             { cat = LEGION, type = PET, method = NPC, name = L["Glittering Ball of Yarn"], itemId = 142089, spellId = 229096, creatureId = 115141, npcs = { 33515 }, chance = 10, repeatable = true, coords = {{m=529,x=51.3,y=57.2,i=true}},},
					["Ironbound Collar"] =																							       { cat = LEGION, type = PET, method = NPC, name = L["Ironbound Collar"], itemId = 142087, spellId = 229094, creatureId = 115139, npcs = { 33186 }, chance = 10, repeatable = true, coords = {{m=529,x=54.3,y=26.5,i=true}},},
					["Magnataur Hunting Horn"] =													           { cat = LEGION, type = PET, method = NPC, name = L["Magnataur Hunting Horn"], itemId = 142084, spellId = 229091, creatureId = 115136, npcs = { 34797 }, chance = 10, repeatable = true, coords = {{m=543,x=51.3,y=52.5,i=true}},},
					["Nerubian Relic"] =																											     { cat = LEGION, type = PET, method = NPC, name = L["Nerubian Relic"], itemId = 142085, spellId = 229092, creatureId = 115137, npcs = { 34564 }, chance = 10, repeatable = true, coords = {{m=543,x=53,y=35.5,i=true}},},
					["Ominous Pile of Snow"] =																		        { cat = LEGION, type = PET, method = NPC, name = L["Ominous Pile of Snow"], itemId = 142090, spellId = 229097, creatureId = 115142, npcs = { 32845 }, chance = 10,  statisticId = {2862, 3256}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=529,x=67.1,y=63.4,i=true}},},
					["Overcomplicated Controller"] =									           { cat = LEGION, type = PET, method = NPC, name = L["Overcomplicated Controller"], itemId = 142092, spellId = 229099, creatureId = 115144, npcs = { 33350 }, chance = 10,  statisticId = {2865, 2879}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=529,x=43.8,y=40.8,i=true}},},
					["Putricide's Alchemy Supplies"] =									         { cat = LEGION, type = PET, method = NPC, name = L["Putricide's Alchemy Supplies"], itemId = 142096, spellId = 229103, creatureId = 115148, npcs = { 36678 }, chance = 10, repeatable = true, coords = {{m=604,x=12.8,y=53.1,i=true}},},
					["Red-Hot Coal"] =																															   { cat = LEGION, type = PET, method = NPC, name = L["Red-Hot Coal"], itemId = 142086, spellId = 229093,  creatureId = 115138, npcs = { 33118 }, chance = 10, repeatable = true, coords = {{m=529,x=38,y=26.5,i=true}},},
					["Remains of a Blood Beast"] =													         { cat = LEGION, type = PET, method = NPC, name = L["Remains of a Blood Beast"], itemId = 142095, spellId = 229102, creatureId = 115147, npcs = { 37813 }, chance = 10,  statisticId = {4645, 4662, 4663, 4664}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=604,x=51.5,y=21.4,i=true}},},
					["Skull of a Frozen Whelp"] =																	      { cat = LEGION, type = PET, method = NPC, name = L["Skull of a Frozen Whelp"], itemId = 142097, spellId = 229104, creatureId = 115149, npcs = { 36853 }, chance = 10, repeatable = true, coords = {{m=604,x=36.5,y=22.6,i=true}},},
					["Stormforged Rune"] =																									     { cat = LEGION, type = PET, method = NPC, name = L["Stormforged Rune"], itemId = 142088, spellId = 229095, creatureId = 115140, npcs = { 32857,32927,32867 }, chance = 10, repeatable = true, coords = {{m=529,x=15.5,y=55.9,i=true}},},
					["Wriggling Darkness"] =																								    { cat = LEGION, type = PET, method = NPC, name = L["Wriggling Darkness"], itemId = 142093, spellId = 229100, creatureId = 115145, npcs = { 33288 }, chance = 10,  statisticId = {2869, 2883}, doNotUpdateToHighestStat = true, repeatable = true, coords = {{m=529,x=68.3,y=39.8,i=true}},},
					-- 7.2
     ["Ageless Bronze Drake"] =                          { cat = LEGION, type = PET, method = USE, name = L["Ageless Bronze Drake"], spellId = 248240, itemId = 151828, items = { 151482 }, chance = 20, creatureId = 124944, coords = {{m=488,x=60,y=54.4,n=L["Chromie"]}}, },
					["Albino Buzzard"] =                                { cat = LEGION, type = PET, method = USE, name = L["Albino Buzzard"], spellId = 231017, itemId = 142448, items = { 142447 }, chance = 100, creatureId = 116080, questId = 45083, coords = {{m=11,x=63.58,y=35.94,n=L["Crysa"]}}, },
     ["Bronze Proto-Whelp"] =                            { cat = LEGION, type = PET, method = USE, name = L["Bronze Proto-Whelp"], spellId = 248025, itemId = 151829, items = { 151482 }, chance = 33, creatureId = 124858, coords = {{m=488,x=60,y=54.4,n=L["Chromie"]}}, },
					["Cavern Moccasin"] =                               { cat = LEGION, type = PET, method = USE, name = L["Cavern Moccasin"], spellId = 233333, itemId = 143754, items = { 143753 }, chance = 100, creatureId = 117182, questId = 45539, coords = {{m=11,x=38.8,y=68.2,n=L["Muyani"]}}, },
					["Everliving Spore"] =                              { cat = LEGION, type = PET, method = USE, name = L["Everliving Spore"], spellId = 233331, itemId = 143756, items = { 143753 }, chance = 100, creatureId = 117180, questId = 45539, coords = {{m=11,x=38.8,y=68.2,n=L["Muyani"]}}, },
					["Nightmare Whelpling"] =                           { cat = LEGION, type = PET, method = BOSS, name = L["Nightmare Whelpling"], spellId = 210675, itemId = 136903, creatureId = 112015, npcs = { 99999 }, tooltipNpcs = { 102679 }, chance = 100, groupSize = 10, equalOdds = true, statisticId = { 10928, 10929, 10930, 10931, }, enableCoin = true, coords = { {m=1094,f=5,i=true} }, },
					["Orphaned Felbat"] =                               { cat = LEGION, type = PET, method = USE, name = L["Orphaned Felbat"], spellId = 243136, itemId = 147841, items = { 152108 }, chance = 20, creatureId = 121715, },
     ["Scraps"] =                                        { cat = LEGION, type = PET, method = SPECIAL, name = L["Scraps"], spellId = 240064, itemId = 146953, chance = 33, creatureId = 120397, coords = {{m=1021}}, },
					["Young Venomfang"] =                               { cat = LEGION, type = PET, method = USE, name = L["Young Venomfang"], spellId = 233335, itemId = 143755, items = { 143753 }, chance = 100, creatureId = 117184, questId = 45539, coords = {{m=11,x=38.8,y=68.2,n=L["Muyani"]}}, },				

				},



				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
				-- TOYS AND ITEMS
				--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
  
				items = {
     name = L["Toys & Items"],
					-- Pickpocketing
     --["Pickpocket Test"] =                               { cat = BASE, type = ITEM, method = NPC, name = "Light Feather", itemId = 17056, npcs = { 3115, 3116, }, chance = 100, repeatable = true, pickpocket = true, }, -- Dustwind Harpy and Dustwind Pillager in Razorwind Canyon (Durotar 50 27)
					--["Decahedral Dwarven Dice"] =                       { cat = WOTLK, type = ITEM, method = NPC, name = L["Decahedral Dwarven Dice"], itemId = 36863, npcs = { 27357, 27367, 32149, }, chance = 100, pickpocket = true, },
					--["Loaded Gnomish Dice"] =                           { cat = CATA, type = ITEM, method = NPC, name = L["Loaded Gnomish Dice"], itemId = 63269, npcs = { 58612, 49124, 47595, 46320, }, chance = 300, pickpocket = true, },
					--["Worn Troll Dice"] =                               { cat = WOTLK, type = ITEM, method = NPC, name = L["Worn Troll Dice"], itemId = 36862, npcs = { 34839, 34728, 23660, 34734, 26550, 27260, 28504, 34838, 39438, 29880, 28417, 28123, 23655, 27424, 28388, }, chance = 300, pickpocket = true, },
					
					-- Toys (Holiday)
					["Blight Boar Microphone"] =                        { cat = HOLIDAY, type = ITEM, isToy = true, method = NPC, name = L["Blight Boar Microphone"], itemId = 151265, npcs = { 122899}, chance = 10, holidayTexture = CALENDAR_DARKMOONFAIRE, coords = {{m=974,x=65.6,y=67}}, questId = {47767} },
					["Coin of Many Faces"] =                            { cat = HOLIDAY, type = ITEM, isToy = true, method = NPC, name = L["Coin of Many Faces"], itemId = 128807, npcs = { 96535, 96538, 96637, 96536}, chance = 100, holidayTexture = CALENDAR_HALLOWSEND, coords = {{m=473,x=40.6,y=79.4}}, },					
					["Crashin' Thrashin' Flyer Controller"] =           { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Crashin' Thrashin' Flyer Controller"], itemId = 104318, items = { 116762 }, chance = 50, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=24,x=43.6,y=39.6} }, },
					["Crashin' Thrashin' Racer Controller"] =           { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Crashin' Thrashin' Racer Controller"], itemId = 37710, items = { 116762 }, chance = 50, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=24,x=43.6,y=39.6} }, },
					["Foot Ball"] =                                     { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Foot Ball"], itemId = 90888, items = { 116762 }, chance = 50, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=24,x=43.6,y=39.6} }, },
					["Fuzzy Green Lounge Cushion"] =                    { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Fuzzy Green Lounge Cushion"], itemId = 116692, items = { 21271, 21270, 116762 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, coords = { {m=321,x=49.1,y=78.2,h=true},{m=341,x=33.4,y=65.9,a=true}, }, },
					["MiniZep Controller"] =                            { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["MiniZep Controller"], itemId = 46709, items = { 116762 }, chance = 50, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=24,x=43.6,y=39.6} }, },
     ["Moonfang Shroud"] =                               { cat = HOLIDAY, type = ITEM, isToy = true, method = NPC, name = L["Moonfang Shroud"], itemId = 101571, npcs = { 71992, }, chance = 5, holidayTexture = CALENDAR_DARKMOONFAIRE, coords = { {m=974,x=39.8,y=44.4} }, },
     ["Moonfang's Paw"] =                                { cat = HOLIDAY, type = ITEM, isToy = true, method = NPC, name = L["Moonfang's Paw"], itemId = 105898, npcs = { 71992, }, chance = 5, holidayTexture = CALENDAR_DARKMOONFAIRE, coords = { {m=974,x=39.8,y=44.4} }, },
					["Pineapple Lounge Cushion"] =                      { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Pineapple Lounge Cushion"], itemId = 116689, items = { 21271, 21270, 116762 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, coords = { {m=321,x=49.1,y=78.2,h=true},{m=341,x=33.4,y=65.9,a=true}, }, },
					["Sack of Spectral Spiders"] =                      { cat = HOLIDAY, type = ITEM, isToy = true, method = NPC, name = L["Sack of Spectral Spiders"], itemId = 128794, npcs = { 96323, }, chance = 8, questId = 39617, holidayTexture = CALENDAR_HALLOWSEND, coords = { zoneOverride = L["Draenor Garrison"], {m=971},{m=976}, }, },
					["Safari Lounge Cushion"] =                         { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Safari Lounge Cushion"], itemId = 116690, items = { 21271, 21270, 116762 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, coords = { {m=321,x=49.1,y=78.2,h=true},{m=341,x=33.4,y=65.9,a=true}, }, },
					["Silver-Plated Turkey Shooter"] =                  { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Silver-Plated Turkey Shooter"], itemId = 116400, items = { 116404 }, chance = 33, holidayTexture = CALENDAR_PILGRIMSBOUNTY, coords = { {m=341,x=60,y=34.2,q=14048,a=true},{m=341,x=60,y=34.2,q=14051,a=true},{m=381,x=61.8,y=46.4,q=14054,a=true},{m=30,x=33.8,y=50.8,q=14055,a=true},{m=30,x=33.6,y=50.6,q=14053,a=true},{m=4,x=46.4,y=13.8,q=14061,h=true},{m=4,x=46.4,y=13.8,q=14062,h=true},{m=362,x=31,y=69.6,q=14060,h=true},{m=382,x=65.2,y=13.8,q=14058,h=true},{m=382,x=63.4,y=9,q=14059,h=true}, }, },
     ["The Heartbreaker"] =                              { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["The Heartbreaker"], itemId = 50471, items = { 54537, }, chance = 83, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."], lockDungeonId = 288, coords = { {m=764,x=40,y=52.6,i=true} }, },
					["The Pigskin"] =                                   { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["The Pigskin"], itemId = 90883, items = { 116762 }, chance = 50, holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, coords = { {m=24,x=43.6,y=39.6} }, },
					["Zhevra Lounge Cushion"] =                         { cat = HOLIDAY, type = ITEM, isToy = true, method = USE, name = L["Zhevra Lounge Cushion"], itemId = 116691, items = { 21271, 21270, 116762 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, coords = { {m=321,x=49.1,y=78.2,h=true},{m=341,x=33.4,y=65.9,a=true}, }, },
					
					-- Toys (2.x)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Orb of the Sin'dorei"] =                          { cat = TBC, type = ITEM, isToy = true, method = NPC, name = L["Orb of the Sin'dorei"], itemId = 35275, npcs = { 24664, 24744, 24723, 24560, }, chance = 60, coords = { {m=798,i=true} }, },
     ["Time-Lost Figurine"] =                            { cat = TBC, type = ITEM, isToy = true, method = NPC, name = L["Time-Lost Figurine"], itemId = 32782, npcs = { 21838, }, chance = 10, coords = { {m=478,x=66.2,y=77.6} }, },
					
					-- Toys (3.x)
     ["Frenzyheart Brew"] =                              { cat = WOTLK, type = ITEM, isToy = true, method = USE, name = L["Frenzyheart Brew"], itemId = 44719, items = { 44718, }, chance = 4, sourceText = L["Contained in Ripe Disgusting Jar, which is obtained by becoming Revered with Frenzyheart Tribe, purchasing a Disgusting Jar from their reputation vendor, and waiting three days."], coords = { {m=493,x=55,y=69} }, },
     ["Unusual Compass"] =                               { cat = WOTLK, type = ITEM, isToy = true, method = USE, name = L["Unusual Compass"], itemId = 45984, items = { 46007, }, chance = 20, coords = { {m=504,x=52.6,y=65.6} }, },
					
					-- Toys (5.x)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ai-Li's Skymirror"] =                             { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Ai-Li's Skymirror"], itemId = 86589, npcs = { 50821, }, chance = 7, coords = { {m=858,x=34.8,y=23.2} }, },
     ["Blackflame Daggers"] =                            { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Blackflame Daggers"], itemId = 104302, npcs = { 73171, }, chance = 100, coords = { {m=951,x=63.6,y=43.6} }, },
     ["Chalice of Secrets"] =                            { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Chalice of Secrets"], itemId = 86575, npcs = { 50359, }, chance = 5, coords = { {m=811,x=39.8,y=25} }, },
     ["Eternal Kiln"] =                                  { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Eternal Kiln"], itemId = 104309, npcs = { 72896, }, chance = 250, coords = { {m=951,x=68.6,y=35.2} }, },
     ["Farwater Conch"] =                                { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Farwater Conch"], itemId = 86581, npcs = { 50769, }, chance = 7, coords = { {m=809,x=74.4,y=79.2} }, },
     ["Gastropod Shell"] =                               { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Gastropod Shell"], itemId = 98136, npcs = { 68220, }, chance = 150, coords = { {m=930,f=3,x=44.4,y=80.4,i=true} }, },
     ["Hozen Beach Ball"] =                              { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Hozen Beach Ball"], itemId = 86593, npcs = { 50836, }, chance = 7, coords = { {m=858,x=55.4,y=63.4} }, },
     ["Kang's Bindstone"] =                              { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Kang's Bindstone"], itemId = 86571, npcs = { 50349, }, chance = 5, coords = { {m=811,x=15,y=35.6} }, },
     ["Mr. Smite's Brass Compass"] =                     { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Mr. Smite's Brass Compass"], itemId = 86568, npcs = { 50336, }, chance = 10, coords = { {m=811,x=87.8,y=44.6} }, },
     ["Odd Polished Stone"] =                            { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Odd Polished Stone"], itemId = 104262, npcs = { 72970, 72809, }, chance = 250, sourceText = L["This item has a 1 in 4 chance to drop from Golganarr, a rare spawn on Timeless Isle. It has a 1 in 250 chance to drop from Eroded Cliffdweller on Timeless Isle."], coords = { {m=951,x=63.4,y=60.6} }, },
     ["Pandaren Firework Launcher"] =                    { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Pandaren Firework Launcher"], itemId = 86588, npcs = { 50817, }, chance = 10, coords = { {m=809,x=40.8,y=42.4} }, },
     ["Panflute of Pandaria"] =                          { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Panflute of Pandaria"], itemId = 86586, npcs = { 50806, }, chance = 7, coords = { {m=811,x=39.4,y=53.6} }, },
     ["Rime of the Time-Lost Mariner"] =                 { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Rime of the Time-Lost Mariner"], itemId = 104294, npcs = { 73281, }, chance = 7, coords = { {m=951,x=25.8,y=23.2} }, },
     ["Warning Sign"] =                                  { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Warning Sign"], itemId = 104331, npcs = { 73169, }, chance = 100, coords = { {m=951,x=53.6,y=83} }, },
					
					-- Toys (6.x)
					["Crashin' Thrashin' Cannon Controller"] =          { cat = WOD, type = ITEM, isToy = true, method = NPC, name = L["Crashin' Thrashin' Cannon Controller"], itemId = 108633, npcs = { 98284, }, chance = 10, questId = 40106, coords = { {m=945,x=80.6,y=56.4,n=L["Gondar"]} }},
					["Crashin' Thrashin' Mortar Controller"] =          { cat = WOD, type = ITEM, isToy = true, method = NPC, name = L["Crashin' Thrashin' Mortar Controller"], itemId = 108634, npcs = { 98285, }, chance = 10, questId = 40104, coords = { {m=945,x=88.1,y=55.8,n=L["Smashum Grabb"]} }},
					["Crashin' Thrashin' Roller Controller"] =          { cat = WOD, type = ITEM, isToy = true, method = NPC, name = L["Crashin' Thrashin' Roller Controller"], itemId = 108631, npcs = { 98283, }, chance = 10, questId = 40105, coords = { {m=945,x=83.6,y=43.6,n=L["Drakum"]} }},
     ["Fandral's Seed Pouch"] =                          { cat = WOD, type = ITEM, isToy = true, method = NPC, name = L["Fandral's Seed Pouch"], itemId = 122304, npcs = { 52571, }, chance = 100, disableForClass = { ["DEATHKNIGHT"] = true, ["DEMONHUNTER"] = true, ["HUNTER"] = true, ["MAGE"] = true, ["MONK"] = true, ["PALADIN"] = true, ["PRIEST"] = true, ["ROGUE"] = true, ["SHAMAN"] = true, ["WARLOCK"] = true, ["WARRIOR"] = true }, sourceText = L["Will only drop for druids."], coords = { {m=800,f=2,x=50.9,y=72.4,i=true} }, },

					-- Toys (7.x) -- some of these are toy conversions in 7.x but I marked them as the expansion they came out in
					["Aqua Jewel"] =                                    { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Aqua Jewel"], itemId = 86582, npcs = { 50780, }, chance = 10, coords = { {m=811,x=69.6,y=30.8,n=L["Sahn Tidehunter"]} }},
     ["Arcano-Shower"] =                                 { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Arcano-Shower"], itemId = 141297, chance = 33, questId = 43943, coords = {{m=1033}} },
					["Ash-Covered Horn"] =                              { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Ash-Covered Horn"], itemId = 104329, npcs = { 72898, }, chance = 72, coords = { {m=951,x=35,y=32.4,n=L["High Priest of Ordos"]},{m=951,x=45,y=26,n=L["High Priest of Ordos"]},{m=951,x=50.6,y=23.4,n=L["High Priest of Ordos"]},{m=951,x=57.6,y=26.4,n=L["High Priest of Ordos"]},{m=951,x=49.6,y=33.6,n=L["High Priest of Ordos"]},{m=951,x=56.6,y=34.2,n=L["High Priest of Ordos"]} }},
					["Battle Horn"] =                                   { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Battle Horn"], itemId = 86565, npcs = { 51059, }, chance = 5, coords = { {m=807,x=32.8,y=62.8,n=L["Blackhoof"]},{m=807,x=34.6,y=59.6,n=L["Blackhoof"]},{m=807,x=37.8,y=60.6,n=L["Blackhoof"]},{m=807,x=39.6,y=57.6,n=L["Blackhoof"]} }}, -- Ordon Candlekeeper drops the Battle Horn too with a 0.5% chance
					["Bottled Tornado"] =                               { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Bottled Tornado"], itemId = 134023, npcs = { 50749, }, chance = 5, coords = { {m=811,x=14,y=58.6,n=L["Kal'tik the Blight"]} }},
					["Burgy Blackheart's Handsome Hat"] =               { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Burgy Blackheart's Handsome Hat"], itemId = 134022, npcs = { 50052, }, chance = 100, coords = { {m=615,x=57.6,y=69.8} }},
					["Chain Pet Leash"] =                               { cat = LEGION, type = ITEM, isToy = true, method = USE, name = L["Chain Pet Leash"], itemId = 89139, items = { 89125, 93148, 93147, 93146, 93149, 94207, 91086, 116062, 98095 }, chance = 2, },
     ["Displacer Meditation Stone"] =                    { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Displacer Meditation Stone"], itemId = 141298, chance = 33, questId = 43943, coords = {{m=1033}} },
					["Don Carlos' Famous Hat"] =                        { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Don Carlos' Famous Hat"], itemId = 134019, npcs = { 28132, }, chance = 10, coords = { {m=734,x=45.4,y=55.6} }},
					["Essence of the Breeze"] =                         { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Essence of the Breeze"], itemId = 86590, npcs = { 50822, }, chance = 5, coords = { {m=811,x=42.6,y=69.0,n=L["Ai-Ran the Shifting Cloud"]} }},
					["Eternal Warrior's Sigil"] =                       { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Eternal Warrior's Sigil"], itemId = 86578, npcs = { 50739, }, chance = 7, coords = { {m=858,x=35.6,y=30.8,n=L["Gar'lok"]},{m=858,x=37.8,y=29.6,n=L["Gar'lok"]},{m=858,x=39.2,y=41.8,n=L["Gar'lok"]} }},
					["Faintly Glowing Flagon of Mead"] =                { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Faintly Glowing Flagon of Mead"], itemId = 129113, npcs = { 91892, }, chance = 20, coords = { {m=1037,x=41,y=72} }},
					["Goren \"Log\" Roller"] =                          { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Goren \"Log\" Roller"], itemId = 119180, npcs = { 87352, }, chance = 7, questId = 37380, coords = { {m=941,x=66.6,y=25.4,n=L["Gibblette the Cowardly"]} }},
					["Hardened Shell"] =                                { cat = MOP, type = ITEM, isToy = true, method = NPC, name = L["Hardened Shell"], itemId = 86584, npcs = { 50789, }, chance = 6, coords = { {m=809,x=63.8,y=13.8,n=L["Nessos the Oracle"]} }}, -- Chelon and Great Turtle Furyshell drop the shell too with a 1.7% chance
					["Helpful Wikky's Whistle"] =                       { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Helpful Wikky's Whistle"], itemId = 86594, npcs = { 50840, }, chance = 5, coords = { {m=811,x=31,y=91.6,n=L["Major Nanners"]} }},
					["Kaldorei Light Globe"] =                          { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Kaldorei Light Globe"], itemId = 141299, chance = 33, questId = 43943, coords = {{m=1033}} },
					["Ley Spider Eggs"] =                               { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Ley Spider Eggs"], itemId = 140786, chance = 33, questId = 43943, coords = {{m=1033}} },
					["Salyin Battle Banner"] =                          { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Salyin Battle Banner"], itemId = 86583, npcs = { 50783, }, chance = 7, coords = { {m=807,x=67.6,y=60,n=L["Salyin Warscout"]},{m=807,x=71,y=52.4,n=L["Salyin Warscout"]},{m=807,x=75.8,y=46.4,n=L["Salyin Warscout"]} }},
					["Sassy Imp"] =                                     { cat = LEGION, type = ITEM, isToy = true, method = NPC, name = L["Sassy Imp"], itemId = 127655, npcs = { 90429, }, chance = 3, questId = 38026, coords = { {m=945,x=31.6,y=72.8,n=L["Imp-Master Valessa"]} }},
					["Sira's Extra Cloak"] =                            { cat = LEGION, type = ITEM, isToy = true, method = USE, name = L["Sira's Extra Cloak"], itemId = 147843, items = { 152107 }, chance = 20, },
					["Unstable Powder Box"] =                           { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Unstable Powder Box"], itemId = 141301, chance = 33, questId = 43943, coords = {{m=1033}} },
					["Wisp in a Bottle"] =                              { cat = LEGION, type = ITEM, isToy = true, method = SPECIAL, name = L["Wisp in a Bottle"], itemId = 141306, chance = 33, questId = 43943, coords = {{m=1033}} },

					-- Mount-related items (5.x)
     ["Primal Egg"] =                                    { cat = MOP, type = ITEM, method = NPC, name = L["Primal Egg"], itemId = 94295, npcs = { 69983, 69991, 69992, 69993, 70004, 70005, 70006, 70007, 70008, 70009, 70010, 70011, 70012, 70013, 70014, 70015, 70016, 70017, 70018, 70019, 70020, 70021, }, chance = 100, repeatable = true, unique = true, sourceText = L["Dropped by dinosaurs on Isle of Giants Will hatch into one of three Primal Raptor mounts after three days."], coords = { {m=929} }, },
     ["Skyshard"] =                                      { cat = MOP, type = ITEM, method = ZONE, name = L["Skyshard"], spellId = 90655, itemId = 86547, zones = { "811" }, chance = 1000, repeatable = true, sourceText = L["Dropped by any mob in Vale of Eternal Blossoms (except minor mobs). 10 of these can be combined to pierce Alani's shield, allowing combat and a guaranteed drop of Reins of the Thundering Ruby Cloud Serpent."], coords = { {m=811} }, },
     
					-- Battle pet-related items
     ["Mr. Pinchy"] =                                    { cat = TBC, type = ITEM, method = FISHING, name = L["Mr. Pinchy"], spellId = 33050, itemId = 27388, zones = { "Lake Jorune", "Lake Ere'Noru", "Skethyl Mountains", "Blackwind Landing", "Blackwind Valley", "Skettis", "Blackwind Lake", "Veil Harr'ik", "Veil Ala'rak", "Terokk's Rest" }, chance = 500, requiresPool = true, creatureId = 18839, sourceText = L["Obtained by fishing in pools located in Terrokar Forest"], coords = { {m=478} }, },
     
					-- Achievements
     ["Old Crafty"] =                                    { cat = TBC, type = ITEM, method = FISHING, name = L["Old Crafty"], itemId = 34486, zones = { "321" }, chance = 10000, requiresPool = false, achievementId = 1836, sourceText = L["Obtained by fishing in any water in Orgrimmar"], coords = { {m=321} }, },
     ["Old Ironjaw"] =                                   { cat = TBC, type = ITEM, method = FISHING, name = L["Old Ironjaw"], itemId = 34484, zones = { "341" }, chance = 10000, requiresPool = false, achievementId = 1837, sourceText = L["Obtained by fishing in any water in Ironforge"], coords = { {m=341} }, },
     --["Stat Test"] = { type = MOUNT, method = BOSS, name = "Stat Test", spellId = -1, itemId = -1, npcs = { 99999 }, chance = 100, groupSize = 40, equalOdds = true, statisticId = { 107 } },    }, -- Killing any creature
				},



    user = {
     name = L["Custom"],
     --["Test 1"] =      { type = PET, method = NPC, name = "Test 1", spellId = 10682, itemId = 25467, npcs = { 16520, 16516 }, chance = 100, repeatable = true, },
    },

   }, -- groups

		}, -- profile
	} -- self.defaults

	self.PrepareDefaults = nil
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
			**- Fishing nodes (GatherMate2/Constants.lua)
			**- Mining nodes
			XX- NO LONGER: New zones for Sea Turtle (http://wowpedia.org/MapID) (they stopped putting it in new expansions starting with Warlords of Draenor)
			
			APIs:
			**- Check if NPC ID format changed
			**- Check if instance difficulty API or IDs changed
			**- Check if COMBAT_LOG_EVENT_UNFILTERED changed
			**- Check for other API changes (i.e. http://wowpedia.org/Patch_6.0.1/API_changes)
			
			Other:
			**- Good-luck coins
			**- New Archaeology races: /run for race_id = 1, GetNumArchaeologyRaces() do Rarity:Print("race_id: "..race_id.." | "..GetArchaeologyRaceInfo(race_id)) end
			**- Add a new category icon for the expansion
			**- If a new class was added, add it to the list at the top of Options.lua in the Options module
			
]]--


