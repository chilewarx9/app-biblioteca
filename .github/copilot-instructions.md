# Copilot Instructions for app_tareas

## Project Overview
This is a Flutter application for managing tasks, structured for cross-platform deployment (Android, iOS, web, desktop). The main logic resides in the `lib/` directory, with UI widgets, controllers, and models separated for clarity and maintainability.

## Key Architecture & Patterns
- **UI Components:**
  - Screens: `lib/login_screen.dart`, `lib/task_screen.dart`
  - Widgets: `lib/widgets/` (e.g., `new_task_sheet.dart`, `taskWidgets/empty_state.dart`)
- **State & Logic:**
  - Controllers: `lib/controllers/` (e.g., `task_contoller.dart`)
  - Models: `lib/models/task.dart`
- **Navigation:**
  - Main entry: `lib/main.dart` sets up navigation and app theme.
- **Empty State Pattern:**
  - Use `EmptyState` widget (`lib/widgets/taskWidgets/empty_state.dart`) to display when no tasks exist.

## Developer Workflows
- **Build:**
  - Use `flutter run` for development.
  - Platform-specific builds: `flutter build apk`, `flutter build ios`, etc.
- **Test:**
  - Add tests in `test/` (not present yet).
  - Run with `flutter test`.
- **Debug:**
  - Use Flutter DevTools or IDE debugging tools.

## Conventions & Practices
- **Widget Structure:**
  - Prefer stateless widgets for simple UI components.
  - Use `Padding`, `Column`, and `SizedBox` for layout consistency.
- **Naming:**
  - Use English for code, Spanish for user-facing strings (see `EmptyState`).
- **State Management:**
  - Currently uses basic controller pattern; no external state management package detected.
- **Assets:**
  - Place images, icons, and fonts in `assets/` or platform-specific folders.

## Integration Points
- **External Dependencies:**
  - Managed via `pubspec.yaml`.
  - No custom platform channels or advanced integrations detected.

## Example Patterns
```dart
// Example: Empty State Widget Usage
EmptyState()
```

## Key Files & Directories
- `lib/` — Main app logic
- `lib/controllers/` — Business logic
- `lib/models/` — Data models
- `lib/widgets/` — Reusable UI components
- `pubspec.yaml` — Dependency management

---
For questions about build, test, or architecture, check this file and `README.md` first. Update this file as new patterns or workflows emerge.
