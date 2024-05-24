import SwiftUI
import ComposableArchitecture

extension AppRoute {
    @ViewBuilder func view(_ store: StoreOf<AppModule>) -> some View {
        switch self {
        case .intro:
            IntroContainer(store: store.scope(state: \.intro, action: \.intro))
        case .login:
            LoginContainer(store: store.scope(state: \.login, action: \.login))
        case .management:
            ManagementCoordinatorView(store: store.scope(state: \.management, action: \.management))
        case .report:
            // ReportContainer(store: store.scope(state: \.management, action: \.management))
            Text("Report View ;-)")
        case .settings:
            SettingsContainer(store: store)
        
        }
    }
}
