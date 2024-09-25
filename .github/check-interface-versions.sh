local_version=$(cat Rarity.toc | grep -oP '## Interface: \K(\d{6},? ?)+')
options_version=$(cat Modules/Options/Rarity_Options.toc | grep -oP '## Interface: \K(\d{6},? ?)+')

# Since there's no "official" way to get the latest version, just use a popular/frequently updated addon ...
remote_version=$(curl https://raw.githubusercontent.com/BigWigsMods/BigWigs/master/BigWigs.toc --silent | grep -oP '## Interface: \K(\d{6},? ?)+')

if [ "$local_version" != "$remote_version" ]; then
    echo "✗ Local interface version ($local_version) does NOT match remote version ($remote_version)"
    exit 1
else
    echo "✓ Local interface version ($local_version) matches remote version ($remote_version)"
fi

if [ "$local_version" != "$options_version" ]; then
    echo "✗ Core interface version ($local_version) does NOT match options version ($options_version)"
    exit 1
else
    echo "✓ Core interface version ($local_version) matches options version ($options_version)"
fi