//
//  GenresResponse.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import Foundation

struct GenresResponse: Decodable {
    let genres: [GenreDTO]

    enum CodingKeys: String, CodingKey {
        case genres
    }
}
