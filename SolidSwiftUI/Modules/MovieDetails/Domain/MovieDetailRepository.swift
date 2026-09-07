//
//  MovieDetailRepository.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import Foundation
import Combine

protocol MovieDetailRepository {
    func fetchMovieDetail(movieId: Int) -> AnyPublisher<MovieDetail, Error>
}
