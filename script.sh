VERSION_WITHOUT_SUFFIX="$(grep 'version:' pubspec.yaml | awk '{ print $2 }' | cut -d'+' -f 1)"
function parse_git_hash() {
git rev-list --count origin/main
}
MAIN_COUNT=$(parse_git_hash)
APP_VERSION="$VERSION_WITHOUT_SUFFIX+$MAIN_COUNT"
echo "::set-output name=version::$(echo $APP_VERSION)"