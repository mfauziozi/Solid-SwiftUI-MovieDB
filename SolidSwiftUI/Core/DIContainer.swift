//
//  DIContainer.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 13/04/26.
//

import Foundation

/// Centralized Dependency Injection Container.
/// All concrete dependency wiring happens here — Views and ViewModels
/// only depend on protocols, never on concrete implementations.
final class DIContainer {

    static let shared = DIContainer()

    // MARK: - Shared Infrastructure
    private lazy var apiService = MovieAPIService()

    private init() {}

    // MARK: - Genres Module
    func makeGenresViewModel() -> GenresViewModel {
        let repository = GenreRepositoryImpl(remoteDataSource: apiService)
        let useCase = GenresUseCaseImpl(repository: repository)
        return GenresViewModel(fetchGenresUseCase: useCase)
    }

    // MARK: - Discover Module
    func makeDiscoverViewModel(genreId: Int, genreName: String) -> DiscoverViewModel {
        let repository = DiscoverRepositoryImpl(remoteDataSource: apiService)
        let useCase = DiscoverUseCaseImpl(repository: repository)
        return DiscoverViewModel(
            fetchDiscoverUseCase: useCase,
            genreId: genreId,
            genreName: genreName
        )
    }

    // MARK: - Movie Detail Module
    func makeMovieDetailViewModel(movieId: Int) -> MovieDetailViewModel {
        let repository = MovieDetailRepositoryImpl(remoteDataSource: apiService)
        let useCase = MovieDetailUseCaseImpl(repository: repository)
        return MovieDetailViewModel(
            fetchMovieDetailUseCase: useCase,
            movieId: movieId
        )
    }
}
