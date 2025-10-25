# APK

Android client exploration for the [swarm-space](https://github.com/bobdub/swarm-space.git) experience.

## Project Overview
The initial iteration of this repository relied on a Compose/Gradle Android shell that wrapped the swarm-space web experience inside a WebView. Because Gradle and the Android toolchain are not accessible in this execution environment, the current focus is to document and prototype alternative delivery paths that do **not** require local Gradle builds.

### Current Assets
- Gradle-based Android project skeleton retained for reference.
- Documentation describing Gradle-free packaging and distribution options for the swarm-space experience.

## Delivery Options Without Local Gradle
See [docs/non_gradle_options.md](docs/non_gradle_options.md) for detailed guidance. In summary, viable strategies include:

1. **Ship as a Progressive Web App (PWA):** Invest in PWA capabilities within the swarm-space web codebase and distribute via browser install prompts or Chrome WebAPK generation.
2. **Leverage Trusted Web Activity (TWA) managed builds:** Use cloud CI (GitHub Actions, CI services) or Google Play Console to produce signed artifacts without requiring local Gradle access.
3. **Wrap with cross-platform runtimes that avoid Gradle locally:** Tools like Capacitor or Tauri can generate Android packages using remote build providers while allowing day-to-day development in web tooling.
4. **Host a downloadable WebView shell built in CI:** Maintain the existing Android module but run Gradle exclusively in automated pipelines that publish debug/release APKs for testers.

## Documentation
- [Non-Gradle delivery options](docs/non_gradle_options.md)
- [Project plan](docs/project_plan.md)
- [Architecture overview](docs/architecture.md)
- [Testing & QA strategy](docs/testing.md)

## Contributing
- Use feature branches for all work.
- Update documentation with findings from experiments in Gradle-free workflows.
- Coordinate with CI owners before altering build or signing configurations.

## License
TBD.
