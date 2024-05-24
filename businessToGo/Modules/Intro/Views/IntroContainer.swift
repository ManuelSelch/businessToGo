import SwiftUI
import ComposableArchitecture

struct IntroContainer: View {
    let store: StoreOf<IntroModule>
    
    var body: some View {
        IntroPagesView(pages: store.state.pages)
    }
}

