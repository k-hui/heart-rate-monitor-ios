//
//  ReportView.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 10/30/21.
//

import SwiftUI

struct ReportView: View {
    @EnvironmentObject var userManager: UserManager
    @EnvironmentObject var apiManager: ApiManager

    @State private var isPresentedAlert = false
    @State private var isPresentedPdf = false
    @State private var pdfUrl: URL? = nil
    @State private var pdfData: Data? = nil
    @State private var errMessage: String = ""
    @State private var genotypes: Array<GenotypeModel> = []

    var body: some View {
        VStack {
            Spacer(minLength: 8)
            Text("Genetic details")
            List(genotypes, id: \.id) { genotype in
                Text("\(genotype.name) - \(genotype.symbol)")
            }
                .frame(maxHeight: .infinity)
//            Spacer().frame(maxWidth: .infinity)
            Divider()
            Button(action: presentReport) {
                Text("View PDF report")
            }
                .fullScreenCover(isPresented: $isPresentedPdf) {
                PdfView(url: $pdfUrl, data: $pdfData)
            }
                .alert(isPresented: $isPresentedAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text("\(errMessage)"),
                    dismissButton: .default(Text("OK"))
                )
            }
            Spacer(minLength: 20)
        }.onAppear {
            getGeneticDetails()
        }
    }
}

struct ReportView_Previews: PreviewProvider {
    static var previews: some View {
        ReportView()
    }
}

extension ReportView {
    func getGeneticDetails() {
        // call api
        Task {
            guard let userId = userManager.getId() else {
                isPresentedAlert = true
                errMessage = "Missing userId"
                return
            }
            let response = await apiManager.genetics().getGeneticDetails(id: userId)
//            Logger.d(response)
            genotypes = response?.genotypes ?? []
        }
    }

    func presentReport() {
        // call api
        Task {
            guard let userId = userManager.getId() else {
                isPresentedAlert = true
                errMessage = "Missing userId"
                return
            }
            let response = await apiManager.genetics().getHealthReport(id: userId)
//            Logger.d(response)
            guard let response = response else {
                isPresentedAlert = true
                errMessage = "Missing response data"
                return
            }
            pdfData = response.data
            pdfUrl = response.url
            isPresentedPdf.toggle()
        }
    }
}
