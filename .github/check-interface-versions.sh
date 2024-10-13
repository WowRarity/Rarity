set -eu

curl --silent --show-error https://us.version.battle.net/v2/products/wow/versions > cdn-response.txt
evo Tests/TOC/check-cdn-version.lua cdn-response.txt