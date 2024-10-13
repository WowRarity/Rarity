set -eu

curl --silent --show-error https://us.version.battle.net/v2/products/wow/versions > .github/cdn-response.txt
evo .github/process-cdn-response.lua .github/cdn-response.txt