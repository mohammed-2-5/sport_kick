# Repository Guidelines

## Project Structure & Module Organization
`lib/` holds Flutter source organized by Clean Architecture: `core/` for shared utilities/constants and `features/<feature>/{domain,data,presentation}` for feature code. Localization lives in `lib/l10n/` with ARB files and generated `app_localizations*.dart` (configured in `l10n.yaml`). Assets and fonts are in `assets/`, and environment values are loaded from `.env`. Tests are in `test/`, integration tests in `integration_test/`, with driver helpers in `test_driver/`. Platform targets are under `android/`, `ios/`, `web/`, and `windows/`; backend scripts/config live in `supabase/` and `docs/`.

## Build, Test, and Development Commands
- `flutter pub get` installs dependencies.
- `flutter run` runs the app on a device or simulator.
- `flutter analyze` runs linting from `analysis_options.yaml`.
- `flutter format .` formats Dart code.
- `flutter test` runs unit and widget tests.
- `flutter test integration_test` runs integration tests.
- `flutter build apk` (or `flutter build ios`) creates release builds.

## Coding Style & Naming Conventions
Use 2-space indentation, max ~80-100 characters per line, and trailing commas for formatting. Prefer `const` constructors. Follow Dart style, the lints in `analysis_options.yaml`, and guidance in `CODE_QUALITY_STANDARDS.md`. File names are snake_case (for example, `user_settings_page.dart`), and each public widget or class lives in its own file.

## Testing Guidelines
Use `flutter_test`, `bloc_test`, and `mocktail` for unit/widget tests, and `integration_test` for end-to-end flows. Name files `*_test.dart` and mirror feature paths (for example, `test/features/auth/...`). Add tests when changing Cubits, use cases, or critical booking flows.

## Commit & Pull Request Guidelines
Git history shows a mix of Conventional Commits (`feat:`, `fix:`, `test:`, `refactor:`) and short descriptive messages (for example, "update all ui v2"). Prefer the Conventional Commit style for new work. PRs should include a clear description, a linked issue if relevant, screenshots for UI changes, and a note of tests run.

## Security & Configuration
Do not commit secrets. Keep Supabase keys and other environment values in `.env` and `.env.example`, and load via `flutter_dotenv` or `--dart-define`.
