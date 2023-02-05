//
//  CustomerService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

class CustomerService: BaseApiService {
    enum Path: String {
        case login = "v1/customer/login"
        case logout = "v1/customer/logout"
        case user = "v1/customer/:id/user"
    }

    func login(request: LoginRequest) async -> LoginResponse? {
        let url = withHost(Path.login.rawValue)
        Logger.d(url)
        do {
            let response = try await makeRequest(
                LoginResponse.self,
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

    func logout() async -> VoidResponse? {
        let url = withHost(Path.logout.rawValue)
        Logger.d(url)
        do {
            let response = try await makeRequest(
                VoidResponse.self,
                url: url,
                method: .post
            )
            Logger.d(response)
            return response
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }

    func user(id: Int64) async -> UserResponse? {
        let url = withHost(Path.user.rawValue).withId(id: id)
        Logger.d(url)
        do {
            let response = try await makeRequest(
                UserResponse.self,
                url: url,
                method: .get
            )
            Logger.d(response)
            return response
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }
}
