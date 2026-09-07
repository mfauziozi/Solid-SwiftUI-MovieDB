//
//  MovieDetailUseCase.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import Foundation
import Combine

protocol MovieDetailUseCase {
    func execute(movieId: Int) -> AnyPublisher<MovieDetail, Error>
}
