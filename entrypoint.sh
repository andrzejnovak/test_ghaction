#!/bin/bash
set -e
api_url="https://pokeapi.co/api/v2/pokemon/${INPUT_POKEMON_ID}"
echo $api_url
pokemon_name=$(curl "${api_url}" | jq ".name")
echo $pokemon_name
echo "::set-output name=pokemon_name::$pokemon_name"


echo "BLABLA"
git branch
git status
git log --pretty=oneline --abbrev-commit |grep -v \|
OLD_TAG=$(git describe --tags --abbrev=0)
echo "OLD_TAG=${OLD_TAG}" >> $GITHUB_ENV
bump2version $BV_PART --message "Bump version: {current_version} → {new_version}
                                 Triggered by #${PR_NUMBER} via GitHub Actions."
NEW_TAG=$(git describe --tags --abbrev=0)
echo "NEW_TAG=${NEW_TAG}" >> $GITHUB_ENV
git tag -n99 -l $NEW_TAG

CHANGES=$(git log --pretty=format:'%s' $OLD_TAG..HEAD -i -E --grep='^([a-z]*?):')
echo "CHANGES:"$CHANGES";"
if [ -z "${CHANGES// }" ]; then echo "CHANGES is empty, will substitute a dummy"; fi
if [ -z "${CHANGES// }" ]; then CHANGES="dummy: didn't find valid semantic labels"; fi
CHANGES_NEWLINE="$(echo "${CHANGES}" | sed -e 's/^/  - /')"
SANITIZED_CHANGES=$(echo "${CHANGES}" | sed -e 's/^/<li>/' -e 's|$|</li>|' -e 's/(#[0-9]\+)//' -e 's/"/'"'"'/g')
echo "CHANGES=${SANITIZED_CHANGES//$'\n'/}" >> $GITHUB_ENV
NUM_CHANGES=$(echo -n "$CHANGES" | grep -c '^')
echo "NUM_CHANGES=${NUM_CHANGES}" >> $GITHUB_ENV
git tag $NEW_TAG $NEW_TAG^{} -f -m "$(printf "This is a $BV_PART release from $OLD_TAG → $NEW_TAG.\n\nChanges:\n$CHANGES_NEWLINE")"
git tag -n99 -l $NEW_TAG
git status
git log --pretty=oneline --abbrev-commit |grep -v \|