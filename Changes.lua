local changes = {
	["r693"] = {
		fixes = {
			"Fixed integration with the TradeSkillMaster4 addon (used to display pricing info in Rarity's tooltip)",
		},
	},
	["r692"] = {
		additions = {
			"Added defeat detection for all relevant rares in Nazjatar and Mechagon Island",
		},
		fixes = {
			"Fixed tracking for the Timewalking version of the Ozumat encounter (Throne of the Tides)",
			"Fixed waypoint coordinates for Rukhmar and Sha of Anger (courtesy of divinemaiden)"
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
		fixes = {
			"Fixed an error caused by Blizzard now blocking addons from accessing files via relative paths",
		},
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
		}
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
		fixes = {
			"Improved defeat detection for the G.M.O.D. mount (still somewhat experimental)",
		},
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
		fixes = {
			"Updated tracking for the G.M.O.D. mount to account for a recent hotfix by Blizzard",
		},
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
		fixes = {
			"Fixed tracking for pets obtained from BFA paragon reward boxes ",
		},
	},
	["r682"] = {
		additions = {
			"Added tracking for BFA paragon reputation rewards",
			"Added an option to display TSM pricing data in the addon's tooltips (courtesy of zsml) - This feature requires the TradeSkillMaster addon",
		},
	},
	["r681"] = {
		fixes = {
			"Fixed tracking for Skyshard attempts while in the Guo-Lai Halls subzone",
		},
	},
	["r680"] = {
		fixes  = {
			"Defeat detection for rares in the Arathi Highlands should now function correctly regardless of the player's faction",
		},
		additions = {
			"Added defeat detection for The Lion's Roar and Doom's Howl",
		},
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
			"Existing mounts that are dropped by rares in the Arathi Highlands are now listed under the \"Groups\" category if defeating said rare tends to require a group",
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
			"Added tracking for mounts obtainable from Mythic difficulty BFA dungeons"
		},
		changes = {
			"All Warlords of Draenor raids are now considered soloable",
			"Midnight's Eternal Reins: Attumen the Huntsman is now considered soloable",
			"Updated group size estimations for various Legion raids",
		},
		fixes= {
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
			"Added tooltip for the \"Adventurer of ...\" exploration achievements to all relevant rares in Kul'tiras and Zandalar",
		},
		fixes = {
			"Fixed tracking for Stormforged Rune (Drop: The Assembly of Iron)",
		},
	},
	["r674"] = {
		additions = {
			"Added tooltip for the \"Commander of Argus\" achievement to all relevant rares on Argus",
		},
		fixes = {
			"Fixed tooltip display for Fossorial Bile Larva (Profession: Skinning)",
		},
	},
	["r673"] = {
		changes = {
				"Installing the addon without embedded libraries is no longer possible",
			},
			notes = {
				"This Curse/Twitch \"feature\" caused many bug reports and offers little tangible benefit, as it was often done in error or automatically by the Twitch client. I ultimately chose to disable it in order to reduce the time spent on providing support instead of working on bug fixes or new features"
			},
		},
	["r672"] = {
		additions = {
			"Added pet: Fel Lasher",
			"Added pet: Fossorial Bile Larva"
		},
		fixes = {
			"Fixed detection for various 8.0.1 gathering (and fishing) spells that had not already been supported",
		},
	},
	["r671"] = {
		changes = {
			"Minor cosmetic changes to the addon's output",
		},
	},
	["r670"] = {
			fixes = {
				"Casting Pick Pocket on NPCs that drop items Rarity is tracking should no longer incorrectly add attempts for those items",
			},
		},
	["r669"] = {
		fixes = {
			"Fixed TomTom waypoint creation for 8.0.1 (BFA pre-patch)",
		},
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
		fixes = {
			"Fixed error caused by invalid Archaeology projects data",
		},
		notes = {
			"The data itself remains untouched and should update with the next solve, but it's also possible to reset attempts manually (and have them update immediately)"
		},
	},
	["r667-release"] = {
		changes = {
			"Updated drop rate for Magnataur Hunting Horn (Snobold companion)",
		},
	},
}

return changes
