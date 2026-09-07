//
//  MovieApiService.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import Foundation
import Combine

// MARK: - MovieAPIService conforms to per-module DataSource protocols (ISP)
final class MovieAPIService: GenreRemoteDataSource, DiscoverRemoteDataSource, MovieDetailRemoteDataSource {
    private let urlSession: URLSession

    init(urlSession: URLSession = .shared) {
        self.urlSession = urlSession
    }

    // MARK: - GenreRemoteDataSource
    func fetchGenres() -> AnyPublisher<GenresResponse, Error> {
        requestPublisher(route: MovieApiRouter.getGenres)
    }

    // MARK: - DiscoverRemoteDataSource
    func fetchDiscoverMovies(genreId: Int, page: Int) -> AnyPublisher<DiscoverMoviesResponse, Error> {
        requestPublisher(route: MovieApiRouter.getDiscover(genre: genreId, page: page))
    }

    // MARK: - MovieDetailRemoteDataSource
    func fetchMovieDetails(movieId: Int) -> AnyPublisher<MovieDetailResponse, Error> {
        requestPublisher(route: MovieApiRouter.getMovieDetails(movieId: movieId))
    }

    // MARK: - Private: Generic Network Request
    private func requestPublisher<T: Decodable>(route: NetworkApiRouter) -> AnyPublisher<T, Error> {
        Future { [weak self] promise in
            guard let self else { return }
            Task {
                do {
                    let result: T = try await self.request(route: route)
                    promise(.success(result))
                } catch {
                    promise(.failure(error))
                }
            }
        }
        .eraseToAnyPublisher()
    }

    private func request<T: Decodable>(route: NetworkApiRouter) async throws -> T {
        let request = try route.asURLRequest()

        logRequest(request)

        let (data, response) = try await urlSession.data(for: request)

        logResponse(response, data: data, error: nil)

        guard let httpResponse = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }

        guard (200...299).contains(httpResponse.statusCode) else {
            throw NetworkError.statusCode(httpResponse.statusCode)
        }

        logResponseBody(data)

        do {
            return try JSONDecoder().decode(T.self, from: data)
        } catch {
            throw NetworkError.decodingError(error)
        }
    }

    // MARK: - Logging
    private func logRequest(_ request: URLRequest) {
        print("\n🌐 [API Request]")
        print("URL: \(request.url?.absoluteString ?? "N/A")")
        print("Method: \(request.httpMethod ?? "N/A")")

        if let headers = request.allHTTPHeaderFields, !headers.isEmpty {
            print("Headers:")
            headers.forEach { print("  \($0.key): \($0.value)") }
        }

        if let body = request.httpBody,
           let bodyString = String(data: body, encoding: .utf8),
           !bodyString.isEmpty {
            print("Body: \(bodyString)")
        }
    }

    private func logResponse(_ response: URLResponse?, data: Data?, error: Error?) {
        print("\n📡 [API Response]")

        if let error = error {
            print("❌ Error: \(error.localizedDescription)")
            return
        }

        guard let httpResponse = response as? HTTPURLResponse else {
            print("⚠️ Invalid response type")
            return
        }

        print("Status Code: \(httpResponse.statusCode)")
    }

    private func logResponseBody(_ data: Data) {
        if let jsonString = prettyPrintedJSON(data: data) {
            print("Response Body:\n\(jsonString)")
        } else {
            print("Response Body: (Not a valid JSON or empty)")
        }
    }

    private func prettyPrintedJSON(data: Data) -> String? {
        guard let jsonObject = try? JSONSerialization.jsonObject(with: data),
              let prettyData = try? JSONSerialization.data(withJSONObject: jsonObject, options: .prettyPrinted) else {
            return nil
        }
        return String(data: prettyData, encoding: .utf8)
    }
}
