//
//  DiscoverViewModel.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 28/07/25.
//

import SwiftUI
import Combine

final class DiscoverViewModel: ObservableObject {
    private let fetchDiscoverUseCase: DiscoverUseCase
    private let genreId: Int
    private var cancellables = CancelBag()
    private var currentPage = 1
    private var totalPages = 1

    var hasMorePages: Bool {
        currentPage < totalPages
    }

    @Published var movies: [Movie] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""
    @Published var navigationTitle: String

    init(fetchDiscoverUseCase: DiscoverUseCase, genreId: Int, genreName: String) {
        self.fetchDiscoverUseCase = fetchDiscoverUseCase
        self.genreId = genreId
        self.navigationTitle = genreName
    }

    func onAppear() {
        guard movies.isEmpty else { return }
        loadMovies(page: 1)
    }

    func loadNextPageIfNeeded(currentIndex: Int) {
        let thresholdIndex = movies.count - 1
        if currentIndex >= thresholdIndex && hasMorePages && !isLoading {
            loadMovies(page: currentPage + 1)
        }
    }

    private func loadMovies(page: Int) {
        isLoading = true
        showError = false
        fetchDiscoverUseCase.execute(genreId: genreId, page: page)
            .receive(on: DispatchQueue.main)
            .map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let discoverPage):
                    self.currentPage = discoverPage.page
                    self.totalPages = discoverPage.totalPages
                    if page == 1 {
                        self.movies = discoverPage.movies
                    } else {
                        self.movies += discoverPage.movies
                    }
                case .failure(let error):
                    self.showError = true
                    self.errorMessage = error.localizedDescription
                }
            }
            .store(in: &cancellables)
    }
}
