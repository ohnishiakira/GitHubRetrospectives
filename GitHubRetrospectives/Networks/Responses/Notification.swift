//
//  Notification.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation

struct Notification: Codable {
    let subject: Subject

    struct Subject: Codable {
        let title: String
        let type: String
    }

    let repository: Repository

    struct Repository: Codable {
        let id: Int
        let name: String
        let fullName: String
        let description: String?
    }

    let reason: String
    let updatedAt: String

    var reasonDescription: String {
        reason == "author" ? subject.type : reason
    }
}
