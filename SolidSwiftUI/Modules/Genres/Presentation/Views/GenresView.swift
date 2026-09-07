//
//  GenresView.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import SwiftUI

struct GenresView: View {
    @StateObject private var viewModel: GenresViewModel

    init(container: DIContainer = .shared) {
        _viewModel = StateObject(wrappedValue: container.makeGenresViewModel())
    }

    var body: some View {
        NavigationView {
            List {
                ForEach(viewModel.sections, id: \.id) { section in
                    ForEach(section.genres, id: \.id) { genre in
                        NavigationLink(
                            destination: DiscoverView(genreId: genre.id, genreName: genre.name)
                        ) {
                            GenreRow(genre: genre)
                        }
                        .buttonStyle(.plain)
                        .listRowSeparator(.hidden)
                    }
                }
                if viewModel.isLoading {
                    ProgressView()
                        .frame(maxWidth: .infinity, alignment: .center)
                }
            }
            .listStyle(GroupedListStyle())
            .navigationTitle("Genres")
            .onAppear {
                viewModel.fetchGenres()
            }
            .alert(isPresented: $viewModel.showError) {
                Alert(
                    title: Text("Error"),
                    message: Text(viewModel.errorMessage),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
