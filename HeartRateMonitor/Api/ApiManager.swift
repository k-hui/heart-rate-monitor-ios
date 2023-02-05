//
//  ApiManager.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

// REST API
// https://raw.githubusercontent.com/Prenetics/test-api/master/api.json
// https://editor.swagger.io

import SwiftUI

class ApiManager: ObservableObject {
    var token: String?

    func customer() -> CustomerService {
        return CustomerService(token: token)
    }

    func genetics() -> GeneticsService {
        return GeneticsService(token: token)
    }

    func lifestyle() -> LifestyleService {
        return LifestyleService(token: token)
    }
}
