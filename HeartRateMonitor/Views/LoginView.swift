//
//  ContentView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/26/21.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    @State var username = ""
    @State var password = ""
    @State var authenticationDidFail = false
    @State var authenticationDidSucceed = false

    var body: some View {
        ZStack {
            VStack {
                TitleText()
                UsernameTextField(username: $username)
                PasswordSecureField(password: $password)
                if authenticationDidFail {
                    Text("Information not correct. Try again.")
                        .offset(y: -10)
                        .foregroundColor(.red)
                }
                Button(action: onTapLogin) {
                    LoginButtonText()
                }
            }
                .padding()

            if authenticationDidSucceed {
                Text("Login succeeded!")
                    .font(.headline)
                    .frame(width: 250, height: 80)
                    .background(Color.green)
                    .cornerRadius(20.0)
                    .foregroundColor(.white)
            }
        }.onAppear {
            #if DEBUG
                if AppConfig.mock {
                    username = MockData.username
                    password = MockData.password
                }
            #endif
        }
    }
}

struct LoginView_Previews: PreviewProvider {
    static var previews: some View {
        LoginView()
    }
}

struct TitleText: View {
    var body: some View {
        Text("Heart Rate Monitor")
            .font(.largeTitle)
            .fontWeight(.semibold)
            .padding(.bottom, 20)
    }
}

struct LoginButtonText: View {
    var body: some View {
        Text("LOGIN")
            .font(.headline)
            .foregroundColor(.white)
            .padding()
            .frame(width: 220, height: 60)
            .background(.red)
            .cornerRadius(15.0)
    }
}

struct UsernameTextField: View {
    @Binding var username: String

    var body: some View {
        TextField("Username", text: $username)
            .padding()
            .background(.gray)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

struct PasswordSecureField: View {
    @Binding var password: String

    var body: some View {
        SecureField("Password", text: $password)
            .padding()
            .background(.gray)
            .cornerRadius(5.0)
            .padding(.bottom, 20)
    }
}

extension LoginView {
    func isValidInputs() -> Bool {
        if username.isEmpty || password.isEmpty {
            return false
        }
        return true
    }

    func onTapLogin() {
        guard isValidInputs() else {
            authenticationDidFail = true
            return
        }

        // call api
        let request = LoginRequest(username: username, password: password)
        Task {
            let response = await apiManager.customer().login(request: request)
            Logger.d(response)
            if let token = response?.token {
                userManager.login(token: token)
                apiManager.token = token
                authenticationDidFail = false
            } else {
                authenticationDidFail = true
            }
        }
    }
}
