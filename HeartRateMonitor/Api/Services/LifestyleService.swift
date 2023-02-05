//
//  LifestyleService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

class LifestyleService: BaseApiService {
    enum Path: String {
        case heartRate = "v1/customer/:id/heartrate"
    }

    func postHeartRate(id: Int64, request: HeartRateRequest) async -> VoidResponse? {
        let url = withHost(Path.heartRate.rawValue.withId(id: id))
        Logger.d(url)
        do {
            let response = try await makeRequest(
                VoidResponse.self,
                url: url,
                method: .post,
                parameters: request.toData
            )
            Logger.d(response)
            return response
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }
}
