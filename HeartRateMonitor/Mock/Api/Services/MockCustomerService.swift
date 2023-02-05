//
//  MockCustomerService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

class MockCustomerService: CustomerService {
    override func login(request: LoginRequest) async -> LoginResponse? {
        return MockData.loginResponse
    }

    override func logout() async -> VoidResponse? {
        return VoidResponse()
    }

    override func user(id: Int64) async -> UserResponse? {
        return MockData.userResponse
    }
}
