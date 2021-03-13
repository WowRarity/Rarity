**r706:**

Additions:
> Added an option to disable the achievement toast (popup) and sound effect triggered whenever a tracked item is found
> Added tracking for Pterrordax Egg (Zandalar)
> Added tracking for Piccolo of the Flaming Fire (Stratholme)
> Added an option to delay the tooltip (i.e., how long the icon should be hovered over before it is shown)
> Added tracking for Lucy's Lost Collar (Shadowlands)

Changes:
> Skyshards are now tracked repeatedly by default

Fixes:
> Clicking the achievement toast (popup) displayed when a tracked item is found should no longer cause a script error
> Skyshards should now also be tracked in the corrupted (instanced) version of the Shrine of Seven Stars
> Calendar-based notifications should now be triggered correctly for all holiday event items that Rarity tracks by default

Contributors (in alphabetical order):
> Nick Bayley
> Tommy Godejord

-----

**r705:**

Additions:
> Added tracking for various Shadowlands pets and toys that were previously missing
> Added tracking for Smoldering Ember Wyrm (Return to Karazhan)
> Added tracking for Gloop (Corrupted Vale of Eternal Blossoms/Uldum)
> Added tooltips for achievement-related rares in Nazjatar, Mechagon Island, as well as Shadowlands zones

Changes:
> The main tooltip's sort order can now also be changed by CTRL-clicking on the tooltip header (in addition to clicking on the LDB icon/minimap button)

Fixes:
> Fixed an issue where duplicate attempts would be detected when defeating certain Timewalking encounters
> Fixed waypoint data (including the displayed zone) for certain legacy collectibles
> Fixed tracking for Mechagon Peacekeeper, Golden Snorf, and Microbot 8D (Operation: Mechagon)
> Mining Elementium veins should now add attempts for Elementium Geode in all Cataclysm zones

Contributors (in alphabetical order):
> Tommy Godejord (https://github.com/godejord)

-----

**r704:**

Additions:
> Added tracking for various Shadowlands pets and toys that were previously missing

Fixes:
> Mechagon Peacekeeper should now correctly be displayed in the Group category
> Attempts for Gahz'rooki's Summoning Stone should now be tracked correctly when looting relevant Kor'kron NPCs in The Barrens

Contributors (in alphabetical order):
> Tommy Godejord (https://github.com/godejord)

-----

**r703:**

Additions:
> Added tracking for various Shadowlands pets and toys that were previously missing
> Added a setting to show the addon's tooltip on click instead of hover

Changes:
> Removed tracking for various items that appear to have never made it to live servers

Fixes:
> Removed restrictions placed on the tracking for Theater of Pain rares (to account for Blizzard's stealth hotfix)
> Fixed an issue where killing covenant-restricted rares on characters that haven't selected a covenant yet would cause an error
> Fixed tracking for Lightbinders (pet)

Contributors (in alphabetical order):
> Nick Bayley (https://github.com/nickbayley)
> Tommy Godejord (https://github.com/godejord)
> Mikael Jelveby (https://github.com/jelveby)

-----

**r702:**

Additions:
> Added most rare collectibles available in the Shadowlands expansion (many thanks to Tommy Godejord for helping with this task)
> Added a button to always track battle pets repeatedly. Note: This will overwrite all individual settings for the 'repeatable' flag, so beware and/or make a backup of your saved variables first if you're at all unsure

Changes:
> Many collectibles from the Battle for Azeroth expansion are no longer considered group content and have been moved to the 'solo-able' category
