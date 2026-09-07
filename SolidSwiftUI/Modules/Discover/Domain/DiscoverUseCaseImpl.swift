//
//  DiscoverUseCaseImpl.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

final class DiscoverUseCaseImpl: DiscoverUseCase {
    private let repository: DiscoverRepository

    init(repository: DiscoverRepository) {
        self.repository = repository
    }

    func execute(genreId: Int, page: Int) -> AnyPublisher<DiscoverPage, Error> {
        repository.fetchDiscoverMovies(genreId: genreId, page: page)
    }
}
