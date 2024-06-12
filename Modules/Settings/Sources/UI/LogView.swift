import SwiftUI
import PulseUI

public struct LogView: View {
    public init() {}
    
    public var body: some View {
        ConsoleView(store: .shared)
    }
}

