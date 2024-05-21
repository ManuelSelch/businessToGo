import SwiftUI
import Redux

struct IntroContainer: View {
    @ObservedObject var store: StoreOf<IntroModule>
    
    var body: some View {
        IntroPagesView(pages: store.state.pages)
    }
}

