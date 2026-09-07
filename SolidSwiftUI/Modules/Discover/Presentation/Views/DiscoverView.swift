//
//  DiscoverView.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import SwiftUI

struct DiscoverView: View {
    @StateObject private var viewModel: DiscoverViewModel

    init(genreId: Int, genreName: String, container: DIContainer = .shared) {
        _viewModel = StateObject(wrappedValue: container.makeDiscoverViewModel(
            genreId: genreId,
            genreName: genreName
        ))
    }

    private let columns = [
        GridItem(.flexible(), spacing: 16),
        GridItem(.flexible(), spacing: 16)
    ]

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 16) {
                ForEach(viewModel.movies.indices, id: \.self) { index in
                    let movie = viewModel.movies[index]
                    NavigationLink(
                        destination: MovieDetailView(movieId: movie.id)
                    ) {
                        MovieCellView(
                            title: movie.title,
                            imageURL: "https://image.tmdb.org/t/p/w500\(movie.posterPath ?? "")"
                        )
                    }
                    .buttonStyle(PlainButtonStyle())
                    .onAppear {
                        viewModel.loadNextPageIfNeeded(currentIndex: index)
                    }
                }
            }
            .padding(16)
        }
        .navigationTitle(viewModel.navigationTitle)
        .overlay(
            viewModel.isLoading ? ProgressView() : nil
        )
        .alert(isPresented: $viewModel.showError) {
            Alert(
                title: Text("Error"),
                message: Text(viewModel.errorMessage),
                dismissButton: .default(Text("OK"))
            )
        }
        .onAppear {
            viewModel.onAppear()
        }
    }
}
