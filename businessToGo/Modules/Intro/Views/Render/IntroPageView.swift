import SwiftUI

struct IntroPageView: View {
    var page: IntroPage
    
    var body: some View {
        VStack(spacing: 20) {
            Image(page.image)
                .resizable()
                .scaledToFit()
                .padding()
                .cornerRadius(30)
                .background(.gray.opacity(0.10))
                .cornerRadius(10)
                .padding()
            
            Text(page.name)
                .font(.title)
                .bold()
            
            Text(page.description)
                .font(.subheadline)
                .frame(width: 300)
        }
    }
}

#Preview {
    IntroPageView(page: .sample)
}
