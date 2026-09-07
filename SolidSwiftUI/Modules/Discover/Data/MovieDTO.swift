//
//  MovieDTO.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 13/04/26.
//

import Foundation

struct MovieDTO: Decodable {
    let id: Int?
    let title: String?
    let overview: String?
    let posterPath: String?

    enum CodingKeys: String, CodingKey {
        case id
        case title
        case overview
        case posterPath = "poster_path"
    }

    func toDomain() -> Movie {
        Movie(
            id: id ?? 0,
            title: title ?? "-",
            overview: overview ?? "",
            posterPath: posterPath
        )
    }
}
