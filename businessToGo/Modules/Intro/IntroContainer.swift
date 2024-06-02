import SwiftUI
import Redux

struct IntroContainer: View {
    let store: StoreOf<IntroFeature>
    
    var body: some View {
        IntroPagesView(pages: store.state.pages)
    }
}

