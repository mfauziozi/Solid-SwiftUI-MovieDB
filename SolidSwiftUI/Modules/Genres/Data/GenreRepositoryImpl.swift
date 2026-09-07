//
//  GenreRepositoryImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

// MARK: - Data Source Protocol (Interface Segregation)
protocol GenreRemoteDataSource {
    func fetchGenres() -> AnyPublisher<GenresResponse, Error>
}

// MARK: - Repository Implementation
final class GenreRepositoryImpl: GenreRepository {
    private let remoteDataSource: GenreRemoteDataSource

    init(remoteDataSource: GenreRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchGenres() -> AnyPublisher<[Genre], Error> {
        remoteDataSource.fetchGenres()
            .map { response in
                response.genres.map { $0.toDomain() }
            }
            .eraseToAnyPublisher()
    }
}
