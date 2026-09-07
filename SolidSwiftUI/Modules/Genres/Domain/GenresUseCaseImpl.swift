//
//  GenresUseCaseImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

final class GenresUseCaseImpl: GenresUseCase {
    private let repository: GenreRepository

    init(repository: GenreRepository) {
        self.repository = repository
    }

    func execute() -> AnyPublisher<[Genre], Error> {
        repository.fetchGenres()
    }
}
