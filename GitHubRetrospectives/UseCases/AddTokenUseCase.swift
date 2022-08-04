//
//  AddTokenUseCase.swift
//  GitHubRetrospectives
//
//  Created by Akira Ohnishi on 2022/08/04.
//

import Foundation
import KeychainAccess

class AddTokenUseCase {
    private let service = "com.example.github-token"
    private let key = "github-pat"

    private var keychain: Keychain {
        Keychain(service: service)
    }

    func add(personalAccessToken: String) {
        keychain[key] = personalAccessToken
    }

    func get() -> String? {
        keychain[key]
    }

    func exist() -> Bool {
        keychain[key] != nil
    }
}
