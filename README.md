# Imago

Imago is a cross-platform Flutter application for generating images from text prompts. It provides a simple, intuitive interface for users to create and discover visuals, making it a powerful tool for creative expression.

The project is built with a scalable, feature-driven clean architecture to ensure maintainability and separation of concerns. The `lib` directory is organized into `core` for shared utilities and `features` for self-contained modules. Each feature is split into `data` (data sources), `domain` (business logic), and `presentation` (UI), promoting a robust and testable codebase.

## Getting Started

To get started with this project, clone the repository and run:

```bash
flutter pub get
flutter run
```

## Project Structure

The project follows the principles of Clean Architecture, organized by features.

```
imago/
└── lib/
    ├── core/
    │   ├── error/
    │   ├── typedef/
    │   └── usecase/
    └── features/
        └── home_page/
            ├── data/
            │   ├── datasources/
            │   ├── models/
            │   └── repositories/
            ├── domain/
            │   ├── entities/
            │   ├── repositories/
            │   └── usecases/
            └── presentation/
                ├── bloc/
                ├── pages/
                └── widgets/
```

- **`core`**: Contains shared code used across multiple features, such as base use cases, error handling, and type definitions.
- **`features`**: Each feature of the application is a self-contained module.
  - **`data`**: Implements the repository interfaces from the domain layer. It handles data from sources like APIs or local databases.
  - **`domain`**: Contains the core business logic. It defines entities, repository interfaces (contracts), and use cases. This layer is independent of any other layer.
  - **`presentation`**: Contains the UI and state management logic (e.g., BLoC, Provider). It depends on the domain layer to execute use cases and display data.
