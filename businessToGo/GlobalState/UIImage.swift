import SwiftUI
import Foundation

#if os(macOS)
    import Cocoa

    typealias CustomImage = NSImage

    public struct CustomImageHelper {
        static func create(from img: CustomImage) -> Image {
            return Image(nsImage: img)
        }
    }
#elseif os(iOS)
    typealias CustomImage = UIImage

    public struct CustomImageHelper {
        static func create(from img: CustomImage) -> Image {
            return Image(uiImage: img)
        }
    }
#endif


