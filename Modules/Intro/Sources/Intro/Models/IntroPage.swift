import Foundation

struct IntroPage: Identifiable, Equatable, Codable, Hashable {
    var id = UUID()
    var name: String
    var description: String
    var image: String
    var tag: Int
}

extension IntroPage {
    static let sample: IntroPage = .init(name: "Willkommen", description: "Hallo Welt", image: "", tag: 0)
    
    static let samples: [IntroPage] = [
        .init(name: "Willkommen", description: "Hallo Welt", image: "", tag: 0),
        .init(name: "Next", description: "02", image: "", tag: 1)
    ]
}
