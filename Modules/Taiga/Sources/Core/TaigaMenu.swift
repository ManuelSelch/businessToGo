import Foundation
import SwiftUI

public enum TaigaMenu: String, Codable, Equatable {
    case kanban = "Kanban"
    case backlog = "Backlog 02"
    
    public var localizedName: LocalizedStringKey { LocalizedStringKey(rawValue) }
}
