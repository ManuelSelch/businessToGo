import SwiftUI

struct AccountsAssistantView: View {
    
    let assistantTapped: () -> ()
    
    
    var body: some View {
        VStack {
            Image("no-accounts")
                .resizable()
                .scaledToFit()
                .frame(maxWidth: 800)
                .padding()
                .cornerRadius(10)
                .padding()
            
            Text("Noch kein Workspace")
                .font(.title)
                .bold()
            
            Button(action: assistantTapped) {
                Text("Assistent starten")
            }
            .padding(10)
            //.background(Color.theme)
            .cornerRadius(10)
            //.foregroundStyle(Color.background)
        }
    }
}

#Preview {
    AccountsAssistantView(assistantTapped: {})
}
