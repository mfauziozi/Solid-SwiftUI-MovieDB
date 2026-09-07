//
//  GenresViewModel.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import SwiftUI
import Combine

struct GenreSection: Identifiable {
    let id = UUID()
    let title: String
    let genres: [Genre]
}

final class GenresViewModel: ObservableObject {
    private let fetchGenresUseCase: GenresUseCase
    private var cancellables = Set<AnyCancellable>()

    @Published var sections: [GenreSection] = []
    @Published var isLoading = false
    @Published var showError = false
    @Published var errorMessage = ""

    init(fetchGenresUseCase: GenresUseCase) {
        self.fetchGenresUseCase = fetchGenresUseCase
    }

    func fetchGenres() {
        isLoading = true
        fetchGenresUseCase.execute()
            .receive(on: DispatchQueue.main)
            .map { Result.success($0) }
            .catch { Just(Result.failure($0)) }
            .sink { [weak self] result in
                guard let self else { return }
                self.isLoading = false
                switch result {
                case .success(let genres):
                    let grouped = Dictionary(
                        grouping: genres,
                        by: { String($0.name.prefix(1).uppercased()) }
                    )
                    self.sections = grouped.map { key, values in
                        GenreSection(title: key, genres: values.sorted(by: { $0.name < $1.name }))
                    }
                    .sorted(by: { $0.title < $1.title })
                case .failure(let error):
                    self.errorMessage = error.localizedDescription
                    self.showError = true
                }
            }
            .store(in: &cancellables)
    }
}
