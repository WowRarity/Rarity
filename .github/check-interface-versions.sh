set -eu

curl --silent --show-error https://us.version.battle.net/v2/products/wow/versions > cdn-response.txt
evo Tools/check-cdn-version.lua cdn-response.txt