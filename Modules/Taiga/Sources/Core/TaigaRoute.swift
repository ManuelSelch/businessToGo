import Foundation

public enum TaigaRoute: Hashable, Codable {
    case project(_ kimai: Int, _ taiga: Int)
}
