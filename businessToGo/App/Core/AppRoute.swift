import Foundation

enum AppRoute: Identifiable, Codable, Equatable {
    case login
    
    case management
    case report
    
    case intro
    case settings
    
    var id: Self {self}
}
