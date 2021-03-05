**r705:**

Additions:
* Added tracking for various Shadowlands pets and toys that were previously missing
* Added tracking for Smoldering Ember Wyrm (Return to Karazhan)
* Added tracking for Gloop (Corrupted Vale of Eternal Blossoms/Uldum)
* Added tooltips for achievement-related rares in Nazjatar, Mechagon Island, as well as Shadowlands zones

Changes:
* The main tooltip's sort order can now also be changed by CTRL-clicking on the tooltip header (in addition to clicking on the LDB icon/minimap button)

Fixes:
* Fixed an issue where duplicate attempts would be detected when defeating certain Timewalking encounters
* Fixed waypoint data (including the displayed zone) for certain legacy collectibles
* Fixed tracking for Mechagon Peacekeeper, Golden Snorf, and Microbot 8D (Operation: Mechagon)
* Mining Elementium veins should now add attempts for Elementium Geode in all Cataclysm zones

Contributors (in alphabetical order):
* Tommy Godejord (https://github.com/godejord)

-----

**r704:**

Additions:
* Added tracking for various Shadowlands pets and toys that were previously missing

Fixes:
* Mechagon Peacekeeper should now correctly be displayed in the Group category
* Attempts for Gahz'rooki's Summoning Stone should now be tracked correctly when looting relevant Kor'kron NPCs in The Barrens

Contributors (in alphabetical order):
* Tommy Godejord (https://github.com/godejord)

-----

**r703:**

Additions:
* Added tracking for various Shadowlands pets and toys that were previously missing
* Added a setting to show the addon's tooltip on click instead of hover

Changes:
* Removed tracking for various items that appear to have never made it to live servers

Fixes:
* Removed restrictions placed on the tracking for Theater of Pain rares (to account for Blizzard's stealth hotfix)
* Fixed an issue where killing covenant-restricted rares on characters that haven't selected a covenant yet would cause an error
* Fixed tracking for Lightbinders (pet)

Contributors (in alphabetical order):
* Nick Bayley (https://github.com/nickbayley)
* Tommy Godejord (https://github.com/godejord)
* Mikael Jelveby (https://github.com/jelveby)

-----

**r702:**

Additions:
* Added most rare collectibles available in the Shadowlands expansion (many thanks to Tommy Godejord for helping with this task)
* Added a button to always track battle pets repeatedly. Note: This will overwrite all individual settings for the 'repeatable' flag, so beware and/or make a backup of your saved variables first if you're at all unsure

Changes:
* Many collectibles from the Battle for Azeroth expansion are no longer considered group content and have been moved to the 'solo-able' category

-----

**r701:**

Additions:
* Added an option to hide items that are already known from the mouseover tooltip (courtesy of Daniel Bowden) 

Fixes:
* Attempts for the Great Sea Ray should now be correctly tracked while fishing on Mechagon Island and in Boralus
* Fixed an error that would occur when Blizzard's bonus roll window was displayed after obtaining a tracked item
* Attempts should no longer be added if tracking is disabled for the player's class
