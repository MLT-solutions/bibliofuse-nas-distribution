#!/bin/sh
# Regenerate synology-repo.json (the DSM Package Center third-party source
# feed) from a GitHub Release's .spk asset.
#
# Schema is taken from SynoCommunity/spkrepo's actual nas.py view (the code
# that runs packages.synocommunity.com), not guessed:
# https://github.com/SynoCommunity/spkrepo/blob/main/spkrepo/views/nas.py
#
# Usage: generate-synology-repo.sh <release-tag> <output-path>
set -eu

REPO="MLT-solutions/bibliofuse-nas-distribution"
PACKAGE_ID="BiblioFuseNAS"
DISPLAY_NAME="BiblioFuse NAS"
DESCRIPTION="Private ebook and comic library with a free browser reader."
DISTRIBUTOR="MLT Solutions"
DISTRIBUTOR_URL="https://bibliofuse.com"
ICON_BASE_URL="${ICON_BASE_URL:-https://mlt-solutions.github.io/bibliofuse-nas-distribution}"

TAG="${1:?usage: generate-synology-repo.sh <release-tag> <output-path>}"
OUT="${2:?usage: generate-synology-repo.sh <release-tag> <output-path>}"

ASSETS_JSON=$(gh release view "${TAG}" -R "${REPO}" --json assets)
SPK_NAME=$(printf '%s' "${ASSETS_JSON}" | jq -r --arg pkg "${PACKAGE_ID}" \
    '.assets[] | select(.name | startswith($pkg) and endswith(".spk")) | .name')
SPK_URL=$(printf '%s' "${ASSETS_JSON}" | jq -r --arg pkg "${PACKAGE_ID}" \
    '.assets[] | select(.name | startswith($pkg) and endswith(".spk")) | .url')

if [ -z "${SPK_NAME}" ] || [ -z "${SPK_URL}" ]; then
    echo "no .spk asset found for ${PACKAGE_ID} in release ${TAG}" >&2
    exit 1
fi

# BiblioFuseNAS-0.1.0-0056-x86_64.spk -> 0.1.0-0056
STEM=${SPK_NAME#"${PACKAGE_ID}-"}
STEM=${STEM%.spk}
VERSION=${STEM%-*}

echo "release ${TAG}: package version ${VERSION}, asset ${SPK_NAME}"

WORK_DIR=$(mktemp -d "${TMPDIR:-/tmp}/synology-repo.XXXXXX")
trap 'rm -rf "${WORK_DIR}"' EXIT HUP INT TERM
curl -fsSL "${SPK_URL}" -o "${WORK_DIR}/${SPK_NAME}"

if command -v md5 >/dev/null 2>&1; then
    MD5=$(md5 -q "${WORK_DIR}/${SPK_NAME}")
else
    MD5=$(md5sum "${WORK_DIR}/${SPK_NAME}" | cut -d' ' -f1)
fi
SIZE=$(wc -c <"${WORK_DIR}/${SPK_NAME}" | tr -d ' ')

echo "md5=${MD5} size=${SIZE}"

jq -n \
    --arg package "${PACKAGE_ID}" \
    --arg version "${VERSION}" \
    --arg dname "${DISPLAY_NAME}" \
    --arg desc "${DESCRIPTION}" \
    --arg link "${SPK_URL}" \
    --arg thumb "${ICON_BASE_URL}/icon_64.png" \
    --arg thumb256 "${ICON_BASE_URL}/icon_256.png" \
    --arg distributor "${DISTRIBUTOR}" \
    --arg distributor_url "${DISTRIBUTOR_URL}" \
    --arg md5 "${MD5}" \
    --argjson size "${SIZE}" \
    '{
        packages: [{
            package: $package,
            version: $version,
            dname: $dname,
            desc: $desc,
            link: $link,
            thumbnail: [$thumb],
            thumbnail_retina: [$thumb256, $thumb256],
            qinst: true,
            qupgrade: true,
            qstart: true,
            download_count: 0,
            recent_download_count: 0,
            snapshot: [],
            distributor: $distributor,
            distributor_url: $distributor_url,
            maintainer: $distributor,
            maintainer_url: $distributor_url,
            md5: $md5,
            size: $size,
            startable: "yes"
        }]
    }' >"${OUT}"

echo "wrote ${OUT}"
