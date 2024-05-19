import Foundation
import SwiftUI
import Redux

enum AppRoute: Hashable, Identifiable, CaseIterable, Codable, Equatable {
    case login
    case management
    case report
    case settings
    
    var id: AppRoute { self }
}

extension AppRoute {
    
    var title: String {
        switch self {
        case .login:
            return "Login"
        case .management:
            return "Projects"
        case .report:
            return "Report"
        case .settings:
            return "Settings"
        }
    }
    
    var image: String {
        switch self {
        case .login: return "person"
        case .management: return "shippingbox.fill"
        case .report: return "chart.bar.xaxis.ascending"
        case .settings: return "gear"
        }
    }
    
    @ViewBuilder
    var label: some View {
        Label(title, systemImage: image)
    }
    
    func createView(_ store: Store<AppState, AppAction, AppDependency>) -> some View {
        switch self {
        case .login:
            AnyView(
                LoginContainer(
                    store: store.lift(\.login, AppAction.login, store.dependencies)
                )
            )
        case .management:
            AnyView(
                ManagementContainer(
                    store: store.lift(\.management, AppAction.management, store.dependencies.management)
                )
            )
        case .report:
            AnyView(
                ReportContainer(
                    store: store.lift(\.management, AppAction.management, store.dependencies.management)
                )
            )
        case .settings:
            AnyView(
                SettingsContainer(store: store)
            )
        }
    }
    
}
