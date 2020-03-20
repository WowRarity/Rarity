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

-----

**r695:**

> Added tracking for missing collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms
<br>Added defeat detection for collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms
<br>Added tracking for Crimson Skipper (dropped by Honey Smasher)
<br>Added tracking for Mollie (dropped by Dunegorger Kraulok)

-----

**r694:**

> Added tracking for collectibles dropped from rares in Uldum and Vale of the Eternal Blossoms (experimental)

-----

**r693:**

> Fixed integration with the TradeSkillMaster4 addon (used to display pricing info in Rarity's tooltip)
