import Foundation
import SwiftUI

import OfflineSyncCore

public struct KimaiCustomerDTO: TableProtocol {
    public var id: Int
    public var name: String
    public var number: String?
    public var color: String?
    public var teams: [KimaiTeam]
    public var visible: Bool
}

public extension KimaiCustomerDTO {
    func toModel() -> KimaiCustomer {
        return .init(
            id: id, name: name,
            number: number, color: color,
            teams: teams.map { $0.id },
            visible: visible
        )
    }
    
    init(from customer: KimaiCustomer) {
        id = customer.id
        name = customer.name
        number = customer.number
        color = customer.color
        teams = []
        visible = customer.visible
    }
}


extension KimaiCustomerDTO {
    public init() {
        id = -1
        name = ""
        number = ""
        color = ""
        teams = []
        visible = true
    }
}

public struct KimaiCustomer: KimaiTableProtocol, Hashable {
    public var id: Int
    public var name: String
    public var number: String?
    public var color: String?
    public var teams: [Int]
    public var visible: Bool
}

extension KimaiCustomer {
    public init() {
        id = -1
        name = ""
        number = ""
        color = ""
        teams = []
        visible = true
    }
    
    public static let new = KimaiCustomer()
    public static let sample = KimaiCustomer(id: 0, name: "Customer 1", teams: [], visible: true)
}



