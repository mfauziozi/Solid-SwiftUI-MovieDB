//
//  MovieDetailViewModel.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 06/08/25.
//

import SwiftUI
import Combine

final class MovieDetailViewModel: ObservableObject {
    private let fetchMovieDetailUseCase: MovieDetailUseCase
    private var cancellables = Set<AnyCancellable>()
    private let movieId: Int

    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var movieDetail: MovieDetail?

    init(fetchMovieDetailUseCase: MovieDetailUseCase, movieId: Int) {
        self.fetchMovieDetailUseCase = fetchMovieDetailUseCase
        self.movieId = movieId
    }

    func fetchMovieDetail() {
        isLoading = true
        fetchMovieDetailUseCase.execute(movieId: movieId)
            .receive(on: DispatchQueue.main)
            .map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let detail):
                    self.movieDetail = detail

                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
            .store(in: &cancellables)
    }
}
