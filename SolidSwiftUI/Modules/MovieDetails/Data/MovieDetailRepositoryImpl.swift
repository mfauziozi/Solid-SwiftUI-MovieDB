//
//  MovieDetailRepositoryImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import Foundation
import Combine

// MARK: - Data Source Protocol (Interface Segregation)
protocol MovieDetailRemoteDataSource {
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetailResponse, Error>
}

// MARK: - Repository Implementation
final class MovieDetailRepositoryImpl: MovieDetailRepository {
    private let remoteDataSource: MovieDetailRemoteDataSource

    init(remoteDataSource: MovieDetailRemoteDataSource) {
        self.remoteDataSource = remoteDataSource
    }

    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        remoteDataSource.fetchMovieDetails(movieId: movieId)
            .map { response in
                response.toDomain()
            }
            .eraseToAnyPublisher()
    }
}
