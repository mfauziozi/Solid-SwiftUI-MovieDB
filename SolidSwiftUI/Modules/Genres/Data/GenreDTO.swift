//
//  GenreDTO.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 13/04/26.
//

import Foundation

struct GenreDTO: Decodable {
    let id: Int
    let name: String

    enum CodingKeys: String, CodingKey {
        case id
        case name
    }

    func toDomain() -> Genre {
        Genre(id: id, name: name)
    }
}
