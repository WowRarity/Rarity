set -eu

curl --silent --show-error https://us.version.battle.net/v2/products/wow/versions > retail-mainline-versions.txt
curl --silent --show-error https://us.version.battle.net/v2/products/wow_classic/versions > cata-classic-versions.txt
curl --silent --show-error https://us.version.battle.net/v2/products/wow_classic_era/versions > classic-era-versions.txt
evo Tools/check-cdn-version.lua retail-mainline-versions.txt cata-classic-versions.txt classic-era-versions.txt