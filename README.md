# clickless-app

Sparkle update distribution for [Molo](https://github.com/hananbeer/molo-swift) (built from `molo-swift`).

## Sparkle feed

Apps check this URL for updates:

```
https://github.com/hananbeer/clickless-app/releases/download/updates/appcast.xml
```

## Repository layout

| Path | Purpose |
|------|---------|
| `appcast.xml` | Sparkle feed (committed to git; also uploaded as a release asset) |
| `scripts/publish.sh` | Upload `appcast.xml` and zip(s) to the `updates` GitHub release |

Release zips are **not** committed (see `.gitignore`). They are uploaded as GitHub Release assets only.

## Publishing a new version

From `molo-swift`:

```bash
./Scripts/publish-update.sh
```

Or manually:

1. Bump `CFBundleShortVersionString` and `CFBundleVersion` in `molo-swift/Sources/MoloApp/Info.plist`.
2. Build and zip in `molo-swift` (see `Scripts/package-app.sh`).
3. Copy the zip here as `Molo-<version>.zip`.
4. Regenerate the appcast:

   ```bash
   cd ../molo-swift
   ./Scripts/generate-appcast.sh
   ```

5. Publish:

   ```bash
   cd ../clickless-app
   ./scripts/publish.sh Molo-<version>.zip
   git add appcast.xml
   git commit -m "Release Molo <version>"
   git push
   ```

## First-time setup

Requires the [GitHub CLI](https://cli.github.com/) authenticated as `hananbeer`:

```bash
gh auth login
```

The `updates` release tag is created automatically on first publish.
