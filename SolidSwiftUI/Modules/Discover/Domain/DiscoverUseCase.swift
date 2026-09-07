//
//  DiscoverUseCase.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

protocol DiscoverUseCase {
    func execute(genreId: Int, page: Int) -> AnyPublisher<DiscoverPage, Error>
}
