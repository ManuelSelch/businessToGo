import SwiftUI
import Redux

struct Header: View {
    @ObservedObject var store: StoreOf<AppModule>
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Text(store.state.tab.title)
               
                Spacer()
            }
            .foregroundStyle(Color.white)
                
            HStack {
                Spacer()
                
                Button(action: {
                    store.send(.route(.presentSheet(.settings)))
                }){
                    Image(systemName: "gear")
                        .font(.system(size: 20))
                        .foregroundColor(Color.white)
                }
            }
                
        }
        .padding()
        .background(Color.theme)
    }
}
