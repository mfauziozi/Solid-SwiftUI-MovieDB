//
//  GenresUseCase.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation
import Combine

protocol GenresUseCase {
    func execute() -> AnyPublisher<[Genre], Error>
}
