//
//  String_.swift
//  HeartRateMonitor
//
//  Created by Key Hui on 27/10/2021.
//

extension String {
    func withId(id: Int64) -> String {
        return replacingOccurrences(of: ":id", with: String(id))
    }
}
