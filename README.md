# todo_app_1

A simple Flutter application for managing your daily tasks.

## Features

- Add, ~~edit~~, and delete tasks (`edit` not implemented yet)
- Mark tasks as completed or finished
- Search tasks
- Persistent local storage
- Responsive UI

## Getting Started

1. **Clone the repository:**
    ```bash
    git clone git@github.com:mcscoder/todo-app-1.git
    cd todo-app-1
    ```

2. **Install dependencies:**
    ```bash
    flutter pub get
    ```

## Running the App

You can run the app in different modes:

- **Debug mode:**
    ```bash
    flutter run
    ```
    Debug mode is useful for development and troubleshooting, but performance may not reflect the final app.

- **Release mode:** `recommended for preview application`
    ```bash
    flutter run --release
    ```
    Release mode provides better performance and is closer to what end users will experience. If you want to see how the app looks and performs in production, it's recommended to run in release mode.

## Folder Structure

```
lib/
  main.dart
  models/
  screens/
  widgets/
  assets/
  database/
```

## Dependencies

- [Flutter](https://flutter.dev/)
- [cupertino_icons](https://pub.dev/packages/cupertino_icons)
- [drift](https://pub.dev/packages/drift)
- [drift_flutter](https://pub.dev/packages/drift_flutter)
- [path_provider](https://pub.dev/packages/path_provider)

**Dev dependencies:**
- [flutter_test](https://pub.dev/packages/flutter_test)
- [drift_dev](https://pub.dev/packages/drift_dev)
- [build_runner](https://pub.dev/packages/build_runner)
