//
//  GenreRepository.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

protocol GenreRepository {
    func fetchGenres() -> AnyPublisher<[Genre], Error>
}
