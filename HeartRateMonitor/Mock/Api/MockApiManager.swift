//
//  MockApiManager.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import SwiftUI

class MockApiManager: ApiManager {
    override func customer() -> CustomerService {
        return MockCustomerService()
    }

    override func genetics() -> GeneticsService {
        return MockGeneticsService()
    }

    override func lifestyle() -> LifestyleService {
        return MockLifestyleService()
    }
}
