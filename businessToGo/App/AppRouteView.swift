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
            ReportCoordinatorView(
                store: store
                    .scope(state: \.management, action: \.management)
                    .scope(state: \.report, action: \.report)
            )
        case .settings:
            SettingsCoordinatorView(store: store.scope(state: \.settings, action: \.settings))
        
        }
    }
}
