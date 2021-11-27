**r713:**

Additions:
> Attempts for Reins of the Infinite Timereaver should now also accumulate in Legion Timewalking dungeons
<br>REVERTED: Added tracking for Illidari Doomhawk and Doomwalker Trophy Stand (17th anniversary)
<br>Added tracking for the convenant-specific toys added in patch 9.1.5 (obtained from Callings)

Fixes:
> Fixed an error in the spell detection that caused attempts for custom items using Pick Pocket to not be detected

Developer Notes:
> Blizzard hotfixed the anniversary drops to be guaranteed. As such they've been removed from Rarity again.

Contributors (in alphabetical order):
> Tommy Godejord

-----

**r712:**

Additions:
> Added tracking for Gilded Darknight

Fixes:
> The main window should again be rendered properly (previously broken by patch 9.1.5 API changes)

Contributors (in alphabetical order):
> Tommy Godejord

-----

**r711:**

Additions:
> Added tracking for Adamant Vaults Cell

Changes:
> The mini map button is now displayed by default, to hopefully improve the experience for first-time users

Fixes:
> Fixed an issue that prevented item information being displayed in the game tooltip for items using the ZONE (zonewide) detection method

Contributors (in alphabetical order):
> Tommy Godejord

-----

**r710:**

Additions:
> Added an overview of the tracking data to each item's settings in the Options UI
<br>Added tracking for toys obtained from Zovaal's Vault
<br>Added links to the Rarity Discord and GitHub repository to the Options UI

Changes:
> The main window should now render MUCH faster, depending on the sort method selected (sorting by zone is still relatively slow)

Fixes:
> Fixed tracking for Wilderling Saddle
<br>Fixed tracking for Rook
<br>Fixed tracking for Intact Aquilon Core
<br>Fixed an issue that could prevent items using the COLLECTION method from being tracked correctly

Developer Notes:
> By improving the sorting algorithms used internally, we were able to reduce the time spent on rendering the addon's main window significantly. The remaining time for all sort modes except "by zone" is now limited by the WOW client's UI system and can't be reduced as easily, though we're looking at workarounds to this problem. If you're still experiencing significant performance issues after updating, please let us know!

Contributors (in alphabetical order):
> AySz88
<br>Tommy Godejord
<br>Matthew Rowland

-----

**r709:**

Additions:
> Added tracking for mounts introduced in Chains of Domination 
<br>Added tracking for various toys introduced in Chains of Domination
<br>Added tracking for most pets introduced in Chains of Domination

Changes:
> Rarity's achievement toast now also supports two lines of text properly, similar to Blizzard's recently-updated version

Fixes:
> Fixed an issue where two icons would be displayed in the achievement toast

Developer Notes:
> There are a number of collectibles we don't currently have sufficient data on. These will be added as soon™ as possible, but it might still take a while.

Contributors (in alphabetical order):
> Tommy Godejord
