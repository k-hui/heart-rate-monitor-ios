//
//  ApiError.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

enum ApiErrorCode: Int {
    case succeed = 200
    case created = 201
    case invalidId = 400
    case unauthorized = 401
    case forbidden = 403
}

enum ApiError: Error {
    case invalidUrl
}
