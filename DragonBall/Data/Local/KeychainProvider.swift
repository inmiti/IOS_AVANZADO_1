//
//  KeychainProvider.swift
//  DragonBall
//
//  Created by ibautista on 11/10/23.
//

import Foundation
import KeychainSwift

protocol SecureDataProviderProtocol {
    func save(token: String)
    func getToken() -> String?
}

class SecureDataProvider: SecureDataProviderProtocol {
    private let keychain = KeychainSwift()
    
    private enum Key {
        static let token = "KEY_KEYCHAIN_TOKEN"
    }
    
    func save(token: String) {
        keychain.set(token, forKey: Key.token)
    }
    
    func getToken() -> String? {
        keychain.get(Key.token)
    }
}
