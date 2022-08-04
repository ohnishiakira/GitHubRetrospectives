//
//  GitHubApiRequest.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation

protocol GitHubApiRequest {
    associatedtype ResponseType: Codable

    var endpoint: String { get }
    var path: String { get }
    var queries: [String: String]? { get }
    var urlRequest: URLRequest { get }
    var decoder: JSONDecoder { get }
    var requireAuthorization: Bool { get }

    func decode(from data: Data) throws -> ResponseType
}

extension GitHubApiRequest {
    var endpoint: String {
        "https://api.github.com"
    }

    var headers: [String: String]? {
        [:]
    }

    private var defaultHeaders: [String: String] {
        [
            "Accept": "application/vnd.github+json"
        ]
    }

    var queries: [String: String]? {
        [:]
    }

    var urlRequest: URLRequest {
        var url = URLComponents(string: endpoint + path)!

        if let queries = queries {
            url.queryItems = queries.map { name, value -> URLQueryItem in
                URLQueryItem(name: name, value: value)
            }
        }

        var req = URLRequest(url: url.url!)
        req.httpMethod = httpMethod

        defaultHeaders.forEach { (key: String, value: String) in
            req.addValue(value, forHTTPHeaderField: key)
        }

        headers?.forEach { (key: String, value: String) in
            req.addValue(value, forHTTPHeaderField: key)
        }

        return req
    }

    var httpMethod: String {
        "GET"
    }

    var decoder: JSONDecoder {
        let decoder = JSONDecoder()
        decoder.keyDecodingStrategy = .convertFromSnakeCase

        return decoder
    }

    var requireAuthorization: Bool {
        false
    }

    func decode(from data: Data) throws -> ResponseType {
        try decoder.decode(ResponseType.self, from: data)
    }
}
