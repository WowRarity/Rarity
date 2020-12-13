**r702:**

> Added most rare collectibles available in the Shadowlands expansion (many thanks to Tommy Godejord for helping with this task)
<br>Added a button to always track battle pets repeatedly. Note: This will overwrite all individual settings for the 'repeatable' flag, so beware and/or make a backup of your saved variables first if you're at all unsure

> Many collectibles from the Battle for Azeroth expansion are no longer considered group content and have been moved to the 'solo-able' category

-----

**r701:**

> Added an option to hide items that are already known from the mouseover tooltip (courtesy of Daniel Bowden) 

> Attempts for the Great Sea Ray should now be correctly tracked while fishing on Mechagon Island and in Boralus
<br>Fixed an error that would occur when Blizzard's bonus roll window was displayed after obtaining a tracked item
<br>Attempts should no longer be added if tracking is disabled for the player's class

-----

**r700:**

> Fixed errors caused by API changes in the Shadowlands prepatch (there may be more errors still)

Developer Notes:
> Thanks to Daniel Bowden (dbowden713)

-----

**r699:**

> When items with incomplete or invalid data are detected by the addon, a notification will now be displayed. These messages should help narrow down future issues with custom items; they can be disabled with a newly-added setting that is located in the Advanced/Experimental section of the configuration UI (subject to change)
<br>Added a button to remove accountwide statistics for players affected by realm merges, transfers and name changes, to be used if the old character's attempts are still saved and the attempts counts are wrong as a result of the unique ID (name-realm) being different. It can be found in the 'Advanced' section of the options, for now.

> Black Tabby Cat is now considered a zonewide drop, obtainable in all of Hillsbrad Foothills
<br>Attempts for Knockoff Blingtron are now added when opening Blingtron 7000 Gift Packages

> Fixed a UI issue that could cause the tooltip to not be shown when custom items were added with invalid data (or Blizzard's server didn't send any data for the given item)
<br>The tooltip now always displays an item's estimated base drop rate instead of considering the somewhat arbitrary group size setting in order to provide consistent data to players
<br>Added a workaround for some display issues in Blizzard's addon menu that can cause the options window to not open correctly (sigh)

-----

**r698:**

> Looting an epic-quality Satchel of Chilled Goods (obtained from Frost Lord Ahune during the Midsummer Fire Festival) will now correctly register attempts for the Frigid Frostling pet
