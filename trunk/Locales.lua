local L
L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "enUS", true)













L["Loading"] = true
L["Loaded (running in debug mode)"] = true
L["Profile modified, rebooting"] = true
L["(running in debug mode)"] = true
L["Debug mode OFF"] = true
L["Debug mode ON"] = true
L["Welcome to Rarity r%d. Your settings have been reset."] = true
L["The Rarity Options module has been disabled. Log out and enable it from your add-ons menu."] = true
L["Obtained On Your First Attempt"] = true
L["Obtained After %d Attempts"] = true
L["Unknown"] = true
L["Attempts"] = true
L["Progress"] = true
L["Likelihood"] = true
L["Time"] = true
L["Battle Pets"] = true
L["%s: %d attempt"] = true
L["%s: %d attempts"] = true
L["Luckiness"] = true
L["Lucky"] = true
L["Unlucky"] = true
L["Mounts"] = true
L[" (Group)"] = true
L["Shift-Click to open options"] = true
L["Click to toggle the progress bar"] = true
L["%d attempt - %.2f%%"] = true
L["%d attempts - %.2f%%"] = true
L["Found on your first attempt!"] = true
L["Found after %d attempts!"] = true
L["Toys & Items"] = true
L["%s: %d attempt (%d total)"] = true
L["%s: %d attempts (%d total)"] = true
L["Dwarf"] = true
L["Draenei"] = true
L["Fossil"] = true
L["Night Elf"] = true
L["Nerubian"] = true
L["Orc"] = true
L["Tol'vir"] = true
L["Troll"] = true
L["Vrykul"] = true
L["Other"] = true
L["Drops from NPC(s)"] = true
L["Drops from a boss requiring a group"] = true
L["Drops from any mob in a zone"] = true
L["Obtained by using an item or opening a container"] = true
L["Obtained by fishing"] = true
L["Obtained as an archaeology project"] = true
L["Mount"] = true
L["Battle Pet"] = true
L["Toy or Item"] = true
L["Usually requires a group of around %d players"] = true
L["1 in %d chance"] = true
L["Lucky if you obtain in %d or less"] = true
L["Since last drop"] = true
L["Time spent farming"] = true
L["Chance so far"] = true
L["Total"] = true
L["Total found"] = true
L["Bunny Hunter is running. Would you like Rarity to import data from Bunny Hunter now? Disable Bunny Hunter or click Yes if you don't want to be asked again."] = true
L["Data has been imported from Bunny Hunter"] = true
L["#%d: %d attempt (%.2f%%)"] = true
L["#%d: %d attempts (%.2f%%)"] = true
L["Already known"] = true
L["General"] = true
L["Show minimap icon"] = true
L["Turns on a minimap icon for Rarity. Use this option if you don't have an LDB display add-on."] = true
L["Announcements"] = true
L["Enable announcements"] = true
L["Enables announcements whenever you complete a new attempt toward anything Rarity is tracking. You can also enable announcements per-item, but this is the master switch."] = true
L["Feed text"]= true
L["Controls what type of text is shown in Rarity's LDB feed. Minimal shows just the number of attempts. Normal adds the likelihood percent, and verbose adds the item link."] = true
L["Minimal"] = true
L["Normal"] = true
L["Verbose"] = true
L["%d attempts"] = true
L["%d attempt"] = true
L["%s: %d attempt - %.2f%%"] = true
L["%s: %d attempts - %.2f%%"] = true
L["Create a new item to track"] = true
L["Delete this item"] = true
L["Are you sure you want to delete this item?"] = true
L["Create a New Item"] = true
L["New item"] = true
L["Custom"] = true
L["To create a new item, enter a unique name for the item, and click Okay. The name will be used if the server does not return the item link or if the item is invalid.\n\nYou can't change this name after you create the item, so choose it well."] = true
L["Item ID"] = true
L["The item ID to track. This is the item as it appears in your inventory or in a loot window. Use WowHead or a similar service to lookup item IDs. This must be a valid number and must be unique."] = true
L["You must enter an item ID."] = true
L["You must enter a valid number."] = true
L["You entered an item ID that is already being used by another item."] = true
L["How likely the item is to appear, expressed as 1 in X, where X is the number you enter here."] = true
L["Chance"] = true
L["You must enter an amount."] = true
L["You must enter a number larger than 1."] = true
L["You must enter a number larger than or equal to 0."] = true
L["How many attempts you've made so far."] = true
L["Track this"] = true
L["Determines whether tracking should be enabled for this item. Items that are disabled will not appear in the tooltip."] = true
L["Repeatable"] = true
L["Determines whether you want to repeatedly farm this item. If you turn this on and find the item, Rarity will mark the item as un-found after a few seconds."] = true
L["Enables announcements whenever you complete a new attempt toward this item."] = true
L["Type of item"] = true
L["Announce"] = true
L["Determines what type of item this is."] = true
L["Identify the Item"] = true
L["Toggles"] = true
L["Statistics"] = true
L["Spell ID"] = true
L["You must enter a spell ID."] = true
L["You entered a spell ID that is already being used by another item."] = true
L["The spell ID of the item once you've learned it. This applies only to mounts and companions, and is the spell as it appears in your spell book after learning the item. Use WowHead or a similar service to lookup spell IDs. This must be a valid number and must be unique."] = true
L["You must enter a number larger than 0."] = true
L["Method of obtaining"] = true
L["Determines how this item is obtained."] = true
L["Group size"] = true
L["The number of players it takes to obtain the item. This will lower your chances of obtaining the item."] = true
L["Equal odds"] = true
L["Turn this on if the item requires a group to obtain, but every player gets an equal chance to obtain the item. This currently only applies to some of the holiday mounts. When you turn this on, Rarity will stop lowering your chance to obtain based on the group size."] = true
L["Archaeology race"] = true
L["Determines which race includes this archaeology project."] = true
L["Zones"] = true
L["A comma-separated list of the zones or sub-zones this item can be found in. For zones, you can enter either the Map ID (i.e. 811 is Vale of Eternal Blossoms), or the full name of the zone. For sub-zones, you must enter the full name of the sub-zone.\n\nEnter zone names with proper spelling, capitalization, and punctuation. They can be entered either in US English or your client's local language. Use WowHead or a similar service to make sure you're entering the zone names perfectly.\n\nPLEASE NOTE: Zone translations may not be correct. For zones, it is highly recommended that you use the Map ID instead of the name. For sub-zones, you must enter the name. If sub-zone detection isn't working for you, please visit the LibBabble-SubZone-3.0 library page on wowace.com and update the translations for your language."] = true
L["One of the Map IDs you entered (%s) is incorrect. Please enter numbers larger than zero."] = true
L["You must enter at least one zone."] = true
L["Please enter a comma-separated list of zones."] = true
L["One of the zones or sub-zones you entered (%s) cannot be found. Check that it is spelled correctly, and is either US English or your client's local language."] = true
L["Items to Use"] = true
L["A comma-separated list of item IDs which, when used or opened, can give you this item. Use WowHead or a similar service to lookup item IDs."] = true
L["You must enter at least one item ID."] = true
L["Please enter a comma-separated list of item IDs."] = true
L["Every item ID must be a number greater than 0."] = true
L["NPCs"] = true
L["A comma-separated list of NPC IDs who drop this item. Use WowHead or a similar service to lookup NPC IDs."] = true
L["You must enter at least one NPC ID."] = true
L["Please enter a comma-separated list of NPC IDs."] = true
L["Every NPC ID must be a number greater than 0."] = true
L["The name you entered is already being used by another item. Please enter a unique name."] = true
L["You entered a reserved name. Please enter the correct item name as it appears in game."] = true
L["Click to switch to this item"] = true
L["Shift-Click to link your progress to chat"] = true
L["%s: 0/%d attempts so far (%.2f%% - %s)"] = true
L["%s: 0/%d attempt so far (%.2f%% - %s)"] = true
L["lucky"] = true
L["unlucky"] = true
L["Requires a pool"] = true
L["Determines whether the item can only be obtained from fishing in pools. In order for this option to work, the fishing pools must have all been translated into your client's language."] = true
L["Special case"] = true
L["Obtained by mining"] = true
L["Mysterious Camel Figurine"] = true
L["Obtained by mining Elementium Vein"] = true
L["Session"] = true
L["Today"] = true
L["Yesterday"] = true
L["Last Week"] = true
L["Last Month"] = true
L["Left"] = true
L["Right"] = true
L["Hidden"] = true
L["Controls on which side the secondary tooltip appears when you hover over an item in the main tooltip. If the main tooltip is on the right side of your screen, change this to Left. Otherwise, choose Right. You can also hide the status tooltip completely."] = true
L["Kill Statistic IDs"] = true
L["A comma-separated list of Statistic IDs that track the number of kills toward obtaining this item."] = true
L["You must enter at least one Statistic ID."] = true
L["Please enter a comma-separated list of Statistic IDs."] = true
L["A comma-separated list of Statistic IDs that track the number of kills toward obtaining this item. These statistics will be added together. Use WowHead or a similar service to locate statistic IDs."] = true
L["Ctrl-Click to change sort order"] = true
L["Sorting by name"] = true
L["Sorting by difficulty"] = true
L["Sorting by percent complete"] = true
L["Progress Bar"] = true
L["Width"] = true
L["Height"] = true
L["Scale"] = true
L["Show anchor"] = true
L["Locked"] = true
L["Other Requirements"] = true
L["Horde only"] = true
L["This item is only available to Horde players."] = true
L["Alliance only"] = true
L["This item is only available to Alliance players."] = true
L["Debug mode"] = true
L["Enter 1 or leave this blank to mark the item as soloable."] = true
L["Classic"] = true
L["The Burning Crusade"] = true
L["Wrath of the Lich King"] = true
L["Cataclysm"] = true
L["Mists of Pandaria"] = true
L["Holiday"] = true
L["Content Category"] = true
L["These toggles control which items appear in the main Rarity tooltip. Items are categorized by the expansion they were introduced in (although holiday items have a separate category). Turning off these checkboxes does not turn off tracking for any items within the category; it simply hides the item from the tooltip in order to help reduce the number of items in it."] = true
L["Hide high chance items"] = true
L["When on, this option hides any item with a drop chance of 1 in 49 or better. The item is merely hidden from the tooltip in order to keep it clean. Items hidden in this fashion are still tracked like normal."] = true
L["Undefeated"] = true
L["Defeated"] = true
L["Creature ID"] = true
L["The NPC ID of the creature that is spawned when you summon this pet. This is used to track account-wide battle pets."] = true
L["You must enter a creature ID."] = true
L["You entered a creature ID that is already being used by another item."] = true
L["Mantid"] = true
L["Pandaren"] = true
L["Mogu"] = true
L["Enable Coins"] = true
L["When any good-luck coin is used within about 90 seconds of an attempt on this item, another attempt will be counted for this item. Only enable this for items which can legitimately be obtained from coin rolls."] = true
L["Warlords of Draenor"] = true
L["Arakkoa"] = true
L["Draenor Clans"] = true
L["Ogre"] = true
L["Obtained by collecting a number of items"] = true
L["Collect %d %s"] = true
L["Collected"] = true
L["Dropped from dinosaurs on Isle of Giants"] = true
L["Collection complete!"] = true
L["%d collected - %.2f%%"] = true
L["Collection Complete"] = true
L["How many items you've collected so far."] = true
L["Collection Size"] = true
L["How many items you need to collect."] = true
L["Item ID to Collect"] = true
L["The item ID that you need to collect. Rarity uses the number of this item that you have in your bags as your progress. Use WowHead or a similar service to lookup item IDs. This must be a valid number and must not be used by another item."] = true
L["You entered an item ID that is already set as the collected item for something else."] = true
L["%s: %d collected"] = true
L["Rarity: "] = true
L["Enable tooltip additions"] = true
L["When enabled, Rarity will add obtainable items to game tooltips whenever possible."] = true
L["Blank line before tooltip additions"] = true
L["This causes Rarity to put a blank line above its tooltip additions."] = true
L["Font"] = true
L["Texture"] = true
L["Font Size"] = true
L["Right-Aligned"] = true
L["Show Icon"] = true
L["Show Text"] = true
L["Achievement ID"] = true
L["Set this to the achievement ID which indicates this item has been obtained. This is useful for items which do not yield mounts or pets, but which do grant an achievement when obtained, such as Old Crafty or Old Ironjaw. Leave this blank for mounts and pets. Use WowHead to find achievement IDs."] = true
L["You entered a achievement ID that is already being used by another item."] = true
L["Instance Difficulty"] = true
L["Determines which instance difficulties this item may be obtained in. Leave everything unchecked if the instance difficulty doesn't matter.\n\nIf you specified a Statistic ID for this item, the Instance Difficulty is probably meaningless, because all modern statistics already incorporate the difficulty.\n\nYou can check multiple items in this list at once."] = true
L["Take screenshots"] = true
L["When on, Rarity will take a screenshot when the achievement alert pops up indicating that you obtained an item."] = true
L["Already known"] = true
L["(%d/%d attempts)"] = true
L["(%d/%d collected)"] = true
L["Show attempts in tooltips"] = true
L["When enabled, Rarity tooltips will include how many attempts you've made."] = true
L["Already defeated"] = true
L["Unavailable"] = true
L["Hide unavailable items"] = true
L["When on, items marked as Unavailable will be hidden from the tooltip. This way, items requiring a certain holiday will automatically be hidden when the holiday is not active."] = true
L["Holiday reminders"] = true
L["When on, Rarity will remind you to go farm holiday items you're missing if the holiday is active and the item is set as Undefeated. (This only works for items that originate from holiday dungeons or daily quests.) The reminder occurs each time you log in or reload your UI, and stops for the day once you defeat the holiday dungeon or complete the	quest."] = true
L["A holiday event is available today for %s! Go get it!"] = true
L["You can turn off holiday reminders as a whole or on an item-by-item basis by visiting the Rarity Options screen."] = true
L["Sorting by category, then name"] = true
L["Show category icons"] = true
L["When on, Rarity will show an icon next to each item in the tooltip indicating which expansion the item belongs to."] = true
L["Primary tooltip scale"] = true
L["Adjusts the scale of the primary tooltip. This will take effect the next time the tooltip is shown."] = true
L["Rarity Tooltip Options"] = true
L["World Tooltip Options"] = true
L["General Options"] = true
L["Secondary tooltip display"] = true
L["Requires Pickpocketing"] = true
L["When enabled, the item can only be obtained by pickpocketing. The item will be marked Unavailable for non-rogues."] = true
L["Required for %s"] = true
L["Already defeated for %s"] = true
L["Profiling ON"] = true
L["Profiling OFF"] = true
L["Enable profiling"] = true
L["When enabled, Rarity will print debug profiling messages to the chat window when certain things happen. This is used to determine which parts of the code are slow."] = true



-- Sources
L[""] = true
L["This was a guaranteed drop for players who defeated the encounter when it was current"] = true
L["Players have a personal loot chance to obtain this item."] = true
L["All players can participate in killing this world boss once per week, regardless of faction"] = true
L["Contained in bonus satchels"] = true
L["Appears in the Black Market"] = true
L["Can be obtained with a bonus roll"] = true
L["This mount is only obtainable by Alliance players"] = true
L["This mount is only obtainable by Horde players"] = true

L["All raid formats except Raid Finder"] = true
L["Any raid size or difficulty"] = true
L["25-player heroic"] = true
L["Mythic difficulty"] = true
L["Heroic difficulty"] = true
L["Any difficulty"] = true
L["Any raid size"] = true
L["Heroic, any raid size"] = true
L["Only Raid Finder difficulty"] = true
L["Raid Finder or Flexible difficulty"] = true

L["Dropped by Yogg-Saron in Ulduar (25-player) with no Keepers assisting"] = true
L["Dropped by Malygos in The Eye of Eternity (any raid size)"] = true
L["Dropped by Koralon the Flame Watcher, Emalon the Storm Watcher, Archavon the Stone Watcher, and Toravon the Ice Watcher in Vault of Archavon (any raid size)."] = true
L["Contained in Cracked Egg, which is obtained by becoming Revered with The Oracles, purchasing a Mysterious Egg from their reputation vendor, and waiting three days. The mount has a 5% chance to appear in the Cracked Egg."] = true
L["Contained in Ripe Disgusting Jar, which is obtained by becoming Revered with Frenzyheart Tribe, purchasing a Disgusting Jar from their reputation vendor, and waiting three days."] = true
L["Dropped by Onyxia in Onyxia's Lair (any raid size)"] = true
L["Contained in Hyldnir Spoils, which is rewarded for completing daily quests given by Gretta the Arbiter in Brunnhildar Village, Storm Peaks. The mount has a 3% chance to appear in Hyldnir Spoils."] = true
L["Obtained very rarely by fishing in pools located in any expansion zone (not Classic zones)"] = true
L["Dropped by Ultraxion in Dragon Soul (any raid size or difficulty)"] = true
L["Obtained as a rare project for the Fossil branch of archaeology"] = true
L["Dropped by the Madness of Deathwing encounter in Dragon Soul (any raid size or difficulty)"] = true
L["Guaranteed drop from Dormus the Camel-Hoarder. Accessing this encounter requires finding a rare Mysterious Camel Figurine in Uldum. These are difficult to spot and, when clicked, have a small chance to grant you access to the Dormus encounter. Rarity will count how many Figurines you've found if you mouseover them."] = true
L["Obtained as a very rare project for the Tol'vir branch of archaeology"] = true
L["Dropped by the Madness of Deathwing encounter in Dragon Soul (heroic, any raid size)"] = true
L["The Warbringer will be riding the mount color he has a chance to drop."] = true
L["Can be contained in Heart-Shaped Box, rewarded for defeating the World Event Dungeon during Love is in the Air."] = true
L["Can be contained in Keg-Shaped Treasure Chest, rewarded for defeating the World Event Dungeon during Brewfest."] = true
L["Can be contained in Loot-Filled Pumpkin, rewarded for defeating the World Event Dungeon during Hallow's End."] = true
L["Dropped by Elegon in Mogu'shan Vaults (all raid formats except Raid Finder)"] = true
L["Obtained by fishing in pools located in Terrokar Forest"] = true
L["Obtained by fishing in any water in Orgrimmar"] = true
L["Obtained by fishing in any water in Ironforge"] = true
L["Dropped by dinosaurs on Isle of Giants Will hatch into one of three Primal Raptor mounts after three days."] = true
L["Dropped by any mob in Vale of Eternal Blossoms (except minor mobs). 10 of these can be combined to pierce Alani's shield, allowing combat and a guaranteed drop of Reins of the Thundering Ruby Cloud Serpent."] = true
L["Earned by giving 9999 Giant Dinosaur Bones to Ku'ma on Isle of Giants. Giant Dinosaur bones drop from all dinosaurs and Zandalari Dinomancers on Isle of Giants."] = true
L["This bag is rewarded for earning a Gold Victory in a garrison invasion."] = true
L["This bag is rewarded for completing the pet battle daily offered by Jeremy Feasel at the Darkmoon Faire."] = true
L["This bag is rewarded for completing the pet battle daily offered by Christoph VonFeasel at the Darkmoon Faire."] = true
L["This item has a 1 in 4 chance to drop from Golganarr, a rare spawn on Timeless Isle. It has a 1 in 250 chance to drop from Eroded Cliffdweller on Timeless Isle."] = true
L["Dropped by Disturbed Podling, which has a chance to spawn when picking herbs at your garrison."] = true
L["Dropped by Goren Protector, which has a chance to spawn when mining ore at your garrison."] = true


-- Instance difficulties
L["None (not in an instance)"] = true
L["5-player instance"] = true
L["5-player Heroic instance"] = true
L["10-player Raid instance (legacy content; not flexible)"] = true
L["25-player Raid instance (legacy content; not flexible)"] = true
L["10-player Heroic Raid instance (legacy content; not flexible)"] = true
L["25-player Heroic Raid instance (legacy content; not flexible)"] = true
L["Raid Finder instance (legacy content; fixed at 25 players)"] = true
L["Challenge Mode instance"] = true
L["40-player Raid instance (legacy content; not flexible)"] = true
L["Heroic Scenario instance"] = true
L["Scenario instance"] = true
L["Normal Raid (10-30 players)"] = true
L["Heroic Raid (10-30 players)"] = true
L["Mythic Raid (20 player)"] = true
L["Looking For Raid (10-30 players)"] = true

-- Fishing pools
L["Floating Wreckage"] = true
L["Patch of Elemental Water"] = true
L["Floating Debris"] = true
L["Floating Debris Pool"] = true
L["Oil Spill"] = true
L["Firefin Snapper School"] = true
L["Greater Sagefish School"] = true
L["Oily Blackmouth School"] = true
L["Sagefish School"] = true
L["School of Deviate Fish"] = true
L["Stonescale Eel Swarm"] = true
L["Muddy Churning Water"] = true
L["Highland Mixed School"] = true
L["Pure Water"] = true
L["Bluefish School"] = true
L["Feltail School"] = true
L["Brackish Mixed School"] = true
L["Mudfish School"] = true
L["School of Darter"] = true
L["Sporefish School"] = true
L["Steam Pump Flotsam"] = true
L["School of Tastyfish"] = true
L["Borean Man O' War School"] = true
L["Deep Sea Monsterbelly School"] = true
L["Dragonfin Angelfish School"] = true
L["Fangtooth Herring School"] = true
L["Floating Wreckage Pool"] = true
L["Glacial Salmon School"] = true
L["Glassfin Minnow School"] = true
L["Imperial Manta Ray School"] = true
L["Moonglow Cuttlefish School"] = true
L["Musselback Sculpin School"] = true
L["Nettlefish School"] = true
L["Strange Pool"] = true
L["Schooner Wreckage"] = true
L["Schooner Wreckage Pool"] = true
L["Waterlogged Wreckage"] = true
L["Waterlogged Wreckage Pool"] = true
L["Bloodsail Wreckage"] = true
L["Bloodsail Wreckage Pool"] = true
L["Lesser Sagefish School"] = true
L["Lesser Oily Blackmouth School"] = true
L["Sparse Oily Blackmouth School"] = true
L["Abundant Oily Blackmouth School"] = true
L["Teeming Oily Blackmouth School"] = true
L["Lesser Firefin Snapper School"] = true
L["Sparse Firefin Snapper School"] = true
L["Abundant Firefin Snapper School"] = true
L["Teeming Firefin Snapper School"] = true
L["Lesser Floating Debris"] = true
L["Sparse Schooner Wreckage"] = true
L["Abundant Bloodsail Wreckage"] = true
L["Teeming Floating Wreckage"] = true
L["Albino Cavefish School"] = true
L["Algaefin Rockfish School"] = true
L["Blackbelly Mudfish School"] = true
L["Fathom Eel Swarm"] = true
L["Highland Guppy School"] = true
L["Mountain Trout School"] = true
L["Pool of Fire"] = true
L["Shipwreck Debris"] = true
L["Deepsea Sagefish School"] = true
L["Emperor Salmon School"] = true
L["Giant Mantis Shrimp Swarm"] = true
L["Golden Carp School"] = true
L["Jade Lungfish School"] = true
L["Krasarang Paddlefish School"] = true
L["Redbelly Mandarin School"] = true
L["Reef Octopus Swarm"] = true
L["Floating Shipwreck Debris"] = true
L["Jewel Danio School"] = true
L["Spinefish School"] = true
L["Tiger Gourami School"] = true
L["Large Swarm of Migrated Reef Octopus"] = true
L["Large Pool of Sha-Touched Spinefish"] = true
L["Large Pool of Glowing Jade Lungfish"] = true
L["Large Pool of Crowded Redbelly Mandarin"] = true
L["Large Tangled Mantis Shrimp Cluster"] = true
L["Large Swarm of Panicked Paddlefish"] = true
L["Large Pool of Tiger Gourami Slush"] = true
L["Large Pool of Glimmering Jewel Danio Pool"] = true
L["Large Pool of Brew Frenzied Emperor Salmon"] = true
L["Brew Frenzied Emperor Salmon"] = true
L["Glimmering Jewel Danio Pool"] = true
L["Tiger Gourami Slush"] = true
L["Swarm of Panicked Paddlefish"] = true
L["Tangled Mantis Shrimp Cluster"] = true
L["Crowded Redbelly Mandarin"] = true
L["Glowing Jade Lungfish"] = true
L["Sha-Touched Spinefish"] = true
L["Abyssal Gulper School"] = true
L["Oily Abyssal Gulper School"] = true
L["Blackwater Whiptail School"] = true
L["Blind Lake Sturgeon School"] = true
L["Fat Sleeper School"] = true
L["Fire Ammonite School"] = true
L["Jawless Skulker School"] = true
L["Sea Scorpion School"] = true
L["Oily Sea Scorpion School"] = true
L["Savage Piranha Pool"] = true

-- Mining nodes
L["Copper Vein"] = true
L["Tin Vein"] = true
L["Iron Deposit"] = true
L["Silver Vein"] = true
L["Gold Vein"] = true
L["Mithril Deposit"] = true
L["Ooze Covered Mithril Deposit"] = true
L["Truesilver Deposit"] = true
L["Ooze Covered Silver Vein"] = true
L["Ooze Covered Gold Vein"] = true
L["Ooze Covered Truesilver Deposit"] = true
L["Ooze Covered Rich Thorium Vein"] = true
L["Ooze Covered Thorium Vein"] = true
L["Small Thorium Vein"] = true
L["Rich Thorium Vein"] = true
L["Dark Iron Deposit"] = true
L["Lesser Bloodstone Deposit"] = true
L["Incendicite Mineral Vein"] = true
L["Indurium Mineral Vein"] = true
L["Fel Iron Deposit"] = true
L["Adamantite Deposit"] = true
L["Rich Adamantite Deposit"] = true
L["Khorium Vein"] = true
L["Large Obsidian Chunk"] = true
L["Small Obsidian Chunk"] = true
L["Nethercite Deposit"] = true
L["Cobalt Deposit"] = true
L["Rich Cobalt Deposit"] = true
L["Titanium Vein"] = true
L["Saronite Deposit"] = true
L["Rich Saronite Deposit"] = true
L["Obsidium Deposit"] = true
L["Huge Obsidian Slab"] = true
L["Pure Saronite Deposit"] = true
L["Elementium Vein"] = true
L["Rich Elementium Vein"] = true
L["Pyrite Deposit"] = true
L["Rich Obsidium Deposit"] = true
L["Rich Pyrite Deposit"] = true
L["Rich Pyrite Deposit"] = true
L["Ghost Iron Deposit"] = true
L["Rich Ghost Iron Deposit"] = true
L["Black Trillium Deposit"] = true
L["White Trillium Deposit"] = true
L["Kyparite Deposit"] = true
L["Rich Kyparite Deposit"] = true
L["Trillium Vein"] = true
L["Rich Trillium Vein"] = true
L["True Iron Deposit"] = true
L["Rich True Iron Deposit"] = true
L["Blackrock Deposit"] = true
L["Rich Blackrock Deposit"] = true








-- Tracked items
L["Reins of the Vitreous Stone Drake"] = true
L["Ashes of Al'ar"] = true
L["Reins of the Blue Proto-Drake"] = true
L["Reins of the Raven Lord"] = true
L["Swift White Hawkstrider"] = true
L["Fiery Warhorse's Reins"] = true
L["Azure Whelpling"] = true
L["Reins of the Onyxian Drake"] = true
L["Mojo"] = true
L["Disgusting Oozeling"] = true
L["Reins of the White Polar Bear"] = true
L["Flametalon of Alysrazor"] = true
L["Reins of the Azure Drake"] = true
L["Sea Turtle"] = true
L["Scepter of Azj'Aqir"] = true
L["Scorched Stone"] = true
L["Parrot Cage (Hyacinth Macaw)"] = true
L["Parrot Cage (Green Wing Macaw)"] = true
L["Deviate Hatchling"] = true
L["Gundrak Hatchling"] = true
L["Dark Whelpling"] = true
L["Tiny Emerald Whelpling"] = true
L["Captured Firefly"] = true
L["Phoenix Hatchling"] = true
L["Sprite Darter Egg"] = true
L["Fox Kit"] = true
L["Deathcharger's Reins"] = true
L["The Horseman's Reins"] = true
L["Invincible's Reins"] = true
L["Mimiron's Head"] = true
L["Razzashi Hatchling"] = true
L["Tiny Crimson Whelpling"] = true
L["Cat Carrier (Black Tabby)"] = true
L["Reins of the Blue Drake"] = true
L["Reins of the Green Proto-Drake"] = true
L["Big Love Rocket"] = true
L["Armored Razzashi Raptor"] = true
L["Fossilized Raptor"] = true
L["Reins of the Drake of the North Wind"] = true
L["Reins of the Drake of the South Wind"] = true
L["Swift Zulian Panther"] = true
L["Red Qiraji Resonating Crystal"] = true
L["Giant Sewer Rat"] = true
L["Mr. Pinchy"] = true
L["Mr. Grubbs"] = true
L["Reins of the Grey Riding Camel"] = true
L["Elementium Geode"] = true
L["Smoldering Egg of Millagazor"] = true
L["Sea Pony"] = true
L["Ice Chip"] = true
L["Reins of the Grand Black War Mammoth"] = true
L["Experiment 12-B"] = true
L["Reins of the Blazing Drake"] = true
L["Lump of Coal"] = true
L["Toxic Wasteling"] = true
L["Strand Crawler"] = true
L["Great Brewfest Kodo"] = true
L["Swift Brewfest Ram"] = true
L["Son of Galleon's Saddle"] = true
L["Reins of the Astral Cloud Serpent"] = true
L["Reins of the Heavenly Onyx Cloud Serpent"] = true
L["Skyshard"] = true
L["Whistle of Chromatic Bone"] = true
L["Blackwing Banner"] = true
L["Unscathed Egg"] = true
L["Anubisath Idol"] = true
L["Jewel of Maddening Whispers"] = true
L["Viscidus Globule"] = true
L["Core of Hardened Ash"] = true
L["Mark of Flame"] = true
L["Blazing Rune"] = true
L["Blighted Spore"] = true
L["Dusty Clutch of Eggs"] = true
L["Gluth's Bone"] = true
L["Reins of the Thundering Cobalt Cloud Serpent"] = true
L["Reins of the Cobalt Primordial Direhorn"] = true
L["Hollow Reed"] = true
L["Imbued Jade Fragment"] = true
L["Reins of the Slate Primordial Direhorn"] = true
L["Reins of the Amber Primordial Direhorn"] = true
L["Reins of the Jade Primordial Direhorn"] = true
L["Reins of the Green Primal Raptor"] = true
L["Reins of the Black Primal Raptor"] = true
L["Primal Egg"] = true
L["Living Sandling"] = true
L["Son of Animus"] = true
L["Sunfur Panda"] = true
L["Snowy Panda"] = true
L["Mountain Panda"] = true
L["Ji-Kun Hatchling"] = true
L["Porcupette"] = true
L["Direhorn Runt"] = true
L["Brilliant Phoenix Hawk Feather"] = true
L["Crystal of the Void"] = true
L["Dark Quivering Blob"] = true
L["Dripping Strider Egg"] = true
L["Half-Empty Food Container"] = true
L["Instant Arcane Sanctum Security Kit"] = true
L["Netherspace Portal-Stone"] = true
L["Pygmy Direhorn"] = true
L["Quivering Blob"] = true
L["Satyr Charm"] = true
L["Shell of Tide-Calling"] = true
L["Spiky Collar"] = true
L["Tainted Core"] = true
L["Tiny Fel Engine Key"] = true
L["Spawn of Horridon"] = true
L["Clutch of Ji-Kun"] = true
L["Darkmoon Eye"] = true
L["Reins of the Thundering Onyx Cloud Serpent"] = true
L["Ashleaf Spriteling"] = true
L["Death Adder Hatchling"] = true
L["Gu'chi Swarmling"] = true
L["Gulp Froglet"] = true
L["Jadefire Spirit"] = true
L["Jademist Dancer"] = true
L["Ominous Flame"] = true
L["Ruby Droplet"] = true
L["Skunky Alemental"] = true
L["Spineclaw Crab"] = true
L["Blackfuse Bombling"] = true
L["Lil' Bling"] = true
L["Droplet of Y'Shaarj"] = true
L["Gooey Sha-ling"] = true
L["Crane Nest"] = true
L["Azure Crane Chick"] = true
L["Obtained by opening Crane Nests on the Timeless Isle"] = true
L["Bonkers"] = true
L["Obtained by opening Timeless Chests on the Timeless Isle"] = true
L["Timeless Chest"] = true
L["Dandelion Frolicker"] = true
L["Moon Moon"] = true
L["Kovok"] = true
L["Zandalari Anklerender"] = true
L["Zandalari Footslasher"] = true
L["Zandalari Kneebiter"] = true
L["Zandalari Toenibbler"] = true
L["Rotten Helper Box"] = true
L["Imperial Moth"] = true
L["Life-Binder's Handmaiden"] = true
L["Reins of the Bone-White Primal Raptor"] = true
L["Chuck's Bucket"] = true
L["Muckbreaths's Bucket"] = true
L["Snarly's Bucket"] = true
L["Toothy's Bucket"] = true
L["Old Crafty"] = true
L["Old Ironjaw"] = true
L["Time-Locked Box"] = true
L["Kor'kron Juggernaut"] = true
L["Sky-Bo"] = true
L["Shadowhide Pearltusk"] = true
L["Garn Steelmaw"] = true
L["Giant Coldsnout"] = true
L["Smoky Direwolf"] = true
L["Solar Spirehawk"] = true
L["Garn Nighthowl"] = true
L["Syd the Squid"] = true
L["Decahedral Dwarven Dice"] = true
L["Worn Troll Dice"] = true
L["Loaded Gnomish Dice"] = true
L["Ai-Li's Skymirror"] = true
L["Blackflame Daggers"] = true
L["Chalice of Secrets"] = true
L["Eternal Kiln"] = true
L["Farwater Conch"] = true
L["Frenzyheart Brew"] = true
L["Gastropod Shell"] = true
L["Hozen Beach Ball"] = true
L["Kang's Bindstone"] = true
L["Moonfang Shroud"] = true
L["Moonfang's Paw"] = true
L["Mr. Smite's Brass Compass"] = true
L["Odd Polished Stone"] = true
L["Pandaren Firework Launcher"] = true
L["Panflute of Pandaria"] = true
L["Rime of the Time-Lost Mariner"] = true
L["The Heartbreaker"] = true
L["Time-Lost Figurine"] = true
L["Unusual Compass"] = true
L["Warning Sign"] = true
L["Nightshade Sproutling"] = true
L["Red Goren Egg"] = true






--[[
					The rest of this file is auto-generated using the WoWAce localization application.
					Please go to http://www.wowace.com/projects/rarity/localization/ to update translations.
					Anyone with a WowAce/CurseForge account can edit them. 
]] 


L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "deDE")
if L then
--@localization(locale="deDE", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "esES")
if L then
--@localization(locale="esES", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "esMX")
if L then
--@localization(locale="esMX", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "frFR")
if L then
--@localization(locale="frFR", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "koKR")
if L then
--@localization(locale="koKR", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "ruRU")
if L then
--@localization(locale="ruRU", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "zhCN")
if L then
--@localization(locale="zhCN", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "zhTW")
if L then
--@localization(locale="zhTW", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end

L = LibStub("AceLocale-3.0"):NewLocale("Rarity", "ptBR")
if L then
--@localization(locale="ptBR", format="lua_additive_table", handle-subnamespaces="concat", same-key-is-true="true")@
end
