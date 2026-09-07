//
//  MovieDetailUseCaseImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import Foundation
import Combine

final class MovieDetailUseCaseImpl: MovieDetailUseCase {
    private let repository: MovieDetailRepository

    init(repository: MovieDetailRepository) {
        self.repository = repository
    }

    func execute(movieId: Int) -> AnyPublisher<MovieDetail, Error> {
        repository.fetchMovieDetail(movieId: movieId)
    }
}
