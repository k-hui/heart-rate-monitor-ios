//
//  BaseModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

protocol BaseModel: Codable { }

extension BaseModel {
    var toDictionary: [String: Any?] {
        var dict: [String: Any?] = [:]
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            dict = try JSONSerialization.jsonObject(with: data, options: .allowFragments) as! [String: Any?]
        } catch {
            print(error)
        }
        return dict
    }

    var toData: Data? {
        do {
            let encoder = JSONEncoder()
            let data = try encoder.encode(self)
            return data
        } catch {
            print(error)
        }
        return nil
    }
}
