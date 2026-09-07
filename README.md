# SolidSwiftUI

A SwiftUI movie-browsing app built as a reference implementation of **Clean Architecture** and the **SOLID principles** on iOS. It talks to [The Movie Database (TMDB)](https://www.themoviedb.org/) API and lets you browse genres, page through the movies in a genre, and open a movie's detail page.

The point of the project is less the app than the structure: every feature is split into `Domain` / `Data` / `Presentation` layers, dependencies always point inward toward the domain, and all concrete wiring is confined to a single container.

## Features

- **Genres** — fetches the TMDB genre list and groups it into alphabetical sections.
- **Discover** — a two-column poster grid of movies for the selected genre, with infinite scroll (the next page loads as you approach the end of the list).
- **Movie Detail** — poster, title, vote average, genre list, and overview for a single movie.
- Loading indicators and error alerts driven by published view-model state.

## Architecture

Each module under `Modules/` follows the same three-layer shape:

```
Modules/<Feature>/
├── Domain/          Entities, repository + use-case protocols, use-case implementations
├── Data/            DTOs, API response models, repository implementations
└── Presentation/    ViewModels (ObservableObject) and SwiftUI Views
```

The dependency flow for a single screen:

```
View ──▶ ViewModel ──▶ UseCase ──▶ Repository ──▶ RemoteDataSource ──▶ MovieAPIService ──▶ TMDB
        (protocol)    (protocol)   (protocol)      (protocol)
```

Everything above the data source is expressed as a protocol, so any layer can be replaced with a test double without touching the layers around it. Data crosses the boundary as DTOs and is converted to domain models by `toDomain()` mappers, keeping API field names (`poster_path`, `total_pages`) out of the domain and presentation code.

Asynchrony is handled with **Combine**: use cases return `AnyPublisher<T, Error>`, and view models subscribe on the main queue and publish `@Published` state to SwiftUI.

### How the SOLID principles show up

| Principle | Where |
|---|---|
| **S**ingle Responsibility | `MovieApiRouter` builds requests, `MovieAPIService` performs them, repositories map DTOs, use cases hold business rules, view models hold screen state |
| **O**pen/Closed | New endpoints are new `MovieApiRouter` cases; `NetworkApiRouter`'s protocol extension supplies `asURLRequest()` so nothing existing needs editing |
| **L**iskov Substitution | Any `DiscoverRepository`/`GenresUseCase` conformer — real or mock — drops into place unchanged |
| **I**nterface Segregation | Three narrow data-source protocols (`GenreRemoteDataSource`, `DiscoverRemoteDataSource`, `MovieDetailRemoteDataSource`) instead of one fat networking interface; `MovieAPIService` conforms to all three |
| **D**ependency Inversion | Views and view models depend only on protocols; `DIContainer` is the single place that knows about concrete types |

### Dependency injection

`Core/DIContainer.swift` is a singleton factory that assembles each module's repository → use case → view model chain. Views take a `container: DIContainer = .shared` parameter in their initializer, so a test or preview can pass its own container instead.

### Networking

- `NetworkApiRouter` — protocol describing base URL, path, method, headers, and query/body parameters, with a default `asURLRequest()` implementation.
- `MovieApiRouter` — enum of the three TMDB endpoints used (`/genre/movie/list`, `/discover/movie`, `/movie/{id}`).
- `MovieAPIService` — executes requests with `URLSession` and `async/await`, bridges the result back into Combine via `Future`, validates the status code, decodes JSON, and pretty-prints request/response logs to the console.
- `NetworkError` — typed error cases (`invalidURL`, `invalidResponse`, `statusCode`, `decodingError`, …).

## Project layout

```
SolidSwiftUI/
├── Common/CancelBag.swift              typealias for Set<AnyCancellable>
├── Core/
│   ├── DIContainer.swift               all concrete dependency wiring
│   ├── SolidSwiftUIApp.swift           @main entry point
│   ├── NetworkApiService/              MovieAPIService
│   ├── NetworkBaseUrl/                 MovieApiRouter (endpoints)
│   └── NetworkManager/                 NetworkApiRouter, NetworkError, HTTPMethod
├── Modules/
│   ├── Genres/                         Domain · Data · Presentation
│   ├── Discover/                       Domain · Data · Presentation
│   └── MovieDetails/                   Domain · Data · Presentation
└── Utilities/                          ActivityIndicator, ErrorTracker (Combine helpers)
```

## Requirements

- Xcode 16 or later
- iOS 18.1+ (iPhone and iPad)
- Swift 5

## Dependencies

Managed with Swift Package Manager:

- [Kingfisher](https://github.com/onevcat/Kingfisher) 8.5.0 — asynchronous image loading and caching for movie posters.

## Getting started

1. Clone the repository and open `SolidSwiftUI.xcodeproj`. Xcode resolves the Swift package on first open.
2. Set your TMDB API key in `queryParameters` in [`MovieUrlRouter.swift`](SolidSwiftUI/Core/NetworkBaseUrl/MovieUrlRouter.swift) — get one for free from your [TMDB account settings](https://www.themoviedb.org/settings/api).
3. Build and run on an iOS 18.1+ simulator or device.

## Tests

- `SolidSwiftUITests/` — unit tests, including a `DiscoverViewModel` test that injects a mock use case.
- `SolidSwiftUIUITests/` — XCUITest launch and performance tests.
