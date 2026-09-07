//
//  DiscoverViewModelTests.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 11/08/25.
//

import XCTest
import Combine
@testable import SolidSwiftUI

class MockDiscoverUseCase: DiscoverUseCase {
    var result: Result<DiscoverMoviesResponse, Error> = .success(
        DiscoverMoviesResponse(page: 1, movies: [Movie(movieTitle: "Test", movieOverview: "Overview", movieImageUrl: "/test.jpg", movieId: 1)], totalPages: 1)
    )

    func executeDiscoverMovies(genreId: Int, page: Int) -> AnyPublisher<DiscoverMoviesResponse, Error> {
        return result.publisher.eraseToAnyPublisher()
    }
}

final class DiscoverViewModelTests: XCTestCase {
    var viewModel: DiscoverViewModel!
    var cancellables: Set<AnyCancellable> = []

    override func setUp() {
        super.setUp()
        let mockUseCase = MockDiscoverUseCase()
        viewModel = DiscoverViewModel(fetchDiscoverUseCase: mockUseCase, genreId: 1, genreName: "Action")
    }

    func testOnAppearLoadsMovies() {
        let expectation = XCTestExpectation(description: "Movies loaded")
        viewModel.$movies
            .dropFirst()
            .sink { movies in
                XCTAssertEqual(movies.count, 1)
                XCTAssertEqual(movies.first?.movieTitle, "Test")
                expectation.fulfill()
            }
            .store(in: &cancellables)

        viewModel.onAppear()
        wait(for: [expectation], timeout: 1.0)
    }
}
