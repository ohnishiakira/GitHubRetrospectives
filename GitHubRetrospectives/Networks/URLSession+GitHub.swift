//
//  URLSession+GitHub.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Combine
import Foundation

enum GitHubError: Error {
    case requireAuthentication
}

extension URLSession {
    func dataTaskPublisher<Request: GitHubApiRequest>(for request: Request) -> AnyPublisher<Request.ResponseType, Error> {
        var urlRequest = request.urlRequest

        if request.requireAuthorization, let pat = AddTokenUseCase().get() {
            urlRequest.addValue("token \(pat)", forHTTPHeaderField: "Authorization")
        }

        return dataTaskPublisher(for: urlRequest)
            .tryMap { data, response in
                guard let httpResponse = response as? HTTPURLResponse else {
                    throw URLError(.badServerResponse)
                }

                if httpResponse.statusCode == 401 {
                    throw GitHubError.requireAuthentication
                }

                if !(200 ..< 400).contains(httpResponse.statusCode) {
                    throw URLError(.badServerResponse)
                }

                do {
                    return try request.decode(from: data)
                } catch {
                    throw error
                }
            }
            .eraseToAnyPublisher()
    }
}
