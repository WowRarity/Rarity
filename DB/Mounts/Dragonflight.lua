local addonName, addonTable = ...

local L = LibStub("AceLocale-3.0"):GetLocale("Rarity")
local CONSTANTS = addonTable.constants

local dragonflightMounts = {}

Rarity.ItemDB.MergeItems(Rarity.ItemDB.mounts, dragonflightMounts)
