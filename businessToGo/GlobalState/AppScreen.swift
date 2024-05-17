import Foundation
import SwiftUI
import Redux

enum AppScreen: Hashable, Identifiable, CaseIterable, Codable {
    case login
    case management
    case report
    
    case kimaiSettings
    
    var id: AppScreen { self }
}

extension AppScreen {
    
    var title: String {
        switch self {
        case .login:
            return "Login"
        case .management:
            return "Management"
        case .report:
            return "Report"
        case .kimaiSettings:
            return "Settings"
        }
    }
    
    private var image: String {
        switch self {
        case .login: return "person"
        case .management: return "house"
        case .report: return "chart.bar.xaxis.ascending"
        case .kimaiSettings: return "gear"
        }
    }
    
    @ViewBuilder
    var label: some View {
        Label(title, systemImage: image)
    }
    
    func createView(_ store: Store<AppState, AppAction, Environment>, _ router: AppRouter) -> some View {
        switch self {
        case .login:
            AnyView(
                LoginContainer()
                    .environmentObject(store.lift(\.login, AppAction.login, store.dependencies))
            )
        case .management:
            AnyView(
                ManagementContainer()
                    .environmentObject(store.lift(\.management, AppAction.management, store.dependencies.management))
                    .environmentObject(router.management)
            )
        case .report:
            AnyView(
                ReportContainer()
                    .environmentObject(store.lift(\.management, AppAction.management, store.dependencies.management))
            )
        case .kimaiSettings:
            AnyView(
                SettingsContainer()
                    .environmentObject(router.settings)
            )
        }
    }
    
}
