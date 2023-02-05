//
//  UserManager.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import SwiftUI

class UserManager: ObservableObject {
    @Published var isLogged = false
    @Published var user: UserModel?
    @Published var token: String? = nil

    func login(token: String) {
        self.token = token
        self.isLogged = true
        UserDefaultsUtils.saveToken(token)
    }

    func logout() {
        token = nil
        self.isLogged = false
        UserDefaultsUtils.removeToken()
    }

    func getId() -> Int64? {
        // TODO: using fake id, no way to get it
        return 1
    }
}
