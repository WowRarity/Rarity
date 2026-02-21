**r752:**

Additions:
> Rarity now supports tracking dungeon and raid encounters via LfgDungeonEncounter IDs
<br>Added most of the 12.0.0 and 12.0.1 collectibles to the database (so far untested)

Changes:
> Due to the new restrictions Blizzard introduced in the Midnight pre-patch, some of Rarity's core functionality is now blocked in combat and disabled for all types of instanced content. This affects tooltip additions, tracking NPC loot, items that require opening world objects, trade skills, pickpocketing, buffs/auras, and holiday reminders. Only some of these presently have viable workarounds.

Fixes:
> Fixed various Lua errors resulting from API changes made in patch 12.0 and 12.0.1

Developer Notes:
> Custom items which rely on NPC IDs should be updated to use encounter IDs, achievement criteria, or kill statistics. Item strings using methods that are now restricted will unfortunately cease to work when imported; there's no backwards-compatible way to re-interpret them that I could think of. Rarity should still support the old methods on Classic, at least for now.

Contributors (in alphabetical order):
> Ellezanor
