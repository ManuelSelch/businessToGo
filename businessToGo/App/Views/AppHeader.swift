import SwiftUI

struct AppHeader: View {
    
    let title: String
    var settingsTapped: () -> ()
    
    var body: some View {
        ZStack {
            HStack {
                Spacer()
                
                Text(title)
               
                Spacer()
            }
            .foregroundStyle(Color.white)
                
            HStack {
                Spacer()
                
                Button(action: {
                    settingsTapped()
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