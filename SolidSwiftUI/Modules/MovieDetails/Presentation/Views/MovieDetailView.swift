//
//  MovieDetailView.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import SwiftUI
import Kingfisher

struct MovieDetailView: View {
    @StateObject private var viewModel: MovieDetailViewModel

    init(movieId: Int, container: DIContainer = .shared) {
        _viewModel = StateObject(wrappedValue: container.makeMovieDetailViewModel(movieId: movieId))
    }

    var body: some View {
        ZStack {
            ScrollView {
                VStack(alignment: .leading, spacing: 16) {
                    if let detail = viewModel.movieDetail {
                        KFImage(URL(string: "https://image.tmdb.org/t/p/w500\(detail.posterPath)"))
                            .resizable()
                            .aspectRatio(contentMode: .fill)
                            .frame(height: 500)
                            .cornerRadius(10)
                            .clipped()
                            .padding(.top, 14)
                            .padding(.horizontal, 14)

                        HStack {
                            Text(detail.title)
                                .font(.title)
                                .bold()
                                .padding(.leading, 14)
                            Spacer()
                            HStack(spacing: 4) {
                                Image("ic_star")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                Text(String(format: "%.1f", detail.voteAverage))
                                    .font(.headline)
                                    .foregroundColor(.white)
                            }
                            .padding(.trailing, 14)
                        }
                        Text(detail.genres.map { $0.name }.joined(separator: ", "))
                            .font(.subheadline)
                            .foregroundColor(.gray)
                            .padding(.leading, 14)
                        Text(detail.overview)
                            .font(.body)
                            .padding(.leading, 14)
                            .padding(.trailing, 14)
                    }
                    Spacer(minLength: 30)
                }
            }
            if viewModel.isLoading {
                ProgressView()
                    .progressViewStyle(CircularProgressViewStyle())
            }
        }
        .navigationTitle("Movie Detail")
        .navigationBarTitleDisplayMode(.inline)
        .background(Color(.systemBackground))
        .onAppear {
            viewModel.fetchMovieDetail()
        }
        .alert(isPresented: $viewModel.showError) {
            Alert(title: Text("Error"), message: Text(viewModel.errorMessage), dismissButton: .default(Text("OK")))
        }
    }
}
