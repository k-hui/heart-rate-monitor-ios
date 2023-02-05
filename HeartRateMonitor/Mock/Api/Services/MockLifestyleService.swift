//
//  MockLifestyleService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

class MockLifestyleService: LifestyleService {
    override func postHeartRate(id: Int64, request: HeartRateRequest) async -> VoidResponse? {
        return VoidResponse()
    }
}
