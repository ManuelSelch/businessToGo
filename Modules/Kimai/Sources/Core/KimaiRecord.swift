import Foundation

import OfflineSyncCore

public struct KimaiRecord<T: Codable & Equatable & Hashable>: Codable, Equatable, Hashable {
    public var data: T
    public var change: DatabaseChange?
}
