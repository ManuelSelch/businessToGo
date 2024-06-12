import SwiftUI
import Redux

import Intro
import LoginApp
import ManagementApp
import Report
import SettingsApp

extension AppRoute {
    @ViewBuilder func view(_ store: StoreOf<AppFeature>) -> some View {
        switch self {
        case .intro:
            IntroContainer(store: store.lift(\.intro, AppFeature.Action.intro))
        case .login:
            LoginContainer(store: store.lift(\.login, AppFeature.Action.login))
        case .management:
            ManagementContainer(store: store.lift(\.management, AppFeature.Action.management))
        case .report:
            ReportContainer(store: store.lift(\.report, AppFeature.Action.report))
        case .settings:
            SettingsContainer(store: store.lift(\.settings, AppFeature.Action.settings))
        }
    }
}
