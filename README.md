# Mujer Madrid

An iOS app that helps women in Madrid find nearby care points and support centers. Browse available centers, filter by service type, view detailed information, and get directions — all powered by Madrid's public open data.

## 🎯 Purpose

"Mujer Madrid" solves the problem of discovering and accessing women's care services across the city. The app consumes the Madrid City Council's public open data catalog to provide up-to-date information about attention centers for women, including their services, schedules, accessibility, and locations.

## ✨ Features

- **Care Points List**: Browse all available women care points in Madrid
- **Map & List Toggle**: Switch between a list view and a map view of care points
- **Service Filtering**: Filter care points by service type and description
- **Detail View**: View complete information for each care point (description, services, schedule, accessibility, address, organization)
- **Directions**: Open Apple Maps with driving directions to any care point
- **Call Centers**: Directly call a care point from the app
- **Local Caching**: Data is cached locally so the app works even without a network connection
- **Error & Loading States**: Cross-cutting loader and error views with retry support
- **Location-Based**: Requests location permission to provide directions from the user's current location

## 🏗️ Architecture

The app follows **Clean Architecture** principles with clear separation of concerns across three layers, and uses a set of custom Swift frameworks for cross-cutting infrastructure.

### 📁 Project Structure

```
MujerMadrid/
├── MujerMadrid.xcodeproj
├── Frameworks/                               # Embedded xcframeworks
│   ├── FComponents.xcframework               # Reusable UI components
│   ├── FData.xcframework                     # Networking & data layer utilities
│   ├── FDependencyInjector.xcframework       # Dependency injection container
│   ├── FNavigation.xcframework               # Navigation router system
│   └── FPresentation.xcframework             # ViewModel base contracts
├── FComponents.xcframework                   # (root-level copy)
└── MujerMadrid/
    ├── MujerMadrid.swift                     # App entry point & module injection
    ├── Info.plist
    ├── Assets.xcassets
    ├── Preview Content/
    └── Sources/
        ├── Data/                             # Data layer
        │   ├── DataModule.swift              # Dependency injection for data layer
        │   ├── API/
        │   │   └── WomenCarePointAPI.swift   # API endpoint definitions
        │   ├── DataSource/
        │   │   ├── Local/
        │   │   │   └── WomenCarePointHomeLocalDataSource.swift
        │   │   └── Remote/
        │   │       └── WomenCarePointHomeRemoteDataSource.swift
        │   ├── Entities/
        │   │   └── WomenCarePointDataEntity.swift
        │   ├── Mappers/
        │   │   └── WomenCarePointMapper.swift
        │   └── Repositories/
        │       └── WomenCarePointRepository.swift
        ├── Domain/                           # Domain layer
        │   ├── DomainModule.swift            # Dependency injection for domain layer
        │   ├── Models/
        │   │   └── WomenCarePointModel.swift # Core domain model
        │   ├── Repositories/
        │   │   └── WomenCarePointRepositoryContract.swift
        │   └── UseCases/
        │       └── GetWomenCarePointHomeUseCase.swift
        └── Presentation/                     # Presentation layer
            ├── Navigation/
            │   ├── IncomingNavigation.swift   # Navigation routes enum
            │   ├── Navigator.swift            # Route-to-view resolver
            │   └── NavigationModule.swift
            ├── Home/
            │   ├── WomenCarePointHomeBuilder.swift
            │   ├── WomenCarePointHomeModule.swift
            │   ├── WomenCarePointHomeNavigationBuilder.swift
            │   ├── WomenCarePointHomeScreen.swift
            │   ├── WomenCarePointHomeViewModel.swift
            │   └── Sections/
            │       ├── Header/
            │       ├── List/
            │       └── Footer/
            ├── Detail/
            │   ├── WomenCarePointDetailBuilder.swift
            │   ├── WomenCarePointDetailModule.swift
            │   ├── WomenCarePointDetailNavigationBuilder.swift
            │   ├── WomenCarePointDetailScreen.swift
            │   ├── WomenCarePointDetailViewModel.swift
            │   └── Sections/
            │       ├── Header/
            │       └── Content/
            ├── Cross/                        # Cross-cutting UI sections
            │   ├── Error/
            │   └── Loader/
            └── Utils/
                ├── LocationManager.swift      # CoreLocation wrapper
                └── Utils.swift
```

### 🔄 Data Flow

1. **User Interaction** → SwiftUI Screens (Presentation Layer)
2. **Screens** → ViewModels (via section view model contracts)
3. **ViewModels** → Use Cases (Domain Layer)
4. **Use Cases** → Repository Contract (Domain Layer)
5. **Repository** → Data Sources (Data Layer: Remote + Local)
6. **Remote Data Source** → Madrid Open Data API
7. **Local Data Source** → In-memory cache
8. **Mappers** → Convert between data entities and domain models

### 🎯 Core Components

#### WomenCarePointModel (Domain Entity)
The core domain model representing a care point event, with nested models for location, address, organization, and recurrence. Independent from the API response structure.

#### WomenCarePointRepository
Orchestrates data retrieval between the remote data source (Madrid open data API) and the local data source (in-memory cache). Falls back to remote when local cache is empty.

#### IncomingNavigation
Defines the app's navigation routes (`home`, `detail`) and their presentation type (`.goToRoot`, `.push`). Integrates with the `FNavigation` framework's `Router`.

#### Navigator
Resolves `IncomingNavigation` cases into SwiftUI views using the Builder pattern (`WomenCarePointHomeBuilder`, `WomenCarePointDetailBuilder`).

#### Module System
Each layer registers its dependencies in a `ModuleContract` (`DataModule`, `DomainModule`, `NavigationModule`, and feature modules). All modules are injected at app launch in `MujerMadrid.swift`.

## 🚀 Getting Started

### Prerequisites

- iOS 17.6+
- Xcode 16.0+
- Swift 6.0+

### Installation

1. Clone the repository:
```bash
git clone https://github.com/jmrtno/MujerMadrid.git
cd MujerMadrid
```

2. Open the project in Xcode:
```bash
open MujerMadrid.xcodeproj
```

3. Build and run the project on your device or simulator.

### Permissions Required

The app requests the following permission:

1. **Location Services**:
   - `When In Use` authorization for providing directions to care points
   - Usage description: "Necesitamos acceder a tu ubicación para mostrarte la ruta al centro"

## 📱 Usage

### Home Screen

1. The app loads care points from Madrid's open data on launch
2. Browse the list of available care points
3. Toggle between list and map view
4. Filter care points by service type using the filter pills
5. Tap any care point to see its details

### Detail Screen

1. View the care point's title, description, and services
2. See the organization's schedule and accessibility information
3. View the address and location on a map
4. Tap the directions button to open Apple Maps with driving directions
5. Tap the call button to contact the center directly

### Error Handling

- If data fetching fails, an error view is displayed with a retry button
- If local cache is available, the app shows cached data even without a network

## 🛠️ Technical Details

### Data Source

The app consumes the Madrid City Council's public open data catalog:
- Endpoint: `https://datos.madrid.es/egob/catalogo/205736-0-atencion-mujeres.json`
- Returns a JSON catalog of women care points with location, organization, schedule, and service information

### Caching Strategy

- **Primary**: Remote data source (Madrid open data API)
- **Fallback**: Local in-memory cache
- The repository first checks the local cache; if empty, it fetches from remote and caches the result

### Custom Frameworks

The app relies on five in-house Swift frameworks distributed as `.xcframework`:

| Framework              | Responsibility                                      |
|------------------------|-----------------------------------------------------|
| FComponents            | Reusable SwiftUI UI components                      |
| FData                  | Networking contracts and HTTP API abstractions      |
| FDependencyInjector    | Dependency injection container (`@Injected`, `ModuleContract`) |
| FNavigation            | Router-based navigation system (`Router`, `ScreenNavigator`) |
| FPresentation          | ViewModel base contracts (`ViewModelContract`)      |

### Swift 6 & Concurrency

- Built with **Swift 6.0** language mode
- ViewModels and repositories are `@unchecked Sendable`
- Use cases conform to `Sendable`
- Async/await for all data fetching operations

### Navigation System

- Uses `FNavigation`'s `Router` and `NavigationManager` as an environment object
- `IncomingNavigation` enum defines all possible routes
- `Navigator` resolves routes into SwiftUI views using the Builder pattern
- Each feature provides its own `NavigationBuilder` for navigation actions

### Section-Based UI

Screens are composed of independent sections, each with its own:
- **View** — SwiftUI view for the section
- **ViewModelContract** — Protocol defining the section's interface
- **RenderModel** — Presentation-layer model for rendering
- **ObservedModel** — Observable model published by the ViewModel
- **Mapper** — Converts domain models to render models
- **Module** — Registers section dependencies

### Device Support

- **iPhone & iPad** (`TARGETED_DEVICE_FAMILY = 1,2`)
- **iOS Deployment Target**: 17.6
- **App Category**: Healthcare & Fitness
- **Bundle Identifier**: `com.javidev.CercaDeTiApp`

## 🔧 Configuration

### Build Settings

- **iOS Deployment Target**: 17.6
- **Swift Language Version**: 6.0
- **Architecture**: Clean Architecture with MVVM and section-based UI
- **Code Signing**: Manual with provisioning profile

### Environment Configurations

- **Debug**: Includes verbose logging and preview support
- **Release**: Optimized build with whole-module compilation

## 📋 Requirements

### Functional Requirements

- ✅ Display list of women care points in Madrid
- ✅ Filter care points by service type
- ✅ View detailed information for each care point
- ✅ Provide driving directions via Apple Maps
- ✅ Call care points directly from the app
- ✅ Cache data locally for offline access
- ✅ Handle loading and error states gracefully

### Non-Functional Requirements

- ✅ Responsive SwiftUI interface
- ✅ Clean, maintainable, testable architecture
- ✅ Swift 6 concurrency-safe
- ✅ iPad and iPhone support
- ✅ Dependency injection for testability

## 🧪 Testing

### Manual Testing

1. **Data Loading**: Test home screen data fetching and caching
2. **Filtering**: Test filter pills with different service types
3. **Navigation**: Test navigation between home and detail screens
4. **Directions**: Test Apple Maps integration on a real device
5. **Error Handling**: Test error view and retry functionality (disable network)
6. **Offline**: Test cached data display without network

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch (`git checkout -b feature/AmazingFeature`)
3. Commit your changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

When adding a new feature, follow the existing patterns:
- **Data layer**: Add API endpoints, data sources, entities, mappers, and repository implementations
- **Domain layer**: Add models, repository contracts, and use cases
- **Presentation layer**: Add screens with section-based architecture (Builder, Module, Screen, ViewModel, Sections)
- **Navigation**: Add new routes to `IncomingNavigation` and handle them in `Navigator`
- **Dependency injection**: Register new dependencies in the appropriate `ModuleContract`

## 📄 License

This project is licensed under the MIT License - see the LICENSE file for details.

## 🙏 Acknowledgments

- Madrid City Council's open data portal (`datos.madrid.es`) for providing the care points dataset
- SwiftUI for modern declarative UI development
- Clean Architecture principles for maintainable, testable code
- The custom F-frameworks (FComponents, FData, FDependencyInjector, FNavigation, FPresentation) for reusable infrastructure

## 📞 Support

If you have any questions or issues, please open an issue on the GitHub repository.

---

**Made with ❤️ using SwiftUI and Clean Architecture**
