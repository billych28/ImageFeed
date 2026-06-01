//
//  OAuth2Storage.swift
//  ImageFeed
//
//  Created by Мамытов Руслан on 26.05.2026.
//
import Foundation

private enum Keys: String {
    case token
}

final class OAuth2Storage {
    static let shared = OAuth2Storage()
    private init() {}
    
    // MARK: - Public properties
    var token: String? {
        get {
            storage.string(forKey: Keys.token.rawValue)
        }
        set {
            storage.set(newValue, forKey: Keys.token.rawValue)
        }
    }
    
    // MARK: - Private properties
    private let storage: UserDefaults = .standard
}
