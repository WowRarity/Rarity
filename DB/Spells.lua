-- Maps spells of interest to their respective spell IDs (useful since both info is used by Blizzard APIs and the addon itself) - Only some of these are actually used right now, but who knows what the future will bring?
-- Note: Spell names are no longer needed, and dealing with them is actually more complicated after the 8.0.1 API changes. They're only used for readability's sake
Rarity.relevantSpells = {
	-- Tested (confirmed working in 8.0.1)
	[3365] = "Opening",
	[13262] = "Disenchant",
	[22810] = "Opening - No Text",
	[30427] = "Extract Gas",
	[73979] = "Searching for Artifacts",
	[131474] = "Fishing",
	[158743] = "Fishing",
	[144528] = "Opening", -- Timeless Chest (Timeless Isle: Kukuru's Grotto)
	[195125] = "Skinning",
	[195258] = "Mother's Skinning Knife", -- Legion Toy with the same effect as regular skinning, but with a 40y range
	[231932] = "Opening", -- Wyrmtongue Cache (Broken Shore: Secret Treasure Lair)
	[265843] = "Mining",
	[265825] = "Herb Gathering",
	[405274] = "Disgusting Vat Fishing",
	-- 8.2
	[6478] = "Opening", -- Pile of Coins (Mechagon Island: Armored Vaultbot)
	-- 8.3
	[312881] = "Searching Mailbox", -- Mail Muncher
	[1223438] = "Searching Junk", -- Nesting Swarmite
	-- 9.0
	[329997] = "Opening", -- Silver Strongbox (Bastion, Shadowlands)
	[345071] = "Looting", -- Dirty Glinting Object (Shadowlands zones for Lucy's Lost Collar pet)
	-- Not tested (but added just in case)
	[7731] = "Fishing",
	[7732] = "Fishing",
	[7620] = "Fishing",
	[18248] = "Fishing",
	[33095] = "Fishing",
	[51294] = "Fishing",
	[88868] = "Fishing",
	[110410] = "Fishing",
	[2575] = "Mining",
	[265853] = "Mining",
	[158754] = "Mining",
	[2576] = "Mining",
	[195122] = "Mining",
	[3564] = "Mining",
	[10248] = "Mining",
	[29354] = "Mining",
	[50310] = "Mining",
	[74517] = "Mining",
	[265837] = "Mining",
	[102161] = "Mining",
	[265845] = "Mining",
	[265841] = "Mining",
	[265839] = "Mining",
	[265847] = "Mining",
	[265849] = "Mining",
	[265851] = "Mining",
	[2366] = "Herb Gathering",
	[265835] = "Herb Gathering",
	[158745] = "Herb Gathering",
	[195114] = "Herb Gathering",
	[2368] = "Herb Gathering",
	[3570] = "Herb Gathering",
	[28695] = "Herb Gathering",
	[11993] = "Herb Gathering",
	[50300] = "Herb Gathering",
	[110413] = "Herb Gathering",
	[74519] = "Herb Gathering",
	[265819] = "Herb Gathering",
	[265821] = "Herb Gathering",
	[265823] = "Herb Gathering",
	[265827] = "Herb Gathering",
	[265829] = "Herb Gathering",
	[265831] = "Herb Gathering",
	[265834] = "Herb Gathering",
	[8613] = "Skinning",
	[8617] = "Skinning",
	[8618] = "Skinning",
	[32678] = "Skinning",
	[50305] = "Skinning",
	[74522] = "Skinning",
	[102216] = "Skinning",
	[158756] = "Skinning",
	[49383] = "Engineering - Scavenging",
	[430315] = "Thaumaturgy",
	-- Not tested (and disabled until they are needed)
	-- [1804] = "Pick Lock",
}

return Rarity.relevantSpells
