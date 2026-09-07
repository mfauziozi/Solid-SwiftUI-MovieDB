//
//  MovieDetailResponse.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import Foundation

struct MovieDetailResponse: Decodable {
    let movieId: Int
    let movieOverview: String
    let movieImageUrl: String
    let movieTitle: String
    let voteAverage: Double
    let genres: [GenreDTO]

    enum CodingKeys: String, CodingKey {
        case movieTitle    = "title"
        case movieOverview = "overview"
        case movieImageUrl = "poster_path"
        case movieId = "id"
        case voteAverage = "vote_average"
        case genres = "genres"
    }

    func toDomain() -> MovieDetail {
        MovieDetail(
            id: movieId,
            title: movieTitle,
            overview: movieOverview,
            posterPath: movieImageUrl,
            voteAverage: voteAverage,
            genres: genres.map { $0.toDomain() }
        )
    }
}
