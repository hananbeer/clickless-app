#!/usr/bin/env bash
set -euo pipefail

ROOT="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "$ROOT"

REPO="hananbeer/clickless-app"
RELEASE_TAG="updates"
APPCAST="$ROOT/appcast.xml"
DOWNLOAD_PREFIX="https://github.com/${REPO}/releases/download/${RELEASE_TAG}/"

if [[ ! -f "$APPCAST" ]]; then
  echo "error: appcast.xml not found at $APPCAST" >&2
  exit 1
fi

if ! command -v gh >/dev/null 2>&1; then
  echo "error: gh CLI is required (https://cli.github.com/)" >&2
  exit 1
fi

upload_assets=("$APPCAST")
for arg in "$@"; do
  if [[ ! -f "$arg" ]]; then
    echo "error: file not found: $arg" >&2
    exit 1
  fi
  upload_assets+=("$arg")
done

if ! gh release view "$RELEASE_TAG" -R "$REPO" >/dev/null 2>&1; then
  echo "Creating GitHub release tag: $RELEASE_TAG"
  gh release create "$RELEASE_TAG" \
    -R "$REPO" \
    --title "Sparkle Updates" \
    --notes "Rolling release channel for Sparkle appcast and Molo binaries. Do not delete this release tag."
fi

echo "Uploading to https://github.com/${REPO}/releases/tag/${RELEASE_TAG}"
gh release upload "$RELEASE_TAG" "${upload_assets[@]}" -R "$REPO" --clobber

echo ""
echo "Sparkle feed URL:"
echo "  ${DOWNLOAD_PREFIX}appcast.xml"
echo ""
echo "Uploaded:"
for asset in "${upload_assets[@]}"; do
  echo "  $(basename "$asset") -> ${DOWNLOAD_PREFIX}$(basename "$asset")"
done
