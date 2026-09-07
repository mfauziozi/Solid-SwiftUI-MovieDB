//
//  DiscoverModel.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import Foundation

struct Movie: Identifiable {
    let id: Int
    let title: String
    let overview: String
    let posterPath: String?
}

struct DiscoverPage {
    let page: Int
    let movies: [Movie]
    let totalPages: Int
}
