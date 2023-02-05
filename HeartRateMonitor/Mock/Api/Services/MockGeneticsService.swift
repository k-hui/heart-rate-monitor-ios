//
//  MockGeneticsService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

class MockGeneticsService: GeneticsService {
    override func getHealthReport(id: Int64) async -> PdfResponse? {
        return MockData.pdfResponse
    }

    override func getGeneticDetails(id: Int64) async -> GeneticResponse? {
        return MockData.geneticResponse
    }
}

