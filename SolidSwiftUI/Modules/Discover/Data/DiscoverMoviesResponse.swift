//
//  DiscoverMoviesResponse.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation

struct DiscoverMoviesResponse: Decodable {
    let page: Int
    let movies: [MovieDTO]
    let totalPages: Int

    enum CodingKeys: String, CodingKey {
        case page = "page"
        case movies = "results"
        case totalPages = "total_pages"
    }

    func toDomain() -> DiscoverPage {
        DiscoverPage(
            page: page,
            movies: movies.map { $0.toDomain() },
            totalPages: totalPages
        )
    }
}
