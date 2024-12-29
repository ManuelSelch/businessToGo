import Foundation

public enum KimaiAssistantStep: String, CaseIterable, Codable, Equatable, Identifiable {
    case customer = "Ersten Kunden anlegen"
    case project = "Erstes Projekt anlegen anlegen"
    case activity = "Erste Tätigkeit anlegen"
    case timesheet = "Ersten Timesheet Eintrag anlegen"
    
    public var id: Int { KimaiAssistantStep.allCases.firstIndex(of: self) ?? 0 }
}
