import SwiftUI

public struct CustomTextField: View {
    var title: String
    @State var text: String = ""
    
    let onSubmit: (String) -> ()
    
    public init(_ title: String, _ onSubmit: @escaping (String) -> ()) {
        self.title = title
        self.onSubmit = onSubmit
    }
    
    public var body: some View {
        HStack {
            Image(systemName: "plus")
            
            TextField(title, text: $text)
                .padding(.vertical, 10)
                .overlay(Rectangle().frame(height: 1).padding(.top, 35))
        }
        .foregroundColor(.textHeaderSecondary)
        .listRowSeparator(.hidden)
        .onSubmit({
            if(text != "") {
                onSubmit(text)
                text = ""
            }
        })
    }
}
