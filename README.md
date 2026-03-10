# Journalist App 📰✍️
[![Flutter](https://img.shields.io/badge/Flutter-v3.11+-02569B?logo=flutter&logoColor=white)](https://flutter.dev)
[![Clean Architecture](https://img.shields.io/badge/Architecture-Clean_Architecture-green)](https://blog.cleancoder.com/uncle-bob/2012/08/13/the-clean-architecture.html)
[![State Management](https://img.shields.io/badge/State_Management-Bloc_/_Cubit-blue)](https://bloclibrary.dev)

A professional news application designed for journalists, built with **Flutter** following **Clean Architecture** principles and **SOLID** patterns. It features a robust integration with **Firebase Firestore** for article management and a local database for offline reading.

---

## 🏗️ Architecture Implementation

This project implements **Clean Architecture + BLoC/Cubit + Dependency Injection**.

```
┌─────────────────────────────────────────────┐
│              APP (Presentation Layer)       │
│  - Screens: Home, Details, Publish          │
│  - State: Blocs & Cubits                    │
│  - Widgets: ArticleTile, CustomUI           │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│          DOMAIN (Business Logic)            │
│  - Use Cases: GetArticle, PublishArticle... │
│  - Entities: ArticleEntity                  │
│  - Params: PublishArticleParams...          │
│  - Repository Interfaces                    │
└─────────────────┬───────────────────────────┘
                  │
┌─────────────────▼───────────────────────────┐
│        DATA (Implementation Layer)          │
│  - Repository Impl: ArticleRepositoryImpl   │
│  - Data Sources: Remote & Local             │
│  - API Integration: Dio, Firebase           │
│  - Local Persistence: Floor                 │
└─────────────────────────────────────────────┘
```

### 🧱 Project Structure & Layers

#### 1. Presentation (App)
*   **State Management**: Uses **Bloc** and **Cubit** for reactive UI updates.
*   **Cubits**:
    *   `RemoteArticlesCubit`: Handles fetching news from external sources.
    *   `PublishArticleCubit`: Orchestrates the article creation flow.
    *   `ArticleDetailCubit`: Manages the state and smoothed loading for specific article views.
    *   `LocalArticleCubit`: Synchronizes saved articles with the local database.
*   **Widgets**: Reusable components like `ArticleWidget` for feed consistency.

#### 2. Domain (Core)
*   **Pure Dart**: Contains no Flutter dependencies, ensuring high testability and portability.
*   **Use Cases**: Atomic business operations like `GetArticleUseCase` or `RemoveArticleUseCase`.
*   **Entities**: Business objects (e.g., `ArticleEntity`) used throughout the app.
*   **Params**: Encapsulated parameters for use cases (e.g., `PublishArticleParams`).
*   **Repositories (Interfaces)**: Defines the contract for data operations without knowing the source.

#### 3. Data (Repositories)
*   **ArticleRepositoryImpl**: Coordinates between multiple data sources.
*   **Data Sources**:
    *   `FirebaseArticleService`: Interaction with Firestore and Storage.
    *   `NewsApiService`: REST API integration via Dio.
    *   `AppDatabase`: Local storage using Floor.
*   **Mappers**: Logic to convert backend DTOs/Models into business Entities.

---

## 🛠️ Libraries & Technologies

#### 🚀 Framework & UI
*   **Flutter**: Cross-platform development framework.
*   **Declarative UI**: Clean, modern UI built with Flutter Widgets and Material Design.
*   **Ionicons**: Modern iconography package.
*   **Cached Network Image**: High-performance image caching system.

#### 🧠 State Management & DI
*   **Flutter Bloc / Cubit**: Robust state management following the BLoC pattern.
*   **Get_It**: Service locator for high-performance dependency injection.
*   **Flutter Hooks**: Simplified state and lifecycle management in widgets.

#### 📡 Backend & Persistence
*   **Firebase Firestore**: Scalable NoSQL cloud database for real-time storage.
*   **Firebase Storage**: Cloud storage for article images.
*   **Floor**: High-level SQLite abstraction for local data persistence.
*   **Dio**: Robust HTTP client for REST API interaction.

#### 🔧 Utility
*   **Share Plus**: Native OS share sheet integration for rich text and media sharing.
*   **Equatable**: Simplifies object comparison for efficient rebuilding.
*   **Intl**: Internationalization and localization support.
*   **Image Picker**: Native access to device gallery/camera.
*   **Dash Skills (Flutter Agents)**: Enhanced development workflow using AI-driven agents from [dash_skills](https://github.com/kevmoo/dash_skills).

---

## 🔥 Key Features
1.  **News Feed**: Real-time article fetching from both standard APIs and custom Firestore streams.
2.  **Journalist Workflow**: Create and publish articles with image support directly to the cloud.
3.  **Offline Reading**: Save articles locally using the Floor database for reading without connectivity.
4.  **Native Sharing**: Extracted article content, descriptions and URLs perfectly formatted and shared seamlessly through native OS share sheets.
5.  **Multi-language Support (i18n)**: Full English and Spanish localization using `flutter_localizations` and ARB files, easily toggleable via the AppBar.
6.  **Premium Aesthetics**: Modern animated splash screen with gradient shine and haptic feedback, complemented by a bespoke transparent app icon natively configured for Android and iOS via `flutter_launcher_icons`.

## 🚀 Getting Started
1. Clone the repository.
2. Ensure you have your `google-services.json` / `GoogleService-Info.plist` configured for Firebase.
3. Run `flutter pub get`.
4. Run `dart run build_runner build` to generate necessary code (Floor).
5. Launch the app: `flutter run`.

---
**Developed with ❤️ following the best software engineering practices.**
