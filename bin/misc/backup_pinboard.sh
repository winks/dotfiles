#!/bin/bash

TOKEN=$1

[ "$TOKEN" = "" ] && exit 1

DIR="${HOME}/backups/pinboard"

NOW=$(date +%Y%m%d_%H%M%S)

[ -d "${DIR}" ] || mkdir -p "${DIR}"

curl "https://api.pinboard.in/v1/posts/all?auth_token=${TOKEN}&format=json" >> "${DIR}/${NOW}.json"

cd "${DIR}"

for f in ${DIR}/*.json; do
	gzip -9 "${f}";
done
