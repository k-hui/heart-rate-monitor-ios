//
//  PdfResponse.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import Foundation

struct PdfResponse: BaseResponse {
    let data: Data
    let url: URL?
}
