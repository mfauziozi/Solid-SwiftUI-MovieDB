//
//  ErrorTracker.swift
//  SolidSwiftUI
//
//  Created by Muchamad Fauzi on 22/07/25.
//

import Foundation
import Combine

public final class ErrorTracker: Publisher {
    public typealias Output = Error
    public typealias Failure = Never

    private let subject = PassthroughSubject<Error, Never>()
    private let queue = DispatchQueue(label: "==ErrorTracker==")

    public init() {}

    func trackError<Upstream: Publisher>(from upstream: Upstream) -> AnyPublisher<Upstream.Output, Never> {
        return upstream
            .handleEvents(receiveCompletion: { [weak self] completion in
                if case let .failure(error) = completion {
                    self?.queue.async {
                        self?.subject.send(error)
                    }
                }
            })
            .catch { _ in Empty() }
            .eraseToAnyPublisher()
    }

    public func receive<S>(subscriber: S) where S: Subscriber, Never == S.Failure, Error == S.Input {
        subject.receive(subscriber: subscriber)
    }
}

extension Publisher {
    public func trackError(_ errorTracker: ErrorTracker) -> AnyPublisher<Output, Never> {
        return errorTracker.trackError(from: self)
    }
}
