//
//  GenotypeModel.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

struct GenotypeModel: BaseModel {
    var id = UUID() // for list view
    let name: String
    let symbol: String
}

struct GenotypeModelForApi: BaseModel {
    let name: String
    let symbol: String
}
