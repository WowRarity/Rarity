set -eu

# Parameters: https://web.archive.org/web/20200805020232/https://authors.curseforge.com/knowledge-base/projects/529-api
# API tokens: https://www.wowace.com/account/api-tokens (you must request one first)
CF_API_KEY=$1
test $CF_API_KEY || echo "A CurseForge API token is required, but none was provided"
echo "Using CurseForge API token: $CF_API_KEY"

API_ENDPOINT="https://wow.curseforge.com/api/projects/"
PROJECT_ID="30801"
LANGUAGE_SHORTHAND="enUS"
EXPORT_TYPE="Table"
FETCH_URL="$API_ENDPOINT/$PROJECT_ID/localization/export?lang=$LANGUAGE_SHORTHAND&export-type=$EXPORT_TYPE"

OUTPUT_FILE="$LANGUAGE_SHORTHAND.exported.lua"
echo "Request URL: $FETCH_URL"
echo "Output File: $OUTPUT_FILE"
curl --location --show-error --header "x-api-token: $CF_API_KEY" "$FETCH_URL" > "$OUTPUT_FILE"

ls -lah
evo Tools/compare-localization-phrases.lua $OUTPUT_FILE

# Not sure if cleanup is desirable here? Deliberately leaving exported files in the CWD for now.