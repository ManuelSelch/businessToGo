import SwiftUI
import Redux

public struct IntroContainer: View {
    let store: StoreOf<IntroFeature>
    
    public init(store: StoreOf<IntroFeature>) {
        self.store = store
    }
    
    public var body: some View {
        IntroPagesView(pages: store.state.pages)
    }
}

