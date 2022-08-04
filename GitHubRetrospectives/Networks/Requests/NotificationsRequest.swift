//
//  NotificationsRequest.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation

struct NotificationsRequest: GitHubApiRequest {
    typealias ResponseType = [Notification]

    let since: Date
    let before: Date
    let perPage: Int
    let page: Int

    var path: String {
        "/notifications"
    }

    var requireAuthorization: Bool {
        true
    }

    var queries: [String: String]? {
        [
            "all": "true",
            "participating": "true",
            "since": since.iso8601String,
            "before": before.iso8601String,
            "per_page": "\(perPage)",
            "page": "\(page)"
        ]
    }
}
