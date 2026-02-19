local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

if LE_EXPANSION_LEVEL_CURRENT < LE_EXPANSION_WARLORDS_OF_DRAENOR then
	return {}
end

local wodMounts = {
	-- 6.x
	["Armored Razorback"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Armored Razorback"],
		spellId = 171630,
		itemId = 116669,
		npcs = { 95044, 95054, 95053, 95056 },
		chance = 30,
		sourceText = L['Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'],
		questId = { 39287, 39288, 39289, 39290 },
		defeatAllQuests = true,
		coords = {
			{ m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"] },
			{ m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"] },
			{ m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"] },
			{ m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"] },
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"],
		},
	},
	["Bristling Hellboar"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Bristling Hellboar"],
		spellId = 190690,
		itemId = 128481,
		collectedItemId = 124099,
		chance = 5000,
		obtain = L["Dropped from monsters in Fang'rila"],
		tooltipNpcs = { 92922, 92466, 89747, 89695, 89746, 92481 },
		sourceText = L["Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."],
		coords = { { m = 534, x = 55.2, y = 74.8 } },
	},
	["Garn Steelmaw"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Garn Steelmaw"],
		spellId = 171836,
		itemId = 116779,
		items = { 116980, 122163 },
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = { 37640, 38482 },
		defeatAllQuests = true,
		coords = { zoneOverride = L["Draenor Garrison"], { m = 579 }, { m = 585 } },
		defeatSteps = {
			[37640] = L["Garrison Invasion Gold Victory"],
			[38482] = L["Garrison Invasion Platinum Victory"],
		},
	},
	["Giant Coldsnout"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Giant Coldsnout"],
		spellId = 171635,
		itemId = 116673,
		items = { 116980, 122163 },
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = { 37640, 38482 },
		defeatAllQuests = true,
		coords = { zoneOverride = L["Draenor Garrison"], { m = 579 }, { m = 585 } },
		defeatSteps = {
			[37640] = L["Garrison Invasion Gold Victory"],
			[38482] = L["Garrison Invasion Platinum Victory"],
		},
	},
	["Reins of the Crimson Water Strider"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Reins of the Crimson Water Strider"],
		spellId = 127271,
		itemId = 87791,
		collectedItemId = { 117397, 127994, 116820, 116818, 116819, 116821, 122696, 116817, 116822 },
		chance = 100,
		obtain = L["Fished anywhere in Draenor (except your garrison) with the help of Nat Pagle"],
		sourceText = L["Lunkers can be fished anywhere in Draenor (except in your garrison) after you've obtained a level 3 Fishing Shack and acquired Nat Pagle as a follower."],
		coords = {
			{ m = 572 },
			{ m = 588 },
			{ m = 525 },
			{ m = 543 },
			{ m = 550 },
			{ m = 539 },
			{ m = 542 },
			{ m = 622 },
			{ m = 535 },
			{ m = 534 },
			{ m = 624 },
		},
	},
	["Riding Turtle"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Riding Turtle"],
		spellId = 30174,
		itemId = 23720,
		npcs = { 81171, 85715 },
		chance = 200,
		blackMarket = true,
		sourceText = L["After upgrading your garrison's Fishing Shack to level 3, fish up 5 minnows to summon a Cavedweller which can drop this mount."],
		coords = { zoneOverride = L["Draenor Garrison"], { m = 579 }, { m = 585 } },
	},
	["Shadowhide Pearltusk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Shadowhide Pearltusk"],
		spellId = 171624,
		itemId = 116663,
		items = { 116980, 122163 },
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = { 37640, 38482 },
		defeatAllQuests = true,
		coords = { zoneOverride = L["Draenor Garrison"], { m = 579 }, { m = 585 } },
		defeatSteps = {
			[37640] = L["Garrison Invasion Gold Victory"],
			[38482] = L["Garrison Invasion Platinum Victory"],
		},
	},
	["Smoky Direwolf"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.USE,
		name = L["Smoky Direwolf"],
		spellId = 171843,
		itemId = 116786,
		items = { 116980, 122163 },
		chance = 50,
		sourceText = L["This bag is rewarded for earning a Gold or Platinum victory in a garrison invasion."],
		questId = { 37640, 38482 },
		defeatAllQuests = true,
		coords = { zoneOverride = L["Draenor Garrison"], { m = 579 }, { m = 585 } },
		defeatSteps = {
			[37640] = L["Garrison Invasion Gold Victory"],
			[38482] = L["Garrison Invasion Platinum Victory"],
		},
	},
	["Tundra Icehoof"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Tundra Icehoof"],
		spellId = 171619,
		itemId = 116658,
		npcs = { 95044, 95054, 95053, 95056 },
		chance = 30,
		sourceText = L['Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'],
		questId = { 39287, 39288, 39289, 39290 },
		defeatAllQuests = true,
		coords = {
			{ m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"] },
			{ m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"] },
			{ m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"] },
			{ m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"] },
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"],
		},
	},
	["Warsong Direfang"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Warsong Direfang"],
		spellId = 171837,
		itemId = 116780,
		npcs = { 95044, 95054, 95053, 95056 },
		chance = 30,
		sourceText = L['Can be obtained from Rattling Iron Cage, which has a chance to drop from any of the four champions of Hellfire Citadel in Tanaan Jungle (Terrorfist, Deathtalon, Vengeance, or Doomroller). Each of them can be looted once per day. Rarity will consider this mount "defeated" for the day when you kill any of the four.'],
		questId = { 39287, 39288, 39289, 39290 },
		defeatAllQuests = true,
		coords = {
			{ m = 534, x = 32.6, y = 73.8, q = 39290, n = L["Vengeance"] },
			{ m = 534, x = 47, y = 52.6, q = 39289, n = L["Doomroller"] },
			{ m = 534, x = 23.2, y = 40.4, q = 39287, n = L["Deathtalon"] },
			{ m = 534, x = 14.6, y = 63, q = 39288, n = L["Terrorfist"] },
		},
		defeatSteps = {
			[39290] = L["Vengeance"],
			[39287] = L["Deathtalon"],
			[39288] = L["Terrorfist"],
			[39289] = L["Doomroller"],
		},
	},
	["Wild Goretusk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.COLLECTION,
		name = L["Wild Goretusk"],
		spellId = 171633,
		itemId = 116671,
		collectedItemId = 124099,
		chance = 1000,
		obtain = L["Dropped from monsters in Fang'rila"],
		tooltipNpcs = { 92922, 92466, 89747, 89695, 89746, 92481 },
		sourceText = L["Purchased from Z'tenga the Walker <Saberstalker Quartermaster> in Fang'rila in Tanaan Jungle. Blackfang Claws drop from all monsters in Fang'rila."],
		coords = { { m = 534, x = 55.2, y = 74.8 } },
	},
	-- 6.x
	["Felsteel Annihilator"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Felsteel Annihilator"],
		spellId = 182912,
		itemId = 123890,
		npcs = { 99999 },
		tooltipNpcs = { 91331 },
		chance = 100,
		wasGuaranteed = true,
		blackMarket = true,
		statisticId = { 10252 },
		lockBossName = "Archimonde",
		coords = { { m = 670, x = 58.4, y = 53.3, i = true } },
	},
	["Garn Nighthowl"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.NPC,
		name = L["Garn Nighthowl"],
		spellId = 171851,
		itemId = 116794,
		npcs = { 81001 },
		chance = 1, -- TODO: ???
		coords = { { m = 525, x = 16, y = 53.2 } },
	},
	["Ironhoof Destroyer"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Ironhoof Destroyer"],
		spellId = 171621,
		itemId = 116660,
		npcs = { 99999 },
		tooltipNpcs = { 77325 },
		chance = 100,
		wasGuaranteed = true,
		blackMarket = true,
		statisticId = { 9365 },
		lockBossName = "Blackhand",
		coords = { { m = 600, x = 48.4, y = 34.5, i = true } },
	},
	["Solar Spirehawk"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Solar Spirehawk"],
		spellId = 171828,
		itemId = 116771,
		npcs = { 99999 },
		tooltipNpcs = { 87493, 83746 },
		chance = 100,
		statisticId = { 9279 },
		worldBossFactionless = true,
		blackMarket = true,
		questId = 37464,
		coords = { { m = 542, x = 34.98, y = 38.65 } },
	},
	["Reins of the Infinite Timereaver"] = {
		cat = CONSTANTS.ITEM_CATEGORIES.WOD,
		type = CONSTANTS.ITEM_TYPES.MOUNT,
		method = CONSTANTS.DETECTION_METHODS.ENCOUNTER,
		-- TODO
		encounters = {
			-- Classic
			---- TBD Deadmines = CATA only in TW?
			---- Dire Maul
			343, -- Zevrim Thornhoof
			344, -- Hydrospawn
			345, -- Lethtendris
			346, -- Alzzin the Wildshaper
			347, -- Illyanna Ravenoak
			348, -- Magister Kalendris
			349, -- Immol'thar
			350, -- Tendris Warpwood
			361, -- Prince Tortheldrin
			362, -- Guard Mol'dar
			363, -- Stomper Kreeg
			364, -- Guard Fengus
			365, -- Guard Slip'kik
			366, -- Captain Kromcrush
			367, -- Cho'Rush the Observer
			368, -- King Gordok
			---- Stratholme
			472, -- The Unforgiven
			473, -- Hearthsinger Forresten
			474, -- Timmy the Cruel
			475, -- Willey Hopebreaker
			476, -- Commander Malor
			477, -- Instructor Galford
			478, -- Balnazzar
			479, -- Baroness Anastari
			480, -- Nerub'enkan
			481, -- Maleki the Pallid
			482, -- Magistrate Barthilas
			483, -- Ramstein the Gorger
			484, -- Lord Aurius Rivendare
			1885, -- Postmaster Malown
			---- Zul'Farrak
			593, -- Hydromancer Velratha
			594, -- Gahz'rilla
			595, -- Antu'sul
			596, -- Theka the Martyr
			597, -- Witch Doctor Zum'rah
			598, -- Nekrum Gutchewer
			599, -- Shadowpriest Sezz'ziz
			600, -- Chief Ukorz Sandscalp

			-- Cataclysm
			---- Throne of the Tides
			1047, -- Ozumat
			---- The Deadmines
			1081, -- Vanessa VanCleef
			2967, -- Rhahk'Zor
			2968, -- Sneed
			2969, -- Gilnid
			2970, -- Mr. Smite
			2971, -- Captain Greenskin
			2972, -- Edwin VanCleef
			2973, -- "Captain" Cookie
			2974, -- Admiral Ripsnarl
			2975, -- Foe Reaper 5000
			2976, -- Glubtok
			2977, -- Helix Gearbreaker
			2978, -- "Captain" Cookie
			2979, -- Admiral Ripsnarl
			2980, -- Foe Reaper 5000
			2981, -- Glubtok
			2982, -- Helix Gearbreaker
			2986, -- Cookie
			-- Mists of Pandaria
			1304, -- Master Snowdrift
			1306, -- Taran Zhu
			1442, -- Trial of the King
			-- TBD Legion
			-- TBD Shadowlands
			--  TBD TWW
		},
		name = L["Reins of the Infinite Timereaver"],
		spellId = 201098,
		itemId = 133543,
		npcs = {
			-- TBC Timewalking
			---- Magister's Terrace
			1894, -- Kael'thas Sunstrider
			1895, -- Priestess Delrissa
			1897, -- Selin Fireheart
			1898, -- Vexallus
			-- The Shattered Halls
				1936, -- Grand Warlock Nethekurse
			1935, -- Blood Guard Porung
				1937, -- Warbringer O'mrogg
				1938, -- Warchief Kargath Bladefist
			---- The Mana Tombs
				1900, -- Pandemonius
			1901, -- Tavarok
				1899, -- Nexus-Prince Shaffar
			250, -- Yor
			---- Blood Furnace
			1922, -- The Maker
			1924, -- Broggok
			1923, -- Keli'dan the Breaker
			---- The Botanica
				1925, -- Commander Sarannis
			1926, -- High Botanist Freywinn
			1928, -- Thorngrin the Tender
			1927, -- Laj
			1929, -- Warp Splinter
			---- The Underbog
			1946, -- Hungarfen
			1945, -- Ghaz'an
			1947, -- Swamplord Musel'ek
			1948, -- The Black Stalker
			-- WOTLK Timewalking
			---- The Nexus
			576, -- Frozen Commander
			2010, -- Grand Magus Telestra
			2009, -- Anomalus
			2012, -- Ormorok the Tree-Shaper
			2011, -- Keristrasza
			3017, -- Frozen Commander
			---- Halls of Lightning
			1987, -- General Bjarngrim
			1985, -- Volkhan
			1984, -- Ionar
			1986, -- Loken
			---- Gundrak
			1978, -- Slad'ran
			1983, -- Drakkari Colossus
			1980, -- Moorabi
			1981, -- Gal'darah
			1988, -- Eck the Ferocious
			---- Azjol-Nerub
			1971, -- Krik'thir the Gatewatcher
			1972, -- Hadronox
			1973, -- Anub'arak
			---- The Forge of Souls
			2006, -- Bronjahm
			2007, -- Devourer of Souls
			---- Utgarde Keep
			2026, -- Prince Keleseth
			2024, -- Skarvold & Dalronn
			2025, -- Ingvar the Plunderer
			-- CATA Timewalking
			---- Throne of the Tides
			1045, -- Lady Naz'jar
			1044, -- Commander Ulthok
			1046, -- Mindbender Ghur'sha
			1047, -- Ozumat
			---- The Vortex Pinnacle
			1043, -- Grand Vizier Ertan
			1041, -- Altairus
			1042, -- Asaad
			---- The Stonecore
			1056, -- Corborus
			1059, -- Slabhide
			1058, -- Ozruk
			1057, -- High Priestess Azil
			---- Lost City of the Tol'vir
			1052, -- General Husam
			1053, -- High Prophet Barim
			1055, -- Siamat
			1054, -- Lockmaw
			---- End Time
			1881, -- Echo of Baine
			1883, -- Echo of Jaina
			1882, -- Echo of Sylvanas
			1884, -- Echo of Tyrande
			1271, -- Murozond
			---- Blackrock Caverns
			1040, -- Rom'ogg Bonecrusher
			1038, -- Corla, Herald of Twilight
			1039, -- Karsh Steelbender
			1037, -- Beauty
			1036, -- Ascendant Lord Obsidius
			-- MOP Timewalking
			---- Gate of the Setting Sun
			1397, -- Saboteur Kip'tilak
			1405, -- Striker Ga'dok
			1406, -- Commander Ri'mok
			1419, -- Raigonn
			---- Temple of the Jade Serpent
			1418, -- Wise Mari
			1417, -- Lorewalker Stonestep
			1416, -- Liu Flameheart
			1439, -- Sha of Doubt
			---- Stormstout Brewery
			1412, -- Ook-ook
			1413, -- Hoptallus
			1414, -- Yan-Zhu the Uncasked
			---- Shado-Pan Monastery
			1303, -- Gu Cloudstrike
			1304, -- Master Snowdrift
			1305, -- Sha of Violence
			1306, -- Taran Zhu
			---- Mogu'shan Palace
			1442, -- Trial of the King
			2129, -- Gekkan
			1441, -- Xin the Weaponmaster
			---- Scholomance
			1426, -- Instructor Chillheart
			1427, -- Jandice Barov
			1428, -- Rattlegore
			1429, -- Lilian Voss
			1430, -- Darkmaster Gandling
			-- WoD Timewalking
			---- The Everbloom
			1756, -- Yalnu
			1751, -- Archmage Sol
			1752, -- Xeri'tac
			1757, -- Ancient Protectors
			1746, -- Witherbark
			---- Bloodmaul Slag Mines
			1653, -- Slave Watcher Crushto
			1652, -- Roltall
			1655, -- Magmolatus
			1654, -- Gug'rokk
			---- Auchindoun
			1686, -- Vigilant Kaathar
			1685, -- Soulbinder Nyami
			1678, -- Azzakel, Vanguard of the Legion
			1714, -- Teron'gor
			---- Shadowmoon Burial Grounds
			1677, -- Sadana Bloodfury
			1688, -- Nhallish
			1679, -- Bonemaw
			1682, -- Ner'zhul
			---- Skyreach
			1698, -- Ranjit
			1699, -- Araknath
			1700, -- Rukhran
			1701, -- High Sage Viryx
			---- Grimrail Depot
			1715, -- Rocketspark and Borka
			1732, -- Nitrogg Thundertower
			1736, -- Skylord Tovra
			-- Legion Timewalking
			--- Black Rook Hold
			1832, -- Amalgam of Souls
			1833, -- Illysanna Ravencrest
			1834, -- Smashspite the Hateful
			1835, -- Lord Kur'talos Ravencrest
			--- Court of Stars
			1868, -- Patrol Captain Gerdo
			1869, -- Talixae Flamewreath
			1870, -- Advisor Melandrus
			--- Darkheart Thicket
			1836, -- Archdruid Glaidalis
			1837, -- Oakheart
			1838, -- Dresaron
			1839, -- Shade of Xavius
			--- Eye of Azshara
			1810, -- Warlord Parjesh
			1811, -- Lady Hatecoil
			1812, -- King Deepbeard
			1813, -- Serpentrix
			1814, -- Wrath of Azshara
			--- Neltharion's Lair
			1790, -- Rokmora
			1791, -- Ularogg Cragshaper
			1792, -- Naraxas
			1793, -- Dargrul the Underking
			--- Vault of the Wardens
			1815, -- Tirathon Saltheril
			1850, -- Inquisitor Tormentorum
			1816, -- Ash'Golm
			1817, -- Glazer
			1818, -- Cordana Felsong
			-- BFA Timewalking
			--- Atal'Dazar
			2084, -- Priestess Alun'za
			2085, -- Vol'kaal
			2086, -- Rezan
			2087, -- Yazma
			--- Freehold
			2093, -- Skycap'n Kragg
			2095, -- Ring of Booty
			2094, -- Council o' Captains
			2096, -- Lord Harlan Sweete
			--- Kings' Rest
			2139, -- The Golden Serpent
			2142, -- Mchimba the Embalmer
			2140, -- The Council of Tribes
			2143, -- King Dazar
			--- Shrine of the Storm
			2130, -- Aqu'sirr
			2131, -- Tidesage Council
			2132, -- Lord Stormsong
			2133, -- Vol'zith the Whisperer
			--- Temple of Sethraliss
			2124, -- Adderis and Aspix
			2125, -- Merektha
			2126, -- Galvazzt
			2127, -- Avatar of Sethraliss
			--- Waycrest Manor
			2113, -- Heartsbane Triad
			2114, -- Soulbound Goliath
			2115, -- Raal the Gluttonous
			2116, -- Lord and Lady Waycrest
			2117, -- Gorak Tul
			-- Shadowlands Timewalking
			---- The Necrotic Wake
			2387, -- Blightbone
			2388, -- Amarth, The Harvester
			2389, -- Surgeon Stitchflesh
			2390, -- Nalthor the Rimebinder
			---- Spires of Ascension
			2356, -- Ventunax
			2357, -- Kin-Tara
			2358, -- Oryphrion
			2359, -- Devos, Paragon of Loyalty
			---- Plaguefall
			2382, -- Globgrog
			2384, -- Doctor Ickus
			2385, -- Domina Venomblade
			2386, -- Stradama Margrave
			---- De Other Side
			2394, -- The Manastorms
			2395, -- Hakkar, the Soulflayer
			2396, -- Mueh'zala
			2400, -- Dealer Xy'exa
			---- Halls of Atonement
			2380, -- Echelon
			2401, -- Halkias, the Sin-Stained Goliath
			2381, -- Lord Chamberlain
			2403, -- High Adjudicator Aleez
			---- Sanguine Depths
			2360, -- Kryxis the Voracious
			2361, -- Executor Tarvold
			2362, -- Grand Proctor Beryllia
			2363, -- General Kaal
		},
		chance = 4000,
		groupSize = 5,
		equalOdds = true,
		instanceDifficulties = { [CONSTANTS.INSTANCE_DIFFICULTIES.TIMEWALKING_DUNGEON] = true },
		coords = {
			{ m = CONSTANTS.UIMAPIDS.THE_DEADMINES, i = true },
			{ m = CONSTANTS.UIMAPIDS.DIREMAUL_CAPITAL_GARDENS, i = true },
			{ m = CONSTANTS.UIMAPIDS.DIREMAUL_WARPWOOD_QUARTER, i = true },
			{ m = CONSTANTS.UIMAPIDS.ZUL_FARRAK, i = true },
			{ m = CONSTANTS.UIMAPIDS.STRATHOLME, i = true },
			{ m = 348, i = true },
			{ m = 265, i = true },
			{ m = 246, i = true },
			{ m = 272, i = true },
			{ m = 273, i = true },
			{ m = 269, i = true },
			{ m = 184, i = true },
			{ m = 136, i = true },
			{ m = 129, i = true },
			{ m = 138, i = true },
			{ m = 153, i = true },
			{ m = 132, i = true },
			{ m = 322, i = true },
			{ m = 325, i = true },
			{ m = 324, i = true },
			{ m = 277, i = true },
			{ m = 293, i = true },
			{ m = 401, i = true },
			{ m = 437, i = true },
			{ m = 429, i = true },
			{ m = 439, i = true },
			{ m = 457, i = true },
			{ m = 443, i = true },
			{ m = 453, i = true },
		},
	},
}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, wodMounts)
return wodMounts
