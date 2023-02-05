//
//  ProfileView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 28/10/2021.
//

import SwiftUI

struct ProfileView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    var body: some View {
        VStack {
            Spacer()
            Text("First name: \(userManager.user?.firstname ?? "-")")
                .padding()
            Text("Last name: \(userManager.user?.lastname ?? "-")")
                .padding()
            Text("Email: \(userManager.user?.email ?? "-")")
                .padding()
            Text("Date of birth: \(userManager.user?.dob ?? "-")")
                .padding()
            Spacer(minLength: 44)
            Button("LOGOUT") {
                Logger.d("logout")
                userManager.logout()
                apiManager.token = nil
            }
            Spacer()
        }
            .onAppear {
            // update again
            getUser()
        }
    }
}

struct ProfileView_Previews: PreviewProvider {
    static var previews: some View {
        ProfileView()
    }
}

extension ProfileView {
    func getUser() {
        guard let userId = userManager.getId() else {
            Logger.d("Missing userId")
            return
        }
        // call api
        Task {
            let response = await apiManager.customer().user(id: userId)
            guard let response = response else {
                Logger.d("Invalid response")
                return
            }
            userManager.user = UserModel(
                firstname: response.firstname,
                lastname: response.lastname,
                email: response.email,
                dob: response.dob
            )
        }
    }
}
