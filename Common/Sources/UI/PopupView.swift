import SwiftUI

public struct PopupView: View {
    var title: String
    var message: String
    
    let okayTapped: () -> ()
    let cancelTapped: () -> ()
    
    public init(
        title: String, message: String,
        
        okayTapped: @escaping () -> Void,
        cancelTapped: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        
        self.okayTapped = okayTapped
        self.cancelTapped = cancelTapped
    }
    
    public var body: some View {
        VStack(alignment: .leading) {
            Text(title)
                .font(.system(.title3, weight: .bold))
            
            
            
            Text(message)
            
            HStack {
                Button(action: okayTapped) {
                    Text("okay")
                }
                Button(action: cancelTapped) {
                    Text("cancel")
                }
            }
        }
        .padding()
        .background(Color.background)
        .clipShape(.rect(cornerRadius: 5))
    }
}

