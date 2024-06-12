import Foundation

public enum KimaiAssistantStep: String, CaseIterable, Codable, Equatable {
    case customer = "Ersten Kunden anlegen"
    case project = "Erstes Projekt anlegen anlegen"
    case activity = "Erste Tätigkeit anlegen"
    case timesheet = "Esten Timesheet Eintrag anlegen"
    
    public var index: Int { KimaiAssistantStep.allCases.firstIndex(of: self) ?? 0 }
}
