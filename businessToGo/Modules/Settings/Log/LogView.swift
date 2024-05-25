import SwiftUI
import ComposableArchitecture
import PulseUI

struct LogView: View {
    let store: StoreOf<LogFeature>
    
    var body: some View {
        ConsoleView(store: .shared)
    }
}

