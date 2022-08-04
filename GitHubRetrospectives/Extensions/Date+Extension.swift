//
//  Date+Extension.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation

extension Date {
    var iso8601String: String {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]

        return formatter.string(from: self)
    }
}
