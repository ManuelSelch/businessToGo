import SwiftUI
import PulseUI

struct LogView: View {
    
    var body: some View {
        ConsoleView(store: .shared)
    }
}

