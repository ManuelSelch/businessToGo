import Foundation

import LoginApp
import Intro

extension AppFeature {
    enum TabRoute: Identifiable, Codable, Equatable, Hashable, CaseIterable {
        case today
        case management
        case report
        
        var id: Self {self}
    }
    
    enum Route: Identifiable, Codable, Equatable, Hashable {
        case login(LoginFeature.Route)
        case settings(SettingsComponent.Route)
        case intro
        
        case today(TodayComponent.Route)
        case management(ManagementComponent.Route)
        case report(ReportComponent.Route)
        
        var id: Self {self}
    }
}
