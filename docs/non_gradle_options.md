# Gradle-Free Delivery Options for Swarm Mobile

The repository currently retains a Gradle-based Android skeleton, but active development must assume Gradle tooling is not available locally. This document summarizes practical strategies to keep the swarm-space experience installable on Android devices without relying on developer workstations that can execute `./gradlew`.

## 1. Progressive Web App (PWA) Focus

Strengthen the swarm-space web application so it behaves like an installable PWA:

- Implement web app manifest metadata (name, icons, orientation, display mode).
- Provide service worker caching for offline/poor-network resiliency.
- Optimize for Lighthouse installability signals (HTTPS, responsive layout, fast first load).
- Promote installation from browsers that automatically offer WebAPK packaging (Chrome, Edge, Samsung Internet).

**Pros:**
- No native build step; updates deploy as static assets.
- Installation flow works cross-platform (Android, desktop, iOS add-to-home-screen).

**Cons:**
- Limited access to native APIs compared with a fully native shell.
- Discoverability and store distribution require additional steps.

## 2. Trusted Web Activity (TWA) via Cloud Build

Keep a lightweight Android wrapper that opens the PWA in a Trusted Web Activity. Rather than building locally, configure a CI pipeline to assemble, sign, and publish artifacts.

- Use GitHub Actions or another CI provider with an Android runner image.
- Store signing keys and Play Console service account credentials as secrets.
- Trigger Gradle tasks (`bundleRelease`, `assembleRelease`) only inside CI jobs.
- Optionally, integrate with the Play Developer Publishing API for automated rollout.

**Pros:**
- Ships through the Play Store with native install UX.
- Retains the ability to expose select native integrations (notifications via FCM, splash screens, etc.).

**Cons:**
- Requires CI infrastructure and secure secret management.
- Debugging build failures depends on remote logs.

## 3. Cross-Platform Shells with Remote Build Services

Frameworks like [Capacitor](https://capacitorjs.com/), [Ionic Portals](https://ionic.io/portals), [Expo Application Services](https://expo.dev/eas), or [Tauri Mobile](https://tauri.app) can host web content and provide remote build capabilities.

- Day-to-day development uses familiar web tooling (`npm`, `vite`, `react`, etc.).
- Production builds can be outsourced to hosted services (e.g., Expo EAS Build, Ionic Appflow) that deliver signed APKs/AABs.
- Native plugins can be selectively enabled if future requirements demand them.

**Pros:**
- Developer workflow stays within the JavaScript ecosystem.
- Hosted build services remove the need for local Android SDK installation.

**Cons:**
- Some services are paid offerings for production use.
- Plugin ecosystems may lag behind pure native implementations.

## 4. Downloadable WebView Shell Compiled in CI

Maintain the existing Compose/Gradle codebase but treat it as an artifact produced only by automation.

- Preserve the Android module primarily for CI builds.
- Provide documentation for testers to download the latest CI-generated APK.
- Use feature flags or remote config to toggle in-progress experiments without rebuilding.

**Pros:**
- Keeps Kotlin/Compose investments viable.
- Allows gradual migration back to native features if Gradle access is restored.

**Cons:**
- Local iteration on native features is impractical without emulator access.
- Requires reliable CI resources to stay useful.

## Decision Considerations

When choosing among these options, evaluate:

- **Time-to-ship:** How fast do we need an installable artifact?
- **Offline requirements:** PWAs can cache content, but complex background sync may need native capabilities.
- **Native integrations:** Sensors, notifications, or OS-level sharing may influence the choice of wrapper.
- **Team skill set:** Lean toward ecosystems (web vs. native) the maintainers are comfortable supporting.
- **Budget for services:** Hosted build pipelines may incur monthly costs.

Document findings from experiments in this file to keep the decision record current.
