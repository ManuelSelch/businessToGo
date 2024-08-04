import Foundation

import LoginApp
import Intro
import SettingsApp

extension AppFeature {
    enum TabRoute: Identifiable, Codable, Equatable, Hashable, CaseIterable {
        case management
        case report
        
        var id: Self {self}
    }
    
    enum Route: Identifiable, Codable, Equatable, Hashable {
        case login(LoginFeature.Route)
        case settings(SettingsContainer.Route)
        case intro
        
        case management(ManagementContainer.Route)
        case report(ReportContainer.Route)
        
        var id: Self {self}
    }
}
