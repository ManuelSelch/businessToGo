import SwiftUI

struct IntroPagesView: View {
    @State var pageIndex = 0
    
    let pages: [IntroPage]
    
    let dotAppearance = UIPageControl.appearance()
    
    var body: some View {
        TabView(selection: $pageIndex) {
            ForEach(pages){ page in
                VStack {
                    Spacer()
                    IntroPageView(page: page)
                    Spacer()
                }
                .tag(page.tag)
            }
        }
        .animation(.easeInOut, value: pageIndex)
        .tabViewStyle(.page)
        .indexViewStyle(.page(backgroundDisplayMode: .interactive))
        .onAppear {
            dotAppearance.currentPageIndicatorTintColor = .contrast
            dotAppearance.pageIndicatorTintColor = .gray
        }
    }
}


extension IntroPagesView {
    func incrementPage(){
        pageIndex += 1
    }
}

#Preview {
    IntroPagesView(pages: IntroPage.samples)
}
