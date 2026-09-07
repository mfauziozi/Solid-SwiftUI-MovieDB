//
//  ActivityIndicator.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import Combine
import SwiftUI

public final class ActivityIndicator: ObservableObject {
    @Published public private(set) var isLoading = false

    private let lock = NSRecursiveLock()
    private var cancellables = Set<AnyCancellable>()

    public init() {}

    public func trackActivity<PublisherType: Publisher>(of publisher: PublisherType) -> AnyPublisher<PublisherType.Output, PublisherType.Failure> {
        return publisher
            .handleEvents(
                receiveSubscription: { _ in
                    self.startLoading()
                },
                receiveOutput: { _ in
                    self.stopLoading()
                },
                receiveCompletion: { _ in
                    self.stopLoading()
                },
                receiveCancel: {
                    self.stopLoading()
                }
            )
            .eraseToAnyPublisher()
    }

    private func startLoading() {
        lock.lock()
        defer { lock.unlock() }
        isLoading = true
    }

    private func stopLoading() {
        lock.lock()
        defer { lock.unlock() }
        isLoading = false
    }
}

extension Publisher {
    public func trackActivity(_ activityIndicator: ActivityIndicator) -> AnyPublisher<Output, Failure> {
        activityIndicator.trackActivity(of: self)
    }
}
