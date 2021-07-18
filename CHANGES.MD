**r710:**

Additions:
> Added an overview of the tracking data to each item's settings in the Options UI
> Added tracking for toys obtained from Zovaal's Vault
> Added links to the Rarity Discord and GitHub repository to the Options UI

Changes:
> The main window should now render MUCH faster, depending on the sort method selected (sorting by zone is still relatively slow)

Fixes:
> Fixed tracking for Wilderling Saddle
> Fixed tracking for Rook
> Fixed tracking for Intact Aquilon Core
> Fixed an issue that could prevent items using the COLLECTION method from being tracked correctly

Developer Notes:
> By improving the sorting algorithms used internally, we were able to reduce the time spent on rendering the addon's main window significantly. The remaining time for all sort modes except "by zone" is now limited by the WOW client's UI system and can't be reduced as easily, though we're looking at workarounds to this problem. If you're still experiencing significant performance issues after updating, please let us know!

Contributors (in alphabetical order):
> AySz88
> Tommy Godejord
> Matthew Rowland

-----

**r709:**

Additions:
> Added tracking for mounts introduced in Chains of Domination 
> Added tracking for various toys introduced in Chains of Domination
> Added tracking for most pets introduced in Chains of Domination

Changes:
> Rarity's achievement toast now also supports two lines of text properly, similar to Blizzard's recently-updated version

Fixes:
> Fixed an issue where two icons would be displayed in the achievement toast

Developer Notes:
> There are a number of collectibles we don't currently have sufficient data on. These will be added as soon™ as possible, but it might still take a while.

Contributors (in alphabetical order):
> Tommy Godejord

-----

**r708:**

Additions:
> Added tracking for Gilded Water (pet)
> Added tracking for Outrider's Bridle Chain (toy)
> Added a holiday-style reminder for when Dunegorger Kraulok is available (experimental)

Changes:
> The /rarity verify slash command used for validating the item database is now available as /rarity validate

Fixes:
> Items obtainable from the Black Market auction house are now flagged as such
> All items should now be assigned a zone, so that filtering by the current zone no longer incorrectly excludes them
> Tracking for the Ascended Skymane mount should now be working on non-English client locales

Contributors (in alphabetical order):
> Tommy Godejord

-----

**r707:**

Changes:
> The tooltip text for faction-restricted items is now dynamically colored based on whether it's available to the logged-in character

Fixes:
> Fixed an issue where looting Forgotten Chests in Stormsong Valley would cause attempts to be added for Silessa's Battle Harness and Stony's Infused Ruby

Contributors (in alphabetical order):
> Nick Bayley
> Tommy Godejord

-----

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
