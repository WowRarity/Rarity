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
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Garn Nighthowl"],
		spellId = 171851,
		itemId = 116794,
		npcs = { 81001 },
		chance = 1,
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
		method = CONSTANTS.DETECTION_METHODS.BOSS,
		name = L["Reins of the Infinite Timereaver"],
		spellId = 201098,
		itemId = 133543,
		npcs = {
			-- NPCs marked with * can't be looted; they use a workaround and are detected via checking their achievement criteria. The entry here is mostly for the tooltip display....
			-- Classic Dungeons
			---- Deadmines
			644, -- Rhahk'Zor
			643, -- Sneed
			1763, -- Gilnid
			646, -- Mr. Smite
			647, -- Captain Greenskin
			639, -- Edwin VanCleef
			645, -- Cookie
			---- Dire Maul (Capital Gardens)
			11489, -- Tendris Warpwood
			11487, -- Magister Kalendris
			11488, -- Illyanna Ravenoak
			11496, --Immol'thar
			11486, -- Prince Tortheldrin
			---- Dire Maul (Warpwood Quarters)
			14327, -- Lethtendris
			13280, -- Hydrospawn
			11490, -- Zevrim Thornhoof
			11492, -- Alzzin the Wildshaper
			---- Zul Farrak
			7272, -- Theka the Martyr
			7795, -- Hydromancer Velratha
			8127, -- Antu'sul
			7271, -- Witch Doctor Zum'rah
			7273, -- Gahz'rilla
			7275, -- Nekrum & Sezz'ziz
			7267, -- Chief Ukorz Sandscalp
			---- Stratholme (Main Gate)
			10813, -- Balnazzar
			10516, -- The Unforgiven
			10558, -- Hearthsinger Forresten
			10808, -- Timmy the Cruel
			11143, -- Postmaster Malown
			11032, -- Commander Malor
			10997, -- Willey Hopebreaker
			10811, -- Instructor Galford
			---- Stratholme (Service Entrance)
			10436, -- Baroness Anastari
			10437, -- Nerub'enkan
			10438, -- Maleki the Pallid
			10435, -- Magistrate Barthilas
			10439, -- Ramstein the Gorger
			-- TBC Dungeons
			---- Magister's Terrace
			24723, -- Selin Fireheart
			24744, -- Vexallus
			24560, -- Priestess Velrissa
			24664, -- Kael'thas Sunstrider
			-- The Shattered Halls
			16807, -- Grand Warlock Nethekurse
			20923, -- Blood Guard Porung
			16809, -- Warbringer O'mrogg
			16808, -- Warchief Kargath Bladefist
			---- The Mana Tombs
			18341, -- Pandemonius
			18343, -- Tavarok
			18344, -- Nexus-Prince Shaffar
			22930, -- Yor
			---- Blood Furnace
			17381, -- The Maker
			17380, -- Broggok
			17377, -- Keli'dan the Breaker
			---- The Botanica
			17976, -- Commander Sarannis
			17975, -- High Botanist Freywinn
			17978, -- Thorngrin the Tender
			17980, -- Laj
			17977, -- Warp Splinter
			---- The Underbog
			17770, -- Hungarfen
			18105, -- Ghaz'an
			17826, -- Swamplord Musel'ek
			17882, -- The Black Stalker
			-- WOTLK Dungeons
			---- The Nexus
			26731, -- Grand Magus Telestra
			26763, -- Anomalus
			26794, -- Ormorok the Tree-Shaper
			26723, -- Keristrasza
			26796, -- Commander Stoutbeard
			26798, -- Commander Kolurg
			---- Halls of Lightning
			28586, -- General Bjarngrim
			28587, -- Volkhan
			28546, -- Ionar
			28923, -- Loken
			---- Gundrak
			29304, -- Slad'ran
			29573, -- Drakkari Elemental
			29305, -- Moorabi
			29306, -- Gal'darah
			29932, -- Eck the Ferocious
			---- Azjol-Nerub
			28684, -- Krik'thir the Gatewatcher
			28921, -- Hadronox
			29120, -- Anub'arak
			---- The Forge of Souls
			36497, -- Bronjahm
			36502, -- Devourer of Souls
			---- Utgarde Keep
			23953, -- Prince Keleseth
			24201, -- Dalronn
			23954, -- Ingvar the Plunderer
			-- Cataclysm Dungeons
			---- Throne of the Tides
			40586, -- Lady Naz'jar
			40765, -- Commander Ulthok
			40788, -- Mindbender Ghur'sha
			44566, -- Ozumat *
			---- The Vortex Pinnacle
			43878, -- Grand Vizier Ertan
			43873, -- Altairus
			43875, -- Asaad
			---- The Stonecore
			43438, -- Corborus
			43214, -- Slabhide
			42188, -- Ozruk
			42333, -- High Priestess Azil
			---- Lost City of the Tol'vir
			44577, -- General Husam
			43612, -- High Prophet Barim
			44819, -- Siamat
			49045, -- Augh
			---- End Time
			54431, -- Echo of Baine
			54445, -- Echo of Jaina
			54123, -- Echo of Sylvanas
			54544, -- Echo of Tyrande
			54432, -- Murozond *
			---- Blackrock Caverns
			39665, -- Rom'ogg Bonecrusher
			39679, -- Corla
			39698, -- Karsh Steelbender
			39700, -- Beauty
			39705, -- Ascendant Lord Obsidius
			-- MOP Timewalking
			---- Gate of the Setting Sun
			56906, -- Saboteur Kip'tilak
			56589, -- Striker Ga'dok
			56636, -- Commander Ri'mok
			56877, -- Raigonn
			---- Temple of the Jade Serpent
			56448, -- Wise Mari
			59051, -- Strife (Trial of the Yaungol)
			58826, -- Zao Sunseeker (Champion of the Five Suns)
			56732, -- Liu Flameheart
			56439, -- Sha of Doubt
			---- Stormstout Brewery
			56637, -- Ook-ook
			56717, -- Hoptallus
			59479, -- Yan-Zhu the Uncasked
			---- Shado-Pan Monastery
			56747, -- Gu Cloudstrike
			56541, -- Master Snowdrift *
			56719, -- Sha of Violence
			56884, -- Taran Zhu *
			---- Mogu'shan Palace
			61444, -- Ming the Cunning *
			61243, -- Gekkan *
			61398, -- Xin the Weaponmaster
			---- Scholomance
			58633, -- Instructor Chillheart
			59184, -- Jandice Barov
			59153, -- Rattlegore
			58722, -- Lilian Voss
			59080, -- Darkmaster Gandling
			-- WoD Timewalking
			---- The Everbloom
			83846, -- Yalnu
			82682, -- Archmage Sol
			84550, -- Xeri'tac
			83894, -- Dulhu
			81522, -- Witherbark
			---- Bloodmaul Slag Mines
			74366, -- Forgemaster Gog'duh
			74787, -- Slave Watcher Crushto
			75786, -- Roltall
			74790, -- GugÄrokk
			---- Auchindoun
			75839, -- Vigilant Kaathar
			76177, -- Soulbinder Nyami
			75927, -- Azzakel
			77734, -- Teron'gor
			---- Shadowmoon Burial Grounds
			75509, -- Sadana Bloodfury
			75829, -- Nhallish
			75452, -- Bonemaw
			76407, -- Ner'zhul
			---- Skyreach
			75964, -- Ranjit
			76141, -- Araknath
			76379, -- Rukhran
			76266, -- High Sage Viryx
			---- Grimrail Depot
			77803, -- Railmaster Rocketspark
			79545, -- Nitrogg Thundertower
			80005, -- Skylord Tovra
			-- Legion Timewalking
			--- Black Rook Hold
			98542, -- Amalgam of Souls
			98696, -- Illysanna Ravencrest
			98949, -- Smashspite the Hateful
			94923, -- Lord Kur'talos Ravencrest
			--- Court of Stars
			104215, -- Patrol Captain Gerdo
			104217, -- Talixae Flamewreath
			101831, -- Advisor Melandrus
			--- Darkheart Thicket
			96512, -- Archdruid Glaidalis
			103344, -- Oakheart
			99200, -- Dresaron
			99192, -- Shade of Xavius
			--- Eye of Azshara
			91784, -- Warlord Parjesh
			91789, -- Lady Hatecoil
			91797, -- King Deepbeard
			91808, -- Serpentrix
			96028, -- Wrath of Azshara
			--- Neltharion's Lair
			91003, -- Rokmora
			91004, -- Ularogg Cragshaper
			91005, -- Naraxas
			91007, -- Dargrul
			--- Vault of the Wardens
			95885, -- Tirathon Saltheril
			96015, -- Inquisitor Tormentorum
			95886, -- Ash'Golm
			99865, -- Glazer
			95888, -- Cordana Felsong
			-- BFA Dungeons
			--- Atal'Dazar
			129614, -- Priestess Alun'za
			129399, -- Vol'kaal
			143577, -- Rezan
			129412, -- Yazma
			--- Freehold
			129732, -- Skycap'n Kragg
			129431, -- Captain Eudora
			126847, -- Captain Raoul
			129432, -- Captain Jolly
			126969, -- Trothak
			129440, -- Harlan Sweete
			--- Kings' Rest
			135322, -- The Golden Serpent
			134993, -- Mchimba the Embalmer
			135470, -- The Council of Tribes
			136160, -- King Dazar
			--- Shrine of the Storm
			134056, -- Aqu'sirr
			134063, -- Brother Ironhull
			134058, -- Galecaller Faye
			139737, -- Lord Stormsong
			134069, -- Vol'zith the Whisperer
			--- Temple of Sethraliss
			133379, -- Adderis
			133944, -- Aspix
			133384, -- Merektha
			133389, -- Galvazzt
			133392, -- Avatar of Sethraliss
			--- Waycrest Manor
			135360, -- Sister Briar
			131667, -- Soulbound Goliath
			131863, -- Raal the Gluttonous
			131527, -- Lord Waycrest
			131545, -- Lady Waycrest
			131864, -- Gorak Tul
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
