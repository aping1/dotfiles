# Init other dotfiles 
#
GETVERSION () {
IMAGE_FILE=$(realpath $1)
[[ -e ${IMAGE_FILE} ]] || return 16
VERSION=$(jq '.name + "-" + ( .version|tostring )' ${IMAGE_FILE} | tr -d '"')
TEMPDIR=$(mktemp  "/tmp/$VERSION-XXX".pkglist)
curl -X GET http://releng.gaikai.org/images/$VERSION.pkglist > $TEMPDIR
echo $TEMPDIR
}
OSA_LIBRARY_PATH=/Users/aping1/.dotfiles/scripts/libs
