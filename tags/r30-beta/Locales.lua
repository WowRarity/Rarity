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
L["Companions"] = true
L["%s: %d attempt"] = true
L["%s: %d attempts"] = true
L["Luckiness"] = true
L["Lucky"] = true
L["Unlucky"] = true
L["Mounts"] = true
L[" (Group)"] = true
L["Click to open options"] = true
L["%d attempt - %.2f%%"] = true
L["%d attempts - %.2f%%"] = true
L["Found on your first attempt!"] = true
L["Found after %d attempts!"] = true
L["Items"] = true
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
L["Companion"] = true
L["Item"] = true
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
L["Display"] = true
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
L["Requires a 25-player raid"] = true
L["Determines whether this item can only be obtained in 25-player mode."] = true
L["Equal odds"] = true
L["Turn this on if the item requires a group to obtain, but every player gets an equal chance to obtain the item. This currently only applies to some of the holiday mounts. When you turn this on, Rarity will stop lowering your chance to obtain based on the group size."] = true
L["Archaeology race"] = true
L["Determines which race includes this archaeology project."] = true
L["Zones"] = true
L["A comma-separated list of the zones or sub-zones this item can be found in. Enter zone names with proper spelling, capitalization, and punctuation. They can be entered either in US English or your client's local language. Use WowHead or a similar service to make sure you're entering the zone names perfectly."] = true
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








L["Floating Wreckage"] = true
L["Patch of Elemental Water"] = true
L["Floating Debris"] = true
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
L["Waterlogged Wreckage"] = true
L["Bloodsail Wreckage"] = true
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
L["Mr. Grubbs"] = true










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
