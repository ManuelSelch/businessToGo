import SwiftUI

struct CustomColorPicker: View {
    @Binding var selectedColor: String?
    private let colors: [String] = [
        "#c0c0c0",
        "#808080",
        "#000000",
        "#800000",
        "#a52a2a",
        "#ff0000",
        "#ffa500",
        "#ffd700",
        "#ffff00",
        "#ffdab9",
        "#f0e68c",
        "#808000",
        "#00ff00",
        "#9acd32",
        "#008000",
        "#008080",
        "#00ffff",
        "#add8e6",
        "#00bfff",
        "#1e90ff",
        "#0000ff",
        "#000080",
        "#800080",
        "#ff00ff",
        "#ee82ee",
        "#ffe4e1",
        "#E6E6FA"
    ]
    
    var body: some View {
        let layout = [
                GridItem(.adaptive(minimum: 20))
            ]
        
        LazyVGrid(columns: layout) {
            ForEach(colors, id: \.self){ color in
                Circle()
                    .foregroundStyle(Color(hex: color))
                    .frame(width: 20, height: 20)
                    .opacity(color == selectedColor ? 0.8 : 1.0)
                    .onTapGesture {
                        if(selectedColor == color){
                            selectedColor = nil
                        } else {
                            selectedColor = color
                        }
                    }
                    .overlay(
                        Circle()
                            .stroke(.black, lineWidth: 1)
                            .opacity(color == selectedColor ? 1.0 : 0.0)
                    )
                    
            }
        }
        .padding()
        .background(.thinMaterial)
        .cornerRadius(20)
        .padding(.horizontal)
    }
}

extension Color {
    init(hex: String) {
        let hex = hex.trimmingCharacters(in: CharacterSet(charactersIn: "#"))
        let rgbValue = UInt32(hex, radix: 16)
        let r = Double((rgbValue! & 0xFF0000) >> 16) / 255
        let g = Double((rgbValue! & 0x00FF00) >> 8) / 255
        let b = Double(rgbValue! & 0x0000FF) / 255
        self.init(red: r, green: g, blue: b)
    }
}

#Preview {
    
    CustomColorPicker(selectedColor: .constant("#000000"))
}
