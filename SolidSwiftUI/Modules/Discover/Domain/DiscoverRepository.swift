//
//  DiscoverRepository.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

protocol DiscoverRepository {
    func fetchDiscoverMovies(genreId: Int, page: Int) -> AnyPublisher<DiscoverPage, Error>
}
