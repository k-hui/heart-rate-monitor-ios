//
//  UserDefaultsUtils.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import Foundation

struct UserDefaultsUtils {

    enum Key: String {
        case token = "token"
    }

    static private let userDefaults = UserDefaults.standard

    static private func removeObject(key: String) {
        UserDefaults.standard.removeObject(forKey: key)
    }

    static private func save(_ key: String, value: String) {
        userDefaults.set(value, forKey: key)
        userDefaults.synchronize()
    }

    static func loadToken() -> String? {
        return userDefaults.string(forKey: Key.token.rawValue)
    }

    static func saveToken(_ token: String) {
        save(Key.token.rawValue, value: token)
    }

    static func removeToken() {
        removeObject(key: Key.token.rawValue)
    }
}
