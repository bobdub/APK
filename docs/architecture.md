# Architecture Overview

## Current State Snapshot
- The repository still contains an Android `app/` module implemented with Jetpack Compose.
- Local Gradle execution is not feasible in the active environment, so the native module cannot be iterated on directly.
- Decision-making has shifted toward Gradle-free delivery mechanisms described in [docs/non_gradle_options.md](non_gradle_options.md).

## Target Architecture Principles
1. **Web-first core:** Continue treating the swarm-space web experience as the primary source of truth so it can power both browser and installable form factors.
2. **Automation over local builds:** Any native packaging (TWA, WebView shell) must be generated via CI or hosted services.
3. **Composable distribution:** Enable multiple delivery paths (PWA install, CI-built APK, hosted wrappers) without duplicating business logic.

## Repository Layout
```
APK/
 ├── app/                # Reference Android module (built in CI only)
 ├── docs/               # Architecture, plan, testing, and delivery research
 └── MemoryGarden.md     # Caretaker reflections per AGENTS.md directive
```

## Integration Points
- **Web App:** Provide manifest, service worker, and responsive design improvements upstream in swarm-space.
- **CI Infrastructure:** Configure pipelines capable of running Gradle when needed to emit APK/AAB artifacts.
- **Hosted Build Services:** Evaluate Expo EAS, Ionic Appflow, or similar for teams that prefer JavaScript-first tooling.

## Next Architectural Questions
- Which combination of PWA + wrapper best balances delivery speed and user experience?
- How will secrets (signing keys, API tokens) be managed when builds happen remotely?
- What telemetry or feature flags are necessary to support release-over-the-air without native rebuilds?
