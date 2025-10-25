# APK

Android application initiative for the [swarm-space](https://github.com/bobdub/swarm-space.git) project.

## Project Overview
This repository hosts a minimal Android launcher activity that can be compiled without Gradle. The structure is intentionally
lightweight so additional features can be added while keeping the toolchain scriptable.

## Directory Layout
- `app/src/main/AndroidManifest.xml` – core manifest describing the package and launcher activity.
- `app/src/main/kotlin/` – Kotlin sources that avoid XML resources to simplify manual compilation.
- `scripts/build_apk.sh` – bash pipeline that turns the sources into a signed debug APK using the Android command line tools.

## Building the APK (Gradle-free)
1. Install the Android SDK command line tools and create/update the following components:
   - Build tools `34.0.0` (override via `BUILD_TOOLS_VERSION`).
   - Platform `android-34` (override via `PLATFORM_VERSION`).
2. Ensure the Kotlin compiler (`kotlinc`) and JDK `keytool` are available on your `PATH`.
3. Export `ANDROID_SDK_ROOT` to the SDK installation path.
4. Run the build script:
   ```bash
   ./scripts/build_apk.sh
   ```
5. On success the signed debug APK will be emitted to `build/SwarmSpace-debug.apk`.

### Script Notes
- The build script compiles Kotlin sources, links the manifest with `aapt2`, generates DEX bytecode via `d8`, and signs the
  aligned package with a locally generated debug keystore.
- Resource and asset pipelines can be extended by placing files under `app/src/main/res` and wiring them into the `aapt2`
  invocation.
- CI environments can cache the `build/` directory or distribute the debug keystore for reproducible builds.

## Contributing
- Use feature branches for all work.
- Keep documentation and tests up to date with each change.
- Run linting and test suites (or the Gradle-free build script) before opening pull requests.

## License
TBD.
