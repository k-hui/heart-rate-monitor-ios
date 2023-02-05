//
//  GeneticsService.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

import Foundation

class GeneticsService: BaseApiService {
    enum Path: String {
        case report = "v1/customer/:id/report"
        case genetic = "v1/customer/:id/genetic"
    }

    func getHealthReport(id: Int64) async -> PdfResponse? {
        let url = withHost(Path.report.rawValue.withId(id: id))
        Logger.d(url)
        do {
            if let data = try await makeRequest(
                    url: url,
                    method: .get,
                    contentType: .pdf
                ) {
                return PdfResponse(data: data, url: nil)
            }
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }

    func getGeneticDetails(id: Int64) async -> GeneticResponse? {
        let url = withHost(Path.genetic.rawValue.withId(id: id))
        Logger.d(url)
        do {
            if let data = try await makeRequest(
                    url: url,
                    method: .get
                ) {
                // convert to app response
                if let array = try? JSONDecoder().decode([GenotypeModelForApi].self, from: data) {
                    Logger.d(array)
                    let genotypes = array.map { item in
                        return GenotypeModel(name: item.name, symbol: item.symbol)
                    }
                    return GeneticResponse(genotypes: genotypes)
                }
            }
        } catch {
            Logger.d("Request failed: \(error)")
        }
        return nil
    }
}
