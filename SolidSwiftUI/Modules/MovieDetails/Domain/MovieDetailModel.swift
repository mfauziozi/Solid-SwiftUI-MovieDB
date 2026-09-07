//
//  MovieDetailModel.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 13/04/26.
//

import Foundation

struct MovieDetail {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String
    let voteAverage: Double
    let genres: [Genre]
}
