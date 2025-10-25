# APK Project Plan

## Objective
Deliver the swarm-space experience on Android devices without depending on local Gradle tooling. Explore a mix of PWA upgrades, CI-driven native wrappers, and hosted build services to provide installable artifacts.

## Key Milestones
1. **Requirements & Research**
   - [x] Audit the swarm-space repository to understand core user journeys and critical features.
   - [x] Identify any APIs or services that must be accessed from the Android client.
   - [x] Decide whether to build a fully native experience or embed existing web content using a WebView/Compose HTML renderer.

2. **Architecture & Tooling**
   - [x] Audit existing Compose-based shell and document constraints imposed by missing Gradle tooling.
   - [x] Identify Gradle-free distribution approaches (PWA, CI-built TWA, hosted build services).
   - [ ] Prototype CI workflow capable of producing APK/AAB artifacts without local intervention.

3. **Prototype Implementation**
   - [ ] Harden the swarm-space PWA (manifest, service worker, offline UX) to meet installability criteria.
   - [ ] Configure a reference TWA or hosted wrapper build in CI to validate remote packaging.
   - [ ] Document the deployment handoff process for whichever option meets requirements first.

4. **Testing & QA**
   - [ ] Establish Lighthouse CI or equivalent to track PWA quality metrics.
   - [ ] Configure CI runners to execute Gradle lint/unit tests when building the native wrapper.

5. **Deployment**
   - [ ] Decide on distribution channel (PWA-only, Play Store via TWA, hosted build service) and document trade-offs.
   - [ ] Prepare release signing configuration and any hosted service credentials required for automated publishing.

## Immediate Next Steps
- Prioritize PWA enhancements in the swarm-space repository to unlock installability.
- Spike a GitHub Actions workflow that can run Gradle inside CI and archive artifacts for download.
- Evaluate hosted build offerings (Expo EAS, Ionic Appflow, Tauri) for cost, capability, and maintenance overhead.
- Align with stakeholders on acceptable distribution timeline and success metrics.

## Open Questions
- How much native functionality beyond the web experience is required in the near term?
- Which CI provider and artifact hosting solution best fits security and cost constraints?
- Are there regulatory or branding requirements that favor Play Store distribution over PWA sideloading?
