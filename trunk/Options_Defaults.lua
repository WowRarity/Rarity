if not Rarity then return end
local R = Rarity
local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")

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

-- Archaeology races
R.string_archraces = {
 [1] = L["Dwarf"],
 [2] = L["Draenei"],
 [3] = L["Fossil"],
 [4] = L["Night Elf"],
 [5] = L["Nerubian"],
 [6] = L["Orc"],
 [7] = L["Tol'vir"],
 [8] = L["Troll"],
 [9] = L["Vrykul"],
 [10] = L["Mantid"],
	[11] = L["Pandaren"],
	[12] = L["Mogu"],
	[13] = L["Arakkoa"],
	[14] = L["Draenor Clans"],
	[15] = L["Ogre"],
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
}
R.catOrder = {
 [HOLIDAY] = 0,
 [BASE] = 1,
 [TBC] = 2,
 [WOTLK] = 3,
 [CATA] = 4,
 [MOP] = 5,
 [WOD] = 6,
}



function R:PrepareDefaults()

	self.defaults = {
		profile = {
			minimap = { hide = true },

   enableAnnouncements = true,
   feedText = FEED_NORMAL,
   statusTip = TIP_LEFT,
   sortMode = SORT_NAME,
			hideHighChance = false,
			enableTooltipAdditions = true,
			blankLineBeforeTooltipAdditions = true,
			tooltipAttempts = true,
			takeScreenshot = true,
			hideUnavailable = true,
			holidayReminder = true,
			showCategoryIcons = false,
			tooltipScale = GameTooltip:GetScale(),
			enableProfiling = false,

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
				[HOLIDAY] = true,
			},

			-- These are achievements with the names of rare NPCs as criteria to kill
			achNpcs = {
				1312, -- Bloody Rare
				2257, -- Frostbitten
				7439, -- Glorious!
				9400, -- Gorgrond Monster Hunter
			},

			-- These are inventory items that may result in another item that Rarity would like to make you aware of
			extraTooltips = {
				inventoryItems = {
					[94295] = { 94292, 94293, 94291, }, -- Primal Egg: Reins of the Black Primal Raptor, Reins of the Green Primal Raptor, Reins of the Red Primal Raptor
					[94288] = { 94290, }, -- Giant Dinosaur Bone: Reins of the Bone-White Primal Raptor
					[86547] = { 90655, }, -- Skyshard: Reins of the Thundering Ruby Cloud Serpent
					[86546] = { 90655, }, -- Sky Crystal: Reins of the Thundering Ruby Cloud Serpent
					--[6948] = { 6948, }, -- Hearthstone: Hearthstone [this is for testing extraTooltips]
				},
			},

			-- These are items with a 100% drop rate from various mobs; many of them only drop the first time and include a tracking quest
			oneTimeItems = {
	   -- [NPCID] = { questId = QUESTID, itemId = ITEMID }, -- NPC Name

				-- Test item(s)
				--[65432] = { questId = 0--[[31676]], itemId = 102248   }, -- Kyparite Pulverizer (in The Dread Wastes)




				---------------------------------------------------------------------------------------
				-- MISTS OF PANDARIA
				---------------------------------------------------------------------------------------

				[64403] = { itemId = 90655  }, -- Alani <The Stormborn> (Vale of Eternal Blossoms)
				[59369] = { itemId = 88566  }, -- Doctor Theolen Krastinov <The Butcher> (Scholomance)



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
				[79065] = { questId = 34519, itemId = 99999  }, -- Brotoculus
				[71721] = { questId = 32941, itemId = 101436 }, -- Canyon Icemother
				[80242] = { questId = 34843, itemId = 111953 }, -- Chillfang
				[72294] = { questId = 33014, itemId = 111490 }, -- Cindermaw
				[77513] = { questId = 34129, itemId = 112066 }, -- Coldstomp the Griever
				[76914] = { questId = 34131, itemId = 111484 }, -- Coldtusk
				[78621] = { questId = 34477, itemId = 112086 }, -- Cyclonic Fury
				[71670] = { questId = 32920, itemId = 99999  }, -- Deathtoll
				[74971] = { questId = 33504, itemId = 107661 }, -- Firefury Giant
				[79033] = { questId = 34517, itemId = 99999  }, -- Gargantuan Frostbeak
				[71665] = { questId = 32918, itemId = 111530 }, -- Giant-Slayer Kul
				[78337] = { questId = 34382, itemId = 99999  }, -- Grand Warlock Duress
				[74585] = { questId = 33011, itemId = 106899 }, -- Grizzled Frostwolf Veteran
				[80312] = { questId = 34865, itemId = 112077 }, -- Grutush the Pillager
				[80190] = { questId = 34825, itemId = 111948 }, -- Gruuk
				[80235] = { questId = 34839, itemId = 111955 }, -- Gurun
				[87348] = { questId = 37382, itemId = 99999  }, -- Hoarfrost
				[78151] = { questId = 34130, itemId = 99999  }, -- Huntmaster Kuang
				[82616] = { questId = 37386, itemId = 119390 }, -- Jabberjaw
				[87600] = { questId = 37556, itemId = 99999  }, -- Jaluk the Pacifist
				[79678] = { questId = 34708, itemId = 112078 }, -- Jehil the Climber
				[84374] = { questId = 37404, itemId = 99999  }, -- Kaga the Ironbender
				[78872] = { questId = 34498, itemId = 116125 }, -- Klikixx
				[87622] = { questId = 37402, itemId = 99999  }, -- Ogom the Mangler
				[78606] = { questId = 34470, itemId = 111666 }, -- Pale Fishmonger
				[76918] = { questId = 33938, itemId = 111576 }, -- Primalist Mur'og
				[84392] = { questId = 37401, itemId = 119359 }, -- Ragore Driftstalker
				[77526] = { questId = 34132, itemId = 112094 }, -- Scout Goreseeker
				[82620] = { questId = 37383, itemId = 119399 }, -- Son of Goramal
				[77527] = { questId = 34133, itemId = 111475 }, -- The Beater
				[78265] = { questId = 34361, itemId = 111534 }, -- The Bone Crawler
				[82618] = { questId = 37384, itemId = 119379 }, -- Tor'goroth
				[79104] = { questId = 34522, itemId = 99999  }, -- Ug'lok the Frozen
				[87357] = { questId = 37378, itemId = 99999  }, -- Valkor
				[87356] = { questId = 37379, itemId = 99999  }, -- Vrok the Ancient
				[79145] = { questId = 34559, itemId = 111477 }, -- Yaga the Scarred
				-- Gorgrond
				[82085] = { questId = 35335, itemId = 118222 }, -- Bashiok
				[86257] = { questId = 37369, itemId = 119432 }, -- Basten
				[85907] = { questId = 36597, itemId = 118232 }, -- Berthora
				[77739] = { questId = 34197, itemId = 99999  }, -- Bloodbloom the Colossus
				[82311] = { questId = 35503, itemId = 118212 }, -- Char the Burning
				[85250] = { questId = 36387, itemId = 118221 }, -- Fossilwood the Petrified
				[81038] = { questId = 36391, itemId = 118230 }, -- Gelgor of the Blue Flame
				[80868] = { questId = 36204, itemId = 118229 }, -- Glut
				[84431] = { questId = 36186, itemId = 118210 }, -- Greldrok the Cunning
				[88583] = { questId = 37375, itemId = 119414 }, -- Grove Warden Yal
				[83522] = { questId = 35908, itemId = 118209 }, -- Hive Queen Skrikka
				[88672] = { questId = 37377, itemId = 119412 }, -- Hunter Bal'ra
				[77609] = { questId = 34162, itemId = 99999  }, -- Icklarv
				[77562] = { questId = 34143, itemId = 99999  }, -- Kal'rak the Drunk
				[84406] = { questId = 36178, itemId = 118709 }, -- Mandrakor
				[77633] = { questId = 34170, itemId = 99999  }, -- Moltnar
				[76473] = { questId = 34726, itemId = 118208 }, -- Mother Araneae
				[77492] = { questId = 34127, itemId = 99999  }, -- Mother Bloodtusk
				[77593] = { questId = 34160, itemId = 99999  }, -- Nixxie
				[77876] = { questId = 34243, itemId = 99999  }, -- Rak'nar Muzzlebash
				[85970] = { questId = 36600, itemId = 118231 }, -- Riptar
				[85264] = { questId = 36393, itemId = 118211 }, -- Rolkor
				[86520] = { questId = 36837, itemId = 118228 }, -- Stompalupagus
				[79629] = { questId = 35910, itemId = 118224 }, -- Stomper Kreego
				[77622] = { questId = 34168, itemId = 99999  }, -- Stormwave
				[80725] = { questId = 36394, itemId = 114227 }, -- Sulfurious
				[86137] = { questId = 36656, itemId = 118223 }, -- Sunclaw
				[88582] = { questId = 37374, itemId = 119367 }, -- Swift Onyx Flayer
				[86410] = { questId = 36794, itemId = 118213 }, -- Sylldross
				[77861] = { questId = 34231, itemId = 99999  }, -- Tanoboa
				[77661] = { questId = 34191, itemId = 99999  }, -- Un'glok Blackfinger
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
				[84911] = { questId = 37351, itemId = 99999  }, -- Demidos
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
				[77136] = { questId = 33057, itemId = 99999  }, -- Rotbelcher
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
				[84935] = { questId = 36303, itemId = 99999  }, -- Eyeless
				[84890] = { questId = 36297, itemId = 118200 }, -- Festerbloom
				[86978] = { questId = 36943, itemId = 118696 }, -- Gaze
				[84951] = { questId = 36305, itemId = 116836 }, -- Gobblefin
				[84943] = { questId = 36304, itemId = 99999  }, -- Gochar
				[86724] = { questId = 36887, itemId = 118279 }, -- Hermit Palefur
				[84955] = { questId = 36306, itemId = 118202 }, -- Jiasska the Sporegorger
				[84810] = { questId = 36268, itemId = 118735 }, -- Kalos the Bloodbathed
				[84417] = { questId = 36396, itemId = 118206 }, -- Mutafen
				[82247] = { questId = 36129, itemId = 116837 }, -- Nas Dunberlin
				[79959] = { questId = 36479, itemId = 99999  }, -- Nightmaw
				[82303] = { questId = 35481, itemId = 99999  }, -- Nizzix Missfire
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
				[85572] = { questId = 36919, itemId = 99999  }, -- Grrbrrgle
				[83019] = { questId = 37340, itemId = 119402 }, -- Gug'tol
				[83008] = { questId = 37312, itemId = 119403 }, -- Haakun the All-Consuming
				[77715] = { questId = 34185, itemId = 116124 }, -- Hammertooth
				[77626] = { questId = 34167, itemId = 112369 }, -- Hen-Mother Hami
				[77453] = { questId = 34134, itemId = 117563 }, -- Isaari
				[77750] = { questId = 34199, itemId = 99999  }, -- Kaavu the Crimson Claw
				[78710] = { questId = 35219, itemId = 116122 }, -- Kharazos the Triumphant
				[88494] = { questId = 37342, itemId = 119385 }, -- Legion Vanguard
				[77784] = { questId = 34208, itemId = 116070 }, -- Lo'marg Jawcrusher
				[82998] = { questId = 37349, itemId = 119353 }, -- Matron of Sin
				[79334] = { questId = 34859, itemId = 116077 }, -- No'losh
				[77452] = { questId = 34128, itemId = 99999  }, -- Norana Quelldawn
				[77741] = { questId = 34196, itemId = 116112 }, -- Ra'kahn
				[79543] = { questId = 34671, itemId = 112370 }, -- Shirzir
				[78715] = { questId = 35219, itemId = 116122 }, -- Sikthiss, Maiden of Slaughter
				[81766] = { questId = 35244, itemId = 99999  }, -- Skagg
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
			},

			-- For instanceDifficulties, see: http://wowprogramming.com/docs/api/GetInstanceInfo

   groups = {

    mounts = {
     name = L["Mounts"],

					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
     -- Soloable (some of these may be challenging to solo for certain classes, but in general they should be soloable)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					-- 1.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Deathcharger's Reins"] =                          { cat = BASE, type = MOUNT, method = NPC, name = GetItemInfo(13335) or L["Deathcharger's Reins"], spellId = 17481, itemId = 13335, npcs = { 99999 }, tooltipNpcs = { 45412 }, chance = 100, statisticId = { 1097 }, bonusSatchel = true, blackMarket = true, lockBossName = "Lord Aurius Rivendare", },
     ["Red Qiraji Resonating Crystal"] =                 { cat = BASE, type = MOUNT, method = NPC, name = GetItemInfo(21321) or L["Red Qiraji Resonating Crystal"], spellId = 26054, itemId = 21321, npcs = { 15311, 15250, 15247, 15246, 15264, 15262, 15277, 15312, 15252, 15249 }, chance = 100, },
					-- 2.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ashes of Al'ar"] =                                { cat = TBC, type = MOUNT, method = BOSS, name = GetItemInfo(32458) or L["Ashes of Al'ar"], spellId = 40192, itemId = 32458, npcs = { 99999 }, tooltipNpcs = { 19622 }, chance = 100, statisticId = { 1088 }, blackMarket = true, },
     ["Fiery Warhorse's Reins"] =                        { cat = TBC, type = MOUNT, method = NPC, name = GetItemInfo(30480) or L["Fiery Warhorse's Reins"], spellId = 36702, itemId = 30480, npcs = { 16152 }, chance = 100, blackMarket = true, lockBossName = "Attumen the Huntsman", },
     ["Reins of the Raven Lord"] =                       { cat = TBC, type = MOUNT, method = NPC, name = GetItemInfo(32768) or L["Reins of the Raven Lord"], spellId = 41252, itemId = 32768, npcs = { 23035 }, chance = 67, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, }, bonusSatchel = true, blackMarket = true, lockBossName = "Anzu", },
     ["Swift White Hawkstrider"] =                       { cat = TBC, type = MOUNT, method = NPC, name = GetItemInfo(35513) or L["Swift White Hawkstrider"], spellId = 46628, itemId = 35513, npcs = { 24664 }, chance = 33, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, }, sourceText = L["Heroic difficulty"], bonusSatchel = true, blackMarket = true, lockBossName = "Kael'thas Sunstrider", },
					-- 3.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Invincible's Reins"] =                            { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(50818) or L["Invincible's Reins"], spellId = 72286, itemId = 50818, npcs = { 99999 }, tooltipNpcs = { 36597 }, chance = 100, instanceDifficulties = { --[[ Heroic 25-man (legacy) ]] [6] = true, }, statisticId = { 4688 }, sourceText = L["25-player heroic"], blackMarket = true, wasGuaranteed = true, lockBossName = "The Lich King", },
     ["Mimiron's Head"] =                                { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(45693) or L["Mimiron's Head"], spellId = 63796, itemId = 45693, npcs = { 33288 }, chance = 100, instanceDifficulties = { --[[ 25-man (legacy) ]] [4] = true, }, sourceText = L["Dropped by Yogg-Saron in Ulduar (25-player) with no Keepers assisting"], wasGuaranteed = true, blackMarket = true, lockBossName = "Yogg-Saron", },
     ["Reins of the Azure Drake"] =                      { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(43952) or L["Reins of the Azure Drake"], spellId = 59567, itemId = 43952, npcs = { 99999 }, tooltipNpcs = { 28859 }, chance = 100, statisticId = { 1391, 1394 }, sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"], blackMarket = true, lockBossName = "Malygos", },
     ["Reins of the Blue Drake"] =                       { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(43953) or L["Reins of the Blue Drake"], spellId = 59568, itemId = 43953, npcs = { 99999 }, tooltipNpcs = { 28859 }, chance = 100, statisticId = { 1391, 1394 }, sourceText = L["Dropped by Malygos in The Eye of Eternity (any raid size)"], bonusSatchel = true, blackMarket = true, lockBossName = "Malygos", },
     ["Reins of the Blue Proto-Drake"] =                 { cat = WOTLK, type = MOUNT, method = NPC, name = GetItemInfo(44151) or L["Reins of the Blue Proto-Drake"], spellId = 59996, itemId = 44151, npcs = { 26693 }, chance = 77, instanceDifficulties = { --[[ Heroic 5-man ]] [2] = true, }, sourceText = L["Heroic difficulty"], bonusSatchel = true, blackMarket = true, lockBossName = "Skadi the Ruthless", },
     ["Reins of the Grand Black War Mammoth Alliance"] = { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(43959) or L["Reins of the Grand Black War Mammoth"], spellId = 61465, itemId = 43959, npcs = { 99999 }, tooltipNpcs = { 35013, 33993, 31125, 38433 }, chance = 100, requiresAlliance = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, sourceText = L["Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."], lockBossName = "Archavon the Stone Watcher", },
     ["Reins of the Grand Black War Mammoth Horde"] =    { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(44083) or L["Reins of the Grand Black War Mammoth"], spellId = 61467, itemId = 44083, npcs = { 99999 }, tooltipNpcs = { 35013, 33993, 31125, 38433 }, chance = 100, requiresHorde = true, statisticId = { 1753, 1754, 2870, 3236, 4074, 4075, 4657, 4658 }, sourceText = L["Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."], lockBossName = "Archavon the Stone Watcher", },
     ["Reins of the Green Proto-Drake"] =                { cat = WOTLK, type = MOUNT, method = USE, name = GetItemInfo(44707) or L["Reins of the Green Proto-Drake"], spellId = 61294, itemId = 44707, items = { 39883 }, chance = 20, sourceText = L["Contained in Cracked Egg, which is obtained by becoming Revered with The Oracles, purchasing a Mysterious Egg from their reputation vendor, and waiting three days. The mount has a 5% chance to appear in the Cracked Egg."], bonusSatchel = true, blackMarket = true, },
     ["Reins of the Onyxian Drake"] =                    { cat = WOTLK, type = MOUNT, method = BOSS, name = GetItemInfo(49636) or L["Reins of the Onyxian Drake"], spellId = 69395, itemId = 49636, npcs = { 99999 }, tooltipNpcs = { 10184 }, chance = 100, statisticId = { 1098 }, sourceText = L["Any raid size"], blackMarket = true, lockBossName = "Onyxia", },
     ["Reins of the White Polar Bear"] =                 { cat = WOTLK, type = MOUNT, method = USE, name = GetItemInfo(43962) or L["Reins of the White Polar Bear"], spellId = 54753, itemId = 43962, items = { 44751, 69903 }, chance = 33, sourceText = L["Contained in Hyldnir Spoils, which is rewarded for completing daily quests given by Gretta the Arbiter in Brunnhildar Village, Storm Peaks. The mount has a 3% chance to appear in Hyldnir Spoils."], bonusSatchel = true, blackMarket = true, },
     ["Sea Turtle"] =                                    { cat = WOTLK, type = MOUNT, method = FISHING, name = GetItemInfo(46109) or L["Sea Turtle"], spellId = 64731, itemId = 46109, zones = { "490", "510", "488", "491", "486", "493", "709", "700", "720", "640", "606", "857", "806", "807", "809", "811", "858", "810", "823", "951", "929", "928", "873", --[[ WoD ]] --[["962", "978", "941", "976", "949", "971", "950", "947", "948", "1009", "946", "945", "970", "1011",]] }, chance = 10000, requiresPool = true, sourceText = L["Obtained very rarely by fishing in pools located in any expansion zone (not Classic zones)"], },
					-- 4.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Armored Razzashi Raptor"] =                       { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(68823) or L["Armored Razzashi Raptor"], spellId = 96491, itemId = 68823, npcs = { 52151 }, chance = 100, sourceText = L["Heroic difficulty"], lockBossName = "Bloodlord Mandokir", },
     ["Experiment 12-B"] =                               { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(78919) or L["Experiment 12-B"], spellId = 110039, itemId = 78919, npcs = { 99999 }, tooltipNpcs = { 55294 }, chance = 100, statisticId = { 6161, 6162 }, sourceText = L["Dropped by Ultraxion in Dragon Soul (any raid size or difficulty)"], lockBossName = "Ultraxion", },
     ["Flametalon of Alysrazor"] =                       { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(71665) or L["Flametalon of Alysrazor"], spellId = 101542, itemId = 71665, npcs = { 99999 }, tooltipNpcs = { 52530 }, chance = 100, statisticId = { 5970, 5971 }, sourceText = L["Any raid size or difficulty"], blackMarket = true, lockBossName = "Alysrazor", },
     ["Fossilized Raptor"] =                             { cat = CATA, type = MOUNT, method = ARCH, name = GetItemInfo(60954) or L["Fossilized Raptor"], spellId = 84751, itemId = 60954, raceId = 3, chance = 30, sourceText = L["Obtained as a rare project for the Fossil branch of archaeology"], },
     ["Life-Binder's Handmaiden"] =                      { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(77069) or L["Life-Binder's Handmaiden"], spellId = 107845, itemId = 77069, npcs = { 99999 }, chance = 100, statisticId = { 6168 }, sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (heroic, any raid size)"], wasGuaranteed = true, blackMarket = true, lockBossName = "Madness of Deathwing", },
     ["Reins of the Blazing Drake"] =                    { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(77067) or L["Reins of the Blazing Drake"], spellId = 107842, itemId = 77067, npcs = { 99999 }, chance = 100, statisticId = { 6167, 6168 }, sourceText = L["Dropped by the Madness of Deathwing encounter in Dragon Soul (any raid size or difficulty)"], blackMarket = true, lockBossName = "Madness of Deathwing", },
     ["Reins of the Drake of the North Wind"] =          { cat = CATA, type = MOUNT, method = NPC, name = GetItemInfo(63040) or L["Reins of the Drake of the North Wind"], spellId = 88742, itemId = 63040, npcs = { 43873 }, chance = 100, sourceText = L["Any difficulty"], blackMarket = true, },
     ["Reins of the Drake of the South Wind"] =          { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(63041) or L["Reins of the Drake of the South Wind"], spellId = 88744, itemId = 63041, npcs = { 99999 }, tooltipNpcs = { 46753 }, chance = 100, statisticId = { 5576, 5577 }, sourceText = L["Any raid size or difficulty"], blackMarket = true, lockBossName = "Al'Akir", },
     ["Reins of the Grey Riding Camel"] =                { cat = CATA, type = MOUNT, method = SPECIAL, name = GetItemInfo(63046) or L["Reins of the Grey Riding Camel"], spellId = 88750, itemId = 63046, chance = 20, sourceText = L["Guaranteed drop from Dormus the Camel-Hoarder. Accessing this encounter requires finding a rare Mysterious Camel Figurine in Uldum. These are difficult to spot and, when clicked, have a small chance to grant you access to the Dormus encounter. Rarity will count how many Figurines you've found if you mouseover them."], },
     ["Reins of the Vitreous Stone Drake"] =             { cat = CATA, type = MOUNT, method = NPC, name = GetItemInfo(63043) or L["Reins of the Vitreous Stone Drake"], spellId = 88746, itemId = 63043, npcs = { 43214 }, chance = 100, sourceText = L["Any difficulty"], blackMarket = true, },
     ["Scepter of Azj'Aqir"] =                           { cat = CATA, type = MOUNT, method = ARCH, name = GetItemInfo(64883) or L["Scepter of Azj'Aqir"], spellId = 92155, itemId = 64883, raceId = 7, chance = 500, sourceText = L["Obtained as a very rare project for the Tol'vir branch of archaeology"], },
     ["Smoldering Egg of Millagazor"] =                  { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(69224) or L["Smoldering Egg of Millagazor"], spellId = 97493, itemId = 69224, npcs = { 99999 }, tooltipNpcs = { 52409 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 100, statisticId = { 5976, 5977 }, sourceText = L[""], wasGuaranteed = true, blackMarket = true, lockBossName = "Ragnaros", },
     ["Swift Zulian Panther"] =                          { cat = CATA, type = MOUNT, method = BOSS, name = GetItemInfo(68824) or L["Swift Zulian Panther"], spellId = 96499, itemId = 68824, npcs = { 52059 }, chance = 100, sourceText = L["Heroic difficulty"], lockBossName = "High Priestess Kilnara", },
					-- 5.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
					["Reins of the Amber Primordial Direhorn"] =        { cat = MOP, type = MOUNT, method = NPC, name = GetItemInfo(94230) or L["Reins of the Amber Primordial Direhorn"], spellId = 138424, itemId = 94230, npcs = { 69841 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], },
     ["Reins of the Bone-White Primal Raptor"] =         { cat = MOP, type = MOUNT, method = COLLECTION, name = GetItemInfo(94290) or L["Reins of the Bone-White Primal Raptor"], spellId = 138640, itemId = 94290, collectedItemId = 94288, chance = 9999, obtain = L["Dropped from dinosaurs on Isle of Giants"], tooltipNpcs = { 69992, 70013, 70012, 70015, 70014, 70006, 69925, 69993, 70004, 70005, 70007, 70020, 70016, 69983, 70017, 70019, 70018, 70011, 70009, 69991, 70021, 70010, 70008, }, sourceText = L["Earned by giving 9999 Giant Dinosaur Bones to Ku'ma on Isle of Giants. Giant Dinosaur bones drop from all dinosaurs and Zandalari Dinomancers on Isle of Giants."], },
     ["Reins of the Jade Primordial Direhorn"] =         { cat = MOP, type = MOUNT, method = NPC, name = GetItemInfo(94231) or L["Reins of the Jade Primordial Direhorn"], spellId = 138426, itemId = 94231, npcs = { 69842 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], },
     ["Reins of the Slate Primordial Direhorn"] =        { cat = MOP, type = MOUNT, method = NPC, name = GetItemInfo(94229) or L["Reins of the Slate Primordial Direhorn"], spellId = 138425, itemId = 94229, npcs = { 69769 }, chance = 20, sourceText = L["The Warbringer will be riding the mount color he has a chance to drop."], },
					-- 6.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Garn Steelmaw"] =                                 { cat = WOD, type = MOUNT, method = USE, name = GetItemInfo(116779) or L["Garn Steelmaw"], spellId = 171836, itemId = 116779, items = { 116980 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold Victory in a garrison invasion."], },
     ["Giant Coldsnout"] =                               { cat = WOD, type = MOUNT, method = USE, name = GetItemInfo(116673) or L["Giant Coldsnout"], spellId = 171635, itemId = 116673, items = { 116980 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold Victory in a garrison invasion."], },
     ["Shadowhide Pearltusk"] =                          { cat = WOD, type = MOUNT, method = USE, name = GetItemInfo(116663) or L["Shadowhide Pearltusk"], spellId = 171624, itemId = 116663, items = { 116980 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold Victory in a garrison invasion."], },
     ["Smoky Direwolf"] =                                { cat = WOD, type = MOUNT, method = USE, name = GetItemInfo(116786) or L["Smoky Direwolf"], spellId = 171843, itemId = 116786, items = { 116980 }, chance = 50, sourceText = L["This bag is rewarded for earning a Gold Victory in a garrison invasion."], },
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                         
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
					-- Requires a group (some of these may be soloable by certain classes, but not in general)
					--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

					-- Holiday                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Big Love Rocket"] =                               { cat = HOLIDAY, type = MOUNT, method = USE, name = GetItemInfo(50250) or L["Big Love Rocket"], spellId = 71342, itemId = 50250, items = { 54537 }, chance = 3333, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."], lockDungeonId = 288, },
     ["Great Brewfest Kodo"] =                           { cat = HOLIDAY, type = MOUNT, method = USE, name = GetItemInfo(37828) or L["Great Brewfest Kodo"], spellId = 49379, itemId = 37828, items = { 54535 }, chance = 25, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."], lockDungeonId = 287, },
     ["Swift Brewfest Ram"] =                            { cat = HOLIDAY, type = MOUNT, method = USE, name = GetItemInfo(33977) or L["Swift Brewfest Ram"], spellId = 43900, itemId = 33977, items = { 54535 }, chance = 25, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."], lockDungeonId = 287, },
     ["The Horseman's Reins"] =                          { cat = HOLIDAY, type = MOUNT, method = USE, name = GetItemInfo(37012) or L["The Horseman's Reins"], spellId = 48025, itemId = 37012, items = { 117392 }, chance = 200, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."], lockDungeonId = 285, },
					-- 5.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Clutch of Ji-Kun"] =                              { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(95059) or L["Clutch of Ji-Kun"], spellId = 139448, itemId = 95059, npcs = { 99999 }, tooltipNpcs = { 69712 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 50, statisticId = { 8171, 8169, 8172, 8170 }, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Ji-Kun", groupSize = 3, },
     ["Kor'kron Juggernaut"] =                           { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(104253) or L["Kor'kron Juggernaut"], spellId = 148417, itemId = 104253, npcs = { 99999 }, tooltipNpcs = { 71865 }, instanceDifficulties = { --[[ Mythic ]] [16] = true, }, chance = 100, groupSize = 5, statisticId = { 8638, 8637, }, sourceText = L["Mythic difficulty"], wasGuaranteed = true, lockBossName = "Garrosh Hellscream", },
					["Son of Galleon's Saddle"] =                       { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(89783) or L["Son of Galleon's Saddle"], spellId = 130965, itemId = 89783, npcs = { 99999 }, tooltipNpcs = { 62346 }, questId = 32098, chance = 2000, equalOdds = true, statisticId = { 6990 }, enableCoin = true, worldBossFactionless = true, groupSize = 3, },
     ["Spawn of Horridon"] =                             { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(93666) or L["Spawn of Horridon"], spellId = 136471, itemId = 93666, npcs = { 99999 }, tooltipNpcs = { 68476 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 66, statisticId = { 8151, 8149, 8152, 8150 }, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Horridon", groupSize = 3, },
     ["Reins of the Astral Cloud Serpent"] =             { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(87777) or L["Reins of the Astral Cloud Serpent"], spellId = 127170, itemId = 87777, npcs = { 99999 }, tooltipNpcs = { 60410 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 100, statisticId = { 6797, 6798, 7924, 7923, }, sourceText = L["Dropped by Elegon in Mogu'shan Vaults (all raid formats except Raid Finder)"], blackMarket = true, lockBossName = "Elegon", groupSize = 3, },
     ["Reins of the Cobalt Primordial Direhorn"] =       { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(94228) or L["Reins of the Cobalt Primordial Direhorn"], spellId = 138423, itemId = 94228, npcs = { 99999 }, tooltipNpcs = { 69161 }, questId = 32519, chance = 2000, equalOdds = true, statisticId = { 8147 }, enableCoin = true, worldBossFactionless = true, groupSize = 3, },
     ["Reins of the Heavenly Onyx Cloud Serpent"] =      { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(87771) or L["Reins of the Heavenly Onyx Cloud Serpent"], spellId = 127158, itemId = 87771, npcs = { 99999 }, tooltipNpcs = { 60491 }, questId = 32099, chance = 2000, equalOdds = true, statisticId = { 6989 }, enableCoin = true, worldBossFactionless = true, blackMarket = true, groupSize = 3, },
     ["Reins of the Thundering Cobalt Cloud Serpent"] =  { cat = MOP, type = MOUNT, method = BOSS, name = GetItemInfo(95057) or L["Reins of the Thundering Cobalt Cloud Serpent"], spellId = 139442, itemId = 95057, npcs = { 99999 }, tooltipNpcs = { 69099 }, questId = 32518, chance = 2000, equalOdds = true, statisticId = { 8146 }, enableCoin = true, worldBossFactionless = true, blackMarket = true, groupSize = 3, },
     ["Reins of the Thundering Onyx Cloud Serpent"] =    { cat = MOP, type = MOUNT, method = NPC, name = GetItemInfo(104269) or L["Reins of the Thundering Onyx Cloud Serpent"], spellId = 148476, itemId = 104269, npcs = { 73167 }, chance = 100, sourceText = L["Players have a personal loot chance to obtain this item."], groupSize = 3, },
					-- 6.x
     ["Garn Nighthowl"] =                                { cat = WOD, type = MOUNT, method = BOSS, name = GetItemInfo(116794) or L["Garn Nighthowl"], spellId = 171851, itemId = 116794, npcs = { 81001 }, chance = 1, groupSize = 25, },
     ["Solar Spirehawk"] =                               { cat = WOD, type = MOUNT, method = BOSS, name = GetItemInfo(116771) or L["Solar Spirehawk"], spellId = 171828, itemId = 116771, npcs = { 99999 }, tooltipNpcs = { 87493 }, chance = 2000, groupSize = 40, equalOdds = true, statisticId = { 9279 }, enableCoin = true, worldBossFactionless = true, },
                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
    },
    pets = {
     name = L["Battle Pets"],
					-- Holiday                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    					
					["Clockwork Rocket Bot"] =                          { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(34425) or L["Clockwork Rocket Bot"], spellId = 54187, itemId = 34425, items = { 116762 }, chance = 50, creatureId = 24968, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
     ["Darkmoon Eye"] =                                  { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(91040) or L["Darkmoon Eye"], spellId = 132789, itemId = 91040, items = { 91086 }, chance = 50, creatureId = 67332, sourceText = L["This bag is rewarded for completing the pet battle daily offered by Jeremy Feasel at the Darkmoon Faire."], holidayTexture = CALENDAR_DARKMOONFAIRE, questId = 32175, },
					["Frightened Bush Chicken"] =                       { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(116403) or L["Frightened Bush Chicken"], spellId = 171500, itemId = 116403, items = { 116404 }, chance = 33, creatureId = 85846, sourceText = L[""], holidayTexture = CALENDAR_PILGRIMSBOUNTY, },
					["Green Helper Box"] =                              { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(21301) or L["Green Helper Box"], spellId = 26533, itemId = 21301, items = { 21310 }, chance = 4, creatureId = 15698, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, christmasOnly = true, },
     ["Ice Chip"] =                                      { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(53641) or L["Ice Chip"], spellId = 74932, itemId = 53641, items = { 54536 }, chance = 25, groupSize = 5, equalOdds = true, creatureId = 40198, sourceText = L[""], lockDungeonId = 286, },
					["Jingling Bell"] =                                 { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(21308) or L["Jingling Bell"], spellId = 26529, itemId = 21308, items = { 21310 }, chance = 4, creatureId = 15706, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, christmasOnly = true, },
					["Lump of Coal"] =                                  { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(73797) or L["Lump of Coal"], spellId = 103125, itemId = 73797, items = { 116762 }, chance = 50, creatureId = 55215, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Rotten Helper Box"] =                             { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(104317) or L["Rotten Helper Box"], spellId = 148567, itemId = 104317, items = { 116762 }, chance = 100, creatureId = 73741, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Moon Moon"] =                                     { cat = HOLIDAY, type = PET, method = NPC, name = GetItemInfo(101570) or L["Moon Moon"], spellId = 144761, itemId = 101570, npcs = { 71992 }, chance = 17, repeatable = true, creatureId = 72160, sourceText = L[""], holidayTexture = CALENDAR_DARKMOONFAIRE, },
					["Red Helper Box"] =                                { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(21305) or L["Red Helper Box"], spellId = 26541, itemId = 21305, items = { 21310 }, chance = 4, creatureId = 15705, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, christmasOnly = true, },
     ["Sea Pony"] =                                      { cat = HOLIDAY, type = PET, method = FISHING, name = GetItemInfo(73953) or L["Sea Pony"], spellId = 103588, itemId = 73953, zones = { "823" }, chance = 1000, requiresPool = false, creatureId = 55386, sourceText = L[""], holidayTexture = CALENDAR_DARKMOONFAIRE, },
					["Snowman Kit"] =                                   { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(21309) or L["Snowman Kit"], spellId = 26045, itemId = 21309, items = { 21310 }, chance = 4, creatureId = 15710, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8768 }, christmasOnly = true, },
     ["Syd the Squid"] =                                 { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(116064) or L["Syd the Squid"], spellId = 170774, itemId = 116064, items = { 116062 }, chance = 50, creatureId = 85527, sourceText = L["This bag is rewarded for completing the pet battle daily offered by Christoph VonFeasel at the Darkmoon Faire."], holidayTexture = CALENDAR_DARKMOONFAIRE, questId = 36471, },
     ["Toxic Wasteling"] =                               { cat = HOLIDAY, type = PET, method = USE, name = GetItemInfo(50446) or L["Toxic Wasteling"], spellId = 71840, itemId = 50446, items = { 54537 }, chance = 14, groupSize = 5, equalOdds = true, creatureId = 38374, sourceText = L[""], lockDungeonId = 288, },
					-- 1.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Cat Carrier (Black Tabby)"] =                     { cat = BASE, type = PET, method = NPC, name = GetItemInfo(8491) or L["Cat Carrier (Black Tabby)"], spellId = 10675, itemId = 8491, npcs = { 2372, 49116, 2385, 48741, 2248, 48184, 49269, 48628, 48017, 47204, 48260, 49245, 47861, 2373, }, chance = 10000, repeatable = true, creatureId = 7383, sourceText = L[""], },
     ["Dark Whelpling"] =                                { cat = BASE, type = PET, method = NPC, name = GetItemInfo(10822) or L["Dark Whelpling"], spellId = 10695, itemId = 10822, npcs = { 4324, 42042, 2725, 46916, 7049, 4323, 46914 }, chance = 1000, repeatable = true, creatureId = 7543, sourceText = L[""], },
     ["Disgusting Oozeling"] =                           { cat = BASE, type = PET, method = USE, name = GetItemInfo(20769) or L["Disgusting Oozeling"], spellId = 25162, itemId = 20769, items = { 20768 }, chance = 85, repeatable = true, creatureId = 15429, tooltipNpcs = { 1806, 1808, 12387, 3928, 43158, 43123, 44988, 44967, 4394, 4393, 7092, 48315, 7093, 7086, 48136, 48319, 48322, 3295, 8607, 8606, 15335, 41573, 47397, 11741, 11740, 14477, 46997, 42952, 2656, 2655, 6559, 9477, 6557, 42669, 41145, 1032, 41147, 41453, 51028, 49347, 50319, 48768, }, sourceText = L[""], },
     ["Parrot Cage (Green Wing Macaw)"] =                { cat = BASE, type = PET, method = NPC, name = GetItemInfo(8492) or L["Parrot Cage (Green Wing Macaw)"], spellId = 10683, itemId = 8492, npcs = { 48522 }, chance = 33, repeatable = true, creatureId = 7387, sourceText = L[""], },
     ["Parrot Cage (Hyacinth Macaw)"] =                  { cat = BASE, type = PET, method = ZONE, name = GetItemInfo(8494) or L["Parrot Cage (Hyacinth Macaw)"], spellId = 10682, itemId = 8494, zones = { "689", "37", "673" }, chance = 10000, repeatable = true, creatureId = 7391, sourceText = L[""], },
     ["Sprite Darter Egg"] =                             { cat = BASE, type = PET, method = ZONE, name = GetItemInfo(11474) or L["Sprite Darter Egg"], spellId = 15067, itemId = 11474, zones = { "121" }, chance = 10000, creatureId = 9662, sourceText = L[""], },
     ["Tiny Crimson Whelpling"] =                        { cat = BASE, type = PET, method = ZONE, name = GetItemInfo(8499) or L["Tiny Crimson Whelpling"], spellId = 10697, itemId = 8499, zones = { "40" }, chance = 10000, repeatable = true, creatureId = 7544, sourceText = L[""], },
     ["Tiny Emerald Whelpling"] =                        { cat = BASE, type = PET, method = NPC, name = GetItemInfo(8498) or L["Tiny Emerald Whelpling"], spellId = 10698, itemId = 8498, npcs = { 740, 741, 39384 }, chance = 1000, repeatable = true, creatureId = 7545, sourceText = L[""], },
					-- 2.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Azure Whelpling"] =                               { cat = TBC, type = PET, method = ZONE, name = GetItemInfo(34535) or L["Azure Whelpling"], spellId = 10696, itemId = 34535, zones = { "281" }, chance = 10000, repeatable = true, creatureId = 7547, sourceText = L[""], },
     ["Captured Firefly"] =                              { cat = TBC, type = PET, method = NPC, name = GetItemInfo(29960) or L["Captured Firefly"], spellId = 36034, itemId = 29960, npcs = { 20197 }, chance = 1000, repeatable = true, creatureId = 21076, sourceText = L[""], },
     ["Mojo"] =                                          { cat = TBC, type = PET, method = USE, name = GetItemInfo(33993) or L["Mojo"], spellId = 43918, itemId = 33993, items = { 33865 }, chance = 10, creatureId = 24480, sourceText = L[""], },
     ["Phoenix Hatchling"] =                             { cat = TBC, type = PET, method = NPC, name = GetItemInfo(35504) or L["Phoenix Hatchling"], spellId = 46599, itemId = 35504, npcs = { 24664 }, chance = 11, creatureId = 26119, sourceText = L[""], },
     ["Chuck's Bucket"] =                                { cat = TBC, type = PET, method = USE, name = GetItemInfo(35350) or L["Chuck's Bucket"], spellId = 46426, itemId = 35350, items = { 35348 }, chance = 10, creatureId = 26056, sourceText = L[""], },
     ["Muckbreaths's Bucket"] =                          { cat = TBC, type = PET, method = USE, name = GetItemInfo(33818) or L["Muckbreaths's Bucket"], spellId = 43698, itemId = 33818, items = { 35348 }, chance = 10, creatureId = 24389, sourceText = L[""], },
     ["Snarly's Bucket"] =                               { cat = TBC, type = PET, method = USE, name = GetItemInfo(35349) or L["Snarly's Bucket"], spellId = 46425, itemId = 35349, items = { 35348 }, chance = 10, creatureId = 26050, sourceText = L[""], },
     ["Toothy's Bucket"] =                               { cat = TBC, type = PET, method = USE, name = GetItemInfo(33816) or L["Toothy's Bucket"], spellId = 43697, itemId = 33816, items = { 35348 }, chance = 10, creatureId = 24388, sourceText = L[""], },
					-- 3.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Deviate Hatchling"] =                             { cat = WOTLK, type = PET, method = NPC, name = GetItemInfo(48114) or L["Deviate Hatchling"], spellId = 67414, itemId = 48114, npcs = { 3636, 3637 }, chance = 500, repeatable = true, creatureId = 35395, sourceText = L[""], },
     ["Giant Sewer Rat"] =                               { cat = WOTLK, type = PET, method = FISHING, name = GetItemInfo(43698) or L["Giant Sewer Rat"], spellId = 59250, itemId = 43698, zones = { "Cantrips & Crows", "Circle of Wills", "The Underbelly", "The Black Market" }, chance = 1000, requiresPool = false, creatureId = 31575, sourceText = L[""], },
     ["Gundrak Hatchling"] =                             { cat = WOTLK, type = PET, method = NPC, name = GetItemInfo(48116) or L["Gundrak Hatchling"], spellId = 67415, itemId = 48116, npcs = { 29334 }, chance = 1000, repeatable = true, creatureId = 35400, sourceText = L[""], },
     ["Razzashi Hatchling"] =                            { cat = WOTLK, type = PET, method = ZONE, name = GetItemInfo(48126) or L["Razzashi Hatchling"], spellId = 67420, itemId = 48126, zones = { "689", "37", "673" }, chance = 5000, repeatable = true, creatureId = 35394, sourceText = L[""], },
					-- 4.x                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Elementium Geode"] =                              { cat = CATA, type = PET, method = SPECIAL, name = GetItemInfo(67282) or L["Elementium Geode"], spellId = 93838, itemId = 67282, obtain = L["Obtained by mining Elementium Vein"], chance = 2000, creatureId = 50722, sourceText = L[""], },
     ["Fox Kit"] =                                       { cat = CATA, type = PET, method = NPC, name = GetItemInfo(64403) or L["Fox Kit"], spellId = 90637, itemId = 64403, npcs = { 47676 }, chance = 1000, creatureId = 48641, sourceText = L[""], },
     ["Mr. Grubbs"] =                                    { cat = CATA, type = PET, method = USE, name = GetItemInfo(66076) or L["Mr. Grubbs"], spellId = 93739, itemId = 66076, items = { 61387 }, chance = 50, creatureId = 50586, sourceText = L[""], },
     ["Scorched Stone"] =                                { cat = CATA, type = PET, method = USE, name = GetItemInfo(34955) or L["Scorched Stone"], spellId = 45890, itemId = 34955, items = { 71631 }, chance = 20, creatureId = 25706, sourceText = L[""], },
					-- 5.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Hollow Reed"] =                                   { cat = MOP, type = PET, method = NPC, name = GetItemInfo(86563) or L["Hollow Reed"], spellId = 126249, itemId = 86563, npcs = { 50776 }, chance = 10, creatureId = 64633, sourceText = L[""], },
     ["Imbued Jade Fragment"] =                          { cat = MOP, type = PET, method = NPC, name = GetItemInfo(86564) or L["Imbued Jade Fragment"], spellId = 126251, itemId = 86564, npcs = { 50347 }, chance = 10, creatureId = 64634, sourceText = L[""], },
     ["Porcupette"] =                                    { cat = MOP, type = PET, method = USE, name = GetItemInfo(89587) or L["Porcupette"], spellId = 118414, itemId = 89587, items = { 89125 }, chance = 250, creatureId = 61086, sourceText = L[""], },
					-- 5.1                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Anubisath Idol"] =                                { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93040) or L["Anubisath Idol"], spellId = 135267, itemId = 93040, npcs = { 15276 }, chance = 10, creatureId = 68659, sourceText = L[""], },
     ["Blackwing Banner"] =                              { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93037) or L["Blackwing Banner"], spellId = 135265, itemId = 93037, npcs = { 12017 }, chance = 10, creatureId = 68663, sourceText = L[""], },
     ["Blazing Rune"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93034) or L["Blazing Rune"], spellId = 135259, itemId = 93034, npcs = { 11982 }, chance = 10, creatureId = 68664, sourceText = L[""], },
     ["Blighted Spore"] =                                { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93032) or L["Blighted Spore"], spellId = 135255, itemId = 93032, npcs = { 16011 }, chance = 10, creatureId = 68657, sourceText = L[""], },
     ["Core of Hardened Ash"] =                          { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93035) or L["Core of Hardened Ash"], spellId = 135261, itemId = 93035, npcs = { 11988 }, chance = 10, creatureId = 68666, sourceText = L[""], },
     ["Dusty Clutch of Eggs"] =                          { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93030) or L["Dusty Clutch of Eggs"], spellId = 135254, itemId = 93030, npcs = { 15952 }, chance = 10, creatureId = 68656, sourceText = L[""], },
     ["Gluth's Bone"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93029) or L["Gluth's Bone"], spellId = 135257, itemId = 93029, npcs = { 15932 }, chance = 10, creatureId = 68654, sourceText = L[""], },
					["Imperial Moth"] =                                 { cat = MOP, type = PET, method = USE, name = GetItemInfo(90900) or L["Imperial Moth"], spellId = 132574, itemId = 90900, items = { 92960 }, chance = 50, creatureId = 67230, sourceText = L[""], },
     ["Jewel of Maddening Whispers"] =                   { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93041) or L["Jewel of Maddening Whispers"], spellId = 135268, itemId = 93041, npcs = { 15263 }, chance = 10, creatureId = 68658, sourceText = L[""], },
     ["Mark of Flame"] =                                 { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93033) or L["Mark of Flame"], spellId = 135258, itemId = 93033, npcs = { 12098 }, chance = 10, creatureId = 68665, sourceText = L[""], },
     ["Unscathed Egg"] =                                 { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93036) or L["Unscathed Egg"], spellId = 135263, itemId = 93036, npcs = { 12435 }, chance = 10, creatureId = 68661, sourceText = L[""], },
     ["Viscidus Globule"] =                              { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93039) or L["Viscidus Globule"], spellId = 135266, itemId = 93039, npcs = { 15299 }, chance = 10, creatureId = 68660, sourceText = L[""], },
     ["Whistle of Chromatic Bone"] =                     { cat = MOP, type = PET, method = NPC, name = GetItemInfo(93038) or L["Whistle of Chromatic Bone"], spellId = 135264, itemId = 93038, npcs = { 14020 }, chance = 10, creatureId = 68662, sourceText = L[""], },
					-- 5.2                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ji-Kun Hatchling"] =                              { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(94835) or L["Ji-Kun Hatchling"], spellId = 139148, itemId = 94835, npcs = { 99999 }, tooltipNpcs = { 69712 }, chance = 200, statisticId = { 8171, 8169, 8172, 8170, 8168 }, creatureId = 70144, enableCoin = true, sourceText = L[""], lockBossName = "Ji-Kun", groupSize = 3, },
     ["Living Sandling"] =                               { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(94125) or L["Living Sandling"], spellId = 137977, itemId = 94125, npcs = { 69944 }, chance = 200, statisticId = { 8153 }, doNotUpdateToHighestStat = true, creatureId = 69748, enableCoin = true, sourceText = L[""], },
     ["Mountain Panda"] =                                { cat = MOP, type = PET, method = ITEM, name = GetItemInfo(94210) or L["Mountain Panda"], spellId = 138382, itemId = 94210, items = { 94207 }, chance = 7, creatureId = 69892, sourceText = L[""], },
     ["Snowy Panda"] =                                   { cat = MOP, type = PET, method = ITEM, name = GetItemInfo(94209) or L["Snowy Panda"], spellId = 138381, itemId = 94209, items = { 94207 }, chance = 7, creatureId = 69893, sourceText = L[""], },
     ["Son of Animus"] =                                 { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(94152) or L["Son of Animus"], spellId = 138161, itemId = 94152, npcs = { 99999 }, tooltipNpcs = { 69427 }, chance = 200, statisticId = { 8186, 8184, 8187, 8185, 8183 }, creatureId = 69820, enableCoin = true, sourceText = L[""], lockBossName = "Dark Animus", groupSize = 3, },
     ["Sunfur Panda"] =                                  { cat = MOP, type = PET, method = USE, name = GetItemInfo(94208) or L["Sunfur Panda"], spellId = 138380, itemId = 94208, items = { 94207 }, chance = 7, creatureId = 69891, sourceText = L[""], },
     ["Direhorn Runt"] =                                 { cat = MOP, type = PET, method = NPC, name = GetItemInfo(94573) or L["Direhorn Runt"], spellId = 139153, itemId = 94573, npcs = { 70019, 69983, 70016, 70017, 70018, 69992, 70015, 70012, 70013, 70014 }, chance = 250, creatureId = 70154, sourceText = L[""], },
					["Zandalari Anklerender"] =                         { cat = MOP, type = PET, method = NPC, name = GetItemInfo(95422) or L["Zandalari Anklerender"], spellId = 139932, itemId = 95422, npcs = { 69925 }, chance = 50, creatureId = 70451, sourceText = L[""], },
					["Zandalari Footslasher"] =                         { cat = MOP, type = PET, method = NPC, name = GetItemInfo(95423) or L["Zandalari Footslasher"], spellId = 139933, itemId = 95423, npcs = { 69925 }, chance = 50, creatureId = 70452, sourceText = L[""], },
					["Zandalari Kneebiter"] =                           { cat = MOP, type = PET, method = NPC, name = GetItemInfo(94126) or L["Zandalari Kneebiter"], spellId = 138087, itemId = 94126, npcs = { 69925 }, chance = 50, creatureId = 69796, sourceText = L[""], },
					["Zandalari Toenibbler"] =                          { cat = MOP, type = PET, method = NPC, name = GetItemInfo(95424) or L["Zandalari Toenibbler"], spellId = 139934, itemId = 95424, npcs = { 69925 }, chance = 50, creatureId = 70453, sourceText = L[""], },
					-- 5.3                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Brilliant Phoenix Hawk Feather"] =                { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97557) or L["Brilliant Phoenix Hawk Feather"], spellId = 141449, itemId = 97557, npcs = { 19514 }, chance = 33, creatureId = 71022, sourceText = L[""], },
     ["Crystal of the Void"] =                           { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(97556) or L["Crystal of the Void"], spellId = 141448, itemId = 97556, npcs = { 18805 }, chance = 20, creatureId = 71021, sourceText = L[""], },
     ["Dark Quivering Blob"] =                           { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(97960) or L["Dark Quivering Blob"], spellId = 142029, itemId = 97960, npcs = { 99999 }, tooltipNpcs = { 69017 }, instanceDifficulties = { --[[ 10/25 Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, }, chance = 50, statisticId = { 8181, 8179, 8180, 8182 }, creatureId = 71200, enableCoin = true, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Primordius", groupSize = 3, },
     ["Dripping Strider Egg"] =                          { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97554) or L["Dripping Strider Egg"], spellId = 141446, itemId = 97554, npcs = { 21212 }, chance = 250, creatureId = 71019, sourceText = L[""], },
     ["Half-Empty Food Container"] =                     { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97961) or L["Satyr Charm"], spellId = 142030, itemId = 97961, npcs = { 69251 }, chance = 750, creatureId = 71201, sourceText = L[""], },
     ["Instant Arcane Sanctum Security Kit"] =           { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97549) or L["Instant Arcane Sanctum Security Kit"], spellId = 141434, itemId = 97549, npcs = { 15691 }, chance = 33, creatureId = 71015, sourceText = L[""], },
     ["Netherspace Portal-Stone"] =                      { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97550) or L["Netherspace Portal-Stone"], spellId = 141435, itemId = 97550, npcs = { 15690 }, chance = 33, creatureId = 71016, sourceText = L[""], },
     ["Pygmy Direhorn"] =                                { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(94574) or L["Pygmy Direhorn"], spellId = 138825, itemId = 94574, npcs = { 99999 }, tooltipNpcs = { 68476 }, chance = 50, statisticId = { 8151, 8149, 8152, 8150, 8148 }, creatureId = 70083, enableCoin = true, sourceText = L[""], lockBossName = "Horridon", groupSize = 3, },
     ["Quivering Blob"] =                                { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(97959) or L["Quivering Blob"], spellId = 142028, itemId = 97959, npcs = { 99999 }, tooltipNpcs = { 69017 }, instanceDifficulties = { --[[ LFR ]] [7] = true, }, chance = 50, statisticId = { 8178 }, creatureId = 71199, enableCoin = true, sourceText = L["Only Raid Finder difficulty"], lockBossName = "Primordius", },
     ["Satyr Charm"] =                                   { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97551) or L["Satyr Charm"], spellId = 141451, itemId = 97551, npcs = { 15688 }, chance = 33, creatureId = 71033, sourceText = L[""], },
     ["Shell of Tide-Calling"] =                         { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97552) or L["Shell of Tide-Calling"], spellId = 141436, itemId = 97552, npcs = { 21213 }, chance = 20, creatureId = 71017, sourceText = L[""], },
     ["Spiky Collar"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97548) or L["Spiky Collar"], spellId = 141433, itemId = 97548, npcs = { 17521 }, chance = 14, creatureId = 71014, sourceText = L[""], },
     ["Tainted Core"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97553) or L["Tainted Core"], spellId = 141437, itemId = 97553, npcs = { 21216 }, chance = 25, creatureId = 71018, sourceText = L[""], },
     ["Tiny Fel Engine Key"] =                           { cat = MOP, type = PET, method = NPC, name = GetItemInfo(97555) or L["Tiny Fel Engine Key"], spellId = 141447, itemId = 97555, npcs = { 19516 }, chance = 25, creatureId = 71020, sourceText = L[""], },
					-- 5.4                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ashleaf Spriteling"] =                            { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104156) or L["Ashleaf Spriteling"], spellId = 148046, itemId = 104156, npcs = { 73277 }, chance = 66, creatureId = 73533, sourceText = L[""], },
     ["Azure Crane Chick"] =                             { cat = MOP, type = PET, method = SPECIAL, name = GetItemInfo(104157) or L["Azure Crane Chick"], spellId = 148047, itemId = 104157, obtain = L["Obtained by opening Crane Nests on the Timeless Isle"], chance = 50, creatureId = 73534, sourceText = L[""], },
     ["Blackfuse Bombling"] =                            { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104158) or L["Blackfuse Bombling"], spellId = 148049, itemId = 104158, npcs = { 99999 }, tooltipNpcs = { 71504 }, chance = 100, statisticId = { 8624, 8622, 8625, 8623, 8621, 8620, }, creatureId = 73352, sourceText = L[""], lockBossName = "Siegecrafter Blackfuse", groupSize = 3, },
     ["Bonkers"] =                                       { cat = MOP, type = PET, method = SPECIAL, name = GetItemInfo(104202) or L["Bonkers"], spellId = 148373, itemId = 104202, obtain = L["Obtained by opening Timeless Chests on the Timeless Isle"], chance = 70, creatureId = 73668, sourceText = L[""], },
     ["Death Adder Hatchling"] =                         { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104161) or L["Death Adder Hatchling"], spellId = 148052, itemId = 104161, npcs = { 73163 }, chance = 50, creatureId = 73364, sourceText = L[""], },
					["Dandelion Frolicker"] =                           { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104160) or L["Dandelion Frolicker"], spellId = 148051, itemId = 104160, npcs = { 71826, 71823 }, chance = 1250, creatureId = 73532, sourceText = L[""], },
     ["Droplet of Y'Shaarj"] =                           { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(104162) or L["Droplet of Y'Shaarj"], spellId = 148058, itemId = 104162, npcs = { 99999 }, tooltipNpcs = { 71734 }, instanceDifficulties = { --[[ 10/25 Flex/Normal/Heroic ]] [3] = true, [4] = true, [5] = true, [6] = true, [14] = true, }, chance = 100, statisticId = { 8569, 8571, 8573, 8570, 8568, }, creatureId = 73350, enableCoin = true, sourceText = L["All raid formats except Raid Finder"], lockBossName = "Sha of Pride", groupSize = 3, }, -- SHA OF PRIDE (flex/normal/heroic)
     ["Gooey Sha-ling"] =                                { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(104163) or L["Gooey Sha-ling"], spellId = 148059, itemId = 104163, npcs = { 99999 }, tooltipNpcs = { 71734 }, instanceDifficulties = { --[[ LFR/Flex ]] [7] = true, [14] = true, }, chance = 100, equalOdds = true, statisticId = { 8568, 8567, }, creatureId = 73351, enableCoin = true, sourceText = L["Raid Finder or Flexible difficulty"], lockBossName = "Sha of Pride", groupSize = 3, }, -- SHA OF PRIDE (lfr/flex)
     ["Gu'chi Swarmling"] =                              { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104291) or L["Gu'chi Swarmling"], spellId = 148527, itemId = 104291, npcs = { 72909 }, chance = 50, creatureId = 73730, sourceText = L[""], },
     ["Gulp Froglet"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104169) or L["Gulp Froglet"], spellId = 148067, itemId = 104169, npcs = { 72775 }, chance = 33, creatureId = 73359, sourceText = L[""], },
     ["Jadefire Spirit"] =                               { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104307) or L["Jadefire Spirit"], spellId = 148552, itemId = 104307, npcs = { 72769 }, chance = 50, creatureId = 73738, sourceText = L[""], },
     ["Jademist Dancer"] =                               { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104164) or L["Jademist Dancer"], spellId = 148060, itemId = 104164, npcs = { 72767 }, chance = 200, creatureId = 72767, sourceText = L[""], },
     ["Kovok"] =                                         { cat = MOP, type = PET, method = BOSS, name = GetItemInfo(104165) or L["Kovok"], spellId = 148061, itemId = 104165, npcs = { 99999 }, tooltipNpcs = { 71161, 71153, 71160, 71154, 71156, 71155, 71158, 71152, 71157 }, chance = 100, statisticId = { 8630, 8628, 8631, 8629, 8627, 8626, }, creatureId = 73354, enableCoin = true, sourceText = L[""], lockBossName = "Paragons of the Klaxxi", groupSize = 3, }, -- PARAGONS OF THE KLAXXI (all modes)
     ["Lil' Bling"] =                                    { cat = MOP, type = PET, method = USE, name = GetItemInfo(103670) or L["Lil' Bling"], spellId = 147124, itemId = 103670, items = { 86623, 113258, }, chance = 200, creatureId = 73011, sourceText = L[""], questId = { 31752, 34774 }, },
     ["Ominous Flame"] =                                 { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104166) or L["Ominous Flame"], spellId = 148062, itemId = 104166, npcs = { 73162 }, chance = 200, creatureId = 73357, sourceText = L[""], },
     ["Ruby Droplet"] =                                  { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104159) or L["Ruby Droplet"], spellId = 148050, itemId = 104159, npcs = { 73282 }, chance = 25, creatureId = 73356, sourceText = L[""], },
     ["Skunky Alemental"] =                              { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104167) or L["Skunky Alemental"], spellId = 148063, itemId = 104167, npcs = { 71919 }, chance = 33, creatureId = 73367, sourceText = L[""], },
     ["Spineclaw Crab"] =                                { cat = MOP, type = PET, method = NPC, name = GetItemInfo(104168) or L["Spineclaw Crab"], spellId = 148066, itemId = 104168, npcs = { 73166 }, chance = 60, creatureId = 73366, sourceText = L[""], },
					-- 6.0                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
					["Albino Chimaeraling"] =                           { cat = WOD, type = PET, method = USE, name = GetItemInfo(119434) or L["Albino Chimaeraling"], spellId = 177212, itemId = 119434, items = { 118697 }, chance = 15, creatureId = 77021, sourceText = L[""], questId = { 37644, 37645 }, },
					["Firewing"] =                                      { cat = WOD, type = PET, method = USE, name = GetItemInfo(118578) or L["Firewing"], spellId = 170291, itemId = 118578, items = { 118697 }, chance = 15, creatureId = 87704, sourceText = L[""], questId = { 37644, 37645 }, },
     ["Nightshade Sproutling"] =                         { cat = MOP, type = PET, method = NPC, name = GetItemInfo(118595) or L["Nightshade Sproutling"], spellId = 167394, itemId = 118595, npcs = { 85407, 85408, 85409, 85410, 85411, 85412 }, chance = 1000, creatureId = 83594, sourceText = L["Dropped by Disturbed Podling, which has a chance to spawn when picking herbs in Draenor."], },
					["Puddle Terror"] =                                 { cat = WOD, type = PET, method = USE, name = GetItemInfo(119467) or L["Puddle Terror"], spellId = 119467, itemId = 119467, items = { 118697 }, chance = 15, creatureId = 88300, sourceText = L[""], questId = { 37644, 37645 }, },                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Red Goren Egg"] =                                 { cat = MOP, type = PET, method = NPC, name = GetItemInfo(118919) or L["Red Goren Egg"], spellId = 170280, itemId = 118919, npcs = { 85294 }, chance = 1000, creatureId = 85667, sourceText = L["Dropped by Goren Protector, which has a chance to spawn when mining ore in Draenor."], },
     ["Sky-Bo"] =                                        { cat = WOD, type = PET, method = USE, name = GetItemInfo(115483) or L["Sky-Bo"], spellId = 170292, itemId = 115483, items = { 86623, 113258, }, chance = 200, creatureId = 85284, sourceText = L[""], questId = { 31752, 34774 }, },
					["Spectral Bell"] =                                 { cat = WOD, type = PET, method = USE, name = GetItemInfo(113623) or L["Spectral Bell"], spellId = 167731, itemId = 113623, items = { 118697 }, chance = 15, creatureId = 83817, sourceText = L[""], questId = { 37644, 37645 }, },
					["Sun Sproutling"] =                                { cat = WOD, type = PET, method = USE, name = GetItemInfo(118598) or L["Sun Sproutling"], spellId = 167397, itemId = 118598, items = { 118697 }, chance = 15, creatureId = 83588, sourceText = L[""], questId = { 37644, 37645 }, },
					["Sunfire Kaliri"] =                                { cat = WOD, type = PET, method = USE, name = GetItemInfo(119468) or L["Sunfire Kaliri"], spellId = 177227, itemId = 119468, items = { 118697 }, chance = 15, creatureId = 88367, sourceText = L[""], questId = { 37644, 37645 }, },
     ["Time-Locked Box"] =                               { cat = WOD, type = PET, method = NPC, name = GetItemInfo(118675) or L["Time-Locked Box"], spellId = 10699, itemId = 118675, repeatable = true, npcs = { 82458, 77653, 78193, 76886, 77767, 77790, 78921, 77090, 76556, 78345, 82774, 78348, 78670, 76673, 77771, 76189, 77640, 77101, 78695, 77724, 78488, 77643, 78696, 77723, 77644, 78667, 73458, 76672, 82918, 73446, 77721, 82451, 73459, 78674, 76651, }, chance = 500, creatureId = 7546, sourceText = L[""], },
					["Weebomination"] =                                 { cat = WOD, type = PET, method = USE, name = GetItemInfo(113558) or L["Weebomination"], spellId = 158261, itemId = 113558, items = { 118697 }, chance = 15, creatureId = 78421, sourceText = L[""], questId = { 37644, 37645 }, },
     ["Zomstrok"] =                                      { cat = WOD, type = PET, method = NPC, name = GetItemInfo(113554) or L["Zomstrok"], spellId = 167336, itemId = 113554, npcs = { 82262, 82261, 84921, }, chance = 100, creatureId = 83562, sourceText = L[""], },
    },
    items = {
     name = L["Toys & Items"],
					-- Pickpocketing
     --["Pickpocket Test"] =                               { cat = BASE, type = ITEM, method = NPC, name = GetItemInfo(17056) or "Light Feather", itemId = 17056, npcs = { 3115, 3116, }, chance = 100, repeatable = true, pickpocket = true, }, -- Dustwind Harpy and Dustwind Pillager in Razorwind Canyon (Durotar 50 27)
					--["Decahedral Dwarven Dice"] =                       { cat = WOTLK, type = ITEM, method = NPC, name = GetItemInfo(36863) or L["Decahedral Dwarven Dice"], itemId = 36863, npcs = { 27357, 27367, 32149, }, chance = 100, pickpocket = true, },
					--["Loaded Gnomish Dice"] =                           { cat = CATA, type = ITEM, method = NPC, name = GetItemInfo(63269) or L["Loaded Gnomish Dice"], itemId = 63269, npcs = { 58612, 49124, 47595, 46320, }, chance = 300, pickpocket = true, },
					--["Worn Troll Dice"] =                               { cat = WOTLK, type = ITEM, method = NPC, name = GetItemInfo(36862) or L["Worn Troll Dice"], itemId = 36862, npcs = { 34839, 34728, 23660, 34734, 26550, 27260, 28504, 34838, 39438, 29880, 28417, 28123, 23655, 27424, 28388, }, chance = 300, pickpocket = true, },
					
					-- Toys (Holiday)
					["Crashin' Thrashin' Flyer Controller"] =           { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(104318) or L["Crashin' Thrashin' Flyer Controller"], itemId = 104318, items = { 116762 }, chance = 50, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Crashin' Thrashin' Racer Controller"] =           { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(37710) or L["Crashin' Thrashin' Racer Controller"], itemId = 37710, items = { 116762 }, chance = 50, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Foot Ball"] =                                     { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(90888) or L["Foot Ball"], itemId = 90888, items = { 116762 }, chance = 50, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Fuzzy Green Lounge Cushion"] =                    { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(116692) or L["Fuzzy Green Lounge Cushion"], itemId = 116692, items = { 21271, 21270 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, },
					["MiniZep Controller"] =                            { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(46709) or L["MiniZep Controller"], itemId = 46709, items = { 116762 }, chance = 50, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
     ["Moonfang Shroud"] =                               { cat = HOLIDAY, type = ITEM, method = NPC, name = GetItemInfo(101571) or L["Moonfang Shroud"], itemId = 101571, npcs = { 71992, }, chance = 5, sourceText = L[""], holidayTexture = CALENDAR_DARKMOONFAIRE, },
     ["Moonfang's Paw"] =                                { cat = HOLIDAY, type = ITEM, method = NPC, name = GetItemInfo(105898) or L["Moonfang's Paw"], itemId = 105898, npcs = { 71992, }, chance = 5, sourceText = L[""], holidayTexture = CALENDAR_DARKMOONFAIRE, },
					["Pineapple Lounge Cushion"] =                      { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(116689) or L["Pineapple Lounge Cushion"], itemId = 116689, items = { 21271, 21270 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, },
					["Safari Lounge Cushion"] =                         { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(116690) or L["Safari Lounge Cushion"], itemId = 116690, items = { 21271, 21270 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, },
					["Silver-Plated Turkey Shooter"] =                  { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(116400) or L["Silver-Plated Turkey Shooter"], itemId = 116400, items = { 116404 }, chance = 33, sourceText = L[""], holidayTexture = CALENDAR_PILGRIMSBOUNTY, },
     ["The Heartbreaker"] =                              { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(50471) or L["The Heartbreaker"], itemId = 50471, items = { 54537, }, chance = 83, groupSize = 5, equalOdds = true, sourceText = L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."], lockDungeonId = 288, },
					["The Pigskin"] =                                   { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(90883) or L["The Pigskin"], itemId = 90883, items = { 116762 }, chance = 50, sourceText = L[""], holidayTexture = CALENDAR_WINTERVEIL, questId = { 6983, 7043 }, },
					["Zhevra Lounge Cushion"] =                         { cat = HOLIDAY, type = ITEM, method = USE, name = GetItemInfo(116691) or L["Zhevra Lounge Cushion"], itemId = 116691, items = { 21271, 21270 }, chance = 4, sourceText = L["Available starting December 25th"], holidayTexture = CALENDAR_WINTERVEIL, questId = { 8788, 8767 }, christmasOnly = true, },
					-- Toys (2.x)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Orb of the Sin'dorei"] =                          { cat = TBC, type = ITEM, method = NPC, name = GetItemInfo(35275) or L["Orb of the Sin'dorei"], itemId = 35275, npcs = { 24664, 24744, 24723, 24560, }, chance = 60, sourceText = L[""], },
     ["Time-Lost Figurine"] =                            { cat = TBC, type = ITEM, method = NPC, name = GetItemInfo(32782) or L["Time-Lost Figurine"], itemId = 32782, npcs = { 21838, }, chance = 10, sourceText = L[""], },
					-- Toys (3.x)
     ["Frenzyheart Brew"] =                              { cat = WOTLK, type = PET, method = USE, name = GetItemInfo(44719) or L["Frenzyheart Brew"], itemId = 44719, items = { 44718, }, chance = 4, sourceText = L["Contained in Ripe Disgusting Jar, which is obtained by becoming Revered with Frenzyheart Tribe, purchasing a Disgusting Jar from their reputation vendor, and waiting three days."], },
     ["Unusual Compass"] =                               { cat = WOTLK, type = PET, method = USE, name = GetItemInfo(45984) or L["Unusual Compass"], itemId = 45984, items = { 46007, }, chance = 20, sourceText = L[""], },
					-- Toys (5.x)                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                    
     ["Ai-Li's Skymirror"] =                             { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86589) or L["Ai-Li's Skymirror"], itemId = 86589, npcs = { 50821, }, chance = 7, sourceText = L[""], },
     ["Blackflame Daggers"] =                            { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(104302) or L["Blackflame Daggers"], itemId = 104302, npcs = { 73171, }, chance = 100, sourceText = L[""], },
     ["Chalice of Secrets"] =                            { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86575) or L["Chalice of Secrets"], itemId = 86575, npcs = { 50359, }, chance = 5, sourceText = L[""], },
     ["Eternal Kiln"] =                                  { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(104309) or L["Eternal Kiln"], itemId = 104309, npcs = { 72896, }, chance = 250, sourceText = L[""], },
     ["Farwater Conch"] =                                { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86581) or L["Farwater Conch"], itemId = 86581, npcs = { 50769, }, chance = 7, sourceText = L[""], },
     ["Gastropod Shell"] =                               { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(98136) or L["Gastropod Shell"], itemId = 98136, npcs = { 68220, }, chance = 150, sourceText = L[""], },
     ["Hozen Beach Ball"] =                              { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86593) or L["Hozen Beach Ball"], itemId = 86593, npcs = { 50836, }, chance = 7, sourceText = L[""], },
     ["Kang's Bindstone"] =                              { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86571) or L["Kang's Bindstone"], itemId = 86571, npcs = { 50349, }, chance = 5, sourceText = L[""], },
     ["Mr. Smite's Brass Compass"] =                     { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86568) or L["Mr. Smite's Brass Compass"], itemId = 86568, npcs = { 50336, }, chance = 10, sourceText = L[""], },
     ["Odd Polished Stone"] =                            { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(104262) or L["Odd Polished Stone"], itemId = 104262, npcs = { 72970, 72809, }, chance = 250, sourceText = L["This item has a 1 in 4 chance to drop from Golganarr, a rare spawn on Timeless Isle. It has a 1 in 250 chance to drop from Eroded Cliffdweller on Timeless Isle."], },
     ["Pandaren Firework Launcher"] =                    { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86588) or L["Pandaren Firework Launcher"], itemId = 86588, npcs = { 50817, }, chance = 10, sourceText = L[""], },
     ["Panflute of Pandaria"] =                          { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(86586) or L["Panflute of Pandaria"], itemId = 86586, npcs = { 50806, }, chance = 7, sourceText = L[""], },
     ["Rime of the Time-Lost Mariner"] =                 { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(104294) or L["Rime of the Time-Lost Mariner"], itemId = 104294, npcs = { 73281, }, chance = 7, sourceText = L[""], },
     ["Warning Sign"] =                                  { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(104331) or L["Warning Sign"], itemId = 104331, npcs = { 73169, }, chance = 100, sourceText = L[""], },
					-- Mount-related items (5.x)
     ["Primal Egg"] =                                    { cat = MOP, type = ITEM, method = NPC, name = GetItemInfo(94295) or L["Primal Egg"], itemId = 94295, npcs = { 69983, 69991, 69992, 69993, 70004, 70005, 70006, 70007, 70008, 70009, 70010, 70011, 70012, 70013, 70014, 70015, 70016, 70017, 70018, 70019, 70020, 70021, }, chance = 100, repeatable = true, unique = true, sourceText = L["Dropped by dinosaurs on Isle of Giants Will hatch into one of three Primal Raptor mounts after three days."], },
     ["Skyshard"] =                                      { cat = MOP, type = ITEM, method = ZONE, name = GetItemInfo(86547) or L["Skyshard"], spellId = 90655, itemId = 86547, zones = { "811" }, chance = 1000, repeatable = true, sourceText = L["Dropped by any mob in Vale of Eternal Blossoms (except minor mobs). 10 of these can be combined to pierce Alani's shield, allowing combat and a guaranteed drop of Reins of the Thundering Ruby Cloud Serpent."], },
     -- Battle pet-related items
     ["Mr. Pinchy"] =                                    { cat = TBC, type = ITEM, method = FISHING, name = GetItemInfo(27388) or L["Mr. Pinchy"], spellId = 33050, itemId = 27388, zones = { "Lake Jorune", "Lake Ere'Noru", "Skethyl Mountains", "Blackwind Landing", "Blackwind Valley", "Skettis", "Blackwind Lake", "Veil Harr'ik", "Veil Ala'rak", "Terokk's Rest" }, chance = 500, requiresPool = true, creatureId = 18839, sourceText = L["Obtained by fishing in pools located in Terrokar Forest"], },
     -- Achievements
     ["Old Crafty"] =                                    { cat = TBC, type = ITEM, method = FISHING, name = GetItemInfo(34486) or L["Old Crafty"], itemId = 34486, zones = { "321" }, chance = 10000, requiresPool = false, achievementId = 1836, sourceText = L["Obtained by fishing in any water in Orgrimmar"], },
     ["Old Ironjaw"] =                                   { cat = TBC, type = ITEM, method = FISHING, name = GetItemInfo(34484) or L["Old Ironjaw"], itemId = 34484, zones = { "341" }, chance = 10000, requiresPool = false, achievementId = 1837, sourceText = L["Obtained by fishing in any water in Ironforge"], },
     --["Stat Test"] = { type = MOUNT, method = BOSS, name = "Stat Test", spellId = -1, itemId = -1, npcs = { 99999 }, chance = 100, groupSize = 40, equalOdds = true, statisticId = { 107 } },    }, -- Killing any creature
				},
    user = {
     name = L["Custom"],
     --["Test 1"] =      { type = PET, method = NPC, name = GetItemInfo(25467) or "Test 1", spellId = 10682, itemId = 25467, npcs = { 16520, 16516 }, chance = 100, repeatable = true, },
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
			- Reevaluate group sizes for all items (most things can be moved to soloable)
			- New mounts
			- New pets
			- New toys
			- New rare killing achievements
			- New 100% drop items
			
			Nodes and zones:
			- Fishing nodes (GatherMate2/Constants.lua)
			- Mining nodes
			- New zones for Sea Turtle (http://wowpedia.org/MapID)
			
			APIs:
			- Check if NPC ID format changed
			- Check if instance difficulty API or IDs changed
			- Check if COMBAT_LOG_EVENT_UNFILTERED changed
			- Check for other API changes (i.e. http://wowpedia.org/Patch_6.0.1/API_changes)
			
			Other:
			- Good-luck coins
			- New Archaeology races: /run for race_id = 1, GetNumArchaeologyRaces() do Rarity:Print(GetArchaeologyRaceInfo(race_id)) end
			- Add a new category icon for the expansion
			
]]--


