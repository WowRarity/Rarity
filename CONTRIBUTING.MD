# Contributing Guidelines

There aren't any proper guidelines, really, but all contributions are welcome! This document should hopefully help you get started

If you have any questions, feel free to open an issue or send a message on Discord: RDW#9823

## Project Status

The addon has officially been abandoned since approximately Warlords of Draenor, when the original author stopped playing. Since then, it's been more-or-less kept alive, if barely, by a few volunteers.

There are [many issues](https://github.com/SacredDuckwhale/Rarity/issues) that simply can't be resolved without additional manpower (or woman-power :D), so feel free to help out if there's anything you want to do.

## How Rarity works

The addon has some complex logic, but mostly it's just difficult to understand because the code is such a mess. I'll try to give a brief overview here, but I can add more details as needed; just let me know!

### Architecture

There are chiefly just two modules, which come as separate addons:

* The "options" module, which is a graphical interface for accessing many of the addon's settings. This is what you'll see when typing ``/rarity``
* The core addon, which does everything else (yep...)

The options are relatively straight-forward, so let me elaborate on the core functionality instead. There are many different parts:

* DB: Shared constants and read-only definitions that are used elsewhere in the addon
* ItemDB: For some reason, this is called ``Options_Defaults``, but it's really just a HUGE database of all the items Rarity tracks (to be merged with the above, eventually...)
* Libs: All the dependencies are added here, mostly automatically by the CurseForge packager
* Utils: A random assortment of semi-useful/shared functionality. This shouldn't really exist, but I never got around to cleaning it up
* Core: All the various APIs/subsystems that the addon relies on

The core is separated into roughly these subsystems (grouped by functionality):

* Tracking: Items are actively tracked and will be displayed on the LDB icon/custom progress bar as attempts are added. This is where the logic for that resides
* Collections: Interfaces with Blizzard's collections APIs to determine which items aren't yet obtained and retrieve additional information about certain items
* Database: Thin wrapper for the ``AceDB`` functions, which are used to manage the saved variables
* Debugging: As the name implies, anything that's useful for development only
* Detection: This is where attempts are detected and subsequently added to the addon's saved variables
* Events: The code triggered by Blizzard's UI Events, which will call into the addon's APIs to do whatever is needed for the given event (AKA event handlers)
* GUI: Anything that has to do with the graphical interface (tooltip) that's displayed when interacting with the minimap button/LDB icon. This has nothing to do with the Options module
* Init: Setup and startup routines, basically anything that needs to be done *before* the addon can be loaded properly
* Profiling: This should include profiling/debugging stuff, but somehow doesn't? (I don't know either. **TODO: What's with this one?**)
* Serialization: Things related to exporting/importing items, and compatibility with some ancient addon called ``BunnyHunter`` that must've died eons ago
* Session: Sessions are started/ended when attempts are counted, presumably to track the total time spent on individual collectibles. I don't think this has ever worked correctly, but hey, it's all in here
* Settings: I have no idea, it's empty? (**TODO: Review**)
* Statistics: Rarity estimates the "luckiness" based on attempts/droprates, and this is where the logic for probabilistic calculations should be

There's also a bunch of random stuff in the addon loader (``Core.lua``) still, which I haven't finished moving into a subsystem yet.

This is where EVERYTHING was stored originally, so trust me when I say it's much more manageable now, even if it's still some 2000 lines of code and very daunting to behold.

### The Item Database (ItemDB)

**TODO: Detailed explanation**

Outline:

* Categories and expansions
* Preset categories vs. custom items
* Detection methods
* UI Map IDs and waypoints data
* Defeat detection

### Tracked Items and Sessions

This is weird and I don't even know if it works correctly. The system probably needs an overhaul.

**TODO: Explain how it works regardless?**