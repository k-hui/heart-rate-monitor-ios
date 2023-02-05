//
//  FileUtils.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 29/10/2021.
//

import Foundation

struct FileUtils {
    func savePdf(urlString: String, fileName: String) {
        Task {
            guard
                let url = URL(string: urlString),
                let resourceDocUrl = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last
                else { return }
            let pdfData = try? Data.init(contentsOf: url)
            let pdfNameFromUrl = "\(fileName).pdf"
            let actualPath = resourceDocUrl.appendingPathComponent(pdfNameFromUrl)
            do {
                try pdfData?.write(to: actualPath, options: .atomic)
                print("pdf successfully saved!")
            } catch {
                print("Pdf could not be saved")
            }
        }
    }
}
