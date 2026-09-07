//
//  DiscoverRepositoryImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

// MARK: - Data Source Protocol (Interface Segregation)
protocol DiscoverRemoteDataSource {
    func fetchDiscoverMovies(genreId: Int, page: Int) -> AnyPublisher<DiscoverMoviesResponse, Error>
}

// MARK: - Repository Implementation
final class DiscoverRepositoryImpl: DiscoverRepository {
    private let remoteDataSource: DiscoverRemoteDataSource

    init(remoteDataSource: DiscoverRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchDiscoverMovies(genreId: Int, page: Int) -> AnyPublisher<DiscoverPage, Error> {
        remoteDataSource.fetchDiscoverMovies(genreId: genreId, page: page)
            .map { response in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
