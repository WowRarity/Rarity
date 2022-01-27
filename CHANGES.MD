**r714:**

Additions:
> Added tracking for Shaded Judgement Stone (Korthia/The Maw)
<br>Added tracking for the various 'dice' toys obtainable only via pickpocketing

Changes:
> Adjusted the drop rate of several Shadowlands collectibles to more accurately reflect wowhead's data

Fixes:
> Attempts for the Infinite Timereaver mount should now correctly be detected in the recently-added Timewalking dungeons
<br>Collectibles that require being affiliated with a different covenant should now correctly be marked as 'unavailable' in the addon's main window

Contributors (in alphabetical order):
> ithappenedagain
<br>Tommy Godejord

-----

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
