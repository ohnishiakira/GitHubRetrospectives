//
//  FetchNotificationsUseCase.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Combine
import Foundation

struct FetchParameters {
    let since: Date
    let before: Date
}

struct Pagination {
    let perPage: Int
    let page: Int

    var next: Pagination {
        Pagination(perPage: perPage, page: page + 1)
    }
}

protocol FetchNotificationsUseCaseDelegate: AnyObject {
    func onFetched(notifications: [Notification])
    func onAuthenticationRequired()
}

class FetchNotificationsUseCase {
    var notifications: [Notification] = []

    var cancellables = Set<AnyCancellable>()

    weak var delegate: FetchNotificationsUseCaseDelegate?

    func fetchStart(parameters: FetchParameters) {
        notifications = []
        fetch(parameters: parameters, pagination: .init(perPage: 50, page: 1))
    }

    private func fetch(parameters: FetchParameters, pagination: Pagination) {
        let request = NotificationsRequest(since: parameters.since, before: parameters.before,
                                           perPage: pagination.perPage, page: pagination.page)

        URLSession.shared.dataTaskPublisher(for: request)
            .receive(on: RunLoop.main)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    if case .requireAuthentication = error as? GitHubError {
                        self.delegate?.onAuthenticationRequired()
                    }
                }
            } receiveValue: {
                self.notifications.append(contentsOf: $0)

                if $0.count >= pagination.perPage {
                    self.fetch(parameters: parameters, pagination: pagination.next)
                } else {
                    self.delegate?.onFetched(notifications: self.notifications)
                }
            }.store(in: &cancellables)
    }
}
