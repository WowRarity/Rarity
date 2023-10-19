local changes = {
	["r725"] = {
		additions = {
			"Added a new option for toggling the scrolling debug window to Blizzard's keybinding UI",
			"Added tracking for Arfus (Hallow's End 2023 update)",
		},
		fixes = {
			"Fixed an issue that would cause the achievement-style popup to always be shown when looting a class-specific item",
			"Duplicate attempts should no longer be added when using Engineering on Arachnoid Harvester",
			"Fixed tracking for The Horseman's Reins (Hallow's End 2023 update)",
		},
		contributors = { "Alexander Stavitsky (astavitsky)" },
	},
	["r724"] = {
		additions = {
			"Added tracking for Emmah (Disgusting Vat Fishing, in Zskera Vaults)",
			"Added a new scrolling message frame for inspecting cached debug messages (via `/rarity dump)`",
		},
		fixes = {
			"Fixed an issue that could cause pets that have already been obtained to not be detected as such",
		},
		contributors = { "cyriun" },
	},
	["r723"] = {
		additions = {
			"Added tracking for Darkmoon Rabbit",
		},
		fixes = {
			"Fixed an issue that prevented items requiring world events (e.g., DMF) to be active from being displayed",
		},
	},
	["r722"] = {
		additions = {
			"Added tracking for collectibles obtainable in the Zskera Vaults (Forbidden Reach)",
		},
		changes = {
			"The estimated luckiness percentage is now being displayed alongside the attempts count for all items",
		},
		fixes = {
			"Fixed an issue that would incorrectly add duplicate attempts for bosses with both kill statistics and NPC loot",
			"Rolled back a recent change that caused NPC loot to not be registered when using Rarity with fast-loot addons",
		},
		contributors = { "cyriun", "Rubio9" },
	},
	["r721"] = {
		fixes = {
			"Fixed an issue that would incorrectly add attempts to faction-specific Time Rift mounts for the opposing faction",
			"Fixed an issue that would break tracking of container items after the mail box was opened",
		},
		contributors = { "Rubio9" },
	},
	["r720"] = {
		additions = {
			"Added tracking for most of the missing Dragonflight collectibles",
			"Added an experimental button that allows untracking all mounts to the Advanced settings",
			"Opening BFA Island Expedition crates should now add attempts for all relevant collectibles",
		},
		fixes = { "Fixed TomTom waypoint labels not displaying Rarity as their source" },
		contributors = { "cyriun" },
	},
	["r719"] = {
		additions = {
			"Created a slash command for toggling the progress bar (for use in macros)",
			"Added tracking for many Dragonflight collectibles (the list is still incomplete, however)",
		},
		fixes = { "Fixed script errors caused by various WOW API changes" },
		notes = {
			"Many Dragonflight collectibles, especially pets and toys, are still missing."
				.. " Please report any that you think should be tracked, but currently aren't.",
		},
		contributors = { "cyriun", "Elke Freed", "Tommy Godejord" },
	},
	["r718"] = {
		fixes = { "Fixed script errors caused by API changes in patch 10.0.2" },
	},
	["r717"] = {
		fixes = { "Fixed script errors caused by API changes in patch 10.0" },
		changes = { "Tooltip additions should now also work for items in the quest log" },
		contributors = { "Patrick Borgogno", "Tommy Godejord", "teelolws" },
	},
	["r716"] = {
		additions = { "Added defeat detection data for Mythic-difficulty Legion raids" },
		fixes = {
			"Added several missing Torghast bosses to the list of NPCs counting for Sturdy Silver Mawrat Harness",
		},
	},
	["r715"] = {
		additions = { "Added tracking for various collectibles obtained in Zereth Mortis" },
		fixes = { "Fixed the attempts detection for Skull of Corruption" },
		changes = { "Adjusted the difficulty settings for certain legacy collectibles" },
		contributors = { "Tommy Godejord" },
	},
	["r714"] = {
		additions = {
			"Added tracking for Shaded Judgement Stone (Korthia/The Maw)",
			"Added tracking for the various 'dice' toys obtainable only via pickpocketing",
		},
		changes = {
			"Adjusted the drop rate of several Shadowlands collectibles to more accurately reflect wowhead's data",
		},
		fixes = {
			"Attempts for the Infinite Timereaver mount should now correctly be detected in the recently-added Timewalking dungeons",
			"Collectibles that require being affiliated with a different covenant should now correctly be marked as 'unavailable' in the addon's main window",
		},
		contributors = { "ithappenedagain", "Tommy Godejord" },
	},
	["r713"] = {
		additions = {
			"Attempts for Reins of the Infinite Timereaver should now also accumulate in Legion Timewalking dungeons",
			"REVERTED: Added tracking for Illidari Doomhawk and Doomwalker Trophy Stand (17th anniversary)",
			"Added tracking for the convenant-specific toys added in patch 9.1.5 (obtained from Callings)",
		},
		fixes = {
			"Fixed an error in the spell detection that caused attempts for custom items using Pick Pocket to not be detected",
		},
		notes = {
			"Blizzard hotfixed the anniversary drops to be guaranteed. As such they've been removed from Rarity again.",
		},
		contributors = { "Tommy Godejord" },
	},
	["r712"] = {
		additions = { "Added tracking for Gilded Darknight" },
		fixes = { "The main window should again be rendered properly (previously broken by patch 9.1.5 API changes)" },
		contributors = { "Tommy Godejord" },
	},
	["r711"] = {
		additions = { "Added tracking for Adamant Vaults Cell" },
		changes = {
			"The mini map button is now displayed by default, to hopefully improve the experience for first-time users",
		},
		fixes = {
			"Fixed an issue that prevented item information being displayed in the game tooltip for items using the ZONE (zonewide) detection method",
		},
		contributors = { "Tommy Godejord" },
	},
	["r710"] = {
		additions = {
			"Added an overview of the tracking data to each item's settings in the Options UI",
			"Added tracking for toys obtained from Zovaal's Vault",
			"Added links to the Rarity Discord and GitHub repository to the Options UI",
		},
		changes = {
			"The main window should now render MUCH faster, depending on the sort method selected (sorting by zone is still relatively slow)",
		},
		fixes = {
			"Fixed tracking for Wilderling Saddle",
			"Fixed tracking for Rook",
			"Fixed tracking for Intact Aquilon Core",
			"Fixed an issue that could prevent items using the COLLECTION method from being tracked correctly",
		},
		notes = {
			"By improving the sorting algorithms used internally, we were able to reduce the time spent on rendering the addon's main window significantly. The remaining time for all sort modes except \"by zone\" is now limited by the WOW client's UI system and can't be reduced as easily, though we're looking at workarounds to this problem. If you're still experiencing significant performance issues after updating, please let us know!",
		},
		contributors = { "AySz88", "Tommy Godejord", "Matthew Rowland" },
	},
	["r709"] = {
		additions = {
			"Added tracking for mounts introduced in Chains of Domination ",
			"Added tracking for various toys introduced in Chains of Domination",
			"Added tracking for most pets introduced in Chains of Domination",
		},
		changes = {
			"Rarity's achievement toast now also supports two lines of text properly, similar to Blizzard's recently-updated version",
		},
		fixes = { "Fixed an issue where two icons would be displayed in the achievement toast" },
		notes = {
			"There are a number of collectibles we don't currently have sufficient data on. These will be added as soon™ as possible, but it might still take a while.",
		},
		contributors = { "Tommy Godejord" },
	},
	["r708"] = {
		additions = {
			"Added tracking for Gilded Water (pet)",
			"Added tracking for Outrider's Bridle Chain (toy)",
			"Added a holiday-style reminder for when Dunegorger Kraulok is available (experimental)",
		},
		changes = {
			"The /rarity verify slash command used for validating the item database is now available as /rarity validate",
		},
		fixes = {
			"Items obtainable from the Black Market auction house are now flagged as such",
			"All items should now be assigned a zone, so that filtering by the current zone no longer incorrectly excludes them",
			"Tracking for the Ascended Skymane mount should now be working on non-English client locales",
		},
		contributors = { "Tommy Godejord" },
	},
	["r707"] = {
		changes = {
			"The tooltip text for faction-restricted items is now dynamically colored based on whether it's available to the logged-in character",
		},
		fixes = {
			"Fixed an issue where looting Forgotten Chests in Stormsong Valley would cause attempts to be added for Silessa's Battle Harness and Stony's Infused Ruby",
		},
		contributors = { "Nick Bayley", "Tommy Godejord" },
	},
	["r706"] = {
		additions = {
			"Added an option to disable the achievement toast (popup) and sound effect triggered whenever a tracked item is found",
			"Added tracking for Pterrordax Egg (Zandalar)",
			"Added tracking for Piccolo of the Flaming Fire (Stratholme)",
			"Added an option to delay the tooltip (i.e., how long the icon should be hovered over before it is shown)",
			"Added tracking for Lucy's Lost Collar (Shadowlands)",
		},
		changes = { "Skyshards are now tracked repeatedly by default" },
		fixes = {
			"Clicking the achievement toast (popup) displayed when a tracked item is found should no longer cause a script error",
			"Skyshards should now also be tracked in the corrupted (instanced) version of the Shrine of Seven Stars",
			"Calendar-based notifications should now be triggered correctly for all holiday event items that Rarity tracks by default",
		},
		contributors = { "Nick Bayley", "Tommy Godejord" },
	},
	["r705"] = {
		additions = {
			"Added tracking for various Shadowlands pets and toys that were previously missing",
			"Added tracking for Smoldering Ember Wyrm (Return to Karazhan)",
			"Added tracking for Gloop (Corrupted Vale of Eternal Blossoms/Uldum)",
			"Added tooltips for achievement-related rares in Nazjatar, Mechagon Island, as well as Shadowlands zones",
		},
		changes = {
			"The main tooltip's sort order can now also be changed by CTRL-clicking on the tooltip header (in addition to clicking on the LDB icon/minimap button)",
		},
		fixes = {
			"Fixed an issue where duplicate attempts would be detected when defeating certain Timewalking encounters",
			"Fixed waypoint data (including the displayed zone) for certain legacy collectibles",
			"Fixed tracking for Mechagon Peacekeeper, Golden Snorf, and Microbot 8D (Operation: Mechagon)",
			"Mining Elementium veins should now add attempts for Elementium Geode in all Cataclysm zones",
		},
		contributors = { "Tommy Godejord (https://github.com/godejord)" },
	},
	["r704"] = {
		additions = { "Added tracking for various Shadowlands pets and toys that were previously missing" },
		fixes = {
			"Mechagon Peacekeeper should now correctly be displayed in the Group category",
			"Attempts for Gahz'rooki's Summoning Stone should now be tracked correctly when looting relevant Kor'kron NPCs in The Barrens",
		},
		contributors = { "Tommy Godejord (https://github.com/godejord)" },
	},
	["r703"] = {
		additions = {
			"Added tracking for various Shadowlands pets and toys that were previously missing",
			"Added a setting to show the addon's tooltip on click instead of hover",
		},
		changes = { "Removed tracking for various items that appear to have never made it to live servers" },
		fixes = {
			"Removed restrictions placed on the tracking for Theater of Pain rares (to account for Blizzard's stealth hotfix)",
			"Fixed an issue where killing covenant-restricted rares on characters that haven't selected a covenant yet would cause an error",
			"Fixed tracking for Lightbinders (pet)",
		},
		contributors = {
			"Nick Bayley (https://github.com/nickbayley)",
			"Tommy Godejord (https://github.com/godejord)",
			"Mikael Jelveby (https://github.com/jelveby)",
		},
	},
	["r702"] = {
		additions = {
			"Added most rare collectibles available in the Shadowlands expansion (many thanks to Tommy Godejord for helping with this task)",
			"Added a button to always track battle pets repeatedly. Note: This will overwrite all individual settings for the 'repeatable' flag, so beware and/or make a backup of your saved variables first if you're at all unsure",
		},
		changes = {
			"Many collectibles from the Battle for Azeroth expansion are no longer considered group content and have been moved to the 'solo-able' category",
		},
	},
	["r701"] = {
		additions = {
			"Added an option to hide items that are already known from the mouseover tooltip (courtesy of Daniel Bowden) ",
		},
		fixes = {
			"Attempts for the Great Sea Ray should now be correctly tracked while fishing on Mechagon Island and in Boralus",
			"Fixed an error that would occur when Blizzard's bonus roll window was displayed after obtaining a tracked item",
			"Attempts should no longer be added if tracking is disabled for the player's class",
		},
	},
	["r700"] = {
		fixes = { "Fixed errors caused by API changes in the Shadowlands prepatch (there may be more errors still)" },
		notes = { "Thanks to Daniel Bowden (dbowden713)" },
	},
	["r699"] = {
		fixes = {
			"Fixed a UI issue that could cause the tooltip to not be shown when custom items were added with invalid data (or Blizzard's server didn't send any data for the given item)",
			"The tooltip now always displays an item's estimated base drop rate instead of considering the somewhat arbitrary group size setting in order to provide consistent data to players",
			"Added a workaround for some display issues in Blizzard's addon menu that can cause the options window to not open correctly (sigh)",
		},
		additions = {
			"When items with incomplete or invalid data are detected by the addon, a notification will now be displayed. These messages should help narrow down future issues with custom items; they can be disabled with a newly-added setting that is located in the Advanced/Experimental section of the configuration UI (subject to change)",
			"Added a button to remove accountwide statistics for players affected by realm merges, transfers and name changes, to be used if the old character's attempts are still saved and the attempts counts are wrong as a result of the unique ID (name-realm) being different. It can be found in the 'Advanced' section of the options, for now.",
		},
		changes = {
			"Black Tabby Cat is now considered a zonewide drop, obtainable in all of Hillsbrad Foothills",
			"Attempts for Knockoff Blingtron are now added when opening Blingtron 7000 Gift Packages",
		},
	},
	["r698"] = {
		fixes = {
			"Looting an epic-quality Satchel of Chilled Goods (obtained from Frost Lord Ahune during the Midsummer Fire Festival) will now correctly register attempts for the Frigid Frostling pet",
		},
	},
	["r697"] = {
		additions = {
			"Added tracking for pets obtained in the Ny'alotha raid",
			"Added tracking for Skyshards in the phased 8.3 version of the Vale of Eternal Blossoms",
		},
		fixes = {
			"Fixed an error in the fishing detection that could prevent attempts from being registered correctly",
			"Fixed a UI issue that could cause the tooltip loading to fail",
		},
	},
	["r696"] = {
		additions = {
			"Added tracking for collectibles obtained from Horrific Visions (experimental)",
			"Added tracking for the Zan-Tien Lasso (dropped by mogu in the Vale of Eternal Blossoms)",
			"Added tracking for pets obtained from 8.3 paragon caches",
			"Added missing toggle for BFA content in the configuration UI",
		},
		changes = {
			"Updated group size recommendations for 8.3 collectibles",
			"Updated drop rate estimations for mounts obtained in BFA dungeons",
		},
		fixes = {
			"Fixed an issue that could cause additional attempts to be registered when Dunegorger Kraulok died nearby, but wasn't actually engaged",
			"Fixed the detection of pets obtained in the Firelands raid (see notes below)",
		},
		notes = {
			"It appears that Blizzard broke the statistics for the Firelands raid when adding its Timewalking version. Detection for all bosses except Ragnaros and Alysrazor was changed to use NPC looting in order to work around this bug as best as possible, but attempts for items dropped by those two bosses might not always be detected until statistics are being updated correctly again",
		},
	},
	["r695"] = {
		additions = {
			"Added tracking for missing collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms",
			"Added defeat detection for collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms",
			"Added tracking for Crimson Skipper (dropped by Honey Smasher)",
			"Added tracking for Mollie (dropped by Dunegorger Kraulok)",
		},
	},
	["r694"] = {
		additions = {
			"Added tracking for collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms (experimental)",
		},
	},
	["r693"] = {
		fixes = {
			"Fixed integration with the TradeSkillMaster4 addon (used to display pricing info in Rarity's tooltip)",
		},
	},
	["r692"] = {
		additions = { "Added defeat detection for all relevant rares in Nazjatar and Mechagon Island" },
		fixes = {
			"Fixed tracking for the Timewalking version of the Ozumat encounter (Throne of the Tides)",
			"Fixed waypoint coordinates for Rukhmar and Sha of Anger (courtesy of divinemaiden)",
		},
	},
	["r691"] = {
		additions = {
			"Added tracking for collectibles obtained in Nazjatar and Mechagon Island",
			"Added tracking for Paragon rewards from both Nazjatar factions",
			"Added tracking for collectibles obtained from bosses in Azshara's Eternal Palace (raid)",
			"Added tracking for collectibles obtained from bosses in Operation: Mechagon (dungeon)",
		},
	},
	["r690"] = {
		additions = {
			"Added missing NPCs for Goldenmane's Reins",
			"Added support for 8.2 island expedition maps",
			"Added tracking for 8.2 island expedition pets",
			"Added setting to automatically verify the database on login (experimental)",
		},
		fixes = { "Fixed an error caused by Blizzard now blocking addons from accessing files via relative paths" },
		notes = {
			"The remaining collectibles added in patch 8.2 are not yet supported. While this is being resolved, you may want to try this user-provided import string: https://www.curseforge.com/wow/addons/rarity?comment=1883",
		},
	},
	["r689"] = {
		additions = {
			"Added tracking for WOD Timewalking encounters to the Infinite Timereaver mount (courtesy of redpandamonium)",
		},
		fixes = {
			"Removed some BFA Paragon reward toys that didn't make it to live servers",
			"Fishing in Mac'aree and Krokuun (on Argus) should now correctly add attempts for the Pond Nettle mount",
			"The Emerald Whelpling pet should now be listed with its proper name",
		},
	},
	["r688"] = {
		fixes = {
			"Resolved some display issues for faction-specific mounts that can be obtained from Darkshore rares",
			"Fixed tracking for Spawn of Garalon",
		},
	},
	["r687"] = {
		additions = {
			"Added tracking for the Great Sea Ray mount (courtesy of ZaruthEU)",
			"Added tracking for Raiding with Leashes VI: Pets of Pandaria",
		},
		fixes = { "Improved defeat detection for the G.M.O.D. mount (still somewhat experimental)" },
	},
	["r686"] = {
		additions = {
			"Added tracking for new collectibles that were added to Island Expeditions in 8.1 (the accuracy remains highly debatable)",
		},
		fixes = {
			"The tooltip for Mekkatorque (Normal/Heroic/Mythic) and Lady Jaina Proudmoore (LFR) should now show that the G.M.O.D. can be obtained from this encounter in the respective difficulty",
			"Attempts for the Kaldorei Nightsaber mount (Drop: Darkshore) should now be tracked correctly for both factions",
		},
	},
	["r685"] = {
		fixes = { "Updated tracking for the G.M.O.D. mount to account for a recent hotfix by Blizzard" },
		notes = {
			"This mount now drops from Lady Jaina Proudmoore in LFR difficulty only. The tooltip won't indicate this until it can be corrected in a future update.",
		},
	},
	["r684"] = {
		additions = {
			"Added tracking for collectibles that can be obtained in the Battle of Dazar'alor raid (experimental)",
		},
		fixes = {
			"Fishing from pools in Skettis (Draenor) should no longer incorrectly add attempts for Mr. Pinchy",
			"Attempts for the Everburning Treant pet should now be properly tracked for players of both factions",
		},
	},
	["r683"] = {
		additions = {
			"Added tracking for collectibles dropped by rares in Darkshore",
			"Added defeat detection for Midnight's Eternal Reins (Return to Karazhan)",
		},
		fixes = { "Fixed tracking for pets obtained from BFA paragon reward boxes " },
	},
	["r682"] = {
		additions = {
			"Added tracking for BFA paragon reputation rewards",
			"Added an option to display TSM pricing data in the addon's tooltips (courtesy of zsml) - This feature requires the TradeSkillMaster addon",
		},
	},
	["r681"] = { fixes = { "Fixed tracking for Skyshard attempts while in the Guo-Lai Halls subzone" } },
	["r680"] = {
		fixes = {
			"Defeat detection for rares in the Arathi Highlands should now function correctly regardless of the player's faction",
		},
		additions = { "Added defeat detection for The Lion's Roar and Doom's Howl" },
	},
	["r679"] = {
		additions = {
			"Added tracking for BOE mount drops from BFA zones: Terrified Pack Mule, Dune Scavenger, Leaping Veinseeker, and Goldenmane",
		},
		fixes = {
			"Completing The Underrot, Freehold, or King's Rest dungeons (Mythic Keystone difficulty) should now correctly add attempts for the mounts that the Challenger's Cache may contain (see notes below)",
		},
		notes = {
			"Challenge mode (Mythic Keystone) detection is experimental at this point. Please report any issues you may encounter!",
		},
	},
	["r678"] = {
		additions = {
			"Added tracking for the remaining collectibles (pets and toys) dropped by rares in the Arathi Highlands",
			"Added tracking for both toys obtainable from the Arathi Highlands world bosses (Doom's Howl and The Lion's Roar)",
		},
		changes = {
			'Existing mounts that are dropped by rares in the Arathi Highlands are now listed under the "Groups" category if defeating said rare tends to require a group',
		},
		fixes = {
			"Luckiness calculation for the mounts dropped by rares in the Arathi Highlands now correctly assumed Personal Loot",
			"Statistics tracking for the mounts dropped from Mythic difficulty dungeon bosses in The Underrot, Freehold, and King's Rest should now function properly",
		},
		issues = {
			"Looting a Challenger's Cache in The Underrot, Freehold, or King's Rest (Mythic Keystone difficulty) doesn't currently add attempts for the mounts that it may contain",
			"Defeat detection for The Lion's Roar is not currently implemented (see notes below)",
			"Defeat detection for Knight-Captain Aldrin doesn't currently work (see notes below)",
			"The drop rates for many, if not most, of the new items are likely inaccurate. They will have to be updated once more data is available",
		},
		notes = {
			"I don't have a Horde character at max level. Someone will have to find out the quest ID - feel free to message me for instructions on how to do this (it's quite simple if you haven't killed the boss yet for a given warfront cycle)",
			"It is unclear whether or not the toys from Arathi Highlands world bosses can be obtained via bonus roll. Please let me know if someone has obtained them after using theirs. For the time being, Rarity will not consider bonus rolls to  be valid attempts, which may or may not be correct.",
		},
	},
	["r677"] = {
		additions = {
			"Added tracking for all collectibles obtainable from Island Expeditions (see notes below)",
			"Added item: Viable Cobra Egg (Drop: Merektha)",
		},
		changes = {
			"Reverted a minor cosmetic change to the addon's output that had harmless, but unintended, side effects",
		},
		fixes = {
			"Looting Nok-Karosh should no longer count attempts for the Eye of Observation pet (which is a drop from Orumo the Observer)",
		},
		notes = {
			"Since there's virtually no data on anything regarding these items right now, most estimates are little more than a wild guess. They will need to be refined in future updates.",
		},
	},
	["r676"] = {
		additions = {
			"Added tracking for mount: Hellfire/Felblaze Infernal (Drop: Gul'dan)",
			"Added tracking for mount: Shackled Ur'zul (Drop: Argus the Unmaker)",
			"Added tracking for mounts that will be obtainable from killing the Warfront: Arathi Highlands rares (see notes below)",
			"Added tracking for mounts obtainable from Mythic difficulty BFA dungeons",
		},
		changes = {
			"All Warlords of Draenor raids are now considered soloable",
			"Midnight's Eternal Reins: Attumen the Huntsman is now considered soloable",
			"Updated group size estimations for various Legion raids",
		},
		fixes = {
			"Mouseover tooltips for the Assembly of Iron encounter in Ulduar should once again display tracking data for Stormforged Rune",
			"Fixed TomTom waypoint creation for some rares on Argus that previously had invalid entries",
			"Looting Frostdeep Cavedwellers in the Horde garrison should now correctly add attempts for the Riding Turtle mount",
		},
		notes = {
			"Since there isn't any data available, it's virtually guaranteed that the drop chances for these items are wrong. They will be corrected in a future update.",
			"Defeat detection for the new rares is also not yet implemented.",
		},
	},
	["r675"] = {
		additions = {
			'Added tooltip for the "Adventurer of ..." exploration achievements to all relevant rares in Kul\'tiras and Zandalar',
		},
		fixes = { "Fixed tracking for Stormforged Rune (Drop: The Assembly of Iron)" },
	},
	["r674"] = {
		additions = { 'Added tooltip for the "Commander of Argus" achievement to all relevant rares on Argus' },
		fixes = { "Fixed tooltip display for Fossorial Bile Larva (Profession: Skinning)" },
	},
	["r673"] = {
		changes = { "Installing the addon without embedded libraries is no longer possible" },
		notes = {
			'This Curse/Twitch "feature" caused many bug reports and offers little tangible benefit, as it was often done in error or automatically by the Twitch client. I ultimately chose to disable it in order to reduce the time spent on providing support instead of working on bug fixes or new features',
		},
	},
	["r672"] = {
		additions = { "Added pet: Fel Lasher", "Added pet: Fossorial Bile Larva" },
		fixes = {
			"Fixed detection for various 8.0.1 gathering (and fishing) spells that had not already been supported",
		},
	},
	["r671"] = { changes = { "Minor cosmetic changes to the addon's output" } },
	["r670"] = {
		fixes = {
			"Casting Pick Pocket on NPCs that drop items Rarity is tracking should no longer incorrectly add attempts for those items",
		},
	},
	["r669"] = {
		fixes = { "Fixed TomTom waypoint creation for 8.0.1 (BFA pre-patch)" },
		changes = {
			"Garn Nighthowl is now considered soloable",
			"Rukhmar is now considered soloable",
			"Solar Spirehawk: Updated the mount's drop rate using wowhead data",
			"Living Infernal Core: Luckiness calculations now assume Personal Loot",
			"Midnight's Eternal Reins: Luckiness calculations now assume Personal Loot",
			"Eye of Observation: Luckiness calculations now assume Personal Loot",
		},
		notes = {
			"The luckiness calculation of several items was inaccurate due to wrong or outdated data. The BFA pre-patch further caused some mischief with its Personal/Legacy Loot rules",
		},
	},
	["r668"] = {
		fixes = { "Fixed error caused by invalid Archaeology projects data" },
		notes = {
			"The data itself remains untouched and should update with the next solve, but it's also possible to reset attempts manually (and have them update immediately)",
		},
	},
	["r667-release"] = { changes = { "Updated drop rate for Magnataur Hunting Horn (Snobold companion)" } },
}

return changes
