import Foundation

enum ReportType: String, CaseIterable, Identifiable, Codable {
    case day = "Tag"
    case week = "Woche"
    case month = "Monat"
    case year = "Jahr"
    
    var id: Self { self }
}
