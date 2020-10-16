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

-----

**r697:**

> Added tracking for pets obtained in the Ny'alotha raid
<br>Added tracking for Skyshards in the phased 8.3 version of the Vale of Eternal Blossoms

> Fixed an error in the fishing detection that could prevent attempts from being registered correctly
<br>Fixed a UI issue that could cause the tooltip loading to fail

-----

**r696:**

> Added tracking for collectibles obtained from Horrific Visions (experimental)
<br>Added tracking for the Zan-Tien Lasso (dropped by mogu in the Vale of Eternal Blossoms)
<br>Added tracking for pets obtained from 8.3 paragon caches
<br>Added missing toggle for BFA content in the configuration UI

> Updated group size recommendations for 8.3 collectibles
<br>Updated drop rate estimations for mounts obtained in BFA dungeons

> Fixed an issue that could cause additional attempts to be registered when Dunegorger Kraulok died nearby, but wasn't actually engaged
<br>Fixed the detection of pets obtained in the Firelands raid (see notes below)

Developer Notes:
> It appears that Blizzard broke the statistics for the Firelands raid when adding its Timewalking version. Detection for all bosses except Ragnaros and Alysrazor was changed to use NPC looting in order to work around this bug as best as possible, but attempts for items dropped by those two bosses might not always be detected until statistics are being updated correctly again
