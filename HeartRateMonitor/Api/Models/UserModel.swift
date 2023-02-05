//
//  UserModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

// TODO: no user id to start with, so I added it
struct UserModel: BaseModel {
    let firstname: String
    let lastname: String
    let email: String
    let dob: String
}
