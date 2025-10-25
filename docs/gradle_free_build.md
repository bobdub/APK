# Gradle-Free Build Pipeline

This repository intentionally avoids Gradle to keep the build flow transparent and scriptable. The `scripts/build_apk.sh` entry
point assembles the APK using the Android command line interface.

## Requirements
- **Android SDK** with build tools and platforms that match the versions declared by the script.
- **Kotlin compiler** (`kotlinc`).
- **Java Development Kit** providing the `keytool` utility.

## Build Stages
1. **Kotlin Compilation** – source files in `app/src/main/kotlin` are compiled into a runnable JAR with the Kotlin runtime.
2. **Resource Linking** – `aapt2 link` packages the manifest and any optional resources into a base APK skeleton.
3. **DEX Conversion** – `d8` converts the compiled classes into Dalvik bytecode.
4. **APK Assembly** – the DEX payload is merged into the APK skeleton and aligned with `zipalign`.
5. **Signing** – the script signs the artifact with a debug keystore so it can be installed on devices and emulators.

## Customisation Tips
- Override `BUILD_TOOLS_VERSION` or `PLATFORM_VERSION` environment variables to target different SDK levels.
- Add additional Kotlin files under `app/src/main/kotlin` and update the `KOTLIN_SRC` array if the folder layout changes.
- Place resources under `app/src/main/res` and pass the compiled `.flat` files to `aapt2 link` within the build script.
- Replace the generated debug keystore with a team-managed keystore by editing the signing block at the end of the script.

## Troubleshooting
- `aapt2` errors usually indicate issues inside the manifest or resource files.
- `d8` failures often come from missing libraries—ensure `android.jar` is referenced correctly and include any additional JARs
  via the `--lib` parameter.
- On macOS, remember to grant execute permission to the script using `chmod +x scripts/build_apk.sh`.
