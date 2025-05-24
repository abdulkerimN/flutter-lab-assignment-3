# Album App

A Flutter application that displays albums and photos from the JSONPlaceholder API.

## Features

- Display a list of albums
- View album details
- Error handling and loading states
- Modern Material Design 3 UI

## Architecture

- MVVM Architecture
- BLoC for state management
- Repository pattern for data handling
- Retrofit for API calls
- GoRouter for navigation

## Setup

1. Make sure you have Flutter installed on your system
2. Clone this repository
3. Run the following commands:

```bash
flutter pub get
flutter pub run build_runner build --delete-conflicting-outputs
```

## Running the App

```bash
flutter run
```

## Dependencies

- flutter_bloc: State management
- retrofit: API client
- dio: HTTP client
- go_router: Navigation
- json_annotation: JSON serialization
- equatable: Value equality
- cached_network_image: Image caching 